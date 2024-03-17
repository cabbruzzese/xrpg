const MAXXPHIT = 125;
const XPMULTI = 1000;
const STATNUM = 3;
const MAX_LEVEL_ARMOR = 40;//Max armor is 8AC. Highest fighter armor suit is 11. Can't let player get to 20.
const MAX_TOTAL_ARMOR = 95;
const MAX_ARMOR_SPEED_PENALTY = -0.9;
const REGENERATE_TICKS_MAX_DEFAULT = 128;
const REGENERATE_MIN_VALUE = 15;

class XRpgPlayer : PlayerPawn
{
	PlayerHudController hud;
	EquipmentSlotElement accessorySlots[PAPERDOLL_SLOTS];
	XRpgEquipableItem activeMagicItems[PAPERDOLL_SLOTS];
	TrashItemElement trashSlot;

	int initStrength;
	int initDexterity;
	int initMagic;
	XRpgSpellItem activeSpell;
	XRpgSpellItem activeSpell2;
	int regenerateTicks;
	int regenerateTicksMax;

	property InitStrength : initStrength;
	property InitDexterity : initDexterity;
	property InitMagic : initMagic;
	property ActiveSpell : activeSpell;
	property ActiveSpell2 : activeSpell2;
	property RegenerateTicks : regenerateTicks;
	property RegenerateTicksMax : regenerateTicksMax;

	string cursorIcon;
	property CursorIcon:cursorIcon;

	string paperdollIcon;
	property PaperdollIcon:paperdollIcon;

	bool isArmorSlowed;

	Default
	{
		XRpgPlayer.RegenerateTicks 0;
		XRpgPlayer.RegenerateTicksMax REGENERATE_TICKS_MAX_DEFAULT;

		XRpgPlayer.CursorIcon "M_SLDLT";
		XRpgPlayer.PaperdollIcon "M_FWALK2";
	}

	double GetScaledMod(int stat)
	{
		//First 10 scales to 1 by 10% increments
		if (stat <= 10)
			return stat * 0.1;
		
		//Remaining scales at 3.4% increments. 40 = double damage
		return 1 + ((stat - 10) * 0.034);
	}
	
	int GetModDamage(int damage, int stat, int scaled)
	{
		double mod = stat / 10.0;
		if (scaled)
			mod = GetScaledMod(stat);

		let modDamage = damage * mod;
		if (modDamage < 1)
			return 1;

		return modDamage;
	}
	
	int GetDamageForMagic(int damage)
	{
		let statItem = GetStats();
		return GetModDamage(damage, statItem.Magic, 1);
	}

	Class<Inventory> ClassTypeBag(Class<Inventory> className)
	{
		Class<Inventory> result = classname;
		return result;
	}

	void Heal(int amount)
	{
		//don't heal if dead
		if (Health <= 0)
			return;
		
		//Only heal if health is below max
		if (Health < MaxHealth)
		{
			int newHealth = Min(Health + amount, MaxHealth);
			A_SetHealth(newHealth);
		}
	}

	void GiveSpell(class<Inventory> itemtype)
	{
		let spell = GiveInventoryType(itemtype);

		if (spell)
			A_Print(spell.PickupMessage());
	}

	bool IsSpellSlotOpen(XRpgSpellItem spellItem, bool checkTimer)
	{
		if (!spellItem)
			return true;
		
		if (checkTimer && spellItem.TimerVal < 1)
			return true;
		
		return false;
	}

	bool IsSpellSlotActive(XRpgSpellItem spellItem, int spellTypeNum, bool checkTimer)
	{
		if (!spellItem)
			return false;

		if (spellItem.SpellType != spellTypeNum)
			return false;
		
		if (checkTimer && spellItem.TimerVal < 1)
			return false;
		
		return true;
	}

	bool IsSpellActive(int spellTypeNum, bool checkTimer = false)
	{
		return IsSpellSlotActive(ActiveSpell, spellTypeNum, checkTimer) ||
			IsSpellSlotActive(ActiveSpell2, spellTypeNum, checkTimer);
	}

