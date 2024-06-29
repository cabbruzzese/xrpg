const FLAME_VILE_MAX_LAVA = 5;
const FLAME_VILE_VSPEED_MIN = 4;
const FLAME_VILE_VSPEED_MAX = 10;
const FLAME_VILE_MAX_SPEED = 2;
const FLAME_VILE_OFFSET = 48;
const FLAME_VILE_RANGE = 1536;
const CFLAME_CHARGE_MIN = 8;
const CFLAME_CHARGE_MAX = 30;
const CFLAME_PUNCH_MANA = 2;
const CFLAME_FIRE_MANA = 4;


class XRpgCWeapFlame : XRpgClericWeapon replaces CWeapFlame
{
	Default
	{
		+NOGRAVITY +WEAPON.AMMO_OPTIONAL
		Weapon.SelectionOrder 1000;
		Weapon.AmmoUse CFLAME_FIRE_MANA;
		Weapon.AmmoGive 25;
		Weapon.KickBack 150;
		Weapon.YAdjust 10;
		Weapon.AmmoType1 "Mana2";
		Inventory.PickupMessage "$TXT_WEAPON_C3";
		Tag "$TAG_CWEAPFLAME";

		XRpgWeapon.MaxCharge CFLAME_CHARGE_MAX;
	}

	States
	{
	Spawn:
		WCFM ABCDEFGH 4 Bright;
		Loop;
	Select:
		CFLM A 1 A_Raise;
		Loop;
	Deselect:
		CFLM A 1 A_Lower;
		Loop;
	ReadyNoAmmo:
		CFL3 AAAAAAAAAAAA 1 A_WeaponReady;
	Ready:
		CFLM A 0 ChooseNoAmmoFrames("Ready", 0, CFLAME_FIRE_MANA);
		CFLM AAAABBBBCCCC 1 A_WeaponReady;
		Loop;
	Fire:
		CLFM H 0 ChooseNoAmmoFrames("Fire", 0, CFLAME_FIRE_MANA);
		CFLM H 2 Offset (0, 40);
		CFLM I 2 Offset (0, 50);
		CFLM J 4 Bright Offset (0, 36) A_CFlamePunch(true, true);
		CFLM J 4 Offset (0, 36) A_Refire;
		Goto Ready;
	Hold:
		CLFM K 0 ChooseNoAmmoFrames("Hold", 0, CFLAME_FIRE_MANA);
		CFLM K 2 Offset (0, 40);
		CFLM L 2 Offset (0, 50);
		CFLM M 4 Bright Offset (0, 36) A_CFlamePunch(false, true);
		CLFM K 0 ChooseNoAmmoFrames("HoldMiddle", 0, CFLAME_PUNCH_MANA);
		CFLM K 6 Offset (0, 40);
		CFLM H 2 Offset (0, 40);
		CFLM I 2 Offset (0, 50);
		CFLM J 4 Bright Offset (0, 36) A_CFlamePunch(false, true);
		CFLM H 6 Offset (0, 40);
		CFLM H 1 Offset (0, 40)A_Refire;
		Goto Ready;
	ShortChargeAttack:
		CFLM E 4 Bright;
		CFLM F 4 Bright A_CFlameAttack;
		CFLM E 4 Bright;
		CFLM G 2 Offset (0, 40);
		CFLM G 2;
		Goto Ready;
	AltFire:
		CLFM A 0 ChooseNoAmmoFrames("AltFire", 0, CFLAME_FIRE_MANA);
		CFLM A 2 Offset (0, 40);
	AltHold:
		CLFM A 0 ChooseNoAmmoFrames("AltHold", 0, CFLAME_FIRE_MANA);
		CFLM D 2 A_ChargeUp;
		CFLM D 1 A_CFlameVileScan();
		CFLM D 1 A_ReFire;
		CFLM D 1 Offset (0, 36) A_CheckMinCharge(CFLAME_CHARGE_MIN);
		CFLM F 4 Bright A_CFlameVileAttack;
		CFLM E 4 Bright;
		CFLM G 2 Offset (0, 40);
		CFLM G 2;
		Goto Ready;
	FireNoAmmo:
		CFL3 H 2 Offset (0, 40);
		CFL3 I 2 Offset (0, 50);
		CFL3 J 4 Bright Offset (0, 36) A_CFlamePunch(true, false);
		CFL3 J 4 Offset (0, 36) A_Refire;
		Goto Ready;
	HoldNoAmmo:
		CFL3 K 2 Offset (0, 40);
		CFL3 L 2 Offset (0, 50);
		CFL3 M 4 Bright Offset (0, 36) A_CFlamePunch(false, false);
	HoldMiddleNoAmmo:
		CFL3 K 6 Offset (0, 40);
		CFL3 H 2 Offset (0, 40);
		CFL3 I 2 Offset (0, 50);
		CFL3 J 4 Bright Offset (0, 36) A_CFlamePunch(false, false);
		CFL3 H 6 Offset (0, 40);
		CFL3 H 1 Offset (0, 40)A_Refire;
		Goto Ready;
	}

