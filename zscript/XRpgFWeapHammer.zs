// The Fighter's Hammer -----------------------------------------------------
class XRpgFWeapHammer : XRpgFighterShieldWeapon replaces FWeapHammer
{
	const HAMMER_RANGE = 1.5 * DEFMELEERANGE;
	const HAMMER_SLAM_MANA = 9;

	Default
	{
		+BLOODSPLATTER
		Weapon.SelectionOrder 900;
		+WEAPON.AMMO_OPTIONAL +WEAPON.MELEEWEAPON
		Weapon.AmmoUse1 3;
		Weapon.AmmoGive1 25;
		Weapon.KickBack 150;
		Weapon.AmmoType1 "Mana2";
		Inventory.PickupMessage "$TXT_WEAPON_F3";
		Obituary "$OB_MPFWEAPHAMMERM";
		Tag "$TAG_FWEAPHAMMER";
	}

	States
	{
	Spawn:
		WFHM A -1;
		Stop;
	Select:
	WeaponSelect:
		FHMR A 1 A_Raise;
		Loop;
	Deselect:
	WeaponDeselect:
		FHMR A 1 A_Lower;
		Loop;
	Ready:
	WeaponReady:
		FHMR A 1 A_WeaponReady;
		Loop;
	Fire:
	WeaponFire:
		FHMR B 2 Offset (5, 0) A_CheckHammerKeys;
		FHMR B 4 Offset (5, 0) A_CheckBerserk(false);
		FHMR C 3 Offset (5, 0) A_FHammerAttackMelee;
		FHMR D 3 Offset (5, 0);
		FHMR E 2 Offset (5, 0);
		FHMR E 10 Offset (5, 150) A_FHammerThrow;
		FHMR A 1 Offset (0, 60);
		FHMR A 1 Offset (0, 55);
		FHMR A 1 Offset (0, 50);
		FHMR A 1 Offset (0, 45);
		FHMR A 1 Offset (0, 40);
		FHMR A 1 Offset (0, 35);
		FHMR A 1;
		Goto Ready;
	BerserkFire:
		FHMR C 3 Offset (5, 0) A_FHammerAttackMelee;
		FHMR D 3 Offset (5, 0);
		FHMR E 2 Offset (5, 0);
		FHMR E 6 Offset (5, 150) A_FHammerThrow;
		FHMR A 1 Offset (0, 60);
		FHMR A 1 Offset (0, 55);
		FHMR A 1 Offset (0, 50);
		FHMR A 1 Offset (0, 45);
		FHMR A 1 Offset (0, 40);
		FHMR A 1 Offset (0, 35);
		FHMR A 1;
		Goto Ready;
	AltFire:
		Goto ShieldFrameAltFire;
	ShieldSpikedFire:
		Goto ShieldFrameShieldSpikedFire;
    AltHold:
		Goto ShieldFrameAltHold;
	ShieldSpikedHold:
		Goto ShieldFrameShieldSpikedHold;
	ShieldKiteFire:
		Goto ShieldFrameShieldKiteFire;
	ShieldKiteHold:
		Goto ShieldFrameShieldKiteHold;
	ShieldRoundFire:
		Goto ShieldFrameShieldRoundFire;
	ShieldRoundHold:
		Goto ShieldFrameShieldRoundHold;
	ShieldMetalFire:
		Goto ShieldFrameShieldMetalFire;
	ShieldMetalHold:
		Goto ShieldFrameShieldMetalHold;
    ShieldCharged:
		Goto ShieldFrameShieldCharged;
    ShieldFireFinish:
		Goto ShieldFrameShieldFireFinish;
	FistFire:
		Goto ShieldFrameFistFire;
	}

	action void A_CheckHammerKeys()
	{
		weaponspecial = false;

		if (!player || !player.mo)
			return;
		
		let forwardMove = player.mo.GetPlayerInput(INPUT_FORWARDMOVE);

		//If stepping backwards, we can throw
		if (forwardMove != 0)
			weaponspecial = true;
	}

