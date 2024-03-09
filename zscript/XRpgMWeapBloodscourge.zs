// Mage Weapon Piece --------------------------------------------------------

class XRpgMageWeaponPiece : WeaponPiece replaces MageWeaponPiece
{
	Default
	{
		Inventory.PickupSound "misc/w_pkup";
		Inventory.PickupMessage "$TXT_BLOODSCOURGE_PIECE";
		Inventory.ForbiddenTo "XRpgFighterPlayer", "XRpgClericPlayer", "FighterPlayer", "ClericPlayer";
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
		TNT1 A 1 A_DropWeaponPieces("XRpgMWeaponPiece1", "XRpgMWeaponPiece2", "XRpgMWeaponPiece3");
		Stop;
	}
}

class XRpgMWeapBloodscourge : XRpgMageWeapon replaces MWeapBloodscourge
{
	int MStaffCount;
	
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
		MSTF AAAAAABBBBBBCCCCCCDDDDDDEEEEEEFFFFF 1 A_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWZOOM);
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
		MSTF H 1 Bright Offset (0, 48) A_FireMissileSpell("MageStaffFlameMissile", 2, 2);
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
		MSTF H 1 Bright Offset (0, 48) A_FireMissileSpell("MageStaffSunMissile", 1, 1);
        Goto RapidFireFinish;
    MoonSpell:
		MSTF H 9 Bright Offset (0, 48) A_FireMissileSpell("MageStaffMoonMissile", 3, 3);
        Goto AltFireFinish;
    DeathSpell:
		MSTF H 9 Bright Offset (0, 48) A_FireDeathSpell;
        Goto AltFireFinish;
    LightningSpell:
		MSTF H 9 Bright Offset (0, 48) A_FireLightningSpell();
        Goto AltFireFinish;
    BloodSpell:
		MSTF H 1 Bright Offset (0, 48) A_FireBloodSpell;
		MSTF H 24 Bright Offset (0, 48);
        Goto AltFireFinish;
	Reload:
		#### # 8 A_NextSpell;
		Goto Ready;
    Zoom:
		#### # 8 A_PrevSpell;
		Goto Ready;
	}

	const ICECLOUD_SPREAD = 150;
	const ICECLOUD_DIST = 160;
	const ICECLOUD_HEIGHTMOD = 20.0;
	action void A_FireIceCloud()
	{
		if (!player || !player.mo)
			return;
		
		if (!A_AttemptFireSpell(3, 3))
			return;
		
		let mo = Spawn("MageIceCloud");
		if (!mo)
			return;

		int xMod = frandom[IceCloud](-ICECLOUD_SPREAD, ICECLOUD_SPREAD);
		int yMod = frandom[IceCloud](-ICECLOUD_SPREAD, ICECLOUD_SPREAD);
		int zMod = frandom[IceCloud](-ICECLOUD_SPREAD, ICECLOUD_SPREAD);
		Vector3 dir = (AngleToVector(player.mo.angle, cos(player.mo.pitch)), -sin(player.mo.pitch));
		let forwardDir = (dir.X * ICECLOUD_DIST, dir.Y * ICECLOUD_DIST, dir.Z * ICECLOUD_DIST);
		mo.SetOrigin((Pos.X + forwardDir.X + xMod, Pos.Y + forwardDir.Y + yMod, Pos.Z + forwardDir.Z + zMod + ICECLOUD_HEIGHTMOD), false);
		mo.target = player.mo;
	}
    action void A_FireIceSpell()
	{
        for (int i = 0; i < 4; i++)
        {
            A_FireIceCloud();
        }
	}

	action void A_FirePoisoinSpellMissile(double speedMod, int angleMod)
	{
		MageStaffPoisonMissile mo = MageStaffPoisonMissile(SpawnPlayerMissile("MageStaffPoisonMissile", angle + angleMod));
		if (mo)
		{
			mo.AdjustSpeed(speedMod);
		}
	}
    action void A_FirePoisonSpell()
	{
		if (!A_AttemptFireSpell(9, 9))
            return;
		
        A_FirePoisoinSpellMissile(1.0, 0);
		A_FirePoisoinSpellMissile(0.8, -15);
		A_FirePoisoinSpellMissile(0.8, 15);
		A_FirePoisoinSpellMissile(0.6, 25);
		A_FirePoisoinSpellMissile(0.6, -25);
		A_FirePoisoinSpellMissile(0.6, 10);
		A_FirePoisoinSpellMissile(0.6, -10);
		A_FirePoisoinSpellMissile(0.4, 0);
		A_FirePoisoinSpellMissile(0.2, 0);
		A_FirePoisoinSpellMissile(0.1, 0);
		A_FirePoisoinSpellMissile(0.05, 0);
	}

	const STAFFWATER_BOLT_SPREAD_X = 12;
	const STAFFWATER_BOLT_SPREAD_Y = 5;
    action void A_FireWaterSpell()
	{
		if (!A_AttemptFireSpell(6, 6))
            return;

        for (int i = 0; i < 12; i++)
        {
            A_FireSpreadMissile("MageStaffWaterMissile", STAFFWATER_BOLT_SPREAD_X, STAFFWATER_BOLT_SPREAD_Y);
        }
	}

	action void A_FireDeathSpell()
	{
		A_FireMissileSpell("MageStaffDeathMissile2", 3, 3);
		A_FireMissileSpell("MageStaffDeathMissile2", 3, 3, -13);
		A_FireMissileSpell("MageStaffDeathMissile2", 3, 3, 13);
	}

	action void A_FireLightningSpell()
	{
		A_FireMissileSpell("MageWandLightningMissile", 3, 3);
		A_FireMissileSpell("MageWandLightningMissile", 3, 3, -7);
		A_FireMissileSpell("MageWandLightningMissile", 3, 3, 7);

		A_StartSound("ThunderCrash", CHAN_BODY);
	}

	const SUMMONBAT_DIST = 160.0;
	const SUMMONBAT_SPREAD = 90.01;
	const SUMMONBAT_HEIGHTMOD = 20.0;
	const SUMMONBAT_SWARM_SIZE = 13;
	action void A_SummonBat()
	{
		if (!player || !player.mo)
			return;
		
		if (!A_AttemptFireSpell(1, 1))
			return;
		
		XRpgSummonBat mo = XRpgSummonBat(Spawn("XRpgSummonBat"));
		if (!mo)
			return;

		int xMod = frandom[BatSpawn](-SUMMONBAT_SPREAD, SUMMONBAT_SPREAD);
		int yMod = frandom[BatSpawn](-SUMMONBAT_SPREAD, SUMMONBAT_SPREAD);
		int zMod = frandom[BatSpawn](-SUMMONBAT_SPREAD, SUMMONBAT_SPREAD);
		Vector3 dir = (AngleToVector(player.mo.angle, cos(player.mo.pitch)), -sin(player.mo.pitch));
		let forwardDir = (dir.X * SUMMONBAT_DIST, dir.Y * SUMMONBAT_DIST, dir.Z * SUMMONBAT_DIST);
		mo.SetOrigin((Pos.X + forwardDir.X + xMod, Pos.Y + forwardDir.Y + yMod, Pos.Z + forwardDir.Z + zMod + SUMMONBAT_HEIGHTMOD), false);
		A_StartSound(mo.ActiveSound, CHAN_VOICE);
		mo.A_SetAngle(player.mo.angle);
		mo.target = player.mo;
	}
	action void A_FireBloodSpell()
	{	
		for (int i = 0; i < SUMMONBAT_SWARM_SIZE; i++)
		{
			A_SummonBat();
		}
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
		+RIPPER
        Obituary "$OB_MPMWEAPBLOODSCOURGE";
		DamageType "Fire";
		SeeSound "Ignite";

        RenderStyle "Translucent";
        Alpha 0.7;
        Scale 0.5;
    }
    States
    {
    Spawn:
        FHFX I 8 Bright;
        FHFX JKL 3 Bright;
    Death:
        FHFX MNOPQR 2 Bright;
        Stop;
    }
}

