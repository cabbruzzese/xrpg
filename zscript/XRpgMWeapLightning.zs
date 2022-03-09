
// The Mage's Lightning Arc of Death ----------------------------------------

class XRpgMWeapLightning : XRpgMageWeapon replaces MWeapLightning
{
	Default
	{
		+NOGRAVITY
		Weapon.SelectionOrder 1100;
		Weapon.AmmoUse1 5;
		Weapon.AmmoGive1 25;
		Weapon.KickBack 0;
		Weapon.YAdjust 20;
		Weapon.AmmoType1 "Mana2";
		Inventory.PickupMessage "$TXT_WEAPON_M3";
		Tag "$TAG_MWEAPLIGHTNING";
	}

	States
	{
	Spawn:
		WMLG ABCDEFGH 4 Bright;
		Loop;
	Select:
		MLNG A 1 Bright A_Raise;
		Loop;
	Deselect:
		MLNG A 1 Bright A_Lower;
		Loop;
	Ready:
		MLNG AAAAA 1 Bright A_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWZOOM);
		MLNG A 1 Bright A_LightningReady;
		MLNG BBBBBB 1 Bright A_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWZOOM);
		MLNG CCCCC 1 Bright A_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWZOOM);
		MLNG C 1 Bright A_LightningReady;
		MLNG BBBBBB 1 Bright A_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWZOOM);
		Loop;
	Fire:
		MLNG DE 3 Bright;
		MLNG F 4 Bright A_MLightningAttack;
		MLNG G 4 Bright;
		MLNG HI 3 Bright;
		MLNG I 6 Bright Offset (0, 199);
		MLNG C 2 Bright Offset (0, 55);
		MLNG B 2 Bright Offset (0, 50);
		MLNG B 2 Bright Offset (0, 45);
		MLNG B 2 Bright Offset (0, 40);
		Goto Ready;
    AltFire:
        MLNG DE 3 Bright A_AltFireCheckSpellSelected;
		MLNG F 3 Bright A_FireSpell;
	AltFireFinish:
		MLNG G 4 Bright;
		MLNG HI 3 Bright;
		MLNG I 6 Bright Offset (0, 199);
		MLNG C 2 Bright Offset (0, 55);
		MLNG B 2 Bright Offset (0, 50);
		MLNG B 2 Bright Offset (0, 45);
		MLNG B 2 Bright Offset (0, 40) A_ReFire;
		Goto Ready;
	RapidFireFinish:
		MLNG H 3 Bright A_ReFire;
        MLNG I 3 Bright;
		MLNG I 6 Bright Offset (0, 199);
		MLNG C 2 Bright Offset (0, 55);
		MLNG B 2 Bright Offset (0, 50);
		MLNG B 2 Bright Offset (0, 45);
		MLNG B 2 Bright Offset (0, 40);
		Goto Ready;
	FlameSpell:
		MLNG F 1 Bright A_FireMissileSpell("MageLightningFlameMissile2", 3, 2);
        Goto AltFireFinish;
    IceSpell:
		MLNG F 1 Bright A_FireIceSpell;
        Goto AltFireFinish;
    PoisonSpell:
		MLNG F 1 Bright A_FireMissileSpell("MageLightningPoisonMissile", 2, 2);
        Goto RapidFireFinish;
    WaterSpell:
		MLNG F 1 Bright A_FireMissileSpell("MageLightningWaterMissile", 1, 1);
        Goto AltFireFinish;
    SunSpell:
		MLNG F 1 Bright A_FireMissileSpell("MageLightningSunMissile", 10, 10);
        Goto AltFireFinish;
    MoonSpell:
		MLNG F 1 Bright A_FireMissileSpell("MageLightningMoonMissile", 8, 8);
        Goto AltFireFinish;
    DeathSpell:
		MLNG F 1 Bright A_FireMissileSpell("MageLightningDeathMissile", 10, 10);
        Goto AltFireFinish;
    LightningSpell:
		MLNG F 1 Bright A_FireLightningSpell();
        Goto AltFireFinish;
    BloodSpell:
		MLNG F 1 Bright A_FireBloodSpell;
        Goto AltFireFinish;
	Reload:
		#### # 8 Bright A_NextSpell;
		Goto Ready;
    Zoom:
		#### # 8 Bright A_PrevSpell;
		Goto Ready;
	}

	action void A_FireIceSpell()
	{
        if (!A_AttemptFireSpell(3, 3))
            return;

        SpawnPlayerMissile("MageLightningIceMissile", angle);
        SpawnPlayerMissile("MageLightningIceMissile", angle + 12);
        SpawnPlayerMissile("MageLightningIceMissile", angle - 12);

		A_StartSound ("IceGuyMissileExplode", CHAN_BODY);
	}

	action void A_FireLightningSpell()
	{
		double slope = AimLineAttack (angle, DEFMELEERANGE, null, 0., ALF_CHECK3D);
		weaponspecial = (LineAttack (angle, DEFMELEERANGE, slope, 0, 'Melee', null, true) == null);

		if (weaponSpecial)
			A_FireMissileSpell("MageLightningLightningTele", 10, 10);
	}

    action void A_FireBloodSpell()
	{
		if (!A_AttemptFireSpell(7, 7))
            return;

		SpawnPlayerMissile("MageLightningBloodMissile1", angle + 9);
        SpawnPlayerMissile("MageLightningBloodMissile2", angle - 9);
	}
	
	//============================================================================
	//
	// A_LightningReady
	//
	//============================================================================

	action void A_LightningReady()
	{
		A_WeaponReady();
		if (random[LightningReady]() < 160)
		{
			A_StartSound ("MageLightningReady", CHAN_WEAPON);
		}
	}

	//============================================================================
	//
	// A_MLightningAttack
	//
	//============================================================================

	action void A_MLightningAttack(class<Actor> floor = "LightningFloor", class<Actor> ceiling = "LightningCeiling")
	{
		LightningFloor fmo = LightningFloor(SpawnPlayerMissile (floor));
		LightningCeiling cmo = LightningCeiling(SpawnPlayerMissile (ceiling));
		if (fmo)
		{
			fmo.special1 = 0;
			fmo.lastenemy = cmo;
			fmo.A_LightningZap();
		}
		if (cmo)
		{
			cmo.tracer = NULL;
			cmo.lastenemy = fmo;
			cmo.A_LightningZap();
		}
		A_StartSound ("MageLightningFire", CHAN_BODY);

		if (player != NULL)
		{
			Weapon weapon = player.ReadyWeapon;
			if (weapon != NULL)
			{
				weapon.DepleteAmmo (false);
			}
		}
	}
}