	action void ChooseNoAmmoFrames(string frameName, int blueMana = 0, int greenMana = 0)
	{
		// Make no change if we have ammo
		if (A_CheckAllMana(blueMana, greenMana))
			return;

		// If out of ammo, change frames
		if (frameName == "Ready")
			A_SetWeapState("ReadyNoAmmo");
		else if (frameName == "Hold")
			A_SetWeapState("HoldNoAmmo");
		else if (frameName == "HoldMiddle")
			A_SetWeapState("HoldMiddleNoAmmo");
		else if (frameName == "Fire")
			A_SetWeapState("FireNoAmmo");
		//Don't allow shooting without ammo
		else if (frameName == "AltFire")
			A_SetWeapState("ReadyNoAmmo");
		else if (frameName == "AltHold")
			A_SetWeapState("ReadyNoAmmo");
	}

	action void A_CFlamePunch(bool isThrustPunch, bool canPower)
	{
		FTranslatedLineTarget t;

		if (!player)
			return;

		if (isThrustPunch)
		{
			Thrust(15, angle);
	        A_GruntSound(-1);
		}

		//Minimum mana for fire hands if 4, even if punches subtract 2
		bool isPowered = (canPower && A_CheckAllMana(0, CFLAME_FIRE_MANA));

		//If has mana, damage is greater
		int damageMax = 18;
		if (isPowered)
			damageMax = 40;
		int damage = random[CWeapFlame](1, damageMax);

		let xrpgPlayer = XRpgPlayer(player.mo);
		if (xrpgPlayer)
			damage += xrpgPlayer.GetStrength();

		Class<Actor> puffType = "HammerPuff";
		if (A_IsSmite())
		{
			puffType = "BurnyFlamePuff";

			if (xrpgPlayer)
			{
				int magicDamage = xrpgPlayer.GetMagic();
				damage += magicDamage;

				//If powered, double magic bonus
				if (isPowered)
					damage += magicDamage;
			}
		}

		for (int i = 0; i < 16; i++)
		{
			for (int j = 1; j >= -1; j -= 2)
			{
				double ang = angle + j*i*(45. / 16);
				double slope = AimLineAttack(ang, 2 * DEFMELEERANGE, t, 0., ALF_CHECK3D);
				if (t.linetarget)
				{
					Name damageType = 'Normal';
					if (isPowered)
						damageType = 'Fire';
					
					LineAttack(ang, 2 * DEFMELEERANGE, slope, damage, damageType, puffType, true, t);
					if (t.linetarget != null)
					{
						AdjustPlayerAngle(t);

						//On a hit, spend mana if this hit a valid target
						if (isPowered && t.linetarget.Health > 0)
							A_DepleteAllMana(0, CFLAME_PUNCH_MANA);

						return;
					}
				}
			}
		}
		// didn't find any creatures, so try to strike any walls
		weaponspecial = 0;

		double slope = AimLineAttack (angle, DEFMELEERANGE, null, 0., ALF_CHECK3D);
		LineAttack (angle, DEFMELEERANGE, slope, damage, 'Fire', puffType);
	}

	//============================================================================
	//
	// A_CFlameAttack
	//
	//============================================================================

	action void A_CFlameAttack()
	{
		if (player == null)
		{
			return;
		}

		invoker.ChargeValue = 0;

		Weapon weapon = player.ReadyWeapon;
		if (weapon != null)
		{
			if (!weapon.CheckAmmo(Weapon.PrimaryFire, false, true, 4))
				return;

			weapon.DepleteAmmo (false);
		}
		let mo = SpawnPlayerMissile ("CFlameMissile");
		if (mo && A_IsSmite())
		{
			mo.Scale = (3.0, 3.0);
			mo.SetDamage(mo.damage * 3.0);
		}
		A_StartSound ("ClericFlameFire", CHAN_WEAPON);
	}

	action void A_CFlameVileScan()
	{
		if (invoker.ChargeValue < CFLAME_CHARGE_MIN)
			return;
		
		FTranslatedLineTarget t;
		
		int lineDamage = 0;
		double slope = AimLineAttack (angle, FLAME_VILE_RANGE);
		LineAttack(angle, FLAME_VILE_RANGE, slope, lineDamage, "Fire", "FlameVilePuff", LAF_NOINTERACT, t);
		if (t.linetarget != null)
		{
			if (t.linetarget.bIsMonster)
			{
				AdjustPlayerAngle(t);
				let mo = Spawn("FlameVilePuffBig");
				if (mo)
				{
					mo.SetOrigin(t.linetarget.Pos, false);
				}
			}
		}
	}

