class XRpgFWeapMorningStar : XRpgFighterWeapon replaces EttinMace
{
	Default
	{
		+BLOODSPLATTER
		Weapon.SelectionOrder 900;
		+WEAPON.AMMO_OPTIONAL +WEAPON.MELEEWEAPON
		Weapon.KickBack 150;
		Inventory.PickupMessage "$TXT_WEAPON_MSTAR";
		Obituary "$OB_MPFWEAPMSTAR";
		Tag "$TAG_FWEAPMSTAR";
		Inventory.MaxAmount 1;

        XRpgFighterWeapon.MeleePush 10;
        XRpgFighterWeapon.MeleeAdjust true;
		XRpgFighterWeapon.WeaponRange int(1.8 * double(DEFMELEERANGE));
	}

	States
	{
	Spawn:
		ETTB MNOP 5;
		ETTB Q 5;
		ETTB R 5;
		ETTB S -1;
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
		FMCE C 3 Offset (5, 0) A_FWeaponMelee(1, 90, 0, 1.5);
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
		FMCE C 2 Offset (5, 0) A_FWeaponMelee(1, 90, 0, 1.5);
		FMCE D 2 Offset (5, 0);
		FMCE E 2 Offset (5, 0);
		FMCE E 4 Offset (5, 150);
		FMCE A 1 Offset (0, 60);
		FMCE A 1 Offset (0, 55);
		FMCE A 1 Offset (0, 50);
		FMCE A 1 Offset (0, 45);
		FMCE A 1 Offset (0, 40);
		FMCE A 1 Offset (0, 35);
		FMCE A 1;
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