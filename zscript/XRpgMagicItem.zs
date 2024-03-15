const PAPERDOLL_SLOT_ACCESSORY = 1;

class AccessorySlotElement : ItemSlotElement
{
	override bool Clicked()
	{
		let xrpgPlayer = xrpgPlayer(player);

		if (xrpgPlayer)
		{
			if (xrpgPlayer.hud.selectedItem)
				nextSlotItem = xrpgPlayer.hud.selectedItem;
			else
				clearSlot = true;

			return true;
		}

		return super.Clicked();
	}
}

class XRpgMagicItem : TabMenuItem
{
	double speedBoost;
	property SpeedBoost: speedBoost;

	string effectMessage;
	property EffectMessage: effectMessage;

    Default
	{
		Inventory.PickupFlash "PickupFlash";
		Inventory.InterHubAmount 1;
		Inventory.MaxAmount 1;

		Inventory.PickupMessage "$TXT_MAGICITEMPICKUP";

		XRpgMagicItem.EffectMessage "$TXT_MAGICITEMPICKUP";

		TabMenuItem.Selectable true;
		TabMenuItem.Listable true;
	}

	override bool CanRenderInventory()
    {
		let xrpgPlayer = XRpgPlayer(Owner);
		if (!xrpgPlayer)
			return false;
		
		//Don't render in inventory if active or selected
		if (self == xrpgPlayer.hud.selectedItem || self == xrpgPlayer.ActiveMagicItem)
			return false;

        return super.CanRenderInventory();
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

	bool IsActive()
	{
		let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return false;
		
		return xrpgPlayer.IsMagicItemActive(self);
	}

	override bool Use (bool pickup)
	{
		let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return false;

		bool success = xrpgPlayer.SetActiveMagicItem(self);

		if (!success)
		{
			return false;
		}

		ShowMessage();
		return false;
	}
}