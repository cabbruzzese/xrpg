// Mage Weapon Piece --------------------------------------------------------

class XRpgMageWeaponPiece : WeaponPiece replaces MWeaponPiece1
{
	Default
	{
		Inventory.PickupSound "misc/w_pkup";
		Inventory.PickupMessage "$TXT_BLOODSCOURGE_PIECE";
		Inventory.ForbiddenTo "FighterPlayer", "ClericPlayer";
		WeaponPiece.Weapon "XRpgMWeapBloodscourge";
		+FLOATBOB
	}
}

// Mage Weapon Piece 1 ------------------------------------------------------

class XRpgMWeaponPiece1 : XRpgMageWeaponPiece replaces MWeaponPiece1
{
	Default
	{
		WeaponPiece.Number 1;
	}
	States
	{
	Spawn:
		WMS1 A -1 Bright;
		Stop;
	}
}

// Mage Weapon Piece 2 ------------------------------------------------------

class XRpgMWeaponPiece2 : XRpgMageWeaponPiece replaces MWeaponPiece2
{
	Default
	{
		WeaponPiece.Number 2;
	}
	States
	{
	Spawn:
		WMS2 A -1 Bright;
		Stop;
	}
}

// Mage Weapon Piece 3 ------------------------------------------------------

class XRpgMWeaponPiece3 : XRpgMageWeaponPiece replaces MWeaponPiece3
{
	Default
	{
		WeaponPiece.Number 3;
	}
	States
	{
	Spawn:
		WMS3 A -1 Bright;
		Stop;
	}
}

// Bloodscourge Drop --------------------------------------------------------

class XRpgBloodscourgeDrop : Actor replaces BloodscourgeDrop
{
	States
	{
	Spawn:
		TNT1 A 1;
		TNT1 A 1 A_DropWeaponPieces("MWeaponPiece1", "MWeaponPiece2", "MWeaponPiece3");
		Stop;
	}
}

class XRpgMWeapBloodscourge : XRpgMageWeapon replaces MWeapBloodscourge
{
	int MStaffCount;

	XRpgSummonBat Bats[3];
	
	Default
	{
		Health 3;
		Weapon.SelectionOrder 3100;
		Weapon.AmmoUse1 15;
		Weapon.AmmoUse2 15;
		Weapon.AmmoGive1 20;
		Weapon.AmmoGive2 20;
		Weapon.KickBack 150;
		Weapon.YAdjust 20;
		Weapon.AmmoType1 "Mana1";
		Weapon.AmmoType2 "Mana2";
		+WEAPON.PRIMARY_USES_BOTH;
		+WEAPON.ALT_AMMO_OPTIONAL;
		+Inventory.NoAttenPickupSound
		Inventory.PickupMessage "$TXT_WEAPON_M4";
		Inventory.PickupSound "WeaponBuild";
		Tag "$TAG_MWEAPBLOODSCOURGE";
	}