class MageIceCloud : MageFrostIceMissile
{
	Default
    {
        Speed 0;
        Radius 1;
        Height 16;
        Damage 1;
		VSpeed 8;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        +ZDOOMTRANS
		-MISSILE
		-SKYEXPLODE

        SeeSound "IceGuyMissileExplode";
        Obituary "$OB_MPMWEAPBLOODSCOURGE";

		DamageType "Poison";
		Translation "Ice";
        RenderStyle "Translucent";
        Alpha 0.7;
        Scale 2.0;
    }
    States
    {
    Spawn:
        PSBG EFG 8 Bright;
        PSBG HI 12 Bright A_IceShower;
		PSBG EFGHI 12 Bright A_IceShower;
        PSBG EFGHI 12 Bright A_IceShower;
        PSBG EFGHI 12 Bright A_IceShower;
    Death:
        PSBG D 4;
        Stop;
    }
}


class MageStaffPoisonMissile : StoppableActor
{
	Default
    {
        Speed 40;
        Radius 1;
        Height 1;
        Damage 1;
        +RIPPER
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        +ZDOOMTRANS
        SeeSound "PoisonShroomDeath";
        Obituary "$OB_MPMWEAPBLOODSCOURGE";

		DamageType "Poison";

        RenderStyle "Translucent";
        Alpha 0.4;
        Scale 1.5;
    }
    States
    {
    Spawn:
        PSBG E 4 Bright;
        PSBG F 4 Bright A_ExpandCloud;
		PSBG GHI 4 Bright;
		PSBG EFGHI 4 Bright;
        PSBG EFGHI 4 Bright;
        PSBG EFGHI 4 Bright;
        PSBG EFGHI 4 Bright;
    Death:
        PSBG D 4 Bright;
        Stop;
    }

