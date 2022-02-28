class XRpgSpellItem : PowerupGiver
{
    int spellType;
	int timerVal;
	int maxTimer;
	int manaCostBlue;
	int manaCostGreen;
	int magicTimerMod;
	bool isMultiSlot;
	bool isLifeCost;
	int lifeCostTimer;
	int maxLifeCostTimer;
	int lifeCostMin;
	bool useCrystals;
	int hitCount;
	bool drawInactive;
	bool canRenew;

    property SpellType : spellType;
	property TimerVal : timerVal;
	property MaxTimer : maxTimer;
	property ManaCostBlue : manaCostBlue;
	property ManaCostGreen : manaCostGreen;
	property MagicTimerMod : magicTimerMod;
	property IsMultiSlot : isMultiSlot;
	property IsLifeCost : isLifeCost;
	property MaxLifeCostTimer : maxLifeCostTimer;
	property LifeCostMin : lifeCostMin;
	property UseCrystals: useCrystals;
	property HitCount : hitCount;
	property DrawInactive : drawInactive;
	property CanRenew : canRenew;

	Default
	{
		+COUNTITEM
		+FLOATBOB
		Inventory.PickupFlash "PickupFlash";
		Inventory.InterHubAmount 1;
		Inventory.MaxAmount 1;

		Inventory.PickupMessage "$TXT_SPELLPICKUP";

		XRpgSpellItem.TimerVal 0;
		XRpgSpellItem.MaxTimer 0;
		XRpgSpellItem.ManaCostBlue 0;
		XRpgSpellItem.ManaCostGreen 0;
		XRpgSpellItem.MagicTimerMod 1;
		XRpgSpellItem.IsMultiSlot false;
		XRpgSpellItem.IsLifeCost false;
		XRpgSpellItem.MaxLifeCostTimer 0;
		XRpgSpellItem.LifeCostMin 0;
		XRpgSpellItem.UseCrystals false;
		XRpgSpellItem.HitCount 0;
		XRpgSpellItem.DrawInactive false;
		XRpgSpellItem.CanRenew false;
	}

	bool CheckMana(class<Inventory> type, int ammoUse)
    {
        if (ammoUse == 0)
            return true;

        let ammo = Inventory(Owner.FindInventory(type));
        if (!ammo || ammo.Amount < ammoUse)
            return false;
        
        return true;
    }

    bool CheckAllMana(int blueAmmoUse, int greenAmmoUse)
    {
        let blueResult = CheckMana("Mana1", blueAmmoUse);
        let greenResult = CheckMana("Mana2", greenAmmoUse);
        
        return blueResult && greenResult;
    }

    bool DepleteMana(class<Inventory> type, int ammoUse)
    {
        let ammo = Inventory(Owner.FindInventory(type));
        if (!ammo || ammo.Amount < ammoUse)
            return false;

        ammo.Amount -= ammoUse;
        return true;
    }

    bool DepleteAllMana(int blueAmmoUse, int greenAmmoUse)
    {
        let blueResult = DepleteMana("Mana1", blueAmmoUse);
        let greenResult = DepleteMana("Mana2", greenAmmoUse);

        return blueResult && greenResult;
    }
	
	virtual void CastSpell()
	{
	}

	//Get maximum timer with magic bonus.
	// Bonus can increase or decrease the timer.
	// i.e. magic decreases cooldown for cleric heal and increases timer for smite
	int GetMaxTimerVal (XRpgPlayer xrpgPlayer)
	{
		if (!xrpgPlayer)
			return 0;

		int maxTimerVal = MaxTimer;
		
		let lowMaxMod = maxTimerVal / 2;
		let highMaxMod = maxTimerVal * 2;
		maxTimerVal += xrpgPlayer.GetMagic() * MagicTimerMod;

		maxTimerVal = Max(maxTimerVal, lowMaxMod);
		maxTimerVal = Min(maxTimerVal, highMaxMod);

		return maxTimerVal;
	}
	
	override bool Use (bool pickup)
	{
		if (TimerVal > 0 && !CanRenew)
			return false;
		
		let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return false;

		int maxTimerVal = GetMaxTimerVal(xrpgPlayer);
		
		//Don't renew if timer is too high
		if (CanRenew && TimerVal > 0 && TimerVal > (maxTimerVal / 2))
			return false;

		if (!CanRenew && xrpgPlayer.IsSpellActive(SpellType, true))
			return false;
		
		//If multislot, check if slot is open
		if (IsMultiSlot)
		{
			//If both are in use
			if (!xrpgPlayer.IsSpellSlotOpen(xrpgPlayer.ActiveSpell, true) &&
				!xrpgPlayer.IsSpellSlotOpen(xrpgPlayer.ActiveSpell2, true))
			{
				//if no slots are open or if it can be replaced, but is not even active
				if (!CanRenew || !xrpgPlayer.IsSpellActive(SpellType, true))
					return false;
			}
		}

		//If mana cost required, check if enough and spend it
		if (ManaCostBlue > 0 || manaCostGreen > 0)
		{
			if (!CheckAllMana(ManaCostBlue, manaCostGreen))
				return false;

			DepleteAllMana(manaCostBlue, manaCostGreen);
		}

		//If life cost required, check if above minimum (equal to magic)
		if (IsLifeCost)
		{
			if (xrpgPlayer.Health <= LifeCostMin)
				return false;
		}
		
		TimerVal = maxTimerVal;

		lifeCostTimer = 0;

		xrpgPlayer.SetActiveSpell(self);

		CastSpell();

		return false;
	}

	void TickDownLife(XRpgPlayer xrpgPlayer)
	{
		if (MaxLifeCostTimer > 0)
		{
			if (xrpgPlayer.IsSpellActive(SpellType, true))
			{
				lifeCostTimer++;

				if (lifeCostTimer > MaxLifeCostTimer)
				{
					lifeCostTimer = 0;

					if (xrpgPlayer.Health > LifeCostMin)
					{
						xrpgPlayer.A_SetHealth(xrpgPlayer.Health - 1);
					}
					else
					{
						xrpgPlayer.RemoveActiveSpell(self);
						TimerVal = 0;
					}
				}
			}
		}
	}
	
	override void Tick()
	{
		//Count down timer
		if (TimerVal > 0)
			TimerVal --;

		//Remove spell if it is a timed spell
        let xrpgPlayer = XRpgPlayer(Owner);
        if (xrpgPlayer != null)
		{
			if (MaxTimer != 0 && TimerVal == 0)
				xrpgPlayer.RemoveActiveSpell(self);

			TickDownLife(xrpgPlayer);
		}

		// Spells cannot exist outside an inventory
		if (Owner == NULL)
		{
			Destroy ();
		}
	}
}