	States
	{
	Spawn:
		TNT1 A -1;
		Stop;
	Select:
		MSTF A 1 A_Raise;
		Loop;
	Deselect:
		MSTF A 1 A_Lower;
		Loop;
	Ready:
		MSTF AAAAAABBBBBBCCCCCCDDDDDDEEEEEEFFFFF 1 A_WeaponReady;
		Loop;
	Fire:
		MSTF G 4 Offset (0, 40);
		MSTF H 4 Bright Offset (0, 48) A_MStaffAttack;
		MSTF H 2 Bright Offset (0, 48) A_MStaffPalette;
		MSTF II 2 Offset (0, 48) A_MStaffPalette;
		MSTF I 1 Offset (0, 40);
		MSTF J 5 Offset (0, 36);
		Goto Ready;
    AltFire:
        MSTF G 4 Offset (0, 40) A_AltFireCheckSpellSelected;
		MSTF H 3 Bright Offset (0, 48) A_FireSpell;
	AltFireFinish:
		MSTF H 2 Bright Offset (0, 48) A_MStaffPalette;
		MSTF II 2 Offset (0, 48) A_MStaffPalette;
		MSTF I 1 Offset (0, 40);
		MSTF J 5 Offset (0, 36) A_ReFire;
		Goto Ready;
    RapidFireFinish:
        MSTF H 1 Bright Offset (0, 48) A_ReFire;
		MSTF H 2 Bright Offset (0, 48) A_MStaffPalette;
		MSTF II 2 Offset (0, 48) A_MStaffPalette;
		MSTF I 1 Offset (0, 40);
		MSTF J 5 Offset (0, 36);
		Goto Ready;
	FlameSpell:
		MSTF H 1 Bright Offset (0, 48) A_FireMissileSpell("MageStaffFlameMissile", 0, 0);
        Goto RapidFireFinish;
    IceSpell:
		MSTF H 7 Bright Offset (0, 48) A_FireIceSpell;
        Goto AltFireFinish;
    PoisonSpell:
		MSTF H 5 Bright Offset (0, 48) A_FirePoisonSpell;
        Goto AltFireFinish;
    WaterSpell:
		MSTF H 5 Bright Offset (0, 48) A_FireWaterSpell;
        Goto AltFireFinish;
    SunSpell:
		MSTF H 15 Bright Offset (0, 48) A_FireSunSpell;
        Goto AltFireFinish;
    MoonSpell:
		MSTF H 9 Bright Offset (0, 48) A_FireMissileSpell("MageStaffMoonMissile", 0, 0);
        Goto AltFireFinish;
    DeathSpell:
		MSTF H 9 Bright Offset (0, 48) A_FireMissileSpell("MageStaffDeathMissile2", 0, 0);
        Goto AltFireFinish;
    LightningSpell:
		MSTF H 1 Bright Offset (0, 48) A_FireLightningSpell(true);
		MSTF H 4 Bright Offset (0, 48) A_FireLightningSpell(true);
		MSTF H 4 Bright Offset (0, 48) A_FireLightningSpell(true);
		MSTF H 16 Bright Offset (0, 48);
        Goto AltFireFinish;
    BloodSpell:
		MSTF H 1 Bright Offset (0, 48) A_FireBloodSpell;
		MSTF H 24 Bright Offset (0, 48);
        Goto AltFireFinish;
	}

	//Final weapon attacks are weaker but do not use ammo
    action void A_FireIceSpell()
	{
        for (int i = 0; i < 4; i++)
        {
            A_FireSpreadMissile("MageStaffIceMissile", 10, 5);
        }
	}

    const STAFFPOISON_DIST = 64;
    action void A_FirePoisonSpell()
	{
        let xo = random(-STAFFPOISON_DIST, STAFFPOISON_DIST);
		let yo = random(-STAFFPOISON_DIST, STAFFPOISON_DIST);

		Vector3 spawnpos = Vec2OffsetZ(xo, yo, -64);
        Actor mo = SpawnPlayerMissile("MageStaffPoisonMissile");
        mo.SetOrigin(spawnpos, false);
	}

    action void A_FireWaterSpell()
	{
        for (int i = 0; i < 3; i++)
        {
            A_FireSpreadMissile("MageStaffWaterMissile", 6, 2);
        }
	}

    const STAFFSUN_ZSPEED = 0.5;
    const STAFFSUN_ZOFFSET = 0;
    action void A_FireSunSpell()
	{
        Actor mo = SpawnPlayerMissile("MageStaffSunMissile");
        mo.Vel.Z = STAFFSUN_ZSPEED;
        mo.SetOrigin((mo.Pos.X, mo.Pos.Y, Pos.Z + STAFFSUN_ZOFFSET), false);
	}