	virtual bool SetActiveSpell(XRpgSpellItem spellItem)
	{
		if (!spellItem)
			return false;

		//If CanRenew, keep spell active if it is already active
		if (spellItem.CanRenew && IsSpellActive(spellItem.SpellType, true))
			return true;

		//Just replace for basic spells
		if (!spellItem.IsMultiSlot)
		{
			ActiveSpell = spellItem;
			return true;
		}

		//Find open slot
		if (IsSpellSlotOpen(ActiveSpell, true))
		{
			ActiveSpell = spellItem;
			return true;
		}
		else if (IsSpellSlotOpen(ActiveSpell2, true))
		{
			ActiveSpell2 = spellItem;
			return true;
		}

		return false;
	}

	bool RemoveActiveSpell(XRpgSpellItem spellItem)
	{
		bool removed = false;

		if (ActiveSpell == spellItem)
		{
			ActiveSpell = null;
			removed = true;
		}
		else if(ActiveSpell2 == spellItem)
		{
			ActiveSpell2 = null;
			removed = true;
		}

		return removed;
	}

	bool IsMagicItemSlotOpen(XRpgEquipableItem magicItem, int slot)
	{
		if (!magicItem)
			return true;
		
		return false;
	}

	bool SetActiveMagicItems(XRpgEquipableItem magicItem, int slot)
	{
		if (!magicItem)
			return false;

		let previousItem = ActiveMagicItems[slot];

		//clear if same item is used twice
		if (ActiveMagicItems[slot] == magicItem)
		{
			ActiveMagicItems[slot] = null;

			//Unequip old item
			previousItem.Unequip();
			return false;
		}

		//Just replace
		ActiveMagicItems[slot] = magicItem;

		//Unequip old and equip new
		if (previousItem)
			previousItem.Unequip();
			
		magicItem.Equip();

		return true;
	}

	bool IsMagicItemActive(XRpgEquipableItem magicItem, int slot)
	{
		if (!magicItem)
			return false;

		return ActiveMagicItems[slot] == magicItem;
	}

	virtual bool CanUseArmor(int slot, XRpgArmorItem armorItem)
	{
		return true;
	}

	virtual int MaxArmorValue(int slot)
	{
		switch (slot)
		{
			case PAPERDOLL_SLOT_HELMET:
				return 20;
			case PAPERDOLL_SLOT_BODY:
				return 20;
			case PAPERDOLL_SLOT_SHIELD:
				return 20;
			case PAPERDOLL_SLOT_NECK:
				return 20;
		}

		return 0;
	}

	void ApplyMovementBonus()
	{
		double speedMod = 0;


		for (int i = 0; i < PAPERDOLL_SLOTS; i++)
		{
			let magicItem = MagicArmor(ActiveMagicItems[i]);
			let armorEquipped = XRpgArmorItem(ActiveMagicItems[i]);
			if (magicItem && magicItem.speedBoost != 0)
				speedMod = magicItem.speedBoost;
			else if (armorEquipped && armorEquipped.speedBoost != 0)
				speedMod = armorEquipped.speedBoost;
		}

		//Speed can never be reduced more than 90%
		if (speedMod < MAX_ARMOR_SPEED_PENALTY)
			speedMod = MAX_ARMOR_SPEED_PENALTY;

		//Overdoing armor leads to max armor penalty
		if (isArmorSlowed)
			speedMod = MAX_ARMOR_SPEED_PENALTY;

		A_SetSpeed(1 + speedMod);
	}

	void ApplyDexArmorBonusStats(PlayerLevelItem statItem)
	{
		if (!statItem)
			return;

		//Gain 1 AC (5%) per 10 Dex
		int armorMod = statItem.Dexterity / 2;
		armorMod = Max(armorMod, 0);
		armorMod = Min(armorMod, MAX_LEVEL_ARMOR);

		for (int i = 0; i < PAPERDOLL_SLOTS; i++)
		{
			let armorMagicItem = MagicArmor(ActiveMagicItems[i]);
			let armorEquipped = XRpgArmorItem(ActiveMagicItems[i]);
			if (armorMagicItem)
			{
				armorMod += armorMagicItem.ArmorBonus;
			}
			else if (armorEquipped)
			{
				int armorEquippedMod = Min(armorEquipped.ArmorBonus, MaxArmorValue(i));
				//console.printf(string.format("ArmorMod: %d ArmorMax: %d", armorEquipped.ArmorBonus, MaxArmorValue(i)));

				armorMod += armorEquippedMod;
			}
		}

		let hArmor = HexenArmor(FindInventory("HexenArmor"));
		if (hArmor)
		{
			//Aboslute max is 19AC. 20 is invulnerability.
			isArmorSlowed = false;
			if (armorMod >= MAX_TOTAL_ARMOR)
			{
				armorMod = MAX_TOTAL_ARMOR;

				//Over encumber for too much armor
				isArmorSlowed = true;
			}
			hArmor.Slots[4] = armorMod;
		}
	}

