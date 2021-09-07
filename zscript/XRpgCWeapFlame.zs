const FLAME_VILE_MAX_LAVA = 5;
const FLAME_VILE_VSPEED_MIN = 4;
const FLAME_VILE_VSPEED_MAX = 10;
const FLAME_VILE_MAX_SPEED = 2;
const FLAME_VILE_OFFSET = 48;
const FLAME_VILE_RANGE = 1536;

class XRpgCWeapFlame : XRpgClericWeapon replaces CWeapFlame
{
	Default
	{
		+NOGRAVITY
		Weapon.SelectionOrder 1000;
		Weapon.AmmoUse 4;
		Weapon.AmmoGive 25;
		Weapon.KickBack 150;
		Weapon.YAdjust 10;
		Weapon.AmmoType1 "Mana2";
		Inventory.PickupMessage "$TXT_WEAPON_C3";
		Tag "$TAG_CWEAPFLAME";
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
		CFLM A 2 Offset (0, 40);
		CFLM D 2 Offset (0, 50);
		CFLM D 2 Offset (0, 36);
		CFLM E 4 Bright;
		CFLM F 4 Bright A_CFlameAttack;
		CFLM E 4 Bright;
		CFLM G 2 Offset (0, 40);
		CFLM G 2;
		Goto Ready;
	AltFire:
		CFLM A 2 Offset (0, 40);
		CFLM D 2 Offset (0, 50);
		CFLM D 2 Offset (0, 36);
		CFLM E 4 Bright A_CFlameVileScan(true);
		CFLM FEFEFEFEFEFE 4 Bright A_CFlameVileScan(false);
		CFLM F 4 Bright A_CFlameVileAttack;
		CFLM E 4 Bright;
		CFLM G 2 Offset (0, 40);
		CFLM G 2;
		Goto Ready;
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

		Weapon weapon = player.ReadyWeapon;
		if (weapon != null)
		{
			if (!weapon.DepleteAmmo (weapon.bAltFire))
				return;
		}
		let mo = SpawnPlayerMissile ("CFlameMissile");
		if (mo && A_IsSmite())
		{
			mo.Scale = (2.0, 2.0);
			mo.SetDamage(mo.damage * 2.0);
		}
		A_StartSound ("ClericFlameFire", CHAN_WEAPON);
	}

	action void A_CFlameVileScan(bool manaSpend)
	{
		FTranslatedLineTarget t;
		if (manaSpend)
		{
			Weapon weapon = player.ReadyWeapon;
			if (weapon != null)
			{
				if (!weapon.DepleteAmmo (false))
				{
					A_SetWeapState("Ready");
					return;
				}
			}
		}

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
		FTranslatedLineTarget t;
		int lineDamage = 0;
		double slope = AimLineAttack (angle, FLAME_VILE_RANGE);
		let puffObj = LineAttack(angle, FLAME_VILE_RANGE, slope, lineDamage, "Fire", "FlameVilePuff", true, t);
		if (puffObj)
		{
			let mo = A_FireVerticalMissilePos("FlameVilePuffBoom", puffObj.Pos.X, puffObj.Pos.Y, puffObj.Pos.Z + 2, 0, true);

			if (mo && A_IsSmite())
			{
				mo.A_SetHealth(2);
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

		A_Explode(25, 100, false);

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