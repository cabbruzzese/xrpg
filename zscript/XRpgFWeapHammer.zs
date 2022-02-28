// The Fighter's Hammer -----------------------------------------------------
const HAMMER_CHARGE_MAX = 25;
const HAMMER_CHARGE_MIN = 8;

class XRpgFWeapHammer : XRpgFighterWeapon replaces FWeapHammer
{
	const HAMMER_RANGE = 1.5 * DEFMELEERANGE;

	Default
	{
		+BLOODSPLATTER
		Weapon.SelectionOrder 900;
		+WEAPON.AMMO_OPTIONAL
		Weapon.AmmoUse1 3;
		Weapon.AmmoGive1 25;
		Weapon.KickBack 150;
		Weapon.YAdjust -10;
		Weapon.AmmoType1 "Mana2";
		Inventory.PickupMessage "$TXT_WEAPON_F3";
		Obituary "$OB_MPFWEAPHAMMERM";
		Tag "$TAG_FWEAPHAMMER";

		XRpgWeapon.MaxCharge HAMMER_CHARGE_MAX;
	}

	States
	{
	Spawn:
		WFHM A -1;
		Stop;
	Select:
		FHMR A 1 A_Raise;
		Loop;
	Deselect:
		FHMR A 1 A_Lower;
		Loop;
	Ready:
		FHMR A 1 A_WeaponReady;
		Loop;
	Fire:
		FHMR B 6 Offset (5, 0) A_CheckBerserk(false);
		FHMR C 3 Offset (5, 0) A_FHammerAttackMelee;
		FHMR D 3 Offset (5, 0);
		FHMR E 2 Offset (5, 0);
		FHMR E 10 Offset (5, 150);
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
		FHMR E 6 Offset (5, 150);
		FHMR A 1 Offset (0, 60);
		FHMR A 1 Offset (0, 55);
		FHMR A 1 Offset (0, 50);
		FHMR A 1 Offset (0, 45);
		FHMR A 1 Offset (0, 40);
		FHMR A 1 Offset (0, 35);
		FHMR A 1;
		Goto Ready;
	ShortChargeAttack:
		FHMR B 6 Offset (5, 1);
		FHMR C 3 Offset (5, 0);
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
	AltFire:
	AltHold:
		FHMR F 3 Offset (1, -40) A_ChargeUp;
		FHMR F 1 Offset (1, -40) A_ReFire;
		FHMR F 1 Offset (1, -40) A_CheckMinCharge(HAMMER_CHARGE_MIN);
		FHMR C 3 Offset (60, 30);
		FHMR D 3 Offset (90, 30);
		FHMR E 2 Offset (90, 30);
		FHMR E 10 Offset (-5, 150) A_HammerSlam();
		FHMR A 1 Offset (0, 60);
		FHMR A 1 Offset (0, 55);
		FHMR A 1 Offset (0, 50);
		FHMR A 1 Offset (0, 45);
		FHMR A 1 Offset (0, 40);
		FHMR A 1 Offset (0, 35);
		FHMR A 1;
		Goto Ready;
	}

	//============================================================================
	//
	// A_FHammerAttack
	//
	//============================================================================

	action void A_FHammerAttack()
	{
		// Don't spawn a hammer if the player doesn't have enough mana
		if (player.ReadyWeapon == null ||
			!player.ReadyWeapon.CheckAmmo (player.ReadyWeapon.bAltFire ?
				Weapon.AltFire : Weapon.PrimaryFire, false, true))
		{ 
			weaponspecial = false;
		}
	}

	action void A_FHammerAttackMelee()
	{
		FTranslatedLineTarget t;

		if (player == null)
		{
			return;
		}

		int damage = random[HammerAtk](1, 123);

		let xrpgPlayer = XRpgPlayer(player.mo);
		{
			let statItem = xrpgPlayer.GetStats();
			damage += statItem.Strength;
		}

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
							t.linetarget.Thrust(10, t.attackAngleFromSource);
						}
						weaponspecial = false; // Don't throw a hammer
						return;
					}
				}
			}
		}
		// didn't find any targets in meleerange
		double slope = AimLineAttack (angle, HAMMER_RANGE, null, 0., ALF_CHECK3D);
		weaponspecial = (LineAttack (angle, HAMMER_RANGE, slope, damage, 'Melee', "HammerPuff", true) == null);
	}

	//============================================================================
	//
	// A_FHammerThrow
	//
	//============================================================================

	action void A_FHammerThrow()
	{
		if (player == null)
		{
			return;
		}

		invoker.ChargeValue = 0;

		Weapon weapon = player.ReadyWeapon;
		if (weapon != null)
		{
			if (!weapon.DepleteAmmo (false, false))
				return;
		}
		Actor mo = SpawnPlayerMissile ("HammerMissile"); 
		if (mo)
		{
			mo.special1 = 0;
		}
	}

	action void A_HammerSlam()
	{
		if (player == null)
		{
			return;
		}

		float explodeDamageMod = 1.0 + (float(invoker.ChargeValue) / float(invoker.MaxCharge));
		invoker.ChargeValue = 0;

		int damage = random[FWeapHammer](1, 70);
		damage += (invoker.ChargeValue * 3);

		int range = 150;
		let xrpgPlayer = XRpgPlayer(player.mo);
		if (xrpgPlayer)
			damage += xrpgPlayer.GetStrength();
		
		int thrustSpeed = 3500;
		thrustSpeed += invoker.ChargeValue * 100;
		A_Explode(damage, range, false);
		A_RadiusThrust(thrustSpeed, range, RTF_NOIMPACTDAMAGE);

		A_StartSound("FighterHammerHitWall", CHAN_BODY);

		Weapon w = player.ReadyWeapon;
		if (w != null)
		{
			if (w.Ammo1 && w.Ammo1.Amount < 3)
				return;

			w.DepleteAmmo (false, false);
			let mo = HammerFloorMissile2(SpawnPlayerMissile("HammerFloorMissile2"));
			if (mo)
			{
				mo.ExplodeDamageMod = explodeDamageMod;
			}
		}
	}
}

const HAMMERFLOOR_RADIUS = 80;
const HAMMERFLOOR_RADIUSDAMAGE = 40;
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

class HammerFloorMissile2 : HammerFloorMissile1
{
	float explodeDamageMod;
	property ExplodeDamageMod : explodeDamageMod;
	Default
	{
		Radius 5;
		Height 12;
		Speed 12;
		FastSpeed 20;
		Damage HAMMERFLOOR_DAMAGE;
		+FLOORHUGGER
		RenderStyle "Add";

		HammerFloorMissile2.ExplodeDamageMod 1.0;
		
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
			mo.ExplodeDamageMod = ExplodeDamageMod;
			
			mo.FloorFireExplode();
		}
	}
	
	action void FloorFireExplode()
	{
		if (!invoker)
			return;
		int damage = HAMMERFLOOR_RADIUSDAMAGE * invoker.ExplodeDamageMod;
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