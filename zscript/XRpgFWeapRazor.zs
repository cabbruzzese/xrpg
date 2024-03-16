class XRpgFWeapRazor : XRpgFighterShieldWeapon replaces CentaurSword
{
	Default
	{
		+BLOODSPLATTER
		Weapon.SelectionOrder 900;
		+WEAPON.AXEBLOOD +WEAPON.AMMO_OPTIONAL +WEAPON.MELEEWEAPON
		Weapon.KickBack 150;
		Inventory.PickupMessage "$TXT_WEAPON_RAZOR";
		Obituary "$OB_MPFWEAPRAZOR";
		Tag "$TAG_FWEAPRAZOR";
		Inventory.MaxAmount 1;

        XRpgFighterWeapon.Pufftype "AxePuff";
        XRpgFighterWeapon.WeaponRange 2.0 * DEFMELEERANGE;
        XRpgFighterWeapon.MeleePush 0;
        XRpgFighterWeapon.MeleeAdjust true;
	}

	States
	{
	Spawn:
		CTDP KLMNOPQ 3;
		CTDP R 4;
		CTDP S 4;
		CTDP T -1;
		Stop;
	Select:
	WeaponSelect:
		FRZR A 1 A_Raise;
		Loop;
	Deselect:
	WeaponDeselect:
		FRZR A 1 A_Lower;
		Loop;
	Ready:
	WeaponReady:
		FRZR A 1 A_WeaponReady;
		Loop;
	Fire:
	WeaponFire:
		FRZR B 2 Offset (5, 0);
		FRZR B 4 Offset (5, 0) A_CheckBerserk(false);
		FRZR C 1 Offset (5, 0) A_FWeaponMelee(10, 30, -25, 0.35);
		FRZR C 1 Offset (5, 0) A_FWeaponMelee(10, 30, 0, 0.35);
		FRZR C 1 Offset (5, 0) A_FWeaponMelee(10, 30, 25, 0.35);
		FRZR D 3 Offset (5, 0);
		FRZR E 2 Offset (5, 0);
		FRZR E 10 Offset (5, 150);
		FRZR A 1 Offset (0, 60);
		FRZR A 1 Offset (0, 55);
		FRZR A 1 Offset (0, 50);
		FRZR A 1 Offset (0, 45);
		FRZR A 1 Offset (0, 40);
		FRZR A 1 Offset (0, 35);
		FRZR A 1;
		Goto Ready;
	BerserkFire:
		FRZR C 1 Offset (5, 0) A_FWeaponMelee(10, 30, -25, 0.35);
		FRZR C 1 Offset (5, 0) A_FWeaponMelee(10, 30, 0, 0.35);
		FRZR C 1 Offset (5, 0) A_FWeaponMelee(10, 30, 25, 0.35);
		FRZR D 2 Offset (5, 0);
		FRZR E 2 Offset (5, 0);
		FRZR E 4 Offset (5, 150);
		FRZR A 1 Offset (0, 60);
		FRZR A 1 Offset (0, 55);
		FRZR A 1 Offset (0, 50);
		FRZR A 1 Offset (0, 45);
		FRZR A 1 Offset (0, 40);
		FRZR A 1 Offset (0, 35);
		FRZR A 1;
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