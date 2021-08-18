// The Cleric's Mace --------------------------------------------------------

class XRpgCWeapMace : XRpgClericWeapon replaces CWeapMace
{
	Default
	{
		Weapon.SelectionOrder 3500;
		Weapon.KickBack 150;
		Weapon.YAdjust -8;
		+BLOODSPLATTER
		Obituary "$OB_MPCWEAPMACE";
		Tag "$TAG_CWEAPMACE";
	}

	States
	{
	Select:
		CMCE A 1 A_Raise;
		Loop;
	Deselect:
		CMCE A 1 A_Lower;
		Loop;
	Ready:
		CMCE A 1 A_WeaponReady;
		Loop;
	Fire:
		CMCE B 2 Offset (60, 20);
		CMCE B 1 Offset (30, 33);
		CMCE B 2 Offset (8, 45);
		CMCE C 1 Offset (8, 45);
		CMCE D 1 Offset (8, 45);
		CMCE E 1 Offset (8, 45);
		CMCE E 1 Offset (-11, 58) A_CMaceAttack(false);
		CMCE F 1 Offset (8, 45);
		CMCE F 2 Offset (-8, 74);
		CMCE F 1 Offset (-20, 96);
		CMCE F 8 Offset (-33, 160);
		CMCE A 2 Offset (8, 75) A_ReFire;
		CMCE A 1 Offset (8, 65);
		CMCE A 2 Offset (8, 60);
		CMCE A 1 Offset (8, 55);
		CMCE A 2 Offset (8, 50);
		CMCE A 1 Offset (8, 45);
		Goto Ready;
	AltFire:
		CMCE C 2 Offset (160, 80);
		CMCE C 2 Offset (120, 85);
		CMCE C 2 Offset (80, 90);
		CMCE D 2 Offset (40, 95);
		CMCE D 2 Offset (1, 100) A_CMaceAttack(true);
		CMCE E 2 Offset (-40, 105);
		CMCE E 2 Offset (-80, 110);
		CMCE F 2 Offset (-120, 115);
		CMCE F 12 Offset (-160, 120);
		CMCE A 2 Offset (8, 75);
		CMCE A 1 Offset (8, 65);
		CMCE A 2 Offset (8, 60);
		CMCE A 1 Offset (8, 55);
		CMCE A 2 Offset (8, 50);
		CMCE A 1 Offset (8, 45);
		Goto Ready;
	}
	
	//===========================================================================
	//
	// A_CMaceAttack
	//
	//===========================================================================

	action void A_CMaceAttack(bool swing)
	{
		FTranslatedLineTarget t;

		if (player == null)
		{
			return;
		}

		int damage = random(25, 40);

		if (swing)
			damage += 15;

        let xrpgPlayer = XRpgPlayer(player.mo);
		if (xrpgPlayer != null)
			damage = xrpgPlayer.GetDamageForMelee(damage);

		for (int i = 0; i < 16; i++)
		{
			for (int j = 1; j >= -1; j -= 2)
			{
				double ang = angle + j*i*(45. / 16);
				double slope = AimLineAttack(ang, 2 * DEFMELEERANGE, t, 0., ALF_CHECK3D);
				if (t.linetarget)
				{
					LineAttack(ang, 2 * DEFMELEERANGE, slope, damage, 'Melee', "HammerPuff", true, t);
					if (t.linetarget != null)
					{
						AdjustPlayerAngle(t);

						//Cast Smite
						A_CastSmite(t.linetarget);

						if (swing && (t.linetarget.bIsMonster || t.linetarget.player))
						{
							t.linetarget.Thrust(20, t.attackAngleFromSource);
						}

						return;
					}
				}
			}
		}
		// didn't find any creatures, so try to strike any walls
		weaponspecial = 0;

		double slope = AimLineAttack (angle, DEFMELEERANGE, null, 0., ALF_CHECK3D);
		LineAttack (angle, DEFMELEERANGE, slope, damage, 'Melee', "HammerPuff");
	}

	action void A_CastSmite(Actor lineTarget)
	{
		if (!A_IsSmite())
			return;

		A_FireVerticalMissilePos("SmiteningMissile", lineTarget.Pos.X, lineTarget.Pos.Y, lineTarget.Pos.Z, -90, false);
	}
}

class SmiteningMissileSmoke : Actor
{
	Default
	{
		Height 16;
	    +NOBLOCKMAP +NOGRAVITY +SHADOW
	    +NOTELEPORT +CANNOTPUSH +NODAMAGETHRUST
		Scale 0.5;
	}
	States
	{
	Spawn:
		MLFX L 12;
		Stop;
	}
}
class SmiteningMissile : FastProjectile
{
    Default
    {
        Speed 120;
        Radius 12;
        Height 2;
        Damage 2;
        Projectile;
        +RIPPER
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        MissileType "SmiteningMissileSmoke";
        DeathSound "MageLightningFire";
		SeeSound "ThunderCrash";
        Obituary "$OB_MPCWEAPMACE";
		DamageType "Fire";

		Health 0;
    }
    States
    {
    Spawn:
        MLFX K 2 Bright;
		Loop;
    Death:
        MLFX M 2 Bright A_SmiteningExplode;
        Stop;
    }

	action void A_SmiteningExplode()
	{
		int damage = 20;
		int range = 90;

		let xrpgPlayer = XRpgPlayer(target);
		if (xrpgPlayer != null)
		{
			damage = xrpgPlayer.GetDamageForMagic(damage);
			range += xrpgPlayer.Magic;
		}
		
		A_Explode(damage, range, false);
	}
}
