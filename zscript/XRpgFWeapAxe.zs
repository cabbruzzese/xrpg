// The Fighter's Axe --------------------------------------------------------

class XRpgFWeapAxe : XRpgFighterWeapon replaces FWeapAxe
{
	const AXERANGE = (2.25 * DEFMELEERANGE);
	const AXESWINGRANGE = (1.75 * DEFMELEERANGE);

	Default
	{
		Weapon.SelectionOrder 1500;
		+WEAPON.AXEBLOOD +WEAPON.AMMO_OPTIONAL +WEAPON.MELEEWEAPON
		Weapon.AmmoUse1 2;
		Weapon.AmmoGive1 25;
		Weapon.KickBack 150;
		Weapon.AmmoType1 "Mana1";
		Inventory.PickupMessage "$TXT_WEAPON_F2";
		Obituary "$OB_MPFWEAPAXE";
		Tag "$TAG_FWEAPAXE";
	}

	States
	{
	Spawn:
		WFAX A -1;
		Stop;
	Select:
		FAXE A 1 A_FAxeCheckUp;
		Loop;
	Deselect:
		FAXE A 1 A_Lower;
		Loop;
	Ready:
		FAXE A 1 A_FAxeCheckReady;
		Loop;
	Fire:
		FAXE B 4 Offset (15, 32);// A_FAxeCheckAtk();
		FAXE C 3 Offset (15, 32);
		FAXE D 2 Offset (15, 32);
		FAXE D 1 Offset (-5, 70) A_FAxeAttack;
	EndAttack:
		FAXE D 2 Offset (-25, 90);
		FAXE E 1 Offset (15, 32);
		FAXE E 2 Offset (10, 54);
		FAXE E 7 Offset (10, 150);
		FAXE A 1 Offset (0, 60) A_ReFire;
		FAXE A 1 Offset (0, 52);
		FAXE A 1 Offset (0, 44);
		FAXE A 1 Offset (0, 36);
		FAXE A 1;
		Goto Ready;
	BerserkEndAttack:
		FAXE D 1 Offset (-25, 90);
		FAXE E 1 Offset (15, 32);
		FAXE E 1 Offset (10, 54);
		FAXE E 5 Offset (10, 150);
		FAXE A 1 Offset (0, 60) A_ReFire;
		FAXE A 1 Offset (0, 52);
		FAXE A 1 Offset (0, 44);
		FAXE A 1 Offset (0, 36);
		FAXE A 1;
		Goto Ready;
	BerserkFire:
		FAXE B 3 Offset (15, 32);
		FAXE C 2 Offset (15, 32);
		FAXE D 1 Offset (15, 32);
		FAXE D 1 Offset (-5, 70) A_FAxeAttack;
		FAXE D 1 Offset (-25, 90);
		FAXE E 1 Offset (15, 32);
		FAXE E 1 Offset (10, 54);
		FAXE E 5 Offset (10, 150);
		FAXE A 1 Offset (0, 60) A_ReFire;
		FAXE A 1 Offset (0, 52);
		FAXE A 1 Offset (0, 44);
		FAXE A 1 Offset (0, 36);
		FAXE A 1;
		Goto Ready;
	SelectGlow:
		FAXE L 1 A_FAxeCheckUpG;
		Loop;
	DeselectGlow:
		FAXE L 1 A_Lower;
		Loop;
	ReadyGlow:
		FAXE LLL 1 A_FAxeCheckReadyG;
		FAXE MMM 1 A_FAxeCheckReadyG;
		Loop;
	FireGlow:
		FAXE N 4 Offset (15, 32);
		FAXE O 3 Offset (15, 32);
		FAXE P 2 Offset (15, 32);
		FAXE P 1 Offset (-5, 70) A_FAxeAttack;
		FAXE P 2 Offset (-25, 90);
		FAXE Q 1 Offset (15, 32);
		FAXE Q 2 Offset (10, 54);
		FAXE Q 7 Offset (10, 150);
		FAXE A 1 Offset (0, 60) A_ReFire;
		FAXE A 1 Offset (0, 52);
		FAXE A 1 Offset (0, 44);
		FAXE A 1 Offset (0, 36);
		FAXE A 1;
		Goto ReadyGlow;
	BerserkFireGlow:
		FAXE N 3 Offset (15, 32);
		FAXE O 2 Offset (15, 32);
		FAXE P 1 Offset (15, 32);
		FAXE P 1 Offset (-5, 70) A_FAxeAttack;
		FAXE P 1 Offset (-25, 90);
		FAXE Q 1 Offset (15, 32);
		FAXE Q 1 Offset (10, 54);
		FAXE Q 5 Offset (10, 150);
		FAXE A 1 Offset (0, 60) A_ReFire;
		FAXE A 1 Offset (0, 52);
		FAXE A 1 Offset (0, 44);
		FAXE A 1 Offset (0, 36);
		FAXE A 1;
		Goto ReadyGlow;
	RightSwing:
		FAXS A 4 Offset (190, -10) A_FAxeCheckSwingAtk;
		FAXS A 6 Offset (190, -10);
		FAXS A 1 Offset (140, -2) A_FAxeSwingAttack(-40);
		FAXS A 1 Offset (90, 6) A_FAxeSwingAttack(-20);
		FAXS A 1 Offset (40, 14) A_FAxeSwingAttack(0);
		FAXS A 1 Offset (-10, 22) A_FAxeSwingAttack(20);
		FAXS A 1 Offset (-60, 30) A_FAxeSwingAttack(40);
		FAXS A 1 Offset (-110, 38);
		FAXS A 1 Offset (-160, 46);
		FAXS A 1 Offset (-210, 54);
		FAXS A 1 Offset (-260, 62);
		TNT1 A 14 Offset (-310, 70);
		TNT1 A 4 Offset (-310, 70) A_ReFire;
		Goto Ready;
	BerserkRightSwing:
		FAXS A 6 Offset (190, -10);
		FAXS A 1 Offset (140, -2) A_FAxeSwingAttack(-40);
		FAXS A 1 Offset (90, 6) A_FAxeSwingAttack(-20);
		FAXS A 1 Offset (40, 14) A_FAxeSwingAttack(0);
		FAXS A 1 Offset (-10, 22) A_FAxeSwingAttack(20);
		FAXS A 1 Offset (-60, 30) A_FAxeSwingAttack(40);
		FAXS A 1 Offset (-110, 38);
		FAXS A 1 Offset (-160, 46);
		FAXS A 1 Offset (-210, 54);
		FAXS A 1 Offset (-260, 62);
		TNT1 A 4 Offset (-310, 70);
		TNT1 A 4 Offset (-310, 70) A_ReFire;
		Goto Ready;
	RightSwingGlow:
		FAXS B 6 Offset (190, -10);
		FAXS B 1 Offset (140, -2) A_FAxeSwingAttack(-40, true);
		FAXS B 1 Offset (90, 6) A_FAxeSwingAttack(-20, true);
		FAXS B 1 Offset (40, 14) A_FAxeSwingAttack(0, true);
		FAXS B 1 Offset (-10, 22) A_FAxeSwingAttack(20, true);
		FAXS B 1 Offset (-60, 30) A_FAxeSwingAttack(40, true);
		FAXS B 1 Offset (-110, 38);
		FAXS B 1 Offset (-160, 46);
		FAXS B 1 Offset (-210, 54);
		FAXS B 1 Offset (-260, 62);
		TNT1 A 14 Offset (-310, 70);
		TNT1 A 4 Offset (-310, 70) A_ReFire;
		Goto Ready;
	BerserkRightSwingGlow:
		FAXS B 6 Offset (190, -10);
		FAXS B 1 Offset (140, -2) A_FAxeSwingAttack(-40, true);
		FAXS B 1 Offset (90, 6) A_FAxeSwingAttack(-20, true);
		FAXS B 1 Offset (40, 14) A_FAxeSwingAttack(0, true);
		FAXS B 1 Offset (-10, 22) A_FAxeSwingAttack(20, true);
		FAXS B 1 Offset (-60, 30) A_FAxeSwingAttack(40, true);
		FAXS B 1 Offset (-110, 38);
		FAXS B 1 Offset (-160, 46);
		FAXS B 1 Offset (-210, 54);
		FAXS B 1 Offset (-260, 62);
		TNT1 A 4 Offset (-310, 70);
		TNT1 A 2 Offset (-310, 70) A_ReFire;
		Goto Ready;
	LeftSwing:
		FAXS C 4 Offset (-190, -10) A_FAxeCheckSwingAtk;
		FAXS C 6 Offset (-190, -10);
		FAXS C 1 Offset (-140, -2) A_FAxeSwingAttack(40);
		FAXS C 1 Offset (-90, 6) A_FAxeSwingAttack(20);
		FAXS C 1 Offset (-40, 14) A_FAxeSwingAttack(0);
		FAXS C 1 Offset (10, 22) A_FAxeSwingAttack(-20);
		FAXS C 1 Offset (60, 30) A_FAxeSwingAttack(-40);
		FAXS C 1 Offset (110, 38);
		FAXS C 1 Offset (160, 46);
		FAXS C 1 Offset (210, 54);
		FAXS C 1 Offset (260, 62);
		TNT1 A 14 Offset (310, 70);
		TNT1 A 4 Offset (310, 70) A_ReFire;
		Goto Ready;
	BerserkLeftSwing:
		FAXS C 6 Offset (-190, -10);
		FAXS C 1 Offset (-140, -2) A_FAxeSwingAttack(40);
		FAXS C 1 Offset (-90, 6) A_FAxeSwingAttack(20);
		FAXS C 1 Offset (-40, 14) A_FAxeSwingAttack(0);
		FAXS C 1 Offset (10, 22) A_FAxeSwingAttack(-20);
		FAXS C 1 Offset (60, 30) A_FAxeSwingAttack(-40);
		FAXS C 1 Offset (110, 38);
		FAXS C 1 Offset (160, 46);
		FAXS C 1 Offset (210, 54);
		FAXS C 1 Offset (260, 62);
		TNT1 A 4 Offset (310, 70);
		TNT1 A 4 Offset (310, 70) A_ReFire;
		Goto Ready;
	LeftSwingGlow:
		FAXS D 6 Offset (-190, -10);
		FAXS D 1 Offset (-140, -2) A_FAxeSwingAttack(40, true);
		FAXS D 1 Offset (-90, 6) A_FAxeSwingAttack(20, true);
		FAXS D 1 Offset (-40, 14) A_FAxeSwingAttack(0, true);
		FAXS D 1 Offset (10, 22) A_FAxeSwingAttack(-20, true);
		FAXS D 1 Offset (60, 30) A_FAxeSwingAttack(-40, true);
		FAXS D 1 Offset (110, 38);
		FAXS D 1 Offset (160, 46);
		FAXS D 1 Offset (210, 54);
		FAXS D 1 Offset (260, 62);
		TNT1 A 14 Offset (310, 70);
		TNT1 A 4 Offset (310, 70) A_ReFire;
		Goto Ready;
	BerserkLeftSwingGlow:
		FAXS D 6 Offset (-190, -10);
		FAXS D 1 Offset (-140, -2) A_FAxeSwingAttack(40, true);
		FAXS D 1 Offset (-90, 6) A_FAxeSwingAttack(20, true);
		FAXS D 1 Offset (-40, 14) A_FAxeSwingAttack(0, true);
		FAXS D 1 Offset (10, 22) A_FAxeSwingAttack(-20, true);
		FAXS D 1 Offset (60, 30) A_FAxeSwingAttack(-40, true);
		FAXS D 1 Offset (110, 38);
		FAXS D 1 Offset (160, 46);
		FAXS D 1 Offset (210, 54);
		FAXS D 1 Offset (260, 62);
		TNT1 A 4 Offset (310, 70);
		TNT1 A 2 Offset (310, 70) A_ReFire;
		Goto Ready;
	AltFire:
        FSHL A 1 A_CheckShield;
        FSHL BC 1;
        FSHL D 1 A_FWeaponMeleeAttack(1, 20, 0, 1.5, 0, SHIELD_RANGE, "AxePuff", false, 20);
    AltHold:
		FSHL E 8 A_UseShield;
		FSHL E 4 A_Refire;
        FSHL E 4 A_CheckShieldCharged;
        FSHL DCBA 2;
        Goto Ready;
    ShieldCharged:
        FSHL FGH 2 BRIGHT;
		FSHL F 2 BRIGHT A_Refire;
        FSHL G 2 BRIGHT A_ShieldFire;
    ShieldFireFinish:
		FSHL DCBA 2;
        Goto Ready;
	}
	