	const STAFFLIGHTNINGCHARGE_THRUST = 12;
	action void A_FireLightningSpell(bool isFiring)
	{
		if (isFiring)
			A_FireVerticalMissile("MageStaffLightningMissile", 2, 2);
		
		Thrust(STAFFLIGHTNINGCHARGE_THRUST, angle);
	}

	const SUMMONBAT_DIST = 100.0;
	const SUMMONBAT_HEIGHTMOD = 20.0;
	action void A_AddBatToList(XRpgSummonBat batObj)
	{
		XRpgSummonBat bat0 = batObj;
		XRpgSummonBat bat1 = invoker.Bats[0];
		XRpgSummonBat bat2 = invoker.Bats[1];
		XRpgSummonBat bat3 = invoker.Bats[2];

		if (bat3 != null)
			bat3.Destroy();

		invoker.Bats[0] = bat0;
		invoker.Bats[1] = bat1;
		invoker.Bats[2] = bat2;
	}
	action void A_FireBloodSpell()
	{
		XRpgSummonBat mo = XRpgSummonBat(Spawn("XRpgSummonBat"));
		if (!mo)
			return;

		Vector3 dir = (AngleToVector(angle, cos(pitch)), -sin(pitch));
		let forwardDir = (dir.X * SUMMONBAT_DIST, dir.Y * SUMMONBAT_DIST, dir.Z * SUMMONBAT_DIST);
		mo.SetOrigin((Pos.X + forwardDir.X, Pos.Y + forwardDir.Y, Pos.Z + forwardDir.Z + SUMMONBAT_HEIGHTMOD), false);

		A_AddBatToList(mo);
	}
	
	//============================================================================
	//
	// 
	//
	//============================================================================

	override Color GetBlend ()
	{
		if (paletteflash & PF_HEXENWEAPONS)
		{
			if (MStaffCount == 3)
				return Color(128, 100, 73, 0);
			else if (MStaffCount == 2)
				return Color(128, 125, 92, 0);
			else if (MStaffCount == 1)
				return Color(128, 150, 110, 0);
			else
				return Color(0, 0, 0, 0);
		}
		else
		{
			return Color (MStaffCount * 128 / 3, 151, 110, 0);
		}
	}

	//============================================================================
	//
	// MStaffSpawn
	//
	//============================================================================

	private action void MStaffSpawn (double angle, Actor alttarget)
	{
		FTranslatedLineTarget t;

		Actor mo = SpawnPlayerMissile ("MageStaffFX2", angle, pLineTarget:t);
		if (mo)
		{
			mo.target = self;
			if (t.linetarget && !t.unlinked)
				mo.tracer = t.linetarget;
			else
				mo.tracer = alttarget;
		}
	}

	//============================================================================
	//
	// A_MStaffAttack
	//
	//============================================================================

	action void A_MStaffAttack()
	{
		FTranslatedLineTarget t;

		if (player == null)
		{
			return;
		}

		Weapon weapon = player.ReadyWeapon;
		if (weapon != NULL)
		{
			if (!weapon.DepleteAmmo (weapon.bAltFire))
				return;
		}
		
		// [RH] Let's try and actually track what the player aimed at
		AimLineAttack (angle, PLAYERMISSILERANGE, t, 32.);
		if (t.linetarget == NULL)
		{
			t.linetarget = RoughMonsterSearch(10, true, true);
		}
		MStaffSpawn (angle, t.linetarget);
		MStaffSpawn (angle-5, t.linetarget);
		MStaffSpawn (angle+5, t.linetarget);
		A_StartSound ("MageStaffFire", CHAN_WEAPON);
		invoker.MStaffCount = 3;
	}

	//============================================================================
	//
	// A_MStaffPalette
	//
	//============================================================================

	action void A_MStaffPalette()
	{
		if (invoker.MStaffCount > 0) invoker.MStaffCount--;
	}
}