const FLAMEFLOOR_RADIUS = 90;
const FLAMEFLOOR_RADIUSDAMAGE = 80;
const FLAMEFLOOR_DAMAGE = 0;
class MageLightningFlameMissile1 : Actor
{
	Default
	{
		Radius 10;
		Height 6;
		Speed 20;
		FastSpeed 26;
		Damage 3;
		DamageType "Fire";
		Projectile;
		-ACTIVATEIMPACT
		-ACTIVATEPCROSS
		+ZDOOMTRANS
		RenderStyle "Add";
		Obituary "$OB_MPMWEAPLIGHTNING";
	}
	States
	{
	Spawn:
		FX12 AB 6 Bright;
		Loop;
	Death:
		FX12 CDEFGH 5 Bright;
		Stop;
	}
}

class MageLightningFlameMissile2 : MageLightningFlameMissile1
{
	Default
	{
		Radius 5;
		Height 12;
		Speed 24;
		FastSpeed 20;
		Damage FLAMEFLOOR_DAMAGE;
		+FLOORHUGGER
		RenderStyle "Add";
		
		+RIPPER
	}
	
	states
	{
	Spawn:
		FX13 AAAAAAAAAAAA 3 Bright A_SpellFloorFire;
		Stop;
	Death:
		FX13 I 6 BRIGHT SpellFloorFireExplode;
		FX13 JKLM 6 BRIGHT;
		Stop;
	}
	
