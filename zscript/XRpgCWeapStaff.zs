class XRpgCWeapStaff : XRpgClericWeapon replaces CWeapStaff
{
	Default
	{
		Weapon.SelectionOrder 1600;
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 25;
		Weapon.KickBack 150;
		Weapon.YAdjust 10;
		Weapon.AmmoType1 "Mana1";
		Inventory.PickupMessage "$TXT_WEAPON_C2";
		Obituary "$OB_MPCWEAPSTAFFM";
		Tag "$TAG_CWEAPSTAFF";
	}

	States
	{
	Spawn:
		WCSS A -1;
		Stop;
	Select:
		CSSF C 1 A_Raise;
		Loop;
	Deselect:
		CSSF B 3;
		CSSF C 4;
		CSSF C 1 A_Lower;
		Wait;
	Ready:
		CSSF C 4;
		CSSF B 3 A_CStaffInitBlink;
		CSSF AAAAAAA 1 A_WeaponReady;
		CSSF A 1 A_CStaffCheckBlink;
		Goto Ready + 2;
	AltFire:
		CSSF K 10 Offset (0, 36) A_CDrainAttack;
		CSSF K 2 Offset (0, 45) A_Refire;
		Goto Ready + 2;
	Blink:
		CSSF BBBCCCCCBBB 1 A_WeaponReady;
		Goto Ready + 2;
	Drain:
		CSSF K 10 Offset (0, 36);
		Goto Ready + 2;
    Fire:
		CSSF A 1 Offset (0, 45);
		CSSF J 1 Offset (0, 50) A_CStaffAttack;
		CSSF J 2 Offset (0, 50);
		CSSF J 2 Offset (0, 45);
		CSSF A 2 Offset (0, 40);
		CSSF A 2 Offset (0, 36);
		Goto Ready + 2;
	}

	action void A_CDrainAttack()
	{
		FTranslatedLineTarget t;

		if (player == null)
		{
			return;
		}
		Weapon weapon = player.ReadyWeapon;

		int damage = random[StaffCheck](20, 35);

		if (weapon != null)
		{
			if (!weapon.CheckAmmo(Weapon.PrimaryFire, true))
				return;
		}

		int max = player.mo.GetMaxHealth();
		for (int i = 0; i < 3; i++)
		{
			for (int j = 1; j >= -1; j -= 2)
			{
				double ang = angle + j*i*(45. / 16);
				double slope = AimLineAttack(ang, 1.5 * DEFMELEERANGE, t, 0., ALF_CHECK3D);
				if (t.linetarget)
				{
					LineAttack(ang, 1.5 * DEFMELEERANGE, slope, damage, 'Melee', "StaffDrainPuff", false, t);
					if (t.linetarget != null)
					{
						angle = t.angleFromSource;
						if (((t.linetarget.player && (!t.linetarget.IsTeammate(self) || level.teamdamage != 0)) || t.linetarget.bIsMonster)
							&& (!t.linetarget.bDormant && !t.linetarget.bInvulnerable))
						{
							int newLife = player.health + (damage >> 3);
							newLife = newLife > max ? max : newLife;
							if (newLife > player.health)
							{
								health = player.health = newLife;
							}
						}
						if (weapon != null)
						{
							weapon.DepleteAmmo (false);
						}
					}
					return;
				}
			}
		}

		double slope = AimLineAttack (angle, 1.5 * DEFMELEERANGE, null, 0., ALF_CHECK3D);
		weaponspecial = (LineAttack (angle, 1.5 * DEFMELEERANGE, slope, damage, 'Melee', "StaffDrainPuff", true) == null);

		//If drain misses, shoot smite
		if (weaponspecial && A_IsSmite())
        {
			if (weapon.DepleteAmmo (false))
			{
				let mo = SpawnPlayerMissile("StaffPoisonCloudMissile", angle);
				if (mo)
				{
					mo.AddZ(16);
				}
			}
			weapon.CheckAmmo(Weapon.PrimaryFire, true);
			return;
        }
	}

	//============================================================================
	//
	// A_CStaffAttack
	//
	//============================================================================

	action void A_CStaffAttack()
	{
		if (player == null)
		{
			return;
		}

		Weapon weapon = player.ReadyWeapon;
		if (weapon != null)
		{
			if (!weapon.DepleteAmmo (false))
			{
				weapon.CheckAmmo(Weapon.PrimaryFire, true);
				return;
			}
		}

        let isSmite = A_IsSmite();
		Actor mo = SpawnPlayerMissile ("CStaffMissilePoison", angle - 3.0);
		if (mo)
		{
			mo.WeaveIndexXY = 32;
            if (isSmite)
            {
                mo.SetDamage(mo.damage * 1.5);
            }
		}
		mo = SpawnPlayerMissile ("CStaffMissilePoison", angle + 3.0);
		if (mo)
		{
			mo.WeaveIndexXY = 0;
            if (isSmite)
            {
                mo.SetDamage(mo.damage * 1.5);
            }
		}

		//Also shoot tracers on smite
		if (isSmite)
		{
			mo = SpawnPlayerMissile ("CStaffMissileSeeker", angle - 20);
			if (mo)
			{
				mo.tracer = player.mo;
			}
			mo = SpawnPlayerMissile ("CStaffMissileSeeker", angle + 20);
			if (mo)
			{
				mo.tracer = player.mo;
			}
		}

		A_StartSound ("ClericCStaffFire", CHAN_WEAPON);
	}

    /*action void A_CStaffAttackSeek()
	{
		if (player == null || !player.mo)
		{
			return;
		}

		Weapon weapon = player.ReadyWeapon;
		if (weapon != null)
		{
			if (!weapon.DepleteAmmo (false))
				return;
		}

		Actor mo = SpawnPlayerMissile ("CStaffMissileSeeker", angle - 20);
		if (mo)
		{
			mo.tracer = player.mo;
		}
		mo = SpawnPlayerMissile ("CStaffMissileSeeker", angle + 20);
		if (mo)
		{
			mo.tracer = player.mo;
		}

        if (A_IsSmite())
        {
            Actor mo = SpawnPlayerMissile ("CStaffMissileSeeker", angle);
            if (mo)
            {
                mo.tracer = player.mo;
            }
        }

		A_StartSound ("ClericCStaffFire", CHAN_WEAPON);
	}*/

	//============================================================================
	//
	// A_CStaffInitBlink
	//
	//============================================================================

	action void A_CStaffInitBlink()
	{
		weaponspecial = (random[CStaffBlink]() >> 1) + 20;
	}

	//============================================================================
	//
	// A_CStaffCheckBlink
	//
	//============================================================================

	action void A_CStaffCheckBlink()
	{
		if (player && player.ReadyWeapon)
		{
			if (!--weaponspecial)
			{
				player.SetPsprite(PSP_WEAPON, player.ReadyWeapon.FindState ("Blink"));
				weaponspecial = (random[CStaffBlink]() + 50) >> 2;
			}
			else 
			{
				A_WeaponReady();
			}
		}
	}
}

