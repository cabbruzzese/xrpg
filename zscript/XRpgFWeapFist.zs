const FIST_CHARGE_MAX = 20;

class XRpgFWeapFist : XRpgFighterWeapon replaces FWeapFist
{
	Default
	{
		+BLOODSPLATTER
		Weapon.SelectionOrder 3400;
		+WEAPON.MELEEWEAPON
		Weapon.KickBack 150;
		Obituary "$OB_MPFWEAPFIST";
		Tag "$TAG_FWEAPFIST";

		XRpgWeapon.MaxCharge FIST_CHARGE_MAX;
	}

	States
	{
	Select:
		FPCH A 1 A_Raise;
		Loop;
	Deselect:
		FPCH A 1 A_Lower;
		Loop;
	Ready:
		FPCH A 1 A_WeaponReady;
		Loop;
	Fire:
		FPCH B 5 Offset (5, 40) A_CheckBerserk(false);
		FPCH C 4 Offset (5, 40);
		FPCH D 4 Offset (5, 40) A_FPunchAttack;
		FPCH C 4 Offset (5, 40);
		FPCH B 5 Offset (5, 40) A_ReFire;
		Goto Ready;
	BerserkFire:
		FPCH B 4 Offset (5, 40);
		FPCH C 2 Offset (5, 40);
		FPCH D 2 Offset (5, 40) A_FPunchAttack;
		FPCH C 2 Offset (5, 40);
		FPCH B 3 Offset (5, 40) A_ReFire;
		Goto Ready;
	Fire2:
		FPCH DE 4 Offset (5, 40);
		FPCH E 1 Offset (15, 50);
		FPCH E 1 Offset (25, 60);
		FPCH E 1 Offset (35, 70);
		FPCH E 1 Offset (45, 80);
		FPCH E 1 Offset (55, 90);
		FPCH E 1 Offset (65, 100);
		FPCH E 10 Offset (0, 150);
		Goto Ready;
    AltFire:
	AltHold:
		FPCH B 1 Offset (-10, 40) A_Mirror();
		FPCH B 2 Offset (-10, 40) A_ChargeUp;
		FPCH B 2 Offset (-10, 40) A_ReFire;
		FPCH C 2 Offset (5, 40);
		FPCH D 4 Offset (5, 40) A_FPunchAttack2;
		FPCH DE 2 Offset (5, 40);
		FPCH E 1 Offset (15, 50);
		FPCH E 1 Offset (25, 60);
		FPCH E 1 Offset (35, 70);
		FPCH E 1 Offset (45, 80);
		FPCH E 1 Offset (55, 90);
		FPCH E 1 Offset (65, 100);
		FPCH E 2 Offset (0, 150) A_RestoreMirror;
		Goto Ready;
	}

	//============================================================================
	//
	// TryPunch
	//
	// Returns true if an actor was punched, false if not.
	//
	//============================================================================

	private action bool TryPunch(double angle, int damage, int power)
	{
		Class<Actor> pufftype;
		FTranslatedLineTarget t;

		double slope = AimLineAttack (angle, 2*DEFMELEERANGE, t, 0., ALF_CHECK3D);
		if (t.linetarget != null)
		{
			if (++weaponspecial >= 3)
			{
				damage <<= 1;
				power *= 3;
				pufftype = "HammerPuff";
			}
			else
			{
				pufftype = "PunchPuff";
			}

            let xrpgPlayer = XRpgPlayer(player.mo);
			if (xrpgPlayer != null)
			{
				let statItem = xrpgPlayer.GetStats();
				damage += statItem.Strength;
			}

			LineAttack (angle, 2*DEFMELEERANGE, slope, damage, 'Melee', pufftype, true, t);
			if (t.linetarget != null)
			{
				// The mass threshold has been changed to CommanderKeen's value which has been used most often for 'unmovable' stuff.
				if (t.linetarget.player != null || 
					(t.linetarget.Mass < 10000000 && (t.linetarget.bIsMonster)))
				{
					A_ThrustTarget(t.linetarget, power, t.attackAngleFromSource);
				}
				AdjustPlayerAngle(t);
				return true;
			}
		}
		return false;
	}

	//============================================================================
	//
	// A_FPunchAttack
	//
	//============================================================================

	action void A_FPunchAttack()
	{
		if (player == null)
		{
			return;
		}

		int damage = random[FighterAtk](1, 55);
		for (int i = 0; i < 16; i++)
		{
			if (TryPunch(angle + i*(45./16), damage, 2) ||
				TryPunch(angle - i*(45./16), damage, 2))
			{ // hit something
				if (weaponspecial >= 3)
				{
					weaponspecial = 0;
					player.SetPsprite(PSP_WEAPON, player.ReadyWeapon.FindState("Fire2"));
					A_GruntSound(-1);
				}
				return;
			}
		}
		// didn't find any creatures, so try to strike any walls
		weaponspecial = 0;

		double slope = AimLineAttack (angle, DEFMELEERANGE, null, 0., ALF_CHECK3D);
		LineAttack (angle, DEFMELEERANGE, slope, damage, 'Melee', "PunchPuff", true);
	}
	
    private action bool TryPunch2(double angle, int damage, int power)
	{
		Class<Actor> pufftype;
		FTranslatedLineTarget t;

		double slope = AimLineAttack (angle, 2*DEFMELEERANGE, t, 0., ALF_CHECK3D);
		if (t.linetarget != null)
		{
            pufftype = "HammerPuff";

            let xrpgPlayer = XRpgPlayer(player.mo);
			if (xrpgPlayer != null)
			{
				let statItem = xrpgPlayer.GetStats();
				damage += statItem.Strength;
			}

			LineAttack (angle, 2*DEFMELEERANGE, slope, damage, 'Melee', pufftype, true, t);
			if (t.linetarget != null)
			{
				// The mass threshold has been changed to CommanderKeen's value which has been used most often for 'unmovable' stuff.
				if (t.linetarget.player != null || 
					(t.linetarget.Mass < 10000000 && (t.linetarget.bIsMonster)))
				{
					A_ThrustTarget(t.linetarget, power, t.attackAngleFromSource);
				}
				AdjustPlayerAngle(t);
				return true;
			}
		}
		return false;
	}

    action void A_FPunchAttack2()
    {
		if (!player)
			return;

		let xrpgPlayer = XRpgPlayer(player.mo);
		if (!xrpgPlayer)
			return;

		//If berserk, all attacks are at least half of max charge
		bool isBerserk = xrpgPlayer.IsSpellActive(SPELLTYPE_FIGHTER_BERSERK, true);
		if (isBerserk)
			invoker.ChargeValue = Max(invoker.ChargeValue, invoker.MaxCharge / 2);
		
		double damageMod = 1.0 + (double(invoker.ChargeValue) / 10);

        int damage = random[FighterAtk](15, 35);
		damage *= damageMod;
		int power = (invoker.ChargeValue) + 5;

		invoker.ChargeValue = 0;

		Thrust(power / 2, angle);
		A_GruntSound(-1);

		for (int i = 0; i < 16; i++)
		{
			if (TryPunch2(angle + i*(45./16), damage, power) ||
				TryPunch2(angle - i*(45./16), damage, power))
			{ // hit something
				return;
			}
		}
		// didn't find any creatures, so try to strike any walls
		weaponspecial = 0;

		double slope = AimLineAttack (angle, DEFMELEERANGE, null, 0., ALF_CHECK3D);
		LineAttack (angle, DEFMELEERANGE, slope, damage, 'Melee', "PunchPuff", true);
    }
}
