
// The Mage's Wand ----------------------------------------------------------

class XRpgMWeapWand : XRpgMageWeapon replaces MWeapWand
{
	Default
	{
		Weapon.SelectionOrder 3600;
		Weapon.KickBack 0;
		Weapon.YAdjust 9;
		Tag "$TAG_MWEAPWAND";
	}
	States
	{
	Select:
		MWND A 1 A_Raise;
		Loop;
	Deselect:
		MWND A 1 A_Lower;
		Loop;
	Ready:
		MWND A 1 A_WeaponReady;
		Loop;
	Fire:
		MWND A 6;
		MWND B 6 Bright Offset (0, 48) A_FireProjectile ("MageWandMissile");
		MWND A 3 Offset (0, 40);
		MWND A 3 Offset (0, 36) A_ReFire;
		Goto Ready;
    AltFire:
		MWND A 1 A_AltFireCheckSpellSelected;
		MWND B 1 Bright Offset (0, 48) A_FireSpell();
    AltFireFinish:
		MWND A 6 Offset (0, 40);
		MWND A 3 Offset (0, 36) A_ReFire;
		Goto Ready;
    RapidFireFinish:
		MWND A 1 Offset (0, 36) A_ReFire;
        Goto Ready;
    FlameSpell:
        MWND A 7;
        MWND B 7 Bright Offset (0, 48) A_FireMissileSpell("MageWandFlameMissile", 2);
        Goto AltFireFinish;
    IceSpell:
        MWND A 3;
        MWND B 2 Bright Offset (0, 48) A_FireMissileSpell("MageWandIceMissile", 1, 0, 0, 3, 3);
        Goto RapidFireFinish;
    PoisonSpell:
        MWND A 3;
        MWND B 2 Bright Offset (0, 48) A_FireMissileSpell("MageWandPoisonMissile", 2, 0);
        Goto RapidFireFinish;
    WaterSpell:
        MWND A 5;
        MWND B 7 Bright Offset (0, 48) A_FireWaterSpell;
        Goto AltFireFinish;
    SunSpell:
        MWND A 7;
        MWND B 9 Bright Offset (0, 48) A_FireMissileSpell("MageWandSunMissile", 6, 0);
        Goto AltFireFinish;
    MoonSpell:
        MWND A 7;
        MWND B 9 Bright Offset (0, 48) A_FireMissileSpell("MageWandMoonMissile", 3, 0);
        Goto AltFireFinish;
    DeathSpell:
        MWND A 5;
        MWND B 7 Bright Offset (0, 48) A_FireDeathSpell;
        Goto AltFireFinish;
    LightningSpell:
        MWND A 9;
        MWND B 11 Bright Offset (0, 48) A_FireLightningSpell;
        Goto AltFireFinish;
    BloodSpell:
        MWND A 5;
		MWND B 7 Bright Offset (0, 48) A_FireBloodSpell;
        Goto AltFireFinish;
	}

    action void A_FireWaterSpell()
	{
        if (!A_AttemptFireSpell(4, 0))
            return;

        A_FireSpreadMissile("MageWandWaterMissile", 6, 6);
        A_FireSpreadMissile("MageWandWaterMissile", 6, 6);
        A_FireSpreadMissile("MageWandWaterMissile", 6, 6);
        A_FireSpreadMissile("MageWandWaterMissile", 6, 6);
        A_FireSpreadMissile("MageWandWaterMissile", 6, 6);
	}

    action void A_FireDeathSpell()
	{
        if (!A_AttemptFireSpell(5, 0))
            return;

        SpawnPlayerMissile("MageWandDeathMissile", angle);
        SpawnPlayerMissile("MageWandDeathMissile", angle + 12);
        SpawnPlayerMissile("MageWandDeathMissile", angle - 12);
	}

    action void A_FireLightningSpell()
    {
        A_FireMissileSpell("MageWandLightningMissile", 5);

        A_StartSound("ThunderCrash", CHAN_BODY);
    }

    action void A_FireBloodSpell()
	{
        if (!A_AttemptFireSpell(5, 0))
            return;

        SpawnPlayerMissile("MageWandBloodMissile", angle + 8);
        SpawnPlayerMissile("MageWandBloodMissile", angle - 8);
	}
}

class MageWandFlameMissile : Actor
{
    Default
    {
        Speed 60;
        Radius 12;
        Height 8;
        Damage 6;
        Projectile;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        Obituary "$OB_MPMWEAPWAND";
        Scale 0.75;
        DamageType "Fire";
        DeathSound "Fireball";
        SeeSound "FireDemonAttack";
    }
    States
    {
    Spawn:
        DMFX ABD 4 Bright;
        Loop;
    Death:
        DMFX D 4 A_Explode(50, 100);
        DMFX EFGH 4 Bright;
        Stop;
    }
}

class MageWandIceMissile : Actor
{
    Default
    {
        Speed 120;
        Radius 12;
        Height 8;
        Damage 4;
        Projectile;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        SeeSound "IceGuyMissileExplode";
        Obituary "$OB_MPMWEAPWAND";
        DamageType "Ice";
        DeathSound "IceGuyMissileExplode";
    }
    States
    {
    Spawn:
        SHRD ABC 4 Bright;
        Loop;
    Death:
        ICPR IJKLM 4 Bright;
        Stop;
    }
}