class CStaffMissilePoison : Actor
{
	Default
	{
		Speed 22;
		Radius 12;
		Height 10;
		Damage 5;
		RenderStyle "Add";
		Projectile;
		DeathSound "ClericCStaffExplode";
		Obituary "$OB_MPCWEAPSTAFFR";

		DamageType "Poison";
	}
	States
	{
	Spawn:
		CSSF DDEE 1 Bright A_CStaffMissileSlither;
		Loop;
	Death:
		CSSF FG 4 Bright;
		CSSF HI 3 Bright;
		Stop;
	}
	
	override int DoSpecialDamage (Actor target, int damage, Name damagetype)
	{
		// Cleric Serpent Staff does poison damage
		if (target.player)
		{
			target.player.PoisonPlayer (self, self.target, 20);
			damage >>= 1;
		}
		return damage;
	}
	
}

class CStaffMissileSeeker : Actor
{
	Default
	{
		Speed 10;
		Radius 8;
		Height 6;
		Damage 5;
		RenderStyle "Add";
		Projectile;
		DeathSound "ClericCStaffExplode";
		Obituary "$OB_MPCWEAPSTAFFR";

		DamageType "Poison";

        Health 100;
	}
	States
	{
	Spawn:
		CSSF D 2 Bright A_CStaffMissileSeek;
        CSSF E 2 Bright;
		Loop;
	Death:
		CSSF FG 4 Bright;
		CSSF HI 3 Bright;
		Stop;
	}
	