	override State GetUpState ()
	{
		return Ammo1.Amount ? FindState ("SelectGlow") : Super.GetUpState();
	}

	override State GetDownState ()
	{
		return Ammo1.Amount ? FindState ("DeselectGlow") : Super.GetDownState();
	}

	override State GetReadyState ()
	{
		return Ammo1.Amount ? FindState ("ReadyGlow") : Super.GetReadyState();
	}

	override State GetAtkState (bool hold)
	{
		if (!Owner || !Owner.player || !Owner.player.mo)
			return FindState("Fire");
		
		let xrpgPlayer = XRpgPlayer(Owner.player.mo);
		if (!xrpgPlayer)
			return FindState("Fire");

		let forwardMove = xrpgPlayer.GetPlayerInput(INPUT_FORWARDMOVE);
		let sideMove = xrpgPlayer.GetPlayerInput(INPUT_SIDEMOVE);
		let rightMove = sideMove > 0;
		let leftMove = sideMove < 0;
		let backMove = forwardMove < 0;
		
		bool isBerserk = xrpgPlayer.IsSpellActive(SPELLTYPE_FIGHTER_BERSERK, true);
		
		if (isBerserk)
		{
			if (rightMove && !backMove)
				return Ammo1.Amount ? FindState ("BerserkRightSwingGlow") :  FindState ("BerserkRightSwing");	
			else if (leftMove && !backMove)
				return Ammo1.Amount ? FindState ("BerserkLeftSwingGlow") :  FindState ("BerserkLeftSwing");	
			else
				return Ammo1.Amount ? FindState ("BerserkFireGlow") :  FindState ("BerserkFire");
		}
		else
		{
			if (rightMove && !backMove)
				return Ammo1.Amount ? FindState ("RightSwingGlow") :  FindState ("RightSwing");	
			else if (leftMove && !backMove)
				return Ammo1.Amount ? FindState ("LeftSwingGlow") :  FindState ("LeftSwing");	
		}

		return Ammo1.Amount ? FindState ("FireGlow") :  Super.GetAtkState(hold);
	}

	
	
