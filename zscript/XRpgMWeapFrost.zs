// The Mage's Frost Cone ----------------------------------------------------

class XRpgMWeapFrost : XRpgMageWeapon replaces MWeapFrost
{
	Default
	{
		+BLOODSPLATTER
		Weapon.SelectionOrder 1700;
		Weapon.AmmoUse1 3;
		Weapon.AmmoGive1 25;
		Weapon.KickBack 150;
		Weapon.YAdjust 20;
		Weapon.AmmoType1 "Mana1";
		Inventory.PickupMessage "$TXT_WEAPON_M2";
		Obituary "$OB_MPMWEAPFROST";
		Tag "$TAG_MWEAPFROST";
	}

	States
	{
	Spawn:
		WMCS ABC 8 Bright;
		Loop;
	Select:
		CONE A 1 A_Raise;
		Loop;
	Deselect:
		CONE A 1 A_Lower;
		Loop;
	Ready:
		CONE A 1 A_WeaponReady;
		Loop;
	Fire:
		CONE B 3;
		CONE C 4;
	Hold:
		CONE D 3;
		CONE E 5;
		CONE F 3 A_FireConePL1;
		CONE G 3;
		CONE A 9;
		CONE A 10 A_ReFire;
		Goto Ready;
	AltFire:
		CONE B 3 A_AltFireCheckSpellSelected;
		CONE C 4;
		CONE D 3;
		CONE E 5;
		CONE F 3 A_FireSpell();
		CONE G 3;
		CONE A 9;
		CONE A 10 A_ReFire;
		Goto Ready;
    AltHold:
		CONE B 3 A_AltFireCheckSpellSelected;
		CONE C 4;
		CONE D 3;
		CONE E 5;
		CONE F 3 A_FireSpell();
		CONE G 3;
		CONE A 9;
		CONE A 10 A_ReFire;
		Goto Ready;
	}
	
	//============================================================================
	//
	// A_FireConePL1
	//
	//============================================================================

	action void A_FireConePL1()
	{
		bool conedone=false;
		FTranslatedLineTarget t;

		if (player == null)
		{
			return;
		}

		Weapon weapon = player.ReadyWeapon;
		if (weapon != null)
		{
			if (!weapon.DepleteAmmo (false))//weapon.bAltFire))
				return;
		}
		A_StartSound ("MageShardsFire", CHAN_WEAPON);

		int damage = random[MageCone](90, 105);
		for (int i = 0; i < 16; i++)
		{
			double ang = angle + i*(45./16);
			double slope = AimLineAttack (ang, DEFMELEERANGE, t, 0., ALF_CHECK3D);
			if (t.linetarget)
			{
				t.linetarget.DamageMobj (self, self, damage, 'Ice', DMG_USEANGLE, t.angleFromSource);
				conedone = true;
				break;
			}
		}

		// didn't find any creatures, so fire projectiles
		if (!conedone)
		{
			Actor mo = SpawnPlayerMissile ("FrostMissile");
			if (mo)
			{
				mo.special1 = FrostMissile.SHARDSPAWN_LEFT|FrostMissile.SHARDSPAWN_DOWN|FrostMissile.SHARDSPAWN_UP|FrostMissile.SHARDSPAWN_RIGHT;
				mo.special2 = 3; // Set sperm count (levels of reproductivity)
				mo.target = self;
				mo.args[0] = 3;		// Mark Initial shard as super damage
			}
		}
	}

	override bool IsSpellRapidFire(int spellType)
    {
        /*if (spellType == SPELLTYPE_ICE)
            return true;
        if (spellType == SPELLTYPE_POISON)
            return true;*/

        return false;
    }

    override void FireFlameSpell()
	{
		if (!AttemptFireSpell(0, 8))
            return;

        FireSpreadMissile("MageFrostFlameMissile", 9, 2);
        FireSpreadMissile("MageFrostFlameMissile", 9, 2);
        FireSpreadMissile("MageFrostFlameMissile", 9, 2);
	}
    
    override void FireIceSpell()
	{
		FireMissileSpell("MageFrostIceMissile", 0, 6);
	}

    override void FirePoisonSpell()
	{
		FireMissileSpell("MageFrostPoisonMissile", 0, 8);
	}