	//----------------------------------------------------------------------------
	//
	// PROC A_SpellFloorFire
	//
	//----------------------------------------------------------------------------

	void A_SpellFloorFire()
	{
		SetZ(floorz);
		double x = Random2[MntrFloorFire]() / 64.;
		double y = Random2[MntrFloorFire]() / 64.;
		
		MageLightningFlameMissile3 mo = MageLightningFlameMissile3(Spawn("MageLightningFlameMissile3", Vec2OffsetZ(x, y, floorz), ALLOW_REPLACE));
		if (mo != null)
		{
			mo.target = target;
			mo.Vel.X = MinVel; // Force block checking
			mo.CheckMissileSpawn (radius);
			mo.SetOrigin((mo.Pos.X, mo.Pos.Y, mo.Pos.Z + 2), false);
			
			mo.SpellFloorFireExplode();
		}
	}
	
	action void SpellFloorFireExplode()
	{
		A_Explode(FLAMEFLOOR_RADIUSDAMAGE, FLAMEFLOOR_RADIUS, 0);
		A_StartSound("Fireball", CHAN_BODY);
	}
}

class MageLightningFlameMissile3 : MageLightningFlameMissile2
{
	Default
	{
		Radius 8;
		Height 16;
		Speed 0;
		Damage 0;
	}
	States
	{
	Spawn:
		FX13 IJKLM 6 BRIGHT;
		Stop;
	Death:
		FX13 M 1 BRIGHT;
		Stop;
	}
}

class MageLightningIceMissile : Actor
{
	Default
	{
		Speed 14;
		Radius 8;
		Height 10;
		Damage 6;
		DamageType "Ice";
		Projectile;
		-ACTIVATEIMPACT -ACTIVATEPCROSS
		DeathSound "IceGuyMissileExplode";
        Obituary "$OB_MPMWEAPLIGHTNING";
	}

	States
	{
	Spawn:
		ICPR ABC 3 Bright A_SpawnItemEx("IceFXPuff", 0,0,2);
		Loop;
	Death:
		ICPR D 4 Bright;
		ICPR E 4 Bright A_IceSpellMissileExplode;
		ICPR FG 4 Bright;
		ICPR H 3 Bright;
		Stop;
	}

	void A_IceSpellMissileExplode()
	{
		for (int i = 0; i < 8; i++)
		{
			Actor mo = target.SpawnMissileAngleZ (pos.z+3, "MageLightningIceMissile2", i*45., -0.3);
			if (mo)
			{
                mo.SetOrigin(Pos, false);
				mo.target = target;
			}
		}
	}
}

class MageLightningIceMissile2 : Actor
{
	Default
	{
		Speed 10;
		Radius 4;
		Height 4;
		Damage 3;
		DamageType "Ice";
		Gravity 0.125;
        Projectile;
		+NOBLOCKMAP +DROPOFF +MISSILE
		+NOTELEPORT
		+STRIFEDAMAGE
        Obituary "$OB_MPMWEAPLIGHTNING";
	}
	States
	{
	Spawn:
		ICPR NOP 3 Bright;
		Loop;
	}
}

class MageLightningPoisonMissile : Actor
{
    Default
    {
        Speed 3;
        Radius 12;
        Height 8;
        Damage 1;
        Projectile;
        +RIPPER
        +SPAWNSOUNDSOURCE
        +SEEKERMISSILE
        RenderStyle "Translucent";
        Alpha 0.6;
        SeeSound "PoisonShroomDeath";
        Obituary "$OB_MPMWEAPLIGHTNING";
        Scale 2.0;

		DamageType "Poison";
    }
    States
	{
	Spawn:
		PSBG EFGHIEFGHIEFGHI 8 Bright A_SeekerMissile(50, 60, SMF_LOOK | SMF_PRECISE);
	Death:
		PSBG D 4;
		Stop;
    }
}

