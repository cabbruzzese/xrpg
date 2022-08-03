class XRpgFWeapRazor : XRpgFighterWeapon replaces CentaurSword
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
		FRZR A 1 A_Raise;
		Loop;
	Deselect:
		FRZR A 1 A_Lower;
		Loop;
	Ready:
		FRZR A 1 A_WeaponReady;
		Loop;
	Fire:
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
        FSHL FGH 2 BRIGHT A_UseShield(false);
		FSHL F 2 BRIGHT A_Refire;
        FSHL G 2 BRIGHT A_ShieldFire;
    ShieldFireFinish:
		FSHL DCBA 2;
        Goto Ready;
	}
}