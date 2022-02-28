const MAXXPHIT = 125;
const XPMULTI = 1000;
const STATNUM = 3;
const MAX_LEVEL_ARMOR = 60;
const REGENERATE_TICKS_MAX_DEFAULT = 128;
const REGENERATE_MIN_VALUE = 15;

class XRpgPlayer : PlayerPawn
{
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

	Default
	{
		XRpgPlayer.RegenerateTicks 0;
		XRpgPlayer.RegenerateTicksMax REGENERATE_TICKS_MAX_DEFAULT;
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
	
	void UpdateLevelStats(PlayerLevelItem statItem)
	{
		//Gain 1 AC (5%) per 10 Dex
		int armorMod = statItem.Dexterity / 2;
		armorMod = Max(armorMod, 0);
		armorMod = Min(armorMod, MAX_LEVEL_ARMOR);
		
		let hArmor = HexenArmor(FindInventory("HexenArmor"));
		if (hArmor)
			hArmor.Slots[4] = armorMod;
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

	int GetRandomManaBonus(PlayerLevelItem statItem)
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

		let statItem = GetStats();
		GiveLevelSkill(statItem);
		GiveStartingMana(statItem);

		MaxHealth = statItem.MaxHealth;

		let expItem = Inventory(FindInventory("ExpSquishItemGiver"));
		if (expItem == null)
			expItem = GiveInventoryType("ExpSquishItemGiver");

		//Set minimum spawn level in multiplayer
		if (multiplayer)
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
			A_SetHealth(Health + 1);
	}

	virtual void Regenerate(PlayerLevelItem statItem) { }

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

		Super.Tick();
	}

	override void OnRespawn()
	{
		Super.OnRespawn();

		let statItem = GetStats();

		MaxHealth = statItem.MaxHealth;
		A_SetHealth(MaxHealth);
	}
}
