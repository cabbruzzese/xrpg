class XRpgFWeapCleaver : XRpgFighterShieldWeapon replaces TableShit10
{
	Default
	{
		+BLOODSPLATTER
		Weapon.SelectionOrder 900;
		+WEAPON.AXEBLOOD +WEAPON.AMMO_OPTIONAL +WEAPON.MELEEWEAPON
		Weapon.KickBack 150;
		Inventory.PickupMessage "$TXT_WEAPON_CLEAVER";
		Obituary "$OB_MPFWEAPCLEAVER";
		Tag "$TAG_FWEAPCLEAVER";
		Inventory.MaxAmount 1;

        XRpgFighterWeapon.MeleePush -1;
        XRpgFighterWeapon.MeleeAdjust true;
		XRpgFighterWeapon.WeaponRange int(1.8 * double(DEFMELEERANGE));
	}

	States
	{
	Spawn:
		TST0 A -1;
		Stop;
	Select:
	WeaponSelect:
		CLEV A 1 A_Raise;
		Loop;
	Deselect:
	WeaponDeselect:
		CLEV A 1 A_Lower;
		Loop;
	Ready:
	WeaponReady:
		CLEV A 1 A_WeaponReady;
		Loop;
	Fire:
	WeaponFire:
		CLEV B 4 Offset (5, 0);
		CLEV B 2 Offset (5, 0) A_CheckBerserk(false);
		CLEV C 2 Offset (5, 0) A_FWeaponMelee(15, 45, 0, 1);
		CLEV D 2 Offset (5, 0);
		CLEV E 2 Offset (5, 0);
		CLEV E 2 Offset (5, 150);
		CLEV A 1 Offset (0, 60);
		CLEV A 1 Offset (0, 50);
		CLEV A 1 Offset (0, 40);
		CLEV A 1;
		Goto Ready;
	BerserkFire:
		CLEV C 2 Offset (5, 0) A_FWeaponMelee(15, 45, 0, 1);
		CLEV D 2 Offset (5, 0);
		CLEV E 1 Offset (5, 0);
		CLEV E 1 Offset (5, 150);
		CLEV A 1 Offset (0, 60);
		CLEV A 1 Offset (0, 40);
		CLEV A 1;
		Goto Ready;
	AltFire:
		Goto ShieldFrameAltFire;
	ShieldSpikedFire:
		Goto ShieldFrameShieldSpikedFire;
    AltHold:
		Goto ShieldFrameAltHold;
	ShieldSpikedHold:
		Goto ShieldFrameShieldSpikedHold;
	ShieldKiteFire:
		Goto ShieldFrameShieldKiteFire;
	ShieldKiteHold:
		Goto ShieldFrameShieldKiteHold;
	ShieldRoundFire:
		Goto ShieldFrameShieldRoundFire;
	ShieldRoundHold:
		Goto ShieldFrameShieldRoundHold;
	ShieldMetalFire:
		Goto ShieldFrameShieldMetalFire;
	ShieldMetalHold:
		Goto ShieldFrameShieldMetalHold;
    ShieldCharged:
		Goto ShieldFrameShieldCharged;
    ShieldFireFinish:
		Goto ShieldFrameShieldFireFinish;
	FistFire:
		Goto ShieldFrameFistFire;
	}
}