	action void A_ExpandCloud()
	{
		A_SetSize(16, 12, false);
		A_StopMoving();
	}
}

class MageStaffWaterMissile : Actor
{
    Default
    {
        Speed 45;
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
		DeathSound "WaterSplash";

		Health 2;
		DamageType "Water";
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
		A_StartSound("WaterSplash", CHAN_BODY);

		Health--;
		if (Health < 1)
		{
			SetStateLabel("Death");
			return;
		}
	}
}

class MageStaffSunMissile : OffsetSpriteActor
{
    Default
    {
        Speed 50;
        Radius 2;
        Height 2;
        Damage 5;
        Projectile;
        +SPAWNSOUNDSOURCE
        Obituary "$OB_MPMWEAPBLOODSCOURGE";
        Scale 2.0;
        DamageType "Fire";
		SeeSound "TreeExplode";
		OffsetSpriteActor.OffsetSpriteX 0;
        OffsetSpriteActor.OffsetSpriteY 16;
    }
    States
    {
    Spawn:
        FDMB B 24 Bright Light("YellowSunSmall");
    Death:
        FDMB B 6 Bright Light("YellowSunBig") A_SunExplode;
        FDMB C 3 Bright Light("YellowSunBigFade3");
        FDMB D 3 Bright Light("YellowSunBigFade4");
        FDMB E 3 Bright Light("YellowSunBigFade5");
        Stop;
    }

	action void A_SunExplode()
	{
		A_Explode(55, 120);
		A_StartSound("Fireball", CHAN_BODY);
	}
}

class MageStaffMoonMissile : StoppableActor
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
		+DONTBLAST
        Obituary "$OB_MPMWEAPBLOODSCOURGE";
        Translation "Ice";

		SeeSound "SorcererBallWoosh";
		DeathSound "SorcererBallExplode";
    }
    States
    {
    Spawn:
        MSP1 ABC 4 Light("MoonSmall");
		MSP1 D 4 Light("MoonSmall") A_Blast(BF_NOIMPACTDAMAGE, 200, 120);
		MSP1 ABC 4 Light("MoonSmall");
		MSP1 D 4 Light("MoonSmall") A_Blast(BF_NOIMPACTDAMAGE, 200, 120);
		MSP1 ABC 4 Light("MoonSmall");
		MSP1 D 4 Light("MoonSmall") A_Blast(BF_NOIMPACTDAMAGE, 200, 120);
		MSP1 ABC 4 Light("MoonSmall");
    Death:
        MSP1 H 4 Light("MoonBig") A_MoonExplode(true);
		MSP1 IJKLM 4 Light("MoonBig") A_MoonExplode(false);
		MSP1 HIJKLM 4 Light("MoonBig") A_MoonExplode(false);
		MSP1 NOP 4 Light("MoonBig");
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

	action void A_MoonExplode(bool stopMoving)
	{
		if (stopMoving)
		{
			A_StopMoving();
		}
		A_StartSound("BishopAttack", CHAN_BODY);

        for (int i = 0; i < 10; i++)
        {
            A_FireStars();
        }
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

		DamageType "Electric";
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
const DEATHFLOOR_RADIUSDAMAGE = 20;
//CPS3A0
class MageStaffDeathMissile1 : Actor
{
	Default
	{
		Radius 10;
		Height 6;
		Speed 20;
		FastSpeed 26;
		Damage 6;
		Projectile;
		-ACTIVATEIMPACT
		-ACTIVATEPCROSS
		+ZDOOMTRANS
		RenderStyle "Add";
		Obituary "$OB_MPMWEAPBLOODSCOURGE";

		DamageType "Death";
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
		Speed 7;
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
		TNT1 AAAAAAAAAAAA 10 Bright A_SpellFloorFire;
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

const STAFFDEATH_RISE_DIST = 6;
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
		CPS3 AAAAAA 3 BRIGHT A_RiseFromGround(STAFFDEATH_RISE_DIST);
	Death:
		CPS3 A 4 BRIGHT SpellFloorFireExplode;
		CPS3 AAAAAA 3 BRIGHT A_RiseFromGround(-STAFFDEATH_RISE_DIST);
		Stop;
	}

	void A_WraithInit()
	{
		A_StartSound("ThrustSpikeRaise", CHAN_BODY);

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

		if (random[MSpellDeath4](0, 1) == 1)
			bXFlip = true;
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

		A_StartSound("ThrustSpikeLower", CHAN_BODY);
	}
}