	action void A_FHammerAttackMelee()
	{
		FTranslatedLineTarget t;

		if (!player)
			return;

		int damage = random[HammerAtk](1, 123);

		let xrpgPlayer = XRpgPlayer(player.mo);
		if (xrpgPlayer)
			damage += xrpgPlayer.GetStrength();

		for (int i = 0; i < 16; i++)
		{
			for (int j = 1; j >= -1; j -= 2)
			{
				double ang = angle + j*i*(45. / 32);
				double slope = AimLineAttack(ang, HAMMER_RANGE, t, 0., ALF_CHECK3D);
				if (t.linetarget != null)
				{
					LineAttack(ang, HAMMER_RANGE, slope, damage, 'Melee', "HammerPuff", true, t);
					if (t.linetarget != null)
					{
						AdjustPlayerAngle(t);
						if (t.linetarget.bIsMonster || t.linetarget.player)
						{
							A_ThrustTarget(t.linetarget, 10, t.attackAngleFromSource);
						}
						weaponspecial = false; // Don't throw a hammer
						return;
					}
				}
			}
		}
		// didn't find any targets in meleerange
		double slope = AimLineAttack (angle, HAMMER_RANGE, t, 0., ALF_CHECK3D);
		bool miss = !(LineAttack (angle, HAMMER_RANGE, slope, damage, 'Melee', "HammerPuff", true));

		FLineTraceData RemoteRay;
		bool hit = LineTrace (angle, HAMMER_RANGE, slope, TRF_THRUACTORS, 32, 0, 0, RemoteRay);
		if (hit && RemoteRay.HitType == TRACE_HitFloor)
			A_HammerSlam();

		if (!miss || hit)
			weaponspecial = false;
	}

	//============================================================================
	//
	// A_FHammerThrow
	//
	//============================================================================

	action void A_FHammerThrow()
	{
		if (!player)
			return;

		if (!weaponspecial)
			return;

		Weapon w = player.ReadyWeapon;
		if (!w)
			return;

		if (!A_DepleteAllMana (0, w.AmmoUse1))
			return;

		Actor mo = SpawnPlayerMissile ("HammerMissile"); 
		if (mo)
		{
			mo.special1 = 0;
		}
	}

	action void A_HammerSlam()
	{
		weaponspecial = false;

		if (!player)
			return;

		int damage = random[FWeapHammer](50, 100);

		int range = 150;
		let xrpgPlayer = XRpgPlayer(player.mo);
		if (xrpgPlayer)
			damage += xrpgPlayer.GetStrength();
		
		int thrustSpeed = 4500;
		A_Explode(damage, range, false);
		A_RadiusThrust(thrustSpeed, range, RTF_NOIMPACTDAMAGE);

		A_StartSound("FighterHammerHitWall", CHAN_BODY);

		Weapon w = player.ReadyWeapon;
		if (w != null)
		{
			if (w.Ammo1 && w.Ammo1.Amount < HAMMER_SLAM_MANA)
				return;

			A_DepleteAllMana(0, HAMMER_SLAM_MANA);
			let mo = HammerFloorMissile2(SpawnPlayerMissile("HammerFloorMissile2"));
		}
	}
}

const HAMMERFLOOR_RADIUS = 80;
const HAMMERFLOOR_RADIUSDAMAGE = 55;
const HAMMERFLOOR_DAMAGE = 0;
class HammerFloorMissile1 : Actor
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
		Obituary "$OB_MPFWEAPHAMMERM";
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

class HammerFloorMissile2 : HammerFloorMissile1
{
	Default
	{
		Radius 5;
		Height 12;
		Speed 12;
		FastSpeed 20;
		Damage HAMMERFLOOR_DAMAGE;
		+FLOORHUGGER
		RenderStyle "Add";
		
		+RIPPER
	}
	
	states
	{
	Spawn:
		FX13 AAAAAAAAAA 3 Bright A_ShootFloorFire;
		Stop;
	Death:
		FX13 I 6 BRIGHT FloorFireExplode;
		FX13 JKLM 6 BRIGHT;
		Stop;
	}

	void A_ShootFloorFire()
	{
		SetZ(floorz);
		double x = Random2[MntrFloorFire]() / 64.;
		double y = Random2[MntrFloorFire]() / 64.;
		
		HammerFloorMissile3 mo = HammerFloorMissile3(Spawn("HammerFloorMissile3", Vec2OffsetZ(x, y, floorz), ALLOW_REPLACE));
		if (mo != null)
		{
			mo.target = target;
			mo.Vel.X = MinVel; // Force block checking
			mo.CheckMissileSpawn (radius);
			mo.SetOrigin((mo.Pos.X, mo.Pos.Y, mo.Pos.Z + 2), false);
			
			mo.FloorFireExplode();
		}
	}
	
	action void FloorFireExplode()
	{
		if (!invoker)
			return;
		int damage = HAMMERFLOOR_RADIUSDAMAGE;
		A_Explode(damage, HAMMERFLOOR_RADIUS, 0);
		A_StartSound("MaulatorMissileHit", CHAN_BODY);
	}
}

class HammerFloorMissile3 : HammerFloorMissile2
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