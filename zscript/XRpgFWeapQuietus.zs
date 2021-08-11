// Fighter Weapon Piece -----------------------------------------------------

class XRpgFighterWeaponPiece : WeaponPiece replaces FighterWeaponPiece
{
	Default
	{
		Inventory.PickupSound "misc/w_pkup";
		Inventory.PickupMessage "$TXT_QUIETUS_PIECE";
		Inventory.ForbiddenTo "XRpgClericPlayer", "XRpgMagePlayer";
		WeaponPiece.Weapon "XRpgFWeapQuietus";
		+FLOATBOB
	}
}

// Fighter Weapon Piece 1 ---------------------------------------------------

class XRpgFWeaponPiece1 : XRpgFighterWeaponPiece replaces FWeaponPiece1
{
	Default
	{
		WeaponPiece.Number 1;
	}
	States
	{
	Spawn:
		WFR1 A -1 Bright;
		Stop;
	}
}

// Fighter Weapon Piece 2 ---------------------------------------------------

class XRpgFWeaponPiece2 : XRpgFighterWeaponPiece replaces FWeaponPiece2
{
	Default
	{
		WeaponPiece.Number 2;
	}
	States
	{
	Spawn:
		WFR2 A -1 Bright;
		Stop;
	}
}

// Fighter Weapon Piece 3 ---------------------------------------------------

class XRpgFWeaponPiece3 : XRpgFighterWeaponPiece replaces FWeaponPiece3
{
	Default
	{
		WeaponPiece.Number 3;
	}
	States
	{
	Spawn:
		WFR3 A -1 Bright;
		Stop;
	}
}

// Quietus Drop -------------------------------------------------------------

class XRpgQuietusDrop : Actor replaces QuietusDrop
{
	States
	{
	Spawn:
		TNT1 A 1;
		TNT1 A 1 A_DropWeaponPieces("XRpgFWeaponPiece1", "XRpgFWeaponPiece2", "XRpgFWeaponPiece3");
		Stop;
	}
}

// The Fighter's Sword (Quietus) --------------------------------------------

class XRpgFWeapQuietus : XRpgFighterWeapon replaces FWeapQuietus
{
	Default
	{
		Health 3;
		Weapon.SelectionOrder 2900;
		+WEAPON.PRIMARY_USES_BOTH;
		+Inventory.NoAttenPickupSound
		Weapon.AmmoUse1 14;
		Weapon.AmmoUse2 14;
		Weapon.AmmoGive1 20;
		Weapon.AmmoGive2 20;
		Weapon.KickBack 150;
		Weapon.YAdjust 10;
		Weapon.AmmoType1 "Mana1";
		Weapon.AmmoType2 "Mana2";
		Inventory.PickupMessage "$TXT_WEAPON_F4";
		Inventory.PickupSound "WeaponBuild";
		Tag "$TAG_FWEAPQUIETUS";
	}

	States
	{
	Spawn:
		TNT1 A -1;
		Stop;
	Select:
		FSRD A 1 Bright A_Raise;
		Loop;
	Deselect:
		FSRD A 1 Bright A_Lower;
		Loop;
	Ready:
		FSRD AAAABBBBCCCC 1 Bright A_WeaponReady;
		Loop;
	Fire:
		FSRD DE 3 Bright Offset (5, 36);
		FSRD F 2 Bright Offset (5, 36);
		FSRD G 3 Bright Offset (5, 36) A_FSwordAttack;
		FSRD H 2 Bright Offset (5, 36);
		FSRD I 2 Bright Offset (5, 36);
		FSRD I 10 Bright Offset (5, 150);
		FSRD A 1 Bright Offset (5, 60);
		FSRD B 1 Bright Offset (5, 55);
		FSRD C 1 Bright Offset (5, 50);
		FSRD A 1 Bright Offset (5, 45);
		FSRD B 1 Bright Offset (5, 40);
		Goto Ready;
	}
	
	//============================================================================
	//
	// A_FSwordAttack
	//
	//============================================================================

	action void A_FSwordAttack()
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
		SpawnPlayerMissile ("FSwordMissile", Angle + (45./4),0, 0, -10);
		SpawnPlayerMissile ("FSwordMissile", Angle + (45./8),0, 0,  -5);
		SpawnPlayerMissile ("FSwordMissile", Angle          ,0, 0,   0);
		SpawnPlayerMissile ("FSwordMissile", Angle - (45./8),0, 0,   5);
		SpawnPlayerMissile ("FSwordMissile", Angle - (45./4),0, 0,  10);
		A_StartSound ("FighterSwordFire", CHAN_WEAPON);
	}
}