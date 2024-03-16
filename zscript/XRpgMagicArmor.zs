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

class PlatinumHelmet : XRpgHelmetItem replaces PlatinumHelm
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


// Mesh Armor (1) -----------------------------------------------------------

class MeshBodyArmor : XRpgBodyItem replaces MeshArmor
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "AR_1A0";
		Inventory.PickupSound "misc/p_pkup";
		
		Tag "$TAG_MESHARMOR";
        XRpgEquipableItem.EffectMessage "$TXT_MESHARMOR_USE";
				
		XRpgEquipableItem.ArmorBonus 20;
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
	
// Falcon Shield (2) --------------------------------------------------------

class FalconLargeShield : XRpgShieldItem replaces FalconShield
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "AR_2A0";
		Inventory.PickupSound "misc/p_pkup";
		
		Tag "$TAG_FALCONSHIELD";
        XRpgEquipableItem.EffectMessage "$TXT_FALCONSHIELD_USE";
				
		XRpgEquipableItem.ArmorBonus 20;
		XRpgEquipableItem.SpeedBoost -0.1;
		XRpgArmorItem.IsHeavy true;
	}
	States
	{
	Spawn:
		AR_2 A -1;
		Stop;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, 12);
    }
}

// Amulet of Warding (4) ----------------------------------------------------
class WardingAmulet : XRpgNeckItem replaces AmuletOfWarding
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "AR_4B0";
		Inventory.PickupSound "misc/p_pkup";
		
		Tag "$TAG_WARDINGAMULET";
        XRpgEquipableItem.EffectMessage "$TXT_WARDINGAMULET_USE";
				
		XRpgEquipableItem.ArmorBonus 15;
	}
	States
	{
	Spawn:
		AR_4 B -1;
		Stop;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, -1);
    }
}

class BishopGem : XRpgNeckItem
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "AAMUA0";
		Inventory.PickupSound "misc/p_pkup";
		
		Tag "$TAG_BISHOPGEM";
        XRpgEquipableItem.EffectMessage "$TXT_ARMOR_BISHOPGEM";
				
		XRpgEquipableItem.ArmorBonus 20;
	}
	States
	{
	Spawn:
		AAMU ABCD 8;
		AAMU D -1;
		Stop;
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
				
		XRpgEquipableItem.ArmorBonus 5;
	}
	States
	{
	Spawn:
		AHLM ABCDA 4;
		AHLM A -1;
		Stop;
	}
}