class MageStaffFlameMissile : Actor
{
    Default
    {
        Speed 14;
        Radius 12;
        Height 8;
        Damage 4;
        Projectile;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        +ZDOOMTRANS
        Obituary "$OB_MPMWEAPBLOODSCOURGE";
		DamageType "Fire";

        RenderStyle "Translucent";
        Alpha 0.7;
        Scale 0.5;
    }
    States
    {
    Spawn:
        FHFX I 6 Bright;
        FHFX JKL 2 Bright;
    Death:
        FHFX MNOPQR 2 Bright;
        Stop;
    }
}

class MageStaffIceMissile : FastProjectile
{
    Default
    {
        Speed 120;
        Radius 12;
        Height 8;
        Damage 1;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        SeeSound "IceGuyMissileExplode";
        Obituary "$OB_MPMWEAPBLOODSCOURGE";
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

class MageStaffPoisonMissile : Actor
{
    Default
    {
        Speed 0;
        Radius 16;
        Height 12;
        Damage 1;
        Projectile;
        +RIPPER
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        +ZDOOMTRANS
        SeeSound "PoisonShroomDeath";
        Obituary "$OB_MPMWEAPBLOODSCOURGE";

        RenderStyle "Translucent";
        Alpha 0.4;
        Scale 1.5;
    }
    States
    {
    Spawn:
        PSBG EFGHI 4 Bright;
        PSBG EFGHI 4 Bright;
        PSBG EFGHI 4 Bright;
        PSBG EFGHI 4 Bright;
        PSBG EFGHI 4 Bright;
    Death:
        PSBG D 4 Bright;
        Stop;
    }
}

class MageStaffWaterMissile : Actor
{
    Default
    {
        Speed 25;
        Radius 8;
        Height 8;
        Damage 2;
		Projectile;
        +SPAWNSOUNDSOURCE
        Obituary "$OB_MPMWEAPBLOODSCOURGE";
		Gravity 0.2;
		+NOBLOCKMAP +MISSILE +DROPOFF
		+NOTELEPORT
		+BOUNCEONFLOORS
		+BOUNCEONCEILINGS
		+BOUNCEONWALLS
		+USEBOUNCESTATE
		-NOGRAVITY
		Health 2;

    }
    States
    {
    Spawn:
        SPSH A 6 A_DripWater;
        Loop;
    Death:
        SPSH B 4 A_RadiusThrust(4000, 32, RTF_NOIMPACTDAMAGE & RTF_THRUSTZ );
        SPSH CD 4;
        Stop;
    Bounce:
		SPSH a 1 A_WaterSplashImpact;
		Goto Spawn;
    }

	void A_DripWater ()
	{
        Spawn("MageWaterDrip", pos, ALLOW_REPLACE);
	}

	//Bounce
	void A_WaterSplashImpact()
	{
		Health--;
		if (Health < 1)
		{
			SetStateLabel("Death");
			return;
		}
	}
}

class MageStaffSunMissile : Actor
{
    Default
    {
        Speed 0;
        Radius 2;
        Height 2;
        Damage 0;
        Projectile;
        +RIPPER
        +SPAWNSOUNDSOURCE
        Obituary "$OB_MPMWEAPBLOODSCOURGE";
        Scale 2.0;
        DamageType "Fire";
        DeathSound "Fireball";
    }
    States
    {
    Spawn:
        FDMB B 96 Bright Light("YellowSunSmall");
    Death:
        FDMB B 6 Bright Light("YellowSunBig") A_Explode(50, 100, false);
        FDMB C 3 Bright Light("YellowSunBigFade3");
        FDMB D 3 Bright Light("YellowSunBigFade4");
        FDMB E 3 Bright Light("YellowSunBigFade5");
        Stop;
    }
}

class MageStaffMoonMissile : Actor
{
    Default
    {
        Speed 10;
        Radius 8;
        Height 8;
        Damage 0;
        Projectile;
        +RIPPER;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        Obituary "$OB_MPMWEAPBLOODSCOURGE";
        Translation "Ice";
    }
    States
    {
    Spawn:
        MSP1 ABCD 4 Light("MoonSmall");
    Death:
        RADE DE 3 Light("MoonBigFade3") A_Blast(BF_NOIMPACTDAMAGE, 255, 120);
        RADE FG 3 Light("MoonBigFade4");
        RADE HI 3 Light("MoonBigFade5");
        Stop;
    }
}

class MageStaffLightningSmoke : Actor
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
class MageStaffLightningMissile : FastProjectile
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
        MissileType "MageStaffLightningSmoke";
        DeathSound "MageLightningFire";
        Obituary "$OB_MPMWEAPBLOODSCOURGE";
		Scale 1.5;
    }
    States
    {
    Spawn:
        MLFX K 2 Bright;
		Loop;
    Death:
        MLFX M 2 Bright A_Explode(20, 120, false);
        Stop;
    }
}

