const PAPERDOLL_SLOT_HELMET = 0;
const PAPERDOLL_SLOT_BODY = 1;
const PAPERDOLL_SLOT_SHIELD = 2;
const PAPERDOLL_SLOT_NECK = 3;
const PAPERDOLL_SLOT_ACCESSORY = 4;
const PAPERDOLL_SLOTS = 5;


class EquipmentSlotElement : ItemSlotElement
{
	Name equipmentType;

	static EquipmentSlotElement Create(string imageStr, string textVal, vector2 size, bool selectableVal, bool stopPropagationVal, Vector2 newPos, PlayerPawn playerObj, Name equipmentType)
	{
		let newObject = new ('EquipmentSlotElement');
		
		newObject.equipmentType = equipmentType;

		newObject.init(imageStr, size, selectableVal, stopPropagationVal, newPos, playerObj, textVal);

		return newObject;
	}

	override bool Clicked()
	{
		let xrpgPlayer = xrpgPlayer(player);

		if (xrpgPlayer)
		{
			if (xrpgPlayer.hud.selectedItem && xrpgPlayer.hud.selectedItem is equipmentType)
				nextSlotItem = xrpgPlayer.hud.selectedItem;
			else
				clearSlot = true;

			return true;
		}

		return super.Clicked();
	}
}

class TrashItemElement : ItemSlotElement
{
	XRpgEquipableItem trashItem;

	static TrashItemElement Create(string imageStr, string textVal, vector2 size, bool selectableVal, bool stopPropagationVal, Vector2 newPos, PlayerPawn playerObj)
	{
		let newObject = new ('TrashItemElement');
		
		newObject.init(imageStr, size, selectableVal, stopPropagationVal, newPos, playerObj, textVal);

		return newObject;
	}

	override bool Clicked()
	{
		let xrpgPlayer = xrpgPlayer(player);

		if (xrpgPlayer)
		{
			if (xrpgPlayer.hud.selectedItem)
			{
				let trash = XRpgEquipableItem(xrpgPlayer.hud.selectedItem);
				if (trash)
					trashItem = trash;
			}

			return true;
		}

		return super.Clicked();
	}
}

const ITEM_DEFAULT_COOLDOWN_MAX = 20;
class XRpgEquipableItem : TabMenuItem
{
	int cooldownTimer;
	int maxCooldown;
	property MaxCooldown: maxCooldown;

	double speedBoost;
	property SpeedBoost: speedBoost;

	string effectMessage;
	property EffectMessage: effectMessage;

	int paperDollSlot;
	property PaperDollSlot: paperDollSlot;

	int armorBonus;
    property ArmorBonus: armorBonus;

    Default
	{
		Inventory.PickupFlash "PickupFlash";
		Inventory.InterHubAmount 1;
		Inventory.MaxAmount 1;

		TabMenuItem.Selectable true;
		TabMenuItem.Listable true;

		XRpgEquipableItem.MaxCooldown ITEM_DEFAULT_COOLDOWN_MAX;
	}

	override bool CanRenderInventory()
    {
		let xrpgPlayer = XRpgPlayer(Owner);
		if (!xrpgPlayer)
			return false;
		
		//Don't render in inventory if active or selected
		if (self == xrpgPlayer.hud.selectedItem || self == xrpgPlayer.ActiveMagicItems[paperDollSlot])
			return false;

        return super.CanRenderInventory();
    }

	override bool CanRenderInventoryPlay()
    {
        let xrpgPlayer = XRpgPlayer(Owner);
		if (!xrpgPlayer)
			return false;
		
		//Don't render in inventory if active or selected
		if (self == xrpgPlayer.hud.selectedItem || self == xrpgPlayer.ActiveMagicItems[paperDollSlot])
			return false;

        return super.CanRenderInventoryPlay();
    }

	virtual void DoEquipBlend()
	{
	}

	virtual void Equip()
	{
		DoEquipBlend();
	}

	virtual void Unequip()
	{
	}

	void ShowMessage()
	{
		if (!Owner)
			return;
		
		Owner.A_Print(EffectMessage);
	}

	virtual bool IsItemActive(XRpgPlayer playerObj)
	{
		if (!playerObj)
			return false;
		
		if (playerObj.ActiveMagicItems[paperDollSlot] == self)
			return true;

		return false;
	}

	virtual bool IsActive()
	{
		let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return false;
		
		return IsItemActive(xrpgPlayer);
	}

	virtual bool UseItem(XRpgPlayer playerObj)
	{
		return false;
	}

	override bool Use (bool pickup)
	{
		let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return false;

		bool success = UseItem(xrpgPlayer);

		if (!success)
		{
			return false;
		}

		ShowMessage();
		return false;
	}
	
    override void Tick()
    {
        super.Tick();

        cooldownTimer--;
        if (cooldownTimer < 0)
            cooldownTimer = 0;
    }

	void StartCooldown()
	{
		cooldownTimer = MaxCooldown;
	}

	bool IsCooldownDone()
	{
		return (cooldownTimer == 0);
	}
}

class XRpgAccessorySlotItem : XRpgEquipableItem
{
	override bool IsItemActive(XRpgPlayer playerObj)
	{
		return playerObj.IsMagicItemActive(self, PaperDollSlot);
	}

	override bool UseItem(XRpgPlayer playerObj)
	{
		return playerObj.SetActiveMagicItems(self, PaperDollSlot);
	}
}

class XRpgMagicItem : XRpgAccessorySlotItem
{
	bool modifyDamageBypass0;
	property ModifyDamageBypass0: modifyDamageBypass0;

	Default
	{
		Inventory.PickupMessage "$TXT_MAGICITEMPICKUP";

		XRpgEquipableItem.EffectMessage "$TXT_MAGICITEMPICKUP";

		XRpgEquipableItem.PaperDollSlot PAPERDOLL_SLOT_ACCESSORY;
	}
}

class XRpgArmorItem : XRpgAccessorySlotItem
{
	bool isHeavy;
	property IsHeavy: isHeavy;

	bool isPlate;
	property IsPlate: isPlate;

	bool isLight;
	property IsLight: isLight;

	int mageArmorOverride;
	property MageArmorOverride: mageArmorOverride;
	
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.PickupSound "misc/p_pkup";

		Inventory.PickupMessage "$TXT_ARMORITEMPICKUP";

		XRpgEquipableItem.EffectMessage "$TXT_ARMORITEMPICKUP";
	}

	override void Equip()
	{
		if (!Owner)
			return;

        let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return;

		if (!xrpgPlayer.CanUseArmor(PaperDollSlot, self))
			return;

		super.Equip();

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

	override bool Use(bool pickup)
	{
		if (!Owner)
			return false;

        let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return false;

		if (!xrpgPlayer.CanUseArmor(PaperDollSlot, self))
			return false;
		
		return super.Use(pickup);
	}
}

class XRpgHelmetItem : XRpgArmorItem
{
	string visorImage;
	property VisorImage: visorImage;
	
	Default
	{
		XRpgEquipableItem.PaperDollSlot PAPERDOLL_SLOT_HELMET;
	}
}

class XRpgBodyItem : XRpgArmorItem
{
	Default
	{
		XRpgEquipableItem.PaperDollSlot PAPERDOLL_SLOT_BODY;
	}	
}

class XRpgShieldItem : XRpgArmorItem
{
	Default
	{
		XRpgEquipableItem.PaperDollSlot PAPERDOLL_SLOT_SHIELD;
	}	
}

class XRpgNeckItem : XRpgArmorItem
{
	Default
	{
		XRpgEquipableItem.PaperDollSlot PAPERDOLL_SLOT_NECK;
	}	
}