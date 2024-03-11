class XRpgMagicItem : PowerupGiver
{
	string effectMessage;
	property EffectMessage: effectMessage;

    Default
	{
		Inventory.PickupFlash "PickupFlash";
		Inventory.InterHubAmount 1;
		Inventory.MaxAmount 1;

		Inventory.PickupMessage "$TXT_MAGICITEMPICKUP";

		XRpgMagicItem.EffectMessage "$TXT_MAGICITEMPICKUP";
	}

	virtual void Equip()
	{
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
			Unequip();
			return false;
		}

		ShowMessage();
		Equip();

		return false;
	}
}