	action void A_CFlameVileAttack()
	{
		invoker.ChargeValue = 0;

		Weapon weapon = player.ReadyWeapon;
		if (weapon != null)
		{
			if (!weapon.CheckAmmo(Weapon.PrimaryFire, false, true, 8))
				return;

			//Deplete ammo twice (workaround for weird bugs in alt fire ammo consumption)				
			weapon.DepleteAmmo (false);
			weapon.DepleteAmmo (false);
		}

		FTranslatedLineTarget t;
		int lineDamage = 0;
		double slope = AimLineAttack (angle, FLAME_VILE_RANGE);
		let puffObj = LineAttack(angle, FLAME_VILE_RANGE, slope, lineDamage, "Fire", "FlameVilePuff", true, t);
		if (puffObj)
		{
			let mo = A_FireVerticalMissilePos("FlameVilePuffBoom", puffObj.Pos.X, puffObj.Pos.Y, puffObj.Pos.Z + 2, 0, true);

			if (mo && A_IsSmite())
			{
				mo.A_SetHealth(3);
			}
		}

		A_StartSound ("ClericFlameFire", CHAN_WEAPON);
	}
}

class FlameVilePuff : Actor
{
	Default
	{
		+NOBLOCKMAP +NOGRAVITY
		+PUFFONACTORS
		RenderStyle "Translucent";
		Alpha 0.6;
		VSpeed 0.8;
		Scale 0.25;
	}
	States
	{
	Spawn:
		CFCF ABCDEFGHIJKLMNOP 2;
		Stop;
	}
}
class FlameVilePuffBig : FlameVilePuff
{
	Default
	{
		Scale 2.0;
	}
}

class FlameVilePuffBoom : Actor
{
	Default
	{
		Radius 6;
		Height 4;
		+NOBLOCKMAP +NOGRAVITY
		+PUFFONACTORS
		VSpeed 0;
		Scale 2.0;
		DamageType "Fire";

		Health 1;
	}
	States
	{
	Spawn:
		MSP2 EFGHI 6 BRIGHT A_FireLava();
		Stop;
	}

	action void A_FireLava()
	{
		if (!target)
			return;

		A_Explode(80, 100, false);

		for (int i = 0; i < Health; i++)
		{
			Actor mo = target.SpawnPlayerMissile("FlameVileLava");
			if (!mo)
				return;
			
			let xo = frandom[CWeapFlameLava](-FLAME_VILE_OFFSET, FLAME_VILE_OFFSET);
			let yo = frandom[CWeapFlameLava](-FLAME_VILE_OFFSET, FLAME_VILE_OFFSET);
			mo.SetOrigin((Pos.X + xo, Pos.Y + yo, Pos.Z), false);

			double newz = mo.CurSector.NextLowestFloorAt(mo.pos.x, mo.pos.y, mo.pos.z, mo.pos.z, FFCF_NOPORTALS) + mo.height;
			
			mo.SetZ(newz);

			let xVel = frandom[CWeapFlameLava](-FLAME_VILE_MAX_SPEED, FLAME_VILE_MAX_SPEED);
			let yVel = frandom[CWeapFlameLava](-FLAME_VILE_MAX_SPEED, FLAME_VILE_MAX_SPEED);
			mo.Vel.X = xVel;
			mo.Vel.Y = yVel;
			let vSpeed = frandom[CWeapFlameLava](FLAME_VILE_VSPEED_MIN, FLAME_VILE_VSPEED_MAX);
			mo.Vel.Z = vSpeed;
			mo.CheckMissileSpawn (radius);
		}
	}
}

class FlameVileLava : TimedActor
{
    Default
    {
        Speed 2;
        Radius 8;
        Height 8;
        Damage 3;
		Projectile;
		VSpeed 2;
        +SPAWNSOUNDSOURCE
        Obituary "$OB_MPCWEAPFLAME";
        DamageType "Fire";
        DeathSound "Fireball";
		Gravity 0.25;
		+NOBLOCKMAP +MISSILE +DROPOFF
		+NOTELEPORT
		-NOGRAVITY

		TimedActor.TimeLimit 200;
    }
    States
    {
    Spawn:
        WRBL ABC 4 Bright;
        Loop;
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
		A_Explode(10, 100);
	}
}

class BurnyFlamePuff : Actor
{
	Default
	{
		Radius 10;
		Height 6;
		+NOBLOCKMAP 
		+NOGRAVITY
		+PUFFONACTORS
		RenderStyle "Translucent";
		Alpha 0.6;
		AttackSound "ClericFlameFire";
		SeeSound "ClericFlameFire";
		ActiveSound "FighterPunchMiss";
		VSpeed 1;
		Scale 0.8;
		DamageType "Fire";
	}
	States
	{
	Spawn:
		CFFX ABCDEF 2 BRIGHT Light("YellowSunSmall");
		CFFX GHIJKLM 2 BRIGHT Light("YellowSunSmall");
		Stop;
	}
}