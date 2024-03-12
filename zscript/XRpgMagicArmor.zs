class MagicArmor : XRpgMagicItem
{
    int armorBonus;
    property ArmorBonus: armorBonus;

    override void DoEquipBlend()
	{
		if (!Owner)
			return;
		
		Owner.A_SetBlend("11 99 99", 0.8, 40);
	}

    override void Equip()
	{
		super.Equip();

		if (!Owner)
			return;

        let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return;
        
		xrpgPlayer.ApplyDexArmorBonus();
		xrpgPlayer.ApplyMovementBonus();
	}

    override void Unequip()
    {
        let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return;
        
		xrpgPlayer.ApplyDexArmorBonus();
		xrpgPlayer.ApplyMovementBonus();
    }
}

class DragonBracers : MagicArmor
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.INVBAR +INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "ARTIBRAC";
		Inventory.PickupSound "misc/p_pkup";
		Tag "$TAG_ARTIBOOSTARMOR";

        XRpgMagicItem.EffectMessage "$TXT_DRAGONBRACERS_USE";
		MagicArmor.ArmorBonus 10;
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

class BootsOfSpeed : MagicArmor replaces ArtiSpeedBoots
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.INVBAR +INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "ARTISPED";
		Inventory.PickupSound "misc/p_pkup";
		Tag "$TAG_ARTISPEED";

        XRpgMagicItem.EffectMessage "$TXT_BOOTSOFSPEED_USE";
		XRpgMagicItem.SpeedBoost 0.3;
	}
	States
	{
	Spawn:
		SPED B 4 Bright;
		Loop;
	}

	override void DoEquipBlend()
	{
		if (!Owner)
			return;
		
		Owner.A_SetBlend("99 99 55", 0.8, 40);
	}

    override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, 20);
    }
}