class XRpgFWeapCleaver : XRpgFighterWeapon replaces TableShit10
{
	Default
	{
		+BLOODSPLATTER
		Weapon.SelectionOrder 900;
		+WEAPON.AMMO_OPTIONAL
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
		CLEV A 1 A_Raise;
		Loop;
	Deselect:
		CLEV A 1 A_Lower;
		Loop;
	Ready:
		CLEV A 1 A_WeaponReady;
		Loop;
	Fire:
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