	//============================================================================
	//
	// A_FAxeCheckReady
	//
	//============================================================================

	action void A_FAxeCheckReady()
	{
		if (player == null)
		{
			return;
		}
		Weapon w = player.ReadyWeapon;
		if (w.Ammo1 && w.Ammo1.Amount > 0)
		{
			player.SetPsprite(PSP_WEAPON, w.FindState("ReadyGlow"));
		}
		else
		{
			A_WeaponReady();
		}
	}

	//============================================================================
	//
	// A_FAxeCheckReadyG
	//
	//============================================================================

	action void A_FAxeCheckReadyG()
	{
		if (player == null)
		{
			return;
		}
		Weapon w = player.ReadyWeapon;
		if (!w.Ammo1 || w.Ammo1.Amount <= 0)
		{
			player.SetPsprite(PSP_WEAPON, w.FindState("Ready"));
		}
		else
		{
			A_WeaponReady();
		}
	}

	//============================================================================
	//
	// A_FAxeCheckUp
	//
	//============================================================================

	action void A_FAxeCheckUp()
	{
		if (player == null)
		{
			return;
		}
		Weapon w = player.ReadyWeapon;
		if (w.Ammo1 && w.Ammo1.Amount > 0)
		{
			player.SetPsprite(PSP_WEAPON, w.FindState("SelectGlow"));
		}
		else
		{
			A_Raise();
		}
	}

