class XRpgFWeapMorningStar : XRpgFighterShieldWeapon replaces EttinMace
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
	WeaponSelect:
		FMCE A 1 A_Raise;
		Loop;
	Deselect:
	WeaponDeselect:
		FMCE A 1 A_Lower;
		Loop;
	Ready:
	WeaponReady:
		FMCE A 1 A_WeaponReady;
		Loop;
	Fire:
	WeaponFire:
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
    ShieldCharged:
		Goto ShieldFrameShieldCharged;
    ShieldFireFinish:
		Goto ShieldFrameShieldFireFinish;
	FistFire:
		Goto ShieldFrameFistFire;
	}
}