    action void A_CStaffMissileSeek()
    {
        A_SeekerMissile(60, 60, SMF_PRECISE);

        health--;

        if(health < 1)
        {
            SetStateLabel("Death");
        }
    }

	override int DoSpecialDamage (Actor target, int damage, Name damagetype)
	{
		// Cleric Serpent Staff does poison damage
		if (target.player)
		{
			target.player.PoisonPlayer (self, self.target, 20);
			damage >>= 1;
		}
		return damage;
	}
}

class StaffDrainPuff : Actor
{
	Default
	{
		+NOBLOCKMAP +NOGRAVITY
		+PUFFONACTORS
		RenderStyle "Translucent";
		Alpha 0.6;
		VSpeed 0.8;
		SeeSound "WraithAttack";
		AttackSound "FighterHammerHitWall";
		ActiveSound "FighterHammerMiss";
		Scale 0.25;
	}
	States
	{
	Spawn:
		FSFX DEFGHIJKLM 3;
		Stop;
	}
}

class StaffPoisonCloudSmoke : Actor
{
	Default
	{
	    +NOBLOCKMAP +NOGRAVITY +SHADOW
	    +NOTELEPORT +CANNOTPUSH +NODAMAGETHRUST
		RenderStyle "Translucent";
		Alpha 0.6;
        Scale 0.5;
	}
	States
	{
	Spawn:
		SGSA P 2;
        SGSA QRST 2;
		Stop;
	}
}
class StaffPoisonCloudMissile : FastProjectile
{
	int branchCount;
	property BranchCount: branchCount;

    Default
    {
        Speed 50;
        Radius 8;
        Height 6;
        Damage 3;
        Projectile;
        //+RIPPER
		+DONTREFLECT
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        MissileType "StaffPoisonCloudSmoke";
        Obituary "$OB_MPCWEAPSTAFFM";
		RenderStyle "Translucent";
		Alpha 0.6;
        Scale 0.5;

		SeeSound "FighterSwordFire";

		StaffPoisonCloudMissile.BranchCount 2;

        DamageType "Poison";
    }
    States
    {
    Spawn:
        SGSA P 1 Bright;
        SGSA Q 1 Bright StaffPoisonCloudSplit;
    Death:
        SGSA RST 1 Bright;
        Stop;
    }

	action void StaffPoisonCloudSplit ()
	{
		if (target == null)
		{
			return;
		}
		
		A_StaffPoisonCloudFire();
		A_StaffPoisonCloudFire();
	}

    action void A_StaffPoisonCloudFire()
	{
		if (target == null || invoker.BranchCount == 0)
		{
			return;
		}
		
        int randAngle = random(-12, 12);
        int randPitch = random(-8, 8);
		let mo = target.SpawnPlayerMissile ("StaffPoisonCloudMissile", angle + randAngle);
		if (mo != null)
		{
			mo.SetOrigin(Pos, false);
			mo.target = target;
			mo.A_SetPitch(pitch + randPitch);
			mo.Vel.Z = Vel.Z + randPitch;

			let poisonMissile = StaffPoisonCloudMissile(mo);
			if (poisonMissile)
				poisonMissile.BranchCount = invoker.BranchCount - 1;
		}
	}
}