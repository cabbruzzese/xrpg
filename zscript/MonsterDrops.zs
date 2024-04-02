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

class BeverageItem : HealthPickup
{
	int manaAmount;
	property ManaAmount: manaAmount;

	int drunkAmount;
	property DrunkAmount: drunkAmount;

	Default
	{
		-FLOATBOB
		+COUNTITEM
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "TST1A0";
		Inventory.PickupSound "misc/p_pkup";
		Inventory.PickupMessage "$TXT_MEADSTEIN";
		Tag "$TAG_MEAD";
		HealthPickup.Autouse 0;

		Health 50;
		BeverageItem.ManaAmount 25;
		BeverageItem.DrunkAmount 50;
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
	
	override bool Use(bool pickup)
	{
		if (!Owner || pickup)
			return false;
		
		let xrpgPlayer = XRpgPlayer(Owner);
		if (!xrpgPlayer)
			return false;

		bool healthSuccess = super.use(pickup);
		bool ammoSuccess = ApplyAmmo(xrpgPlayer);

		if (healthSuccess || ammoSuccess)
		{
			if (DrunkAmount > 0)
			{
				owner.GiveInventory("DrunkPowerup", 1);
			}
		}

		return healthSuccess || ammoSuccess;
	}
}

const DRUNK_TICK_MAX = 90;
const DRUNK_TIME_MAX = 3500;
const DRUNK_INTENSITY_MAX = 0.9;
const DRUNK_BLEND_TICS = 20;
const DRUNK_SPEED_MAX = 0.8;
const DRUNK_SPEED_MIN = 0.3;
const DRUNK_STUMBLE_THRESHOLD = 110;
const DRUNK_STUMBLE_SPEED = 6;
class DrunkPowerup : PowerSpeed
{
	int colorCounter;

	Default
	{
		+INVENTORY.AdditiveTime;
		Powerup.Duration -20;
		-INVENTORY.NOTELEPORTFREEZE;
		Inventory.Icon "TST1A0";

		Speed DRUNK_SPEED_MAX;
	}

	override void Tick ()
	{
		super.Tick();

		if (!Owner)
			return;
	
		colorCounter++;
		double intensity = double(EffectTics) / double(DRUNK_TIME_MAX);
		intensity = Min(DRUNK_INTENSITY_MAX, intensity);

		if (colorCounter > DRUNK_TICK_MAX)
		{
			colorCounter = 0;
		}
		else if (colorCounter > 60)
		{
			Owner.A_SetBlend("44 44 22", intensity, DRUNK_BLEND_TICS);
		}
		else if (colorCounter > 30)
		{
			Owner.A_SetBlend("22 44 44", intensity, DRUNK_BLEND_TICS);
		}
		else
		{
			Owner.A_SetBlend("44 22 44", intensity, DRUNK_BLEND_TICS);
		}

		if (colorCounter % 15 == 0)
		{
			double speedRand = frandom(DRUNK_SPEED_MIN, DRUNK_SPEED_MAX);
			Speed = speedRand;

			if (EffectTics > DRUNK_STUMBLE_THRESHOLD)
			{
				//let playerObj = PlayerPawn(Owner);
				if (Owner && Owner.player.cmd.forwardmove && owner.player.onGround)
				{
					double sway = frandom[sway](-DRUNK_STUMBLE_SPEED, DRUNK_STUMBLE_SPEED); //Randomize the movement sway
					sway *= intensity;
					Owner.Thrust(sway,Owner.angle-90); //Thrust the player left or right
				}
			}
		}
		else if (colorCounter % 25 == 0)
		{
			Speed = DRUNK_SPEED_MAX;
		}
	}
}

class MeadStein : BeverageItem replaces TableShit1
{
	Default
	{
		Inventory.Icon "TST1A0";
		Inventory.PickupMessage "$TXT_MEADSTEIN";
		Tag "$TAG_MEAD";

		Health 50;
		BeverageItem.ManaAmount 25;
		BeverageItem.DrunkAmount 50;
	}
	States
	{
	Spawn:
		TST1 A -1;
		Stop;
	}
}

class AleStein : BeverageItem replaces TableShit2
{
	Default
	{
		Inventory.Icon "TST2A0";
		Inventory.PickupMessage "$TXT_ALESTEIN";
		Tag "$TAG_ALE";

		Health 80;
		BeverageItem.ManaAmount 50;
		BeverageItem.DrunkAmount 80;
	}
	States
	{
	Spawn:
		TST2 A -1;
		Stop;
	}
}