	void ApplyDexArmorBonus()
	{
		let statItem = GetStats();
		
		ApplyDexArmorBonusStats(statItem);
	}
	
	void UpdateLevelStats(PlayerLevelItem statItem)
	{
		ApplyDexArmorBonusStats(statItem);
	}

	int CalcXPNeeded(PlayerLevelItem statItem)
	{
		return statItem.ExpLevel * XPMULTI;
	}
	
	void GiveXP (PlayerLevelItem statItem, int expEarned)
	{
		statItem.Exp += expEarned;
		
		while (statItem.Exp >= statItem.ExpNext)
		{
			GainLevel(statItem);
		}
	}
	
	virtual void BasicStatIncrease(PlayerLevelItem statItem)
	{
	}

	virtual void GiveLevelSkill(PlayerLevelItem statItem)
	{
	}
	
	void DoBlend(Color color, float alpha, int tics)
	{
		A_SetBlend(color, alpha, tics);
	}

	void DoLevelGainBlend(PlayerLevelItem statItem)
	{
		DoBlend("77 77 77", 0.8, 40);
		
		string lvlMsg = String.Format("You are now level %d", statItem.ExpLevel);
		A_Print(lvlMsg);
	}
	
	void GainLevelHealth(PlayerLevelItem statItem)
	{
		//health increases by random up to half Strength, min 5 (weighted for low end of flat scale)
		int halfStrength = statItem.Strength / 2;
		int healthBonus = random[LvlHealth](1, halfStrength);
		healthBonus = Max(healthBonus, 5);

		int newHealth = MaxHealth + healthBonus;
		MaxHealth = newHealth;
		statItem.MaxHealth = newHealth;
		if (Health < MaxHealth)
			A_SetHealth(MaxHealth);
	}

	virtual int GetRandomManaBonus(PlayerLevelItem statItem)
	{
		//mana increases by random up to half Magic, min 5 (weighted for low end of flat scale)
		int halfMagic = statItem.Magic / 2;
		int manaBonus = random[LvlMana](1, halfMagic);
		manaBonus = Max(manaBonus, 5);
		
		return manaBonus;
	}

	void GainLevelManaByType(PlayerLevelItem statItem, class<Inventory> type)
	{
		int bonus = GetRandomManaBonus(statItem);

		let ammo = Inventory(FindInventory(type));
		if (ammo == null)
			ammo = GiveInventoryType(type);

		ammo.MaxAmount = ammo.MaxAmount + bonus;

		int halfMax = ammo.MaxAmount / 2;
		if (ammo.Amount < halfMax)
			ammo.Amount = halfMax;
		else
			ammo.Amount = ammo.Amount + bonus;

		if (ammo.Amount > ammo.MaxAmount)
			ammo.Amount = ammo.MaxAmount;
	}

	void GainLevelMana(PlayerLevelItem statItem)
	{
		GainLevelManaByType(statItem, "Mana1");
		GainLevelManaByType(statItem, "Mana2");
	}

