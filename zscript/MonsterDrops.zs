class MonsterDropArmor : Inventory
{
	int armorNum;
	int armorAmount;

	property ArmorNum: armorNum;
	property ArmorAmount: armorAmount;

	Default
	{
		+INVENTORY.FANCYPICKUPSOUND
		+INVENTORY.AUTOACTIVATE
		+INVENTORY.UNDROPPABLE
		+INVENTORY.UNTOSSABLE
		+INVENTORY.ISARMOR
		Inventory.PickupFlash "PickupFlash";
		Inventory.Amount 1;
		Inventory.MaxAmount 0;
		Inventory.PickupSound "misc/p_pkup";

		MonsterDropArmor.ArmorNum 1;
		MonsterDropArmor.ArmorAmount 5;
	}
	States
	{
	Spawn:
		TNT1 A 4;
		Stop;
	}
	
	override bool Use (bool pickup)
	{
		if (!Owner)
			return false;
		
		let xrpgPlayer = XRpgPlayer(Owner);
		if (!xrpgPlayer)
			return false;

		let hArmor = HexenArmor(xrpgPlayer.FindInventory("HexenArmor"));
		
		if (hArmor)
		{
			// Max bonus is max for class, only added if lower.
			int armorMaxVal = Min(ArmorAmount, hArmor.SlotsIncrement[ArmorNum]);
			if (hArmor.Slots[ArmorNum] < armorMaxVal)
			{
				hArmor.Slots[ArmorNum] = armorMaxVal;
				return true;
			}
		}

		return false;
	}
}

class XRpgArmorChunk : Actor
{
	Default
	{
		Radius 4;
		Height 8;
	}
	States
	{
	Spawn:
		ZSUI B -1;
		Stop;
		ZSUI C -1;
		Stop;
		ZSUI D -1;
		Stop;
		ZSUI E -1;
		Stop;
		ZSUI G -1;
		Stop;
		ZSUI H -1;
		Stop;
	}
}

class XRpgSuitOfArmor : Actor replaces ZSuitOfArmor
{
	Default
	{
		Health 60;
		Radius 16;
		Height 72;
		Mass 0x7fffffff;
		+SOLID +SHOOTABLE +NOBLOOD
		+NOICEDEATH
		DeathSound "SuitofArmorBreak";
	}

	States
	{
	Spawn:
		ZSUI A -1;
		Stop;
	Death:
		ZSUI A 1 A_SoAExplode;
		Stop;
	}
	
	//===========================================================================
	//
	// A_SoAExplode - Suit of Armor Explode
	//
	//===========================================================================

	void A_SpawnChunk(class<Actor> chunkType, int frameOffset = 0)
	{
		double xo = (random[SoAExplode]() - 128) / 16.;
		double yo = (random[SoAExplode]() - 128) / 16.;
		double zo = random[SoAExplode]() * Height / 256.;
		Actor mo = Spawn (chunkType, Vec3Offset(xo, yo, zo), ALLOW_REPLACE);
		if (mo)
		{
			mo.SetState (mo.SpawnState + frameOffset);
			mo.Vel.X = random2[SoAExplode]() / 64.;
			mo.Vel.Y = random2[SoAExplode]() / 64.;
			mo.Vel.Z = random[SoAExplode](5, 12);
		}
	}

	void A_SoAExplode()
	{
		for (int i = 0; i < 6; i++)
		{
			A_SpawnChunk("XRpgArmorChunk", i);
		}

		//Spawn Polearm
		A_SpawnChunk("XRpgFWeapPolearm");

		//Spawn Helmet
		A_SpawnChunk("SuitHelmet");

		// Spawn an item?
		Class<Actor> type = GetSpawnableType(args[0]);
		if (type != null)
		{
			if (!(level.nomonsters || sv_nomonsters) || !(GetDefaultByType (type).bIsMonster))
			{ // Only spawn monsters if not -nomonsters
				Spawn (type, Pos, ALLOW_REPLACE);
			}
		}
		A_StartSound (DeathSound, CHAN_BODY);
		Destroy ();
	}
}


class MeadStein : Inventory replaces TableShit1
{
	int healAmount;
	int manaAmount;
	property HealAmount: healAmount;
	property ManaAmount: manaAmount;

	Default
	{
		+INVENTORY.ISHEALTH
		-FLOATBOB
		+INVENTORY.FANCYPICKUPSOUND
		+INVENTORY.AUTOACTIVATE
		+INVENTORY.UNDROPPABLE
		+INVENTORY.UNTOSSABLE
		Inventory.PickupFlash "PickupFlash";
		Inventory.Amount 1;
		Inventory.MaxAmount 0;
		Inventory.PickupSound "misc/p_pkup";
		Inventory.PickupMessage "$TXT_MEADSTEIN";

		MeadStein.HealAmount 50;
		MeadStein.ManaAmount 25;
	}
	States
	{
	Spawn:
		TST1 A -1;
		Stop;
	}

	override bool TryPickup (in out Actor other)
	{
		bool success = ApplyMead(other);

		if (!success)
			return false;
		
		GoAwayAndDie();
		return true;
	}
	
	bool ApplyHealth(XRpgPlayer player)
	{
		if (!player)
			return false;
		
		if (player.GiveBody(HealAmount, MaxAmount))
			return true;

		return false;
	}
	
	bool ApplyAnyAmmo(XRpgPlayer player, Name ammoType)
	{
		if (!player)
			return false;
		
		let ammo = player.FindInventory(ammoType);
		if (ammo == null)
			ammo = GiveInventoryType(ammoType);

		if (ammo.Amount >= ammo.MaxAmount)
			return false;

		ammo.Amount = Min(ammo.Amount + ManaAmount, ammo.MaxAmount);
		return true;
	}

	bool ApplyAmmo (XRpgPlayer player)
	{
		if (!player)
			return false;

		bool blueSuccess = ApplyAnyAmmo(player, "Mana1");
		bool greenSuccess = ApplyAnyAmmo(player, "Mana2");

		return (blueSuccess || greenSuccess);
	}
	
	bool ApplyMead (Actor other)
	{
		if (!other)
			return false;
		
		let xrpgPlayer = XRpgPlayer(other);
		if (!xrpgPlayer)
			return false;

		bool healthSuccess = ApplyHealth(xrpgPlayer);
		bool ammoSuccess = ApplyAmmo(xrpgPlayer);

		return healthSuccess || ammoSuccess;
	}
}

class AleStein : MeadStein replaces TableShit2
{
	Default
	{
		Inventory.PickupMessage "$TXT_ALESTEIN";

		MeadStein.HealAmount 80;
		MeadStein.ManaAmount 50;
	}
	States
	{
	Spawn:
		TST2 A -1;
		Stop;
	}
}