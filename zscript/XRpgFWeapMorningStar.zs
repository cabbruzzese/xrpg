class XRpgFWeapMorningStar : XRpgFighterWeapon
{
	const MSTAR_RANGE = 1.5 * DEFMELEERANGE;

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
	}

	States
	{
	Spawn:
		WFHM A -1;
		Stop;
	Select:
		FMCE A 1 A_Raise;
		Loop;
	Deselect:
		FMCE A 1 A_Lower;
		Loop;
	Ready:
		FMCE A 1 A_WeaponReady;
		Loop;
	Fire:
		FMCE B 2 Offset (5, 0);
		FMCE B 4 Offset (5, 0) A_CheckBerserk(false);
		FMCE C 3 Offset (5, 0) A_FMStarMelee;
		FMCE D 3 Offset (5, 0);
		FMCE E 2 Offset (5, 0);
		FMCE E 10 Offset (5, 150);
		FMCE A 1 Offset (0, 60);
		FMCE A 1 Offset (0, 55);
		FMCE A 1 Offset (0, 50);
		FMCE A 1 Offset (0, 45);
		FMCE A 1 Offset (0, 40);
		FMCE A 1 Offset (0, 35);
		FMCE A 1;
		Goto Ready;
	BerserkFire:
		FMCE C 3 Offset (5, 0) A_FMStarMelee;
		FMCE D 3 Offset (5, 0);
		FMCE E 2 Offset (5, 0);
		FMCE E 6 Offset (5, 150);
		FMCE A 1 Offset (0, 60);
		FMCE A 1 Offset (0, 55);
		FMCE A 1 Offset (0, 50);
		FMCE A 1 Offset (0, 45);
		FMCE A 1 Offset (0, 40);
		FMCE A 1 Offset (0, 35);
		FMCE A 1;
		Goto Ready;
	}

	action void A_FMStarMelee()
	{
		FTranslatedLineTarget t;

		if (player == null)
		{
			return;
		}

		int damage = random[MStarAtk](1, 123);

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
				double slope = AimLineAttack(ang, MSTAR_RANGE, t, 0., ALF_CHECK3D);
				if (t.linetarget != null)
				{
					LineAttack(ang, MSTAR_RANGE, slope, damage, 'Melee', "HammerPuff", true, t);
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
		double slope = AimLineAttack (angle, MSTAR_RANGE, null, 0., ALF_CHECK3D);
		weaponspecial = (LineAttack (angle, MSTAR_RANGE, slope, damage, 'Melee', "HammerPuff", true) == null);
	}
}