const DEATHFLOOR_RADIUS = 80;
const DEATHFLOOR_RADIUSDAMAGE = 10;
//CPS3A0
class MageStaffDeathMissile1 : Actor
{
	Default
	{
		Radius 10;
		Height 6;
		Speed 20;
		FastSpeed 26;
		Damage 3;
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

class MageStaffDeathMissile2 : MageStaffDeathMissile1
{
	Default
	{
		Radius 5;
		Height 12;
		Speed 4;
		FastSpeed 20;
		Damage 0;
		+FLOORHUGGER
		+YFLIP
		RenderStyle "None";
		
		+RIPPER
	}
	
	states
	{
	Spawn:
		TNT1 AAAAA 16 Bright A_SpellFloorFire;
		Stop;
	Death:
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
		MageStaffDeathMissile3 mo = MageStaffDeathMissile3(Spawn("MageStaffDeathMissile3", Vec2OffsetZ(0, 0, floorz), ALLOW_REPLACE));
		if (mo != null)
		{
			mo.target = target;
			mo.Vel.X = MinVel; // Force block checking
			mo.CheckMissileSpawn (radius);
			mo.SetOrigin((mo.Pos.X, mo.Pos.Y, mo.Pos.Z), false);
		}
	}
}

class MageStaffDeathMissile3 : Actor
{
	Default
	{
		Radius 8;
		Height 60;
		Speed 0;
		Damage 0;

		+FLOORCLIP
		+NOGRAVITY
		+DROPOFF
		+FLOAT
		+YFLIP

		-SHOOTABLE
		-SOLID
		+DONTMORPH
		+DONTBLAST
		+SPECIALFLOORCLIP
		+STAYMORPHED
		+INVISIBLE

		//RenderStyle "Add";
	}
	States
	{
	Spawn:
		CPS3 A 1 BRIGHT A_WraithInit;
		CPS3 A 1 BRIGHT A_InitRise;
		CPS3 AAAAAA 3 BRIGHT A_RiseFromGround(10);
	Death:
		CPS3 A 4 BRIGHT SpellFloorFireExplode;
		CPS3 AAAAAA 3 BRIGHT A_RiseFromGround(-10);
		Stop;
	}

	void A_WraithInit()
	{
		AddZ(60);

		// [RH] Make sure the wraith didn't go into the ceiling
		if (pos.z + height > ceilingz)
		{
			SetZ(ceilingz - Height);
		}

		WeaveIndexZ = 0;			// index into floatbob
	}

	action void A_InitRise()
	{
		bInvisible = false;
		bDontBlast = false;
		Floorclip = Height;
	}

	action void A_RiseFromGround(int riseDist)
	{
		if (riseDist > 0)
			RaiseMobj (riseDist);
		else 
			SinkMobj (-riseDist);

		SpawnDirt (radius);
	}

	action void SpellFloorFireExplode()
	{
		A_Explode(FLAMEFLOOR_RADIUSDAMAGE, FLAMEFLOOR_RADIUS, 0);
	}
}