class MageLightningWaterSmoke : Actor
{
	Default
	{
	    +NOBLOCKMAP +NOGRAVITY +SHADOW
	    +NOTELEPORT +CANNOTPUSH +NODAMAGETHRUST
        RenderStyle "Translucent";
        Alpha 0.5;
	}
	States
	{
        Spawn:
            SPSH ABCD 4;
            Stop;
	}
}

class MageWaterDrip : Actor
{
	Default
	{
		Radius 20;
		Height 16;
        Projectile;
		+NOBLOCKMAP
		+NOTELEPORT
		+CANNOTPUSH
		+ZDOOMTRANS
        -NOGRAVITY
        +THRUACTORS;
        Gravity 0.25;
		RenderStyle "Add";
		DamageType "Water";
        Scale 0.5;
	}

	States
	{
	Spawn:
        SPSH A 48 BRIGHT;
    Death:
		SPSH EFGHIJK 4 BRIGHT;
		Stop;
	}	
}
class MageLightningWaterMissile : TimedActor
{
    Default
    {
        Speed 70;
        Radius 12;
        Height 8;
        Damage 1;
        Projectile;
        +SPAWNSOUNDSOURCE
        +EXPLOCOUNT
        +CANPUSHWALLS
        +CANUSEWALLS
        +ACTIVATEIMPACT
        -DONTTHRUST
        -CANNOTPUSH
        -NODAMAGETHRUST
        +BOUNCEONWALLS
        +BOUNCEONFLOORS
        +BOUNCEONCEILINGS
		+USEBOUNCESTATE
        MissileType "MageLightningWaterSmoke";
        Obituary "$OB_MPMWEAPLIGHTNING";
        Scale 3.0;
        PushFactor 10.0;

		DeathSound "WaterSplash";
		DamageType "Water";

		TimedActor.TimeLimit 50;
    }
    States
    {
    Spawn:
        SPSH AAAAAAAAA 3 A_DripWater;
    Death:
        SPSH B 4;
        SPSH CD 4;
        Stop;
	Bounce:
		SPSH A 1 A_WaterBounce;
		Goto Spawn;
    }

	action void A_WaterBounce()
	{
		A_StartSound("WaterSplash", CHAN_BODY);
	}

    action void A_DripWater ()
	{
        Spawn("MageWaterDrip", pos, ALLOW_REPLACE);
        A_RadiusThrust(2000, 32, RTF_NOIMPACTDAMAGE);
	}

	override int DoSpecialDamage (Actor victim, int damage, Name damagetype)
	{
		//If attack does damage and has vertical velocity, divide it by 2 to act like friction.
		if (damage > 0 && (Vel.Z > 0.1 || Vel.Z < -0.1 ))
		{
			Vel.Z = Vel.Z / 2.0;
		}

		return super.DoSpecialDamage(victim, damage, damagetype);
	}
}