	//Gain a level
	void GainLevel(PlayerLevelItem statItem, bool isNoBlend = false)
	{
		if (statItem.Exp < statItem.ExpNext)
			return;

		statItem.ExpLevel++;
		statItem.Exp = statItem.Exp - statItem.ExpNext;
		statItem.ExpNext = CalcXpNeeded(statItem);
		
		//Distribute points randomly, giving weight to highest stats
		int statPoints = STATNUM;
		while (statPoints > 0)
		{
			int statStack = statItem.Strength + statItem.Dexterity + statItem.Magic;
			
			double rand = random[LvlStatStack](1, statStack);
			if (rand <= statItem.Strength)
			{
				statItem.Strength += 1;
			}
			else if (rand <= statItem.Strength + statItem.Dexterity)
			{
				statItem.Dexterity += 1;
			}
			else
			{
				statItem.Magic += 1;
			}
			statPoints--;
		}

		if (!isNoBlend)
			DoLevelGainBlend(statItem);
		
		//BasicStatIncrease to call overrides in classes
		BasicStatIncrease(statItem);
		//Give class specific items or skills
		GiveLevelSkill(statItem);

		GainLevelHealth(statItem);
		GainLevelMana(statItem);
			
		UpdateLevelStats(statItem);
	}

	void GrantXP(int xp)
	{
        if (xp <= 0)
            return;

		let statItem = GetStats();
        GiveXP(statItem, xp);
	}

    void DoXPHit(Actor xpSource, int damage, name damagetype)
	{
        if (damage <= 0)
            return;
        
        if (!xpSource)
            return;

        if (!xpSource.bISMONSTER)
            return;

        int xp = Min(damage, MAXXPHIT);

		let statItem = GetStats();
        GiveXP(statItem, xp);

		//console.printf(String.Format("XP Given: %d", xp));
	}

	const MANA_MAX_MOD = 10; 
	void GiveStartingManaByType(PlayerLevelItem statItem, class<Inventory> type)
	{
		let ammo = Inventory(FindInventory(type));
		if (ammo == null)
			ammo = GiveInventoryType(type);

		let maxMana = statItem.Magic * MANA_MAX_MOD;
		ammo.MaxAmount = maxMana;
		ammo.Amount = maxMana;
	}
	void GiveStartingMana(PlayerLevelItem statItem)
	{
		GiveStartingManaByType(statItem, "Mana1");
		GiveStartingManaByType(statItem, "Mana2");
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

		hud = new('PlayerHudController');
		hud.CursorIcon = CursorIcon;

		int armorXOffset = 15;
		int armorYOffset = 30;
		accessorySlots[PAPERDOLL_SLOT_HELMET] = EquipmentSlotElement.Create("ARTIBOX", (30,30), false, true, (212 + armorXOffset, 164 + armorYOffset), self, 'XRpgHelmetItem');
		accessorySlots[PAPERDOLL_SLOT_BODY] = EquipmentSlotElement.Create("ARTIBOX", (30,30), false, true, (150 + armorXOffset, 164 + armorYOffset), self, 'XRpgBodyItem');
		accessorySlots[PAPERDOLL_SLOT_SHIELD] = EquipmentSlotElement.Create("ARTIBOX", (30,30), false, true, (181 + armorXOffset, 164 + armorYOffset), self, 'XRpgShieldItem');
		accessorySlots[PAPERDOLL_SLOT_NECK] = EquipmentSlotElement.Create("ARTIBOX", (30,30), false, true, (243 + armorXOffset, 164 + armorYOffset), self, 'XRpgNeckItem');
		accessorySlots[PAPERDOLL_SLOT_ACCESSORY] = EquipmentSlotElement.Create("ACCSLOT", (30,30), false, true, (290, 95), self, 'XRpgMagicItem');
		trashSlot = TrashItemElement.Create("TRSHA0", (30,30), false, true, (-20, 130), self);

		let statItem = GetStats();
		GiveLevelSkill(statItem);
		GiveStartingMana(statItem);

		MaxHealth = statItem.MaxHealth;

		let expItem = Inventory(FindInventory("ExpSquishItemGiver"));
		if (expItem == null)
			expItem = GiveInventoryType("ExpSquishItemGiver");

		//Set minimum spawn level in multiplayer
		if (multiplayer || DEBUG_MODE)
		{
			CVar minLevelSetting = CVar.FindCVar('xrpg_minlevel');

        	if(minLevelSetting)
        	{
				while (statItem.ExpLevel < minLevelSetting.GetInt())
				{
					statItem.Exp = statItem.ExpNext;
					GainLevel(statItem, true);

					statItem.Exp = 0;
				}
			}
		}
	}

