class MagicArmor : XRpgMagicItem
{
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

//-----------------------------------
// Magic Items
//-----------------------------------

class DragonBracers : MagicArmor
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "ARTIBRAC";
		Inventory.PickupSound "misc/p_pkup";
		Tag "$TAG_DRAGONBRACERS";

        XRpgEquipableItem.EffectMessage "$TXT_DRAGONBRACERS_USE";
		XRpgEquipableItem.ArmorBonus 10;
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
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "ARTISPED";
		Inventory.PickupSound "misc/p_pkup";
		Tag "$TAG_BOOTSOFSPEED";

        XRpgEquipableItem.EffectMessage "$TXT_BOOTSOFSPEED_USE";
		XRpgEquipableItem.SpeedBoost 0.3;
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

//-----------------------------------------
// Body Armor
//-----------------------------------------

class EttinArmor : XRpgBodyItem
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "ABDYH0";
		Inventory.PickupSound "misc/p_pkup";
		
		Tag "$TAG_ETTINARMOR";
        XRpgEquipableItem.EffectMessage "$TXT_ARMOR_ETTINARMOR";
				
		XRpgEquipableItem.ArmorBonus 10;
		XRpgEquipableItem.SpeedBoost -0.1;
		XRpgArmorItem.IsHeavy true;
	}
	States
	{
	Spawn:
		ABDY ABCDEFG 4;
		ABDY G -1;
		Stop;
	}
}

class MeshBodyArmor : XRpgBodyItem
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "AR_1A0";
		Inventory.PickupSound "misc/p_pkup";
		
		Tag "$TAG_MESHARMOR";
        XRpgEquipableItem.EffectMessage "$TXT_MESHARMOR_USE";
				
		XRpgEquipableItem.ArmorBonus 10;
		XRpgArmorItem.IsHeavy true;
	}
	States
	{
	Spawn:
		AR_1 A -1;
		Stop;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, 16);
    }
}

class LeatherBodyArmor : XRpgBodyItem
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "LTHRA0";
		Inventory.PickupSound "misc/p_pkup";
		
		Tag "$TAG_LEATHERARMOR";
        XRpgEquipableItem.EffectMessage "$TXT_LEATHERARMOR_USE";
				
		XRpgEquipableItem.ArmorBonus 5;
	}
	States
	{
	Spawn:
		LTHR A -1;
		Stop;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, -14);
    }
}

//--------------------------------------------------
// Helmets
//--------------------------------------------------
class PlatinumHelmet : XRpgHelmetItem
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "AR_3A0";
		Inventory.PickupSound "misc/p_pkup";
		
		Tag "$TAG_PLATINUMHELM";
        XRpgEquipableItem.EffectMessage "$TXT_PLATINUMHELM_USE";
				
		XRpgEquipableItem.ArmorBonus 5;
		XRpgArmorItem.IsHeavy true;
	}
	States
	{
	Spawn:
		AR_3 A -1;
		Loop;
	}

    override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, 32);
    }
}

class SuitHelmet : XRpgHelmetItem
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "SUITL0";
		Inventory.PickupSound "misc/p_pkup";
		
		Tag "$TAG_SUITHELMET";
        XRpgEquipableItem.EffectMessage "$TXT_ARMOR_SUITHELMET";
				
		XRpgEquipableItem.ArmorBonus 15;
		XRpgEquipableItem.SpeedBoost -0.1;
		XRpgArmorItem.IsHeavy true;

		XRpgHelmetItem.VisorImage "VSRHLM1";
	}
	States
	{
	Spawn:
		ZSUI F 4;
		ZSUI F -1;
		Stop;
	}
}

class WraithHelmet : XRpgHelmetItem
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "AHLMA0";
		Inventory.PickupSound "misc/p_pkup";
		
		Tag "$TAG_WRAITHHELM";
        XRpgEquipableItem.EffectMessage "$TXT_ARMOR_WRAITHHELM";
				
		XRpgEquipableItem.ArmorBonus 10;
	}
	States
	{
	Spawn:
		AHLM ABCDA 4;
		AHLM A -1;
		Stop;
	}
}

class MetalCap : XRpgHelmetItem
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "CAPHA0";
		Inventory.PickupSound "misc/p_pkup";
		
		Tag "$TAG_METALCAP";
        XRpgEquipableItem.EffectMessage "$TXT_METALCAP_USE";
				
		XRpgEquipableItem.ArmorBonus 5;
	}
	States
	{
	Spawn:
		CAPH A -1;
		Stop;
	}
}