const SUN_RADIANT_DAMAGE = 40;
const SUN_RADIANT_DIST = 300;
class MageLightningSunMissile : Actor
{
    Default
    {
        Speed 4;
        Radius 12;
        Height 8;
        Damage 0;
        Projectile;
        +SPAWNSOUNDSOURCE
        +RIPPER
        Obituary "$OB_MPMWEAPLIGHTNING";
        Scale 6.0;
        DamageType "Fire";
		SeeSound "TreeExplode";
    }
    States
    {
    Spawn:
        FDMB B 16 Bright Light("YellowSunBig");
        FDMB B 4 Light("YellowSunBigFlicker") A_SunFlicker;
        FDMB B 16 Bright Light("YellowSunBig");
        FDMB B 4 Light("YellowSunBigFlicker") A_SunFlicker;
        FDMB B 16 Bright Light("YellowSunBig");
        FDMB B 4 Light("YellowSunBigFlicker") A_SunFlicker;
        FDMB B 14 Bright Light("YellowSunBig");
        FDMB B 4 Light("YellowSunBigFlicker") A_SunFlicker;
        FDMB B 12 Bright Light("YellowSunBig");
        FDMB B 4 Light("YellowSunBigFlicker") A_SunFlicker;
        FDMB B 10 Bright Light("YellowSunBig");
        FDMB B 4 Light("YellowSunBigFlicker") A_SunFlicker;
        FDMB B 8 Bright Light("YellowSunBig");
        FDMB B 4 Light("YellowSunBigFlicker") A_SunFlicker;
        FDMB B 6 Bright Light("YellowSunBig");
        FDMB B 4 Light("YellowSunBigFlicker") A_SunFlicker;
        FDMB B 4 Bright Light("YellowSunBig");
        FDMB B 4 Light("YellowSunBigFlicker") A_SunFlicker;
        FDMB B 2 Bright Light("YellowSunBig");
        FDMB B 4 Light("YellowSunBigFlicker") A_SunFlicker;
        FDMB B 2 Bright Light("YellowSunBig");
        FDMB B 4 Light("YellowSunBigFlicker") A_SunFlicker;
        FDMB B 2 Bright Light("YellowSunBig");
        FDMB B 4 Light("YellowSunBigFlicker") A_SunFlicker;
        FDMB B 2 Bright Light("YellowSunBig");
        FDMB B 4 Light("YellowSunBigFlicker") A_SunFlicker;
        FDMB B 8 Bright Light("YellowSunBig");
    Death:
        FDMB B 6 Bright Light("YellowSunBig") A_SunExplode;
        FDMB C 3 Bright Light("YellowSunBigFade1");
        FDMB C 3 Bright Light("YellowSunBigFade2");
        FDMB D 3 Bright Light("YellowSunBigFade3");
        FDMB D 3 Bright Light("YellowSunBigFade4");
        FDMB E 3 Bright Light("YellowSunBigFade5");
        Stop;
    }

    action void A_SunFlicker()
    {
        A_Explode(SUN_RADIANT_DAMAGE, SUN_RADIANT_DIST, false);
		A_StartSound("LavaSizzle", CHAN_BODY);
    }

	action void A_SunExplode()
	{
		A_Explode(150, 300);
		A_StartSound("Fireball", CHAN_BODY);
	}
}

// Wand Missile -------------------------------------------------------------

class MageLightningMoonStar : FastProjectile
{
	Default
	{
        Speed 184;
        Radius 12;
        Height 8;
        Damage 1;
        +RIPPER +CANNOTPUSH +NODAMAGETHRUST
        MissileType "MageWandSmoke";
        Obituary "$OB_MPMWEAPLIGHTNING";
        Translation "Ice";
        Scale 2.0;
	}
	States
	{
	Spawn:
		MWND CD 4 Bright;
		Loop;
	Death:
		MWND E 4 Bright;
		MWND F 3 Bright;
		MWND G 4 Bright;
		MWND H 3 Bright;
		MWND I 4 Bright;
		Stop;
	}
}

class MageLightningMoonMissile : Actor
{
    Default
    {
        Speed 0;
        Radius 12;
        Height 8;
        Damage 0;
        Projectile;
        +RIPPER
        Obituary "$OB_MPMWEAPLIGHTNING";
        Translation "Ice";
        Scale 4.0;
        Health 24;

		SeeSound "SorcererBallWoosh";
		DeathSound "SorcererBallExplode";
    }
    States
    {
    Spawn:
        MSP1 A 32;
    Pull:
        MSP1 ABC 8 Light("MoonBig") A_BigMoonPull(0);
        MSP1 D 8 Light("MoonBig") A_BigMoonPull(1);
        Loop;
    Death:
        RADE D 6 Light("MoonBigFade1");
        RADE E 6 Light("MoonBigFade2");
        RADE F 6 Light("MoonBigFade3");
        RADE G 6 Light("MoonBigFade4");
        RADE HI 3 Light("MoonBigFade5");
        Stop;
    }

