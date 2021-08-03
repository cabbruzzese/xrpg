
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
		MWND A 6 A_AltFireCheckSpellSelected;
		MWND B 8 Bright Offset (0, 48) A_FireSpell();
		MWND A 6 Offset (0, 40);
		MWND A 3 Offset (0, 36) A_ReFire;
		Goto Ready;
    AltHold:
        MWND A 2 A_AltHoldCheckSpellSelected;
        MWND B 2 Bright Offset (0, 48) A_FireSpell();
		MWND A 1 Offset (0, 36) A_ReFire;
        Goto Ready;
	}

    override bool IsSpellRapidFire(int spellType)
    {
        if (spellType == SPELLTYPE_ICE)
            return true;
        if (spellType == SPELLTYPE_POISON)
            return true;

        return false;
    }

    override void FireFlameSpell()
	{
        FireMissileSpell("MageWandFlameMissile", 2);
	}
    
    override void FireIceSpell()
	{
        if (!AttemptFireSpell(1, 0))
            return;

        FireSpreadMissile("MageWandIceMissile", 3, 3);
	}

    override void FirePoisonSpell()
	{
        FireMissileSpell("MageWandPoisonMissile", 2);
	}

    override void FireWaterSpell()
	{
        if (!AttemptFireSpell(4, 0))
            return;

        FireSpreadMissile("MageWandWaterMissile", 6, 6);
        FireSpreadMissile("MageWandWaterMissile", 6, 6);
        FireSpreadMissile("MageWandWaterMissile", 6, 6);
        FireSpreadMissile("MageWandWaterMissile", 6, 6);
        FireSpreadMissile("MageWandWaterMissile", 6, 6);
	}

    override void FireSunSpell()
	{
        FireMissileSpell("MageWandSunMissile", 6);
	}

    override void FireMoonSpell()
	{
        FireMissileSpell("MageWandMoonMissile", 3);
	}

    override void FireDeathSpell()
	{
        if (!AttemptFireSpell(5, 0))
            return;


        owner.SpawnPlayerMissile("MageWandDeathMissile", owner.angle);
        owner.SpawnPlayerMissile("MageWandDeathMissile", owner.angle + 12);
        owner.SpawnPlayerMissile("MageWandDeathMissile", owner.angle - 12);
	}

    override void FireLightningSpell()
	{
        FireMissileSpell("MageWandLightningMissile", 5);
	}

    override void FireBloodSpell()
	{
        if (!AttemptFireSpell(5, 0))
            return;

        owner.SpawnPlayerMissile("MageWandBloodMissile", owner.angle + 8);
        owner.SpawnPlayerMissile("MageWandBloodMissile", owner.angle - 8);
	}
}

class MageWandFlameMissile : FastProjectile
{
    Default
    {
        Speed 60;
        Radius 12;
        Height 8;
        Damage 4;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        Obituary "$OB_MPMWEAPWAND";
        Scale 0.75;
        DamageType "Fire";
        DeathSound "Fireball";
    }
    States
    {
    Spawn:
        DMFX ABD 4 Bright;
        Loop;
    Death:
        DMFX D 4 A_Explode(40, 100);
        DMFX EFGH 4 Bright;
        Stop;
    }
}

class MageWandIceMissile : FastProjectile
{
    Default
    {
        Speed 120;
        Radius 12;
        Height 8;
        Damage 4;
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
        Speed 10;
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
        Damage 4;
        Projectile;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        Obituary "$OB_MPMWEAPWAND";
        Scale 2.0;
        DamageType "Fire";
        DeathSound "Fireball";
    }
    States
    {
    Spawn:
        FDMB B 4 Bright Light("YellowSunSmall");
        Loop;
    Death:
        FDMB B 6 Bright Light("YellowSunBig") A_Explode(50, 150);
        FDMB C 3 Bright Light("YellowSunBigFade1");
        FDMB C 3 Bright Light("YellowSunBigFade2");
        FDMB D 3 Bright Light("YellowSunBigFade3");
        FDMB D 3 Bright Light("YellowSunBigFade4");
        FDMB E 3 Bright Light("YellowSunBigFade5");
        Stop;
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
    }
    States
    {
    Spawn:
        MSP1 ABCD 4 Light("MoonSmall");
        Loop;
    Death:
        RADE D 6 Light("MoonBig");
        FDMB E 3 Light("MoonBigFade1");
        FDMB F 3 Light("MoonBigFade2");
        FDMB G 3 Light("MoonBigFade3");
        FDMB H 3 Light("MoonBigFade4");
        FDMB I 3 Light("MoonBigFade5");
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
        SeeSound "MageLightningFire";
        Obituary "$OB_MPMWEAPWAND";
        Scale 0.2;
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
        Projectile;
        Obituary "$OB_MPMWEAPWAND";
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