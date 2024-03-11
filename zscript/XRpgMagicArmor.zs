class MagicArmor : XRpgMagicItem
{
    int armorBonus;
    property ArmorBonus: armorBonus;

    Default {
        MagicArmor.ArmorBonus 5;
    }

    override void Equip()
	{
		if (!Owner)
			return;
		
		Owner.A_SetBlend("11 99 99", 0.8, 40);

        let xrpgPlayer = XRpgPlayer(Owner);
        if (xrpgPlayer)
            xrpgPlayer.ApplyDexArmorBonus();
	}

    override void Unequip()
    {
        let xrpgPlayer = XRpgPlayer(Owner);
        if (xrpgPlayer)
            xrpgPlayer.ApplyDexArmorBonus();
    }
}


class DragonBracers : MagicArmor replaces ArtiBoostArmor
{
	Default
	{
		Inventory.DefMaxAmount;
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.INVBAR +INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "ARTIBRAC";
		Inventory.PickupSound "misc/p_pkup";
		Inventory.PickupMessage "$TXT_ARTIBOOSTARMOR";
		Tag "$TAG_ARTIBOOSTARMOR";

        XRpgMagicItem.EffectMessage "$TXT_DRAGONBRACERS_USE";
	}
	States
	{
	Spawn:
		BRAC D 4 Bright;
		Loop;
	}

    override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, 32);
    }
}