    action void A_FireStars()
    {
        let angleMod = Random[MSpellMoon3](1, 360);

        let mo = target.SpawnPlayerMissile("MageLightningMoonStar", angleMod);
        if (mo)
        {
            let pitchMod = frandom[MSpellMoon3](-40, 40);
            mo.SetOrigin(Pos, false);
            mo.Vel.Z = pitchMod;
        }
    }

	action void A_BigMoonPull(int doPull)
	{
		A_StartSound("BishopAttack", CHAN_BODY);

        if (doPull)
        {
    		A_RadiusThrust(-4000, 300, RTF_NOIMPACTDAMAGE & RTF_THRUSTZ);
        }
		
        for (int i = 0; i < 5; i++)
        {
            A_FireStars();
        }

        Health--;

        if (Health < 1)
            SetStateLabel("Death");
	}
}

class MageLightningDeathMissile : Actor
{
    Default
    {
        Speed 40;
        Radius 12;
        Height 8;
        Damage 10;
		Projectile;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
		+SKYEXPLODE
		+NOSHIELDREFLECT
        Obituary "$OB_MPMWEAPLIGHTNING";
		DamageType "Death";

		SeeSound "SpiritActive";
    }
    States
    {
    Spawn:
        SPIR AB 8;
        Loop;
    Death:
        SPIR EFGHI 4;
		SPIR J 4 A_RaiseDead;
        Stop;
    }

	action void A_RaiseDead()
	{
		let rd = A_RadiusGive("RaiseDeadItem", 100, RGF_CORPSES);
	}
}

class MageLightningLightningSmoke : Actor
{
	Default
	{
	    +NOBLOCKMAP +NOGRAVITY +SHADOW
	    +NOTELEPORT +CANNOTPUSH +NODAMAGETHRUST
		Scale 0.75;
	}
	States
	{
	Spawn:
		MLFX L 12;
		Stop;
	}
}
class MageLightningLightningMissile : FastProjectile
{
    Default
    {
        Speed 120;
        Radius 12;
        Height 8;
        Damage 1;
        Projectile;
        +RIPPER
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        MissileType "MageFrostLightningSmoke";
        DeathSound "MageLightningFire";
        Obituary "$OB_MPMWEAPFROST";
		Scale 1.5;

		DamageType "Electric";
    }
    States
    {
    Spawn:
        MLFX K 2 Bright;
		Loop;
    Death:
        MLFX M 2 Bright A_Explode(70, 200, false);
        Stop;
    }
}

const STORMLIGHTNING_DIST = 64;
const STORMLIGHTNING_ZSPEED = -90;
class MageLightningLightningTele : Actor
{
    Default
    {
        Speed 50;
        Radius 20;
        Height 66;
        Damage 0;
        Projectile;
        +CANNOTPUSH 
		+NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
		+BLOCKASPLAYER
    }
    States
    {
    Spawn:
        TNT1 AAAAA 2;
    Death:
		TNT1 A 2 A_TeleportOwner;
        Stop;
    }