	//============================================================================
	//
	// A_FAxeCheckUpG
	//
	//============================================================================

	action void A_FAxeCheckUpG()
	{
		if (player == null)
		{
			return;
		}
		Weapon w = player.ReadyWeapon;
		if (!w.Ammo1 || w.Ammo1.Amount <= 0)
		{
			player.SetPsprite(PSP_WEAPON, w.FindState("Select"));
		}
		else
		{
			A_Raise();
		}
	}

	const AXE_SWING_BLUEMANA = 1;
	action void A_FAxeCheckSwingAtk()
	{
		if (player == null)
			return;

		let xrpgPlayer = XRpgPlayer(player.mo);
		if (!xrpgPlayer)
			return;

		Weapon w = player.ReadyWeapon;
		if (!w)
			return;
		
		A_GruntSound(33);

		bool isBerserk = xrpgPlayer.IsSpellActive(SPELLTYPE_FIGHTER_BERSERK, true);

		if (A_CheckAllMana(AXE_SWING_BLUEMANA, 0))
		{
			if (isBerserk)
				A_SetWeapState("BerserkRightSwingGlow");
			else
				A_SetWeapState("RightSwingGlow");
		}
		else if (isBerserk)
		{
			A_SetWeapState("BerserkRightSwing");
		}
	}

