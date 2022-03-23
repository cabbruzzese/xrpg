CONST POLEARM_LOWER_INCREMENT_X = 48;
CONST POLEARM_LOWER_INCREMENT_Y = 72;
class XRpgFWeapPolearm : XRpgFighterWeapon
{
	Default
	{
		+BLOODSPLATTER
		Weapon.SelectionOrder 900;
		+WEAPON.AMMO_OPTIONAL
		Weapon.KickBack 150;
		Inventory.PickupMessage "$TXT_WEAPON_POLEARM";
		Obituary "$OB_MPFWEAPPOLEARM";
		Tag "$TAG_FWEAPPOLEARM";
		Inventory.MaxAmount 1;

		XRpgFighterWeapon.Pufftype "AxePuff";
        XRpgFighterWeapon.MeleePush 6;
        XRpgFighterWeapon.MeleeAdjust false;
		XRpgFighterWeapon.WeaponRange int(2.4 * double(DEFMELEERANGE));
	}

	States
	{
	Spawn:
		FPOL K 4;
		FPOL K -1;
		Stop;
	Select:
		FPOL A 1 A_Raise;
		Loop;
	Deselect:
		FPOL A 1 A_Lower;
		Loop;
	Ready:
		FPOL A 1 A_WeaponReady;
		Loop;
	Fire:
    Cut:
		FPOL A 3;
        FPOL A 3 Offset (POLEARM_LOWER_INCREMENT_X * -0.5, 0);
        FPOL A 3 Offset (POLEARM_LOWER_INCREMENT_X * -1, 0);
        FPOL H 6 Offset (1, 1) A_GruntSound(50);
		FPOL I 3 Offset (0, 0);
		FPOL J 3 Offset (0, 0) A_FWeaponMelee(1, 120, 0, 1.5);
		FPOL J 3 Offset (0, POLEARM_LOWER_INCREMENT_Y * 1);
        FPOL J 3 Offset (0, POLEARM_LOWER_INCREMENT_Y * 2);
        FPOL J 6 Offset (0, POLEARM_LOWER_INCREMENT_Y * 3);
        Goto Ready;
    Thrust:
		FPOL A 3 Offset (POLEARM_LOWER_INCREMENT_X * 1, POLEARM_LOWER_INCREMENT_Y * 1);
        FPOL A 3 Offset (POLEARM_LOWER_INCREMENT_X * 2, POLEARM_LOWER_INCREMENT_Y * 2);
        FPOL A 3 Offset (POLEARM_LOWER_INCREMENT_X * 3, POLEARM_LOWER_INCREMENT_Y * 3);
        FPOL G 3 Offset (1, POLEARM_LOWER_INCREMENT_Y * 4);
        FPOL G 3 Offset (0, POLEARM_LOWER_INCREMENT_Y * 3);
        FPOL G 4 Offset (0, POLEARM_LOWER_INCREMENT_Y * 2);
        FPOL G 8 Offset (0, POLEARM_LOWER_INCREMENT_Y * 1) A_FWeaponMeleeAttack(1, 100, 0, 1.0, 0.0, int(3.2 * double(DEFMELEERANGE)), "AxePuff", true, true);
        FPOL G 4 Offset (0, POLEARM_LOWER_INCREMENT_Y * 2);
        FPOL G 3 Offset (0, POLEARM_LOWER_INCREMENT_Y * 3);
        FPOL G 3 Offset (0, POLEARM_LOWER_INCREMENT_Y * 4);
        Goto Ready;
    RightSwing:
		FPOL A 3 Offset (POLEARM_LOWER_INCREMENT_X * 1, POLEARM_LOWER_INCREMENT_Y * 1);
        FPOL A 3 Offset (POLEARM_LOWER_INCREMENT_X * 2, POLEARM_LOWER_INCREMENT_Y * 2);
        FPOL A 3 Offset (POLEARM_LOWER_INCREMENT_X * 3, POLEARM_LOWER_INCREMENT_Y * 3);
		FPOL B 8 Offset (1, 1);
		FPOL C 2 Offset (0, 1) A_FWeaponMelee(1, 20, -30, 0.25);
		FPOL C 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, -20, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL D 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, -10, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL D 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, 10, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL E 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, 20, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL E 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, 30, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL F 3 Offset (0, 0);
        FPOL F 3 Offset (POLEARM_LOWER_INCREMENT_X * -1, POLEARM_LOWER_INCREMENT_Y * 1);
        FPOL F 3 Offset (POLEARM_LOWER_INCREMENT_X * -2, POLEARM_LOWER_INCREMENT_Y * 2);
		Goto Ready;
    LeftSwing:
		FPOL A 3 Offset (POLEARM_LOWER_INCREMENT_X * 1, POLEARM_LOWER_INCREMENT_Y * 1);
        FPOL A 3 Offset (POLEARM_LOWER_INCREMENT_X * 2, POLEARM_LOWER_INCREMENT_Y * 2);
        FPOL A 3 Offset (POLEARM_LOWER_INCREMENT_X * 3, POLEARM_LOWER_INCREMENT_Y * 3);
		FPOL B 8 Offset (1, 1) A_Mirror;
		FPOL C 2 Offset (0, 1) A_FWeaponMelee(1, 20, 30, 0.25);
		FPOL C 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, 20, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL D 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, 10, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL D 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, -10, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL E 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, -20, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL E 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, -30, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL F 3 Offset (0, 1);
        FPOL F 3 Offset (POLEARM_LOWER_INCREMENT_X * -1, POLEARM_LOWER_INCREMENT_Y * 1);
        FPOL F 3 Offset (POLEARM_LOWER_INCREMENT_X * -2, POLEARM_LOWER_INCREMENT_Y * 2) A_RestoreMirror;
		Goto Ready;
	BerserkFire:
	BerserkCut:
		FPOL A 2;
        FPOL A 2 Offset (POLEARM_LOWER_INCREMENT_X * -0.5, 0);
        FPOL A 2 Offset (POLEARM_LOWER_INCREMENT_X * -1, 0);
        FPOL H 4 Offset (1, 1);
		FPOL I 2 Offset (0, 0);
		FPOL J 2 Offset (0, 0) A_FWeaponMelee(1, 120, 0, 1.5);
		FPOL J 2 Offset (0, POLEARM_LOWER_INCREMENT_Y * 1);
        FPOL J 2 Offset (0, POLEARM_LOWER_INCREMENT_Y * 2);
        FPOL J 4 Offset (0, POLEARM_LOWER_INCREMENT_Y * 3);
        Goto Ready;
    BerserkThrust:
		FPOL A 2 Offset (POLEARM_LOWER_INCREMENT_X * 1, POLEARM_LOWER_INCREMENT_Y * 1);
        FPOL A 2 Offset (POLEARM_LOWER_INCREMENT_X * 2, POLEARM_LOWER_INCREMENT_Y * 2);
        FPOL A 2 Offset (POLEARM_LOWER_INCREMENT_X * 3, POLEARM_LOWER_INCREMENT_Y * 3);
        FPOL G 2 Offset (1, POLEARM_LOWER_INCREMENT_Y * 4);
        FPOL G 2 Offset (0, POLEARM_LOWER_INCREMENT_Y * 3);
        FPOL G 3 Offset (0, POLEARM_LOWER_INCREMENT_Y * 2);
		FPOL G 6 Offset (0, POLEARM_LOWER_INCREMENT_Y * 1) A_FWeaponMeleeAttack(1, 100, 0, 1.0, 0.0, int(3.2 * double(DEFMELEERANGE)), "AxePuff", true, true);
        FPOL G 3 Offset (0, POLEARM_LOWER_INCREMENT_Y * 2);
        FPOL G 2 Offset (0, POLEARM_LOWER_INCREMENT_Y * 3);
        FPOL G 2 Offset (0, POLEARM_LOWER_INCREMENT_Y * 4);
        Goto Ready;
    BerserkRightSwing:
		FPOL A 2 Offset (POLEARM_LOWER_INCREMENT_X * 1, POLEARM_LOWER_INCREMENT_Y * 1);
        FPOL A 2 Offset (POLEARM_LOWER_INCREMENT_X * 2, POLEARM_LOWER_INCREMENT_Y * 2);
        FPOL A 2 Offset (POLEARM_LOWER_INCREMENT_X * 3, POLEARM_LOWER_INCREMENT_Y * 3);
		FPOL B 4 Offset (1, 1);
		FPOL C 2 Offset (0, 1) A_FWeaponMelee(1, 20, -30, 0.25);
		FPOL C 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, -20, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL D 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, -10, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL D 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, 10, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL E 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, 20, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL E 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, 30, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL F 2 Offset (0, 0);
        FPOL F 2 Offset (POLEARM_LOWER_INCREMENT_X * -1, POLEARM_LOWER_INCREMENT_Y * 1);
        FPOL F 2 Offset (POLEARM_LOWER_INCREMENT_X * -2, POLEARM_LOWER_INCREMENT_Y * 2);
		Goto Ready;
    BerserkLeftSwing:
		FPOL A 2 Offset (POLEARM_LOWER_INCREMENT_X * 1, POLEARM_LOWER_INCREMENT_Y * 1);
        FPOL A 2 Offset (POLEARM_LOWER_INCREMENT_X * 2, POLEARM_LOWER_INCREMENT_Y * 2);
        FPOL A 2 Offset (POLEARM_LOWER_INCREMENT_X * 3, POLEARM_LOWER_INCREMENT_Y * 3);
		FPOL B 4 Offset (1, 1) A_Mirror;
		FPOL C 2 Offset (0, 1) A_FWeaponMelee(1, 20, 30, 0.25);
		FPOL C 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, 20, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL D 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, 10, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL D 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, -10, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL E 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, -20, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL E 2 Offset (0, 1) A_FWeaponMeleePuff(1, 20, -30, 0.25, 0.0, "SmallMacePuffSilent");
		FPOL F 2 Offset (0, 1);
        FPOL F 2 Offset (POLEARM_LOWER_INCREMENT_X * -1, POLEARM_LOWER_INCREMENT_Y * 1);
        FPOL F 2 Offset (POLEARM_LOWER_INCREMENT_X * -2, POLEARM_LOWER_INCREMENT_Y * 2) A_RestoreMirror;
		Goto Ready;
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
		
		bool isBerserk = xrpgPlayer.IsSpellActive(SPELLTYPE_FIGHTER_BERSERK, true);
		
		if (rightMove)
			return isBerserk ? FindState ("BerserkRightSwing") : FindState ("RightSwing");
		else if (leftMove)
			return isBerserk ? FindState ("BerserkLeftSwing") : FindState ("LeftSwing");
		else if (forwardMove != 0)
			return isBerserk ? FindState ("BerserkThrust") : FindState ("Thrust");

		return isBerserk ? FindState ("BerserkFire") :  Super.GetAtkState(hold);
	}
}