	action void A_TeleportOwner()
	{
		if (!target)
			return;
		
		let xrpgPlayer = XRpgPlayer(target);
		if (!xrpgPlayer)
			return;
		
		xrpgPlayer.A_FireVerticalMissile("MageLightningLightningMissile", STORMLIGHTNING_DIST, STORMLIGHTNING_DIST, STORMLIGHTNING_ZSPEED, xrpgPlayer.Pos.X, xrpgPlayer.Pos.Y);
		xrpgPlayer.A_FireVerticalMissile("MageLightningLightningMissile", STORMLIGHTNING_DIST, STORMLIGHTNING_DIST, STORMLIGHTNING_ZSPEED, xrpgPlayer.Pos.X, xrpgPlayer.Pos.Y);
		xrpgPlayer.A_FireVerticalMissile("MageLightningLightningMissile", STORMLIGHTNING_DIST, STORMLIGHTNING_DIST, STORMLIGHTNING_ZSPEED, xrpgPlayer.Pos.X, xrpgPlayer.Pos.Y);
		xrpgPlayer.A_FireVerticalMissile("MageLightningLightningMissile", STORMLIGHTNING_DIST, STORMLIGHTNING_DIST, STORMLIGHTNING_ZSPEED, xrpgPlayer.Pos.X, xrpgPlayer.Pos.Y);
		xrpgPlayer.A_FireVerticalMissile("MageLightningLightningMissile", STORMLIGHTNING_DIST, STORMLIGHTNING_DIST, STORMLIGHTNING_ZSPEED, xrpgPlayer.Pos.X, xrpgPlayer.Pos.Y);
		
		let mo = Spawn("LightningLeaderFx1");
		if (mo)
		{
			mo.target = target;
			mo.SetOrigin(xrpgPlayer.Pos + (0,0,28), false);
		}

		xrpgPlayer.Teleport (Pos, xrpgPlayer.angle, TELF_KEEPVELOCITY | TELF_KEEPORIENTATION);
	}
}

const BLOOD_MAX_MANADRAIN = 20;
const BLOOD_SPEED = 8;
class MageLightningBloodMissile1 : Actor
{
    Default
    {
        Speed BLOOD_SPEED;
        Radius 16;
        Height 12;
        Damage 1;
        Projectile;
        +RIPPER
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        +ZDOOMTRANS
		+NOSHIELDREFLECT
        Obituary "$OB_MPMWEAPFROST";

		Health BLOOD_MAX_MANADRAIN; //max mana restore
		DamageType "Blood";

		Scale 1.5;
		Translation "Ice";
		RenderStyle "Translucent";
		Alpha 0.6;
    }
    States
    {
    Spawn:
        FSFX DEFGHIJK 2 Bright;
    Death:
        FSFX L 2 Bright;
        Stop;
    }

	override int DoSpecialDamage(Actor targetMonster, int damage, name damagetype)
	{
		let playerObj = XRpgPlayer(target);
		if (playerObj && playerObj.Health > 0 && Health > 0)
		{
			Health--;

			let ammo = Inventory(playerObj.FindInventory("Mana1"));

        	if (ammo)
			{
				ammo.Amount += 1;
				if (ammo.Amount > ammo.MaxAmount)
					ammo.Amount = ammo.MaxAmount;

			}
		}
		
		return Super.DoSpecialDamage(targetMonster, damage, damagetype);
	}
}
class MageLightningBloodMissile2 : Actor
{
    Default
    {
        Speed BLOOD_SPEED;
        Radius 16;
        Height 12;
        Damage 1;
        Projectile;
        +RIPPER
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        +ZDOOMTRANS
		+NOSHIELDREFLECT
        Obituary "$OB_MPMWEAPFROST";

		Health BLOOD_MAX_MANADRAIN; //max mana restore
		DamageType "Blood";
		
		Scale 1.5;
		RenderStyle "Translucent";
		Alpha 0.6;

		SeeSound "WraithAttack";
    }
    States
    {
    Spawn:
        FSFX DEFGHIJK 2 Bright;
    Death:
        FSFX L 2 Bright;
        Stop;
    }

	override int DoSpecialDamage(Actor targetMonster, int damage, name damagetype)
	{
		let playerObj = XRpgPlayer(target);
		if (playerObj && playerObj.Health > 0 && Health > 0)
		{
			Health--;

			let ammo = Inventory(playerObj.FindInventory("Mana2"));

        	if (ammo)
			{
				ammo.Amount += 1;
				if (ammo.Amount > ammo.MaxAmount)
					ammo.Amount = ammo.MaxAmount;

			}
		}
		
		return Super.DoSpecialDamage(targetMonster, damage, damagetype);
	}
}