	action void A_FAxeSwingAttack(int angleMod, bool isGlowing = false)
	{
		FTranslatedLineTarget t;

		if (player == null)
		{
			return;
		}

		int damage = random[AxeAtk](1, 15);
		int power = 5;
		class<Actor> pufftype;

		let xrpgPlayer = XRpgPlayer(player.mo);
		if (!xrpgPlayer)
			return;

		let weapon = player.ReadyWeapon;
		if (!weapon)
			return;
		
		bool usemana = isGlowing && A_CheckAllMana(AXE_SWING_BLUEMANA, 0);
		if (usemana)
		{
			damage += xrpgPlayer.GetMagic();
			power = 10;
			pufftype = "SwingAxePuffGlow";
		}
		else
		{
			pufftype = "SwingAxePuff";
		}

		
		if (xrpgPlayer != null)
		{
			damage += xrpgPlayer.GetStrength() / 3.0;
		}

		for (int i = 0; i < 16; i++)
		{
			for (int j = 1; j >= -1; j -= 2)
			{
				double ang = angle + j*i*(45. / 16) + angleMod;
				double slope = AimLineAttack(ang, AXESWINGRANGE, t, 0., ALF_CHECK3D);
				if (t.linetarget)
				{
					LineAttack(ang, AXESWINGRANGE, slope, damage, 'Melee', pufftype, true, t);
					if (t.linetarget != null)
					{
						if (t.linetarget.bIsMonster || t.linetarget.player)
						{
							A_ThrustTarget(t.linetarget, power, t.attackAngleFromSource);
						}
						
						A_DepleteAllMana(AXE_SWING_BLUEMANA,0);
						//weapon.DepleteAmmo (weapon.bAltFire, false);

						return;
					}
				}
			}
		}
		// didn't find any creatures, so try to strike any walls
		self.weaponspecial = 0;

		double slope = AimLineAttack (angle + angleMod, DEFMELEERANGE, null, 0., ALF_CHECK3D);
		LineAttack (angle + angleMod, DEFMELEERANGE, slope, damage, 'Melee', pufftype, true);
	}

	//============================================================================
	//
	// A_FAxeAttack
	//
	//============================================================================

	action void A_FAxeAttack()
	{
		FTranslatedLineTarget t;

		if (player == null)
		{
			return;
		}

		int damage = random[AxeAtk](1, 55);
		damage += random[AxeAtk](0, 7);
		int power = 0;
		Weapon weapon = player.ReadyWeapon;
		class<Actor> pufftype;
		int usemana;
		if ((usemana = (weapon.Ammo1 && weapon.Ammo1.Amount > 0)))
		{
			damage <<= 1;
			power = 6;
			pufftype = "AxePuffGlow";
		}
		else
		{
			pufftype = "AxePuff";
		}

		let xrpgPlayer = XRpgPlayer(player.mo);
		if (xrpgPlayer != null)
		{
			damage += xrpgPlayer.GetStrength();
		}

		for (int i = 0; i < 16; i++)
		{
			for (int j = 1; j >= -1; j -= 2)
			{
				double ang = angle + j*i*(45. / 16);
				double slope = AimLineAttack(ang, AXERANGE, t, 0., ALF_CHECK3D);
				if (t.linetarget)
				{
					LineAttack(ang, AXERANGE, slope, damage, 'Melee', pufftype, true, t);
					if (t.linetarget != null)
					{
						if (t.linetarget.bIsMonster || t.linetarget.player)
						{
							A_ThrustTarget(t.linetarget, power, t.attackAngleFromSource);
						}
						AdjustPlayerAngle(t);
						
						weapon.DepleteAmmo (weapon.bAltFire, false);

						if ((weapon.Ammo1 == null || weapon.Ammo1.Amount == 0) &&
							(!(weapon.bPrimary_Uses_Both) ||
							  weapon.Ammo2 == null || weapon.Ammo2.Amount == 0))
						{
							if (xrpgPlayer && xrpgPlayer.IsSpellActive(SPELLTYPE_FIGHTER_BERSERK, true))
								player.SetPsprite(PSP_WEAPON, weapon.FindState("BerserkEndAttack"));
							else
								player.SetPsprite(PSP_WEAPON, weapon.FindState("EndAttack"));
						}
						return;
					}
				}
			}
		}
		// didn't find any creatures, so try to strike any walls
		self.weaponspecial = 0;

		double slope = AimLineAttack (angle, DEFMELEERANGE, null, 0., ALF_CHECK3D);
		LineAttack (angle, DEFMELEERANGE, slope, damage, 'Melee', pufftype, true);
	}
}

class SwingAxePuff : Actor
{
	Default
	{
		+NOBLOCKMAP +NOGRAVITY
		+PUFFONACTORS
		RenderStyle "Translucent";
		Alpha 0.6;
		SeeSound "FighterAxeHitThing";
		AttackSound "FighterHammerHitWall";
		ActiveSound "FighterHammerMiss";
		Scale 0.75;
	}
	States
	{
	Spawn:
		FHFX STUVW 4;
		Stop;
	}
}

class SwingAxePuffGlow : AxePuff
{
	Default
	{
		+PUFFONACTORS
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 1;
		Scale 0.5;
	}
	States
	{
	Spawn:
		FAXE RSTUVWX 4 Bright;
		Stop;
	}
}