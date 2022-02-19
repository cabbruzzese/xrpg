const FLAME_VILE_MAX_LAVA = 5;
const FLAME_VILE_VSPEED_MIN = 4;
const FLAME_VILE_VSPEED_MAX = 10;
const FLAME_VILE_MAX_SPEED = 2;
const FLAME_VILE_OFFSET = 48;
const FLAME_VILE_RANGE = 1536;
const CFLAME_CHARGE_MIN = 8;
const CFLAME_CHARGE_MAX = 30;

class XRpgCWeapFlame : XRpgClericWeapon replaces CWeapFlame
{
	Default
	{
		+NOGRAVITY +WEAPON.AMMO_OPTIONAL
		Weapon.SelectionOrder 1000;
		Weapon.AmmoUse 4;
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
	Ready:
		CFLM AAAABBBBCCCC 1 A_WeaponReady;
		Loop;
	Fire:
		CFLM H 2 Offset (0, 40);
		CFLM I 2 Offset (0, 50);
		CFLM J 4 Bright Offset (0, 36) A_CFlamePunch(true);
		CFLM J 4 Offset (0, 36) A_Refire;
		Goto Ready;
	Hold:
		CFLM K 2 Offset (0, 40);
		CFLM L 2 Offset (0, 50);
		CFLM M 4 Bright Offset (0, 36) A_CFlamePunch(false);
		CFLM K 6 Offset (0, 40);
		CFLM H 2 Offset (0, 40);
		CFLM I 2 Offset (0, 50);
		CFLM J 4 Bright Offset (0, 36) A_CFlamePunch(false);
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
		CFLM A 2 Offset (0, 40);
	AltHold:
		CFLM D 2 A_ChargeUp;
		CFLM D 1 A_CFlameVileScan();
		CFLM D 1 A_ReFire;
		CFLM D 1 Offset (0, 36) A_CheckMinCharge(CFLAME_CHARGE_MIN);
		CFLM F 4 Bright A_CFlameVileAttack;
		CFLM E 4 Bright;
		CFLM G 2 Offset (0, 40);
		CFLM G 2;
		Goto Ready;
	}

	action void A_CFlamePunch(bool isThrustPunch)
	{
		FTranslatedLineTarget t;

		if (player == null)
		{
			return;
		}

		if (isThrustPunch)
		{
			Thrust(15, angle);
	        A_StartSound ("*fistgrunt", CHAN_VOICE);
		}

		int damage = random(1, 80);

		let xrpgPlayer = XRpgPlayer(player.mo);
		if (xrpgPlayer)
			damage += xrpgPlayer.GetStrength();

		Class<Actor> puffType = "HammerPuff";
		if (A_IsSmite())
		{
			puffType = "BurnyFlamePuff";

			if (xrpgPlayer)
				damage += xrpgPlayer.GetMagic();
		}

		for (int i = 0; i < 16; i++)
		{
			for (int j = 1; j >= -1; j -= 2)
			{
				double ang = angle + j*i*(45. / 16);
				double slope = AimLineAttack(ang, 2 * DEFMELEERANGE, t, 0., ALF_CHECK3D);
				if (t.linetarget)
				{
					LineAttack(ang, 2 * DEFMELEERANGE, slope, damage, 'Fire', puffType, true, t);
					if (t.linetarget != null)
					{
						AdjustPlayerAngle(t);

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
		LineAttack(angle, FLAME_VILE_RANGE, slope, lineDamage, "Fire", "FlameVilePuff", true, t);
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
			if (!weapon.CheckAmmo(Weapon.PrimaryFire, false, true))
				return;
				
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
			
			let xo = frandom(-FLAME_VILE_OFFSET, FLAME_VILE_OFFSET);
			let yo = frandom(-FLAME_VILE_OFFSET, FLAME_VILE_OFFSET);
			mo.SetOrigin((Pos.X + xo, Pos.Y + yo, Pos.Z), false);

			double newz = mo.CurSector.NextLowestFloorAt(mo.pos.x, mo.pos.y, mo.pos.z, mo.pos.z, FFCF_NOPORTALS) + mo.height;
			
			mo.SetZ(newz);

			let xVel = frandom(-FLAME_VILE_MAX_SPEED, FLAME_VILE_MAX_SPEED);
			let yVel = frandom(-FLAME_VILE_MAX_SPEED, FLAME_VILE_MAX_SPEED);
			mo.Vel.X = xVel;
			mo.Vel.Y = yVel;
			let vSpeed = frandom(FLAME_VILE_VSPEED_MIN, FLAME_VILE_VSPEED_MAX);
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
		+RIPPER
		+MISSILE
		+PUFFGETSOWNER
		RenderStyle "Translucent";
		Alpha 0.6;
		AttackSound "ClericFlameFire";
		SeeSound "ClericFlameFire";
		ActiveSound "FighterPunchMiss";
		VSpeed 1;
		Damage 1;
		Scale 0.8;
		DamageType "Fire";
	}
	States
	{
	Spawn:
		CFFX ABCDEFGHIJKLM 2 BRIGHT Light("YellowSunSmall");
		Stop;
	}
}