class MageWandPoisonMissile : Actor
{
    Default
    {
        Speed 12;
        Radius 16;
        Height 12;
        Damage 1;
        Projectile;
        +RIPPER
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        +ZDOOMTRANS
        SeeSound "PoisonShroomDeath";
        Obituary "$OB_MPMWEAPWAND";

        DamageType "Poison";
    }
    States
    {
    Spawn:
        D2FX FGHIJK 4 Bright;
    Death:
        D2FX L 4 Bright;
        Stop;
    }
}

class MageWandWaterMissile : Actor
{
    Default
    {
        Speed 40;
        Radius 8;
        Height 6;
        Damage 2;
        +SPAWNSOUNDSOURCE
        Projectile;
        -NOGRAVITY
        Gravity 0.25;
        Obituary "$OB_MPMWEAPWAND";
        DeathSound "WaterSplash";

        DamageType "Water";
    }
    States
    {
    Spawn:
        SPSH A 4;
        Loop;
    Death:
        SPSH E 4 A_RadiusThrust(3000, 64, RTF_NOIMPACTDAMAGE);
        SPSH GHIJK 4;
        Stop;
    }
}

class MageWandSunMissile : Actor
{
    Default
    {
        Speed 10;
        Radius 12;
        Height 8;
        Damage 10;
        Projectile;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        Obituary "$OB_MPMWEAPWAND";
        Scale 2.0;
        DamageType "Fire";
        SeeSound "TreeExplode";
    }
    States
    {
    Spawn:
        FDMB B 4 Bright Light("YellowSunSmall");
        Loop;
    Death:
        FDMB B 6 Bright Light("YellowSunBig") A_SunExplode;
        FDMB C 3 Bright Light("YellowSunBigFade1");
        FDMB C 3 Bright Light("YellowSunBigFade2");
        FDMB D 3 Bright Light("YellowSunBigFade3");
        FDMB D 3 Bright Light("YellowSunBigFade4");
        FDMB E 3 Bright Light("YellowSunBigFade5");
        Stop;
    }

    action void A_SunExplode()
    {
        A_Explode(65, 150);
        A_StartSound("Fireball", CHAN_BODY);
    }
}

class MageWandMoonMissile : Actor
{
    Default
    {
        Speed 30;
        Radius 12;
        Height 8;
        Damage 20;
        Projectile;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        Obituary "$OB_MPMWEAPWAND";
        Translation "Ice";
        Scale 2.0;

        SeeSound "SorcererBallWoosh";
        DeathSound "SorcererBallExplode";
    }
    States
    {
    Spawn:
        MSP1 ABCD 4 Light("MoonSmall");
        Loop;
    Death:
        RADE D 6 Light("MoonBig");
        RADE E 3 Light("MoonBigFade1");
        RADE F 3 Light("MoonBigFade2");
        RADE G 3 Light("MoonBigFade3");
        RADE H 3 Light("MoonBigFade4");
        RADE I 3 Light("MoonBigFade5");
        Stop;
    }
}

class MageWandDeathMissile : Actor
{
    Default
    {
        Speed 18;
        Radius 12;
        Height 8;
        Damage 10;
        Projectile;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        +ZDOOMTRANS
        SeeSound "BishopAttack";
        Obituary "$OB_MPMWEAPWAND";
        Scale 0.5;

        DamageType "Death";
    }
    States
    {
    Spawn:
        SBS4 ABC 4 Bright;
        Loop;
    Death:
        SBFX CDEFG 4 Bright;
        Stop;
    }
}

class MageWandLightningSmoke : Actor
{
	Default
	{
	    +NOBLOCKMAP +NOGRAVITY +SHADOW
	    +NOTELEPORT +CANNOTPUSH +NODAMAGETHRUST
        Scale 0.2;
	}
	States
	{
	Spawn:
		MLF2 Q 6;
        MLF2 PON 1;
		Stop;
	}
}
class MageWandLightningMissile : FastProjectile
{
    Default
    {
        Speed 110;
        Radius 8;
        Height 6;
        Damage 1;
        Projectile;
        +RIPPER
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        MissileType "MageWandLightningSmoke";
        Obituary "$OB_MPMWEAPWAND";
        Scale 0.2;

        DamageType "Electric";
    }
    States
    {
    Spawn:
        MLF2 Q 2 Bright;
        MLF2 Q 1 Bright WandLightiningSplit;
    Death:
        MLF2 PON 1 Bright;
        Stop;
    }

	action void WandLightiningSplit ()
	{
		if (target == null)
		{
			return;
		}
		
		A_SplitWandLightiningFire();
		A_SplitWandLightiningFire();
	}

    action void A_SplitWandLightiningFire()
	{
		if (target == null)
		{
			return;
		}
		
        int randAngle = random(-12, 12);
        int randPitch = random(-8, 8);
		let mo = target.SpawnPlayerMissile ("MageWandLightningMissile", angle + randAngle);
		if (mo != null)
		{
			mo.SetOrigin(Pos, false);
			mo.target = target;
			mo.A_SetPitch(pitch + randPitch);
			mo.Vel.Z = Vel.Z + randPitch;
			//mo.SetDamage(Damage);
		}
	}
}

class MageWandBloodMissile : Actor
{
    Default
    {
        Speed 12;
        Radius 8;
        Height 6;
        Damage 10;
        +SPAWNSOUNDSOURCE
        +SEEKERMISSILE
        Projectile;
        Obituary "$OB_MPMWEAPWAND";

        SeeSound "BatScream";
        DeathSound "Drip";
        DamageType "Blood";
    }
    States
	{
	Spawn:
		ABAT ABC 4 A_SeekerMissile(20, 60, SMF_LOOK | SMF_PRECISE);
		Loop;
	Death:
		BDSH ABCD 4;
		Stop;
	}
}