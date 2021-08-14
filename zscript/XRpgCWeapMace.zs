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
		CMCE E 1 Offset (-11, 58) A_CMaceAttack;
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
	}
	
	//===========================================================================
	//
	// A_CMaceAttack
	//
	//===========================================================================

	action void A_CMaceAttack()
	{
		FTranslatedLineTarget t;

		if (player == null)
		{
			return;
		}

		int damage = random[MaceAtk](25, 40);

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
		if (!player)
			return;
		
		let clericPlayer = XRpgClericPlayer(player.mo);
        if (!clericPlayer 
			|| !clericPlayer.ActiveSpell 
			|| clericPlayer.ActiveSpell.SpellType != SPELLTYPE_CLERIC_SMITE 
			|| clericPlayer.ActiveSpell.TimerVal < 1)
			return;

		A_FireVerticalMissilePos("SmiteningMissile", lineTarget.Pos.X, lineTarget.Pos.Y, lineTarget.Pos.Z);
	}
}

class SmiteningMissileSmoke : Actor
{
	Default
	{
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
        Obituary "$OB_MPCWEAPMACE";
		DamageType "Fire";
    }
    States
    {
    Spawn:
        MLFX K 2 Bright;
		Loop;
    Death:
        MLFX M 2 Bright A_Explode(20, 100, false);
        Stop;
    }
}
