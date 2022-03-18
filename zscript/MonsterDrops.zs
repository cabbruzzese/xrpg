const SHIELD_MAX_CHARGE = 40;
const SHIELD_MIN_CHARGE = 5;
const SHIELD_DEFENSE = 0.2;
const SHIELD_MISSILE_DEFENSE = 0.1;
const SHIELD_RANGE = 1.5 * DEFMELEERANGE;
class XRpgShield : Inventory replaces CentaurShield
{
    int shieldCharge;
    int shieldTimeout;

    property ShieldCharge : shieldCharge;
    property ShieldTimeout : shieldTimeout;

	Default
	{
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.PickupFlash "PickupFlash";
		Inventory.Amount 1;
		Inventory.MaxAmount 1;
		Inventory.PickupSound "misc/p_pkup";
		Inventory.PickupMessage "$TXT_SHIELDITEM";
        Inventory.ForbiddenTo "XRpgClericPlayer", "XRpgMagePlayer";

        XRpgShield.ShieldCharge 0;
        XRpgShield.ShieldTimeout 0;
	}

	States
	{
	Spawn:
		CTDP ABCDEFGHIJ 3;
		CTDP J -1;
		Stop;
	}

    void AddCharge(int amount)
    {
        ShieldCharge += amount;

        if (ShieldCharge > SHIELD_MAX_CHARGE)
            ShieldCharge = SHIELD_MAX_CHARGE;
    }

    void ClearCharge()
    {
        ShieldCharge = 0;
    }

    bool IsCharged()
    {
        return ShieldCharge >= SHIELD_MIN_CHARGE;
    }

    void ShootShield()
    {
        if (!Owner)
			return;

        let xrpgPlayer = XRpgFighterPlayer(Owner);
        if (!xrpgPlayer)
			return;
        
        if (ShieldCharge < SHIELD_MIN_CHARGE)
            return;

        let mo = xrpgPlayer.SpawnPlayerMissile ("ShieldFX");
        if (mo)
            mo.SetDamage(mo.Damage + ShieldCharge);

        ClearCharge();
    }

    override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if (!Owner)
			return;

		if (!inflictor)
			return;
		
		let xrpgPlayer = XRpgFighterPlayer(Owner);
        if (!xrpgPlayer)
			return;
		
        if (!IsShieldTimeoutActive())
            return;

		if (passive && damage > 0 && Owner && Owner.Player && Owner.Player.mo)
        {
            if (inflictor.bMissile)
            {
                int chargeVal = Max(damage, 1);
			    AddCharge(chargeVal);

                newdamage = double(damage) * SHIELD_MISSILE_DEFENSE;
            }
            else
            {
                newdamage = double(damage) * SHIELD_DEFENSE;
            }

            Owner.A_StartSound("FlechetteBounce", CHAN_VOICE);

            xrpgPlayer.DoBlend("99 99 99", 0.6, 30);
        }
	}

    bool IsShieldTimeoutActive()
	{
		return ShieldTimeout > 0;
	}

	void SetShieldTimeout(int ammount = 10)
	{
		ShieldTimeout = ammount;
	}

    override void Tick()
	{
		Super.Tick();

		if (!Owner)
			return;
		let xrpgPlayer = XRpgFighterPlayer(Owner);
        if (!xrpgPlayer)
			return;

		if (ShieldTimeout > 0)
		{
			ShieldTimeout--;

			if (xrpgPlayer)
				xrpgPlayer.bDONTTHRUST = true;
		}
		else
		{
			if (xrpgPlayer)
				xrpgPlayer.bDONTTHRUST = false;
		}    
	}
}

class ShieldFX : Actor
{
	Default
	{
		Speed 20;
		Damage 15;
		Projectile;
		+SPAWNSOUNDSOURCE
		+ZDOOMTRANS
		RenderStyle "Add";
		SeeSound "CentaurLeaderAttack";
		DeathSound "CentaurMissileExplode";
	}
	States
	{
	Spawn:
		CTFX A -1 Bright;
		Stop;
	Death:
		CTFX B 4 Bright;
		CTFX C 3 Bright;
		CTFX D 4 Bright;
		CTFX E 3 Bright;
		CTFX F 2 Bright;
		Stop;
	}
}



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

class WraithHelmet : MonsterDropArmor
{
	Default
	{
		MonsterDropArmor.ArmorNum 2;
		MonsterDropArmor.ArmorAmount 10;
		Inventory.PickupMessage "$TXT_ARMOR_WRAITHHELM";
	}
	States
	{
	Spawn:
		AHLM ABCDA 4;
		AHLM A -1;
		Stop;
	}
}

class BishopGem : MonsterDropArmor
{
	Default
	{
		MonsterDropArmor.ArmorNum 3;
		MonsterDropArmor.ArmorAmount 10;
		Inventory.PickupMessage "$TXT_ARMOR_BISHOPGEM";
	}
	States
	{
	Spawn:
		AAMU ABCD 8;
		AAMU D -1;
		Stop;
	}
}

class EttinArmor : MonsterDropArmor
{
	Default
	{
		MonsterDropArmor.ArmorNum 0;
		MonsterDropArmor.ArmorAmount 10;
		Inventory.PickupMessage "$TXT_ARMOR_ETTINARMOR";
	}
	States
	{
	Spawn:
		ABDY ABCDEFG 4;
		ABDY G -1;
		Stop;
	}
}

class SuitHelmet : MonsterDropArmor
{
	Default
	{
		MonsterDropArmor.ArmorNum 2;
		MonsterDropArmor.ArmorAmount 15;
		Inventory.PickupMessage "$TXT_ARMOR_SUITHELMET";
	}
	States
	{
	Spawn:
		ZSUI F 4;
		ZSUI F -1;
		Stop;
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