	PlayerLevelItem GetStats()
	{
		let lvlItem = PlayerLevelItem(FindInventory("PlayerLevelItem"));
		if (lvlItem == null)
		{
			lvlItem = PlayerLevelItem(GiveInventoryType("PlayerLevelItem"));
			lvlItem.Strength = InitStrength;
			lvlItem.Dexterity = InitDexterity;
			lvlItem.Magic = InitMagic;
			lvlItem.MaxHealth = MaxHealth;
		}

		return lvlItem;
	}

	ui PlayerLevelItem GetUIStats()
	{
		let lvlItem = PlayerLevelItem(FindInventory("PlayerLevelItem"));
		
		return lvlItem;
	}

	int GetStrength()
	{
		let statItem = GetStats();
		return statItem.Strength;
	}

	int GetMagic()
	{
		let statItem = GetStats();
		return statItem.Magic;
	}

	void RegenerateManaType (class<Inventory> type, int regenMax)
	{
		let ammo = Inventory(FindInventory(type));
		if (ammo == null)
			return;

		regenMax = Max(regenMax, REGENERATE_MIN_VALUE);
		if (ammo.Amount < regenMax)
			ammo.Amount ++;
	}

	void RegenerateHealth(int regenMax)
	{
		regenMax = Max(regenMax, REGENERATE_MIN_VALUE);
		if (Health < regenMax)
			GiveBody(1);
	}

	virtual void Regenerate(PlayerLevelItem statItem) { }

	void DoInventorySlotAction()
	{
		for (int i = 0; i<PAPERDOLL_SLOTS; i++)
		{
			if (accessorySlots[i])
			{
				if (accessorySlots[i].nextSlotItem)
				{
					let newItem = XRpgEquipableItem(accessorySlots[i].nextSlotItem);
					if (newItem)
						newItem.Use(false);
					accessorySlots[i].nextSlotItem = null;
				}
				else if (accessorySlots[i].clearSlot)
				{
					//pick up the item
					hud.selectedItem = activeMagicItems[i];
					
					//setting to the same item clears it
					SetActiveMagicItems(activeMagicItems[i], i);
				}

				accessorySlots[i].clearSlot = false;
			}
		}

		if (trashSlot)
		{
			if (trashSlot.trashItem)
			{
				let trash = trashSlot.trashItem;
				if (trash)
					DropInventory(trash);
				trashSlot.trashItem = null;
			}
		}
	}

	override void Tick()
	{
		RegenerateTicks++;
		if (RegenerateTicks > RegenerateTicksMax)
		{
			RegenerateTicks = 0;

			if (Health > 0)
			{
				let statItem = GetStats();
				Regenerate(statItem);
			}
		}

		//Update inventory if change is pending
		DoInventorySlotAction();

		Super.Tick();
	}

	override void OnRespawn()
	{
		Super.OnRespawn();

		let statItem = GetStats();

		MaxHealth = statItem.MaxHealth;
		A_SetHealth(MaxHealth);
	}

	action void A_FireVerticalMissile(Class<Actor> missileTypeName, int xSpread = 0, int ySpread = 0, int zSpeed = -90, int xMod = 0, int yMod = 0)
	{
		Actor mo = SpawnPlayerMissile(missileTypeName);
		if (!mo) return;

		double offsetX = 0;
		double offsetY = 0;
		if (xSpread > 0)
			offsetX = frandom[VerticleMissile](-xSpread, xSpread);		
		if (ySpread > 0)
			offsetY = frandom[VerticleMissile](-ySpread, ySpread);
		
		int newX = xMod + offsetX;
		int newY = yMod + offsetY;
        double newz = mo.CurSector.HighestCeilingAt((newX, newY));
        mo.SetOrigin((newX, newY, newz), false);

		mo.Vel.X = MinVel; // Force collision detection
        mo.Vel.Y = MinVel; // Force collision detection
		mo.Vel.Z = zSpeed;
		mo.CheckMissileSpawn (radius);
	}

	int GetMana(class<Inventory> type)
    {
        let ammo = Inventory(FindInventory(type));
        if (!ammo)
            return 0;
        
        return ammo.Amount;
    }