    override void FireWaterSpell()
	{
	}

    override void FireSunSpell()
	{
	}

    override void FireMoonSpell()
	{
	}

    override void FireDeathSpell()
	{
	}

    override void FireLightningSpell()
	{
	}

    override void FireBloodSpell()
	{
	}
}

class MageFrostFlameMissile : Actor
{
    Default
    {
        Speed 15;
        Radius 8;
        Height 8;
        Damage 2;
		Projectile;
        +SPAWNSOUNDSOURCE
        Obituary "$OB_MPMWEAPFROST";
        DamageType "Fire";
        DeathSound "Fireball";
		Gravity 0.125;
		+NOBLOCKMAP +MISSILE +DROPOFF
		+NOTELEPORT
		+BOUNCEONFLOORS
		+BOUNCEONCEILINGS
		+BOUNCEONWALLS
		+USEBOUNCESTATE
		-NOGRAVITY
		Health 4;

    }
    States
    {
    Spawn:
        WRBL ABC 4 Bright;
        Loop;
	Bounce:
		FX18 M 1 A_VolcanoImpact;
		Goto Spawn;
    Death:
        WRBL D 4 Bright A_VolcBallImpact;
        WRBL EFGHI 4 Bright;
        Stop;
    }

	void A_VolcBallImpact ()
	{
		if (pos.Z <= floorz)
		{
			bNoGravity = true;
			Gravity = 1;
			AddZ(28);
		}
		A_Explode(40, 100);
	}

	//Bounce
	void A_VolcanoImpact()
	{
		Health--;
		if (Health < 1)
		{
			SetStateLabel("Death");
			return;
		}

		//A_StartSound ("world/volcano/blast", CHAN_BODY);
	}
}

const ICESTORM_SPREAD = 96;
const ICESTORM_ZSPEED = -30;
const ICESTORM_ZSPEED_MOD = 10;
const ICESTORM_NUM = 30;
class MageFrostIceMissile : FastProjectile
{
    Default
    {
        Speed 120;
        Radius 12;
        Height 8;
        Damage 0;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        Obituary "$OB_MPMWEAPFROST";
        Scale 0.75;
        DamageType "Ice";
        DeathSound "IceGuyMissileExplode";
		RenderStyle "None";
    }
    States
    {
    Spawn:
        SHRD A 4;
        Loop;
    Death:
        SHRD D 4 A_IceShower;
        Stop;
    }

	action void A_RainIce()
	{
		double xo = Random(-1 * ICESTORM_SPREAD, ICESTORM_SPREAD);
		double yo = Random(-1 * ICESTORM_SPREAD, ICESTORM_SPREAD);
		Vector3 spawnpos = Vec2OffsetZ(xo, yo, pos.z);
		Actor mo = Spawn("IceShard", spawnpos, ALLOW_REPLACE);
		if (!mo) return;
		
		double newz = mo.CurSector.NextHighestCeilingAt(mo.pos.x, mo.pos.y, mo.pos.z, mo.pos.z, FFCF_NOPORTALS) - (mo.height + 1);
		mo.SetZ(newz);

		mo.target = target;
		mo.Vel.X = MinVel; // Force collision detection
		let zMod = random(-1 * ICESTORM_ZSPEED_MOD, ICESTORM_ZSPEED_MOD);
		mo.Vel.Z = ICESTORM_ZSPEED + zMod;
		mo.CheckMissileSpawn (radius);
		mo.A_SetPitch(90);
	}

	action void A_IceShower()
	{
		for (int i = 0; i < ICESTORM_NUM; i++)
		{
			A_RainIce();
		}
	}
}

class MageFrostPoisonMissile : Actor
{
    Default
    {
        Speed 6;
        Radius 16;
        Height 12;
        Damage 2;
        Projectile;
        +RIPPER
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        +ZDOOMTRANS
        SeeSound "PoisonShroomDeath";
        Obituary "$OB_MPMWEAPWAND";
    }
    States
    {
    Spawn:
        PSBG EFGHI 4 Bright;
		Loop;
    Death:
        PSBG D 4 Bright;
        Stop;
    }
}