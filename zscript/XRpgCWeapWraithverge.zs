// Cleric Weapon Piece ------------------------------------------------------

class XRpgClericWeaponPiece : WeaponPiece replaces ClericWeaponPiece
{
	Default
	{
		Inventory.PickupSound "misc/w_pkup";
		Inventory.PickupMessage "$TXT_WRAITHVERGE_PIECE";
		Inventory.ForbiddenTo "FighterPlayer", "MagePlayer";
		WeaponPiece.Weapon "XRpgCWeapWraithverge";
		+FLOATBOB
	}
}

// Cleric Weapon Piece 1 ----------------------------------------------------

class XRpgCWeaponPiece1 : XRpgClericWeaponPiece replaces CWeaponPiece1
{
	Default
	{
		WeaponPiece.Number 1;
	}
	States
	{
	Spawn:
		WCH1 A -1;
		Stop;
	}
}

// Cleric Weapon Piece 2 ----------------------------------------------------

class XRpgCWeaponPiece2 : XRpgClericWeaponPiece replaces CWeaponPiece2
{
	Default
	{
		WeaponPiece.Number 2;
	}
	States
	{
	Spawn:
		WCH2 A -1;
		Stop;
	}
}

// Cleric Weapon Piece 3 ----------------------------------------------------

class XRpgCWeaponPiece3 : XRpgClericWeaponPiece replaces CWeaponPiece3
{
	Default
	{
		WeaponPiece.Number 3;
	}
	States
	{
	Spawn:
		WCH3 A -1;
		Stop;
	}
}

// Wraithverge Drop ---------------------------------------------------------

class XRpgWraithvergeDrop : Actor replaces WraithvergeDrop
{
	States
	{
	Spawn:
		TNT1 A 1;
		TNT1 A 1 A_DropWeaponPieces("CWeaponPiece1", "CWeaponPiece2", "CWeaponPiece3");
		Stop;
	}
}

// Cleric's Wraithverge (Holy Symbol?) --------------------------------------

class XRpgCWeapWraithverge : XRpgClericWeapon replaces CWeapWraithverge
{
	int CHolyCount;
	
	Default
	{
		Health 3;
		Weapon.SelectionOrder 3000;
		+WEAPON.PRIMARY_USES_BOTH;
		+Inventory.NoAttenPickupSound
		Weapon.AmmoUse1 18;
		Weapon.AmmoUse2 18;
		Weapon.AmmoGive1 20;
		Weapon.AmmoGive2 20;
		Weapon.KickBack 150;
		Weapon.AmmoType1 "Mana1";
		Weapon.AmmoType2 "Mana2";
		Inventory.PickupMessage "$TXT_WEAPON_C4";
		Tag "$TAG_CWEAPWRAITHVERGE";
		Inventory.PickupSound "WeaponBuild";
	}


	States
	{
	Spawn:
		TNT1 A -1;
		Stop;
	Ready:
		CHLY A 1 A_WeaponReady;
		Loop;
	Select:
		CHLY A 1 A_Raise;
		Loop;
	Deselect:
		CHLY A 1 A_Lower;
		Loop;
	Fire:
		CHLY AB 1 Bright Offset (0, 40);
		CHLY CD 2 Bright Offset (0, 43);
		CHLY E 2 Bright Offset (0, 45);
		CHLY F 6 Bright Offset (0, 48) A_CHolyAttack;
		CHLY GG 2 Bright Offset (0, 40) A_CHolyPalette;
		CHLY G 2 Offset (0, 36) A_CHolyPalette;
		Goto Ready;
	}

	override color GetBlend ()
	{
		if (paletteflash & PF_HEXENWEAPONS)
		{
			if (CHolyCount == 3)
				return Color(128, 70, 70, 70);
			else if (CHolyCount == 2)
				return Color(128, 100, 100, 100);
			else if (CHolyCount == 1)
				return Color(128, 130, 130, 130);
			else
				return Color(0, 0, 0, 0);
		}
		else
		{
			return Color(CHolyCount * 128 / 3, 131, 131, 131);
		}
	}

	//============================================================================
	//
	// A_CHolyAttack
	//
	//============================================================================

	action void A_CHolyAttack()
	{
		FTranslatedLineTarget t;

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
		Actor missile = SpawnPlayerMissile ("HolyMissile", angle, pLineTarget:t);
		if (missile != null && !t.unlinked)
		{
			missile.tracer = t.linetarget;
		}

		invoker.CHolyCount = 3;
		A_StartSound ("HolySymbolFire", CHAN_WEAPON);
	}

	//============================================================================
	//
	// A_CHolyPalette
	//
	//============================================================================

	action void A_CHolyPalette()
	{
		if (invoker.CHolyCount > 0) invoker.CHolyCount--;
	}
}