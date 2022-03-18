CONST POLEARM_LOWER_INCREMENT_X = 10;
CONST POLEARM_LOWER_INCREMENT_Y = 35;
class XRpgFWeapPolearm : XRpgFighterWeapon replaces EttinMace
{
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
		Inventory.PickupMessage "$TXT_WEAPON_POLEARM";
		Obituary "$OB_MPFWEAPPOLEARM";
		Tag "$TAG_FWEAPPOLEARM";
		Inventory.MaxAmount 1;

        XRpgFighterWeapon.MeleePush 6;
        XRpgFighterWeapon.MeleeAdjust false;
		XRpgFighterWeapon.WeaponRange int(3.0 * double(DEFMELEERANGE));
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
		FPOL A 2 Offset (POLEARM_LOWER_INCREMENT_X * 1, 10);
        FPOL A 2 Offset (POLEARM_LOWER_INCREMENT_X * 2, 30);
        FPOL A 2 Offset (POLEARM_LOWER_INCREMENT_X * 3, 50) A_CheckBerserk(false);
        FPOL H 4 Offset (1, 1);
		FPOL I 4 Offset (0, 0);
		FPOL J 4 Offset (0, 0);
		FPOL J 4 Offset (0, 0) A_FWeaponMelee(1, 90, 0, 1.5);
		FPOL J 4 Offset (0, 50);
        FPOL J 4 Offset (0, 100);
        FPOL J 4 Offset (0, 150);
        Goto Ready;
    Thrust:
        FPOL A 2 Offset (25, 10);
        FPOL A 2 Offset (45, 30);
        FPOL A 2 Offset (55, 50) A_CheckBerserk(false);
        FPOL G 2 Offset (1, -150);
        FPOL G 2 Offset (0, -100);
        FPOL G 2 Offset (0, -50);
        FPOL G 2 Offset (0, 1) A_FWeaponMelee(1, 90, 0, 1.5);
        FPOL G 2 Offset (0, -50);
        FPOL G 2 Offset (0, -100);
        FPOL G 2 Offset (0, -150);
        Goto Ready;
    RightSwing:
		FPOL A 2 Offset (25, 10);
        FPOL A 2 Offset (45, 30);
        FPOL A 2 Offset (55, 50) A_CheckBerserk(false);
		FPOL B 4 Offset (1, 1);
		FPOL C 4 Offset (0, 0) A_FWeaponMelee(1, 90, 0, 1.5);
		FPOL D 4 Offset (0, 0);
		FPOL E 4 Offset (0, 0);
		FPOL F 4 Offset (0, 0);
        FPOL F 4 Offset (0, -50);
        FPOL F 8 Offset (0, 100);
		Goto Ready;
    LeftSwing:
        FPOL A 2 Offset (25, 10);
        FPOL A 2 Offset (45, 30);
        FPOL A 2 Offset (55, 50) A_CheckBerserk(false);
		FPOL B 4 Offset (1, 1) A_Mirror;
		FPOL C 4 Offset (0, 0) A_FWeaponMelee(1, 90, 0, 1.5);
		FPOL D 4 Offset (0, 0);
		FPOL E 4 Offset (0, 0);
		FPOL F 4 Offset (0, 0);
        FPOL F 4 Offset (0, -50);
        FPOL F 8 Offset (0, 100) A_RestoreMirror;
		Goto Ready;
	BerserkFire:
		FPOL A 2 Offset (25, 10);
        FPOL A 2 Offset (45, 30);
        FPOL A 2 Offset (55, 50) A_CheckBerserk(false);
        FPOL H 4 Offset (1, 1);
		FPOL I 4 Offset (0, 0);
		FPOL J 4 Offset (0, 0);
		FPOL J 4 Offset (0, 0) A_FWeaponMelee(1, 90, 0, 1.5);
		FPOL J 4 Offset (0, 50);
        FPOL J 4 Offset (0, 100);
        FPOL J 4 Offset (0, 150);
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
		
		// if (isBerserk)
		// {
		// 	if (rightMove && !backMove)
		// 		return Ammo1.Amount ? FindState ("BerserkRightSwingGlow") :  FindState ("BerserkRightSwing");	
		// 	else if (leftMove && !backMove)
		// 		return Ammo1.Amount ? FindState ("BerserkLeftSwingGlow") :  FindState ("BerserkLeftSwing");	
		// 	else
		// 		return Ammo1.Amount ? FindState ("BerserkFireGlow") :  FindState ("BerserkFire");
		// }
		// else
		{
			if (rightMove)
				return FindState ("RightSwing");	
			else if (leftMove)
				return FindState ("LeftSwing");
			else if (forwardMove != 0)
				return FindState ("Thrust");
		}

		return Ammo1.Amount ? FindState ("FireGlow") :  Super.GetAtkState(hold);
	}
}