    bool CheckMana(class<Inventory> type, int ammoUse)
    {
        if (ammoUse == 0)
            return true;

        let ammo = Inventory(FindInventory(type));
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
        let ammo = Inventory(FindInventory(type));
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

	MagicShield GetShield ()
	{
		let item = MagicShield(ActiveMagicItems[PAPERDOLL_SLOT_SHIELD]);
		if (!item)
			return null;
		
		return item;
	}

	override void CheatGive (String name, int amount)
	{
		let player = self.player;

		if (player.mo == NULL || player.health <= 0)
		{
			return;
		}

		if (name ~== "spells")
		{
			if (self is "XRpgFighterPlayer")
			{
				GiveInventory("BerserkSpell", 1);
				GiveInventory("StunSpell", 1);
				GiveInventory("PowerSpell", 1);
			}
			else if (self is "XRpgClericPlayer")
			{
				GiveInventory("SmiteSpell", 1);
				GiveInventory("HealSpell", 1);
				GiveInventory("ProtectSpell", 1);
				GiveInventory("WrathSpell", 1);
				GiveInventory("DivineSpell", 1);
			}
			else if (self is "XRpgMagePlayer")
			{
				GiveInventory("FireSpell", 1);
				GiveInventory("IceSpell", 1);
				GiveInventory("PoisonSpell", 1);
				GiveInventory("WaterSpell", 1);
				GiveInventory("SunSpell", 1);
				GiveInventory("MoonSpell", 1);
				GiveInventory("DeathSpell", 1);
				GiveInventory("LightningSpell", 1);
				GiveInventory("BloodSpell", 1);
			}
			return;
		}

		if (name ~== "thac0")
		{			
			GrantXP(5000);
			return;
		}

		if (name ~== "arneson" || name ~== "gygax")
		{			
			GrantXP(50000);
			return;
		}

		if (name ~== "shields")
		{			
			GiveInventory("XRpgShield", 1);
			GiveInventory("FalconLargeShield", 1);
			GiveInventory("SilverSmallShield", 1);
			GiveInventory("RoundShield", 1);
			return;
		}

		if (name ~== "helmets")
		{
			GiveInventory("PlatinumHelmet", 1);
			GiveInventory("SuitHelmet", 1);
			GiveInventory("WraithHelmet", 1);
			GiveInventory("MetalCap", 1);
			return;
		}

		if (name ~== "armor")
		{
			GiveInventory("MeshBodyArmor", 1);
			GiveInventory("LeatherBodyArmor", 1);
			GiveInventory("EttinArmor", 1);
			return;
		}

		if (name ~== "amulets")
		{
			GiveInventory("RegenAmulet", 1);
			GiveInventory("ManaAmulet", 1);
			GiveInventory("WardingAmulet", 1);
			GiveInventory("BishopGem", 1);
			return;
		}

		
		if (name ~== "rings")
		{
			GiveInventory("FireRing", 1);
			GiveInventory("IceRing", 1);
			GiveInventory("LightningRing", 1);
			return;
		}

		if (name ~== "equipment")
		{
			GiveInventory("DragonBracers", 1);
			GiveInventory("BootsOfSpeed", 1);
			return;
		}

		if (name ~== "inventory")
		{			
			GiveInventory("XRpgShield", 1);
			GiveInventory("FalconLargeShield", 1);
			GiveInventory("SilverSmallShield", 1);
			GiveInventory("RoundShield", 1);

			GiveInventory("FireRing", 1);
			GiveInventory("IceRing", 1);
			GiveInventory("LightningRing", 1);
			GiveInventory("DragonBracers", 1);
			GiveInventory("BootsOfSpeed", 1);

			GiveInventory("RegenAmulet", 1);
			GiveInventory("ManaAmulet", 1);
			GiveInventory("WardingAmulet", 1);
			GiveInventory("BishopGem", 1);

			GiveInventory("PlatinumHelmet", 1);
			GiveInventory("SuitHelmet", 1);
			GiveInventory("WraithHelmet", 1);
			GiveInventory("MetalCap", 1);

			GiveInventory("MeshBodyArmor", 1);
			GiveInventory("LeatherBodyArmor", 1);
			GiveInventory("EttinArmor", 1);
			return;
		}

		Super.CheatGive(name, amount);
	}
}
