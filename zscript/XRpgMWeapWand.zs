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
		MWND A 1 A_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWZOOM);
		Loop;
	Fire:
		MWND A 6;
		MWND B 6 Bright Offset (0, 48) A_FireProjectile ("MageWandMissile");
		MWND A 3 Offset (0, 40);
		MWND A 3 Offset (0, 36) A_ReFire;
		Goto Ready;
    AltFire:
		MWND A 0 A_AltFireCheckSpellSelected(WEAPON_ID_MAGE_WAND);
        MWND A 1;
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
        MWND B 7 Bright Offset (0, 48) A_FireMissileSpell("MageWandFlameMissile", MANA_WAND_FLAME_BLUE, MANA_WAND_FLAME_GREEN);
        Goto AltFireFinish;
    IceSpell:
        MWND A 3;
        MWND B 2 Bright Offset (0, 48) A_FireMissileSpell("MageWandIceMissile", MANA_WAND_ICE_BLUE, MANA_WAND_ICE_GREEN, 0, 3, 3);
        Goto RapidFireFinish;
    PoisonSpell:
        MWND A 3;
        MWND B 2 Bright Offset (0, 48) A_FireMissileSpell("MageWandPoisonMissile", MANA_WAND_POISON_BLUE, MANA_WAND_POISON_GREEN);
        Goto RapidFireFinish;
    WaterSpell:
        MWND A 5;
        MWND B 7 Bright Offset (0, 48) A_FireWaterSpell(MANA_WAND_WATER_BLUE, MANA_WAND_WATER_GREEN);
        Goto AltFireFinish;
    SunSpell:
        MWND A 7;
        MWND B 9 Bright Offset (0, 48) A_FireMissileSpell("MageWandSunMissile", MANA_WAND_SUN_BLUE, MANA_WAND_SUN_GREEN);
        Goto AltFireFinish;
    MoonSpell:
        MWND A 7;
        MWND B 9 Bright Offset (0, 48) A_FireMissileSpell("MageWandMoonMissile", MANA_WAND_MOON_BLUE, MANA_WAND_MOON_GREEN);
        Goto AltFireFinish;
    DeathSpell:
        MWND A 5;
        MWND B 7 Bright Offset (0, 48) A_FireDeathSpell(MANA_WAND_DEATH_BLUE, MANA_WAND_DEATH_GREEN);
        Goto AltFireFinish;
    LightningSpell:
        MWND A 9;
        MWND B 11 Bright Offset (0, 48) A_FireLightningSpell(MANA_WAND_LIGHTNIN_BLUE, MANA_WAND_LIGHTNIN_GREEN);
        Goto AltFireFinish;
    BloodSpell:
        MWND A 5;
		MWND B 7 Bright Offset (0, 48) A_FireBloodSpell(MANA_WAND_BLOOD_BLUE, MANA_WAND_BLOOD_GREEN);
        Goto AltFireFinish;
    Reload:
		#### # 8 A_NextSpell;
		Goto Ready;
    Zoom:
		#### # 8 A_PrevSpell;
		Goto Ready;
	}

    action void A_FireWaterSpell(int blueManaUse, int greenManaUse)
	{
        if (!A_AttemptFireSpell(blueManaUse, greenManaUse))
            return;

        A_FireSpreadMissile("MageWandWaterMissile", 6, 6);
        A_FireSpreadMissile("MageWandWaterMissile", 6, 6);
        A_FireSpreadMissile("MageWandWaterMissile", 6, 6);
        A_FireSpreadMissile("MageWandWaterMissile", 6, 6);
        A_FireSpreadMissile("MageWandWaterMissile", 6, 6);
	}

    action void A_FireDeathSpell(int blueManaUse, int greenManaUse)
	{
        if (!A_AttemptFireSpell(blueManaUse, greenManaUse))
            return;

        SpawnPlayerMissile("MageWandDeathMissile", angle);
        SpawnPlayerMissile("MageWandDeathMissile", angle + 12);
        SpawnPlayerMissile("MageWandDeathMissile", angle - 12);
	}

    action void A_FireLightningSpell(int blueManaUse, int greenManaUse)
	{
        A_FireMissileSpell("MageWandLightningMissile", blueManaUse, greenManaUse);

        A_StartSound("ThunderCrash", CHAN_BODY);
    }

    action void A_FireBloodSpell(int blueManaUse, int greenManaUse)
	{
        if (!A_AttemptFireSpell(blueManaUse, greenManaUse))
            return;

        SpawnPlayerMissile("MageWandBloodMissile", angle + 8);
        SpawnPlayerMissile("MageWandBloodMissile", angle - 8);
	}
}

class MageWandFlameMissileSmoke : Actor
{
	Default
	{
	    +NOBLOCKMAP +NOGRAVITY +SHADOW
	    +NOTELEPORT +CANNOTPUSH +NODAMAGETHRUST
		RenderStyle "Translucent";
		Alpha 0.6;
        Scale 0.5;
		VSpeed 1;
	}
	States
	{
	Spawn:
		WRBL GHI 12 Bright;
		Stop;
	}
}
class MageWandFlameMissile : Actor
{
    Default
    {
        Speed 50;
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
        DMFX ABCD 2 Bright A_SpawnItemEx("MageWandFlameMissileSmoke", random2[Puff]()*0.015625, random2[Puff]()*0.015625, random2[Puff]()*0.015625, 
									0,0,0,0,SXF_ABSOLUTEPOSITION, 64);
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

class MageWandSunMissile : OffsetSpriteActor
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
        OffsetSpriteActor.OffsetSpriteX 0;
        OffsetSpriteActor.OffsetSpriteY 16;
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
        TNT1 A 0 A_SpriteOffset(0, 28);
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
    int lightningCount;
    property LightningCount:lightningCount;
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
        MageWandLightningMissile.LightningCount 3;

        DamageType "Electric";
    }
    States
    {
    Spawn:
        MLF2 Q 2 Bright;
        MLF2 Q 1 Bright A_WandLightiningSplit;
    Death:
        MLF2 PON 1 Bright;
        Stop;
    }

	action void A_WandLightiningSplit ()
	{
		if (target == null)
		{
			return;
		}

        if (invoker.LightningCount < 1)
            return;

        invoker.LightningCount--;
        A_SplitWandLightiningFire();
        A_SplitWandLightiningFire();
	}

    action void A_SplitWandLightiningFire()
	{
		if (target == null)
		{
			return;
		}
		
        int randAngle = random[MSpellLightning1](-12, 12);
        int randPitch = random[MSpellLightning1](-8, 8);
		MageWandLightningMissile mo = MageWandLightningMissile(target.SpawnPlayerMissile ("MageWandLightningMissile", angle + randAngle));
		if (mo != null)
		{
			mo.SetOrigin(Pos, false);
			mo.target = target;
			mo.A_SetPitch(pitch + randPitch);
			mo.Vel.Z = Vel.Z + randPitch;
            mo.LightningCount = invoker.LightningCount;
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