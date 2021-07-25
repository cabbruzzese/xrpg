const MAXXPHIT = 75;
const XPMULTI = 1000;
const HEALTHBASE = 100;
const STATNUM = 4;

class XRpgPlayer : PlayerPawn
{
	int expLevel;
	int exp;
	int expNext;
	int strength;
	int dexterity;
	int magic;
	property ExpLevel : expLevel;
	property Exp : exp;
	property ExpNext : expNext;
	property Strength : strength;
	property Dexterity : dexterity;
	property Magic : magic;

	Default
	{
		XRpgPlayer.ExpLevel 1;
		XRpgPlayer.Exp 0;
		XRpgPlayer.ExpNext XPMULTI;

		XRpgPlayer.Strength 1;
		XRpgPlayer.Dexterity 1;
		XRpgPlayer.Magic 1;

		Player.MaxHealth HEALTHBASE;
		Health HEALTHBASE;
	}

	double GetScaledMod(int stat)
	{
		//First 10 scales to 1 by 10% increments
		if (stat <= 10)
			return stat * 0.1;
		
		//Remaining scales at 5% increments. 30 = double damage
		return 1 + ((stat - 10) * 0.05);
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
	
	int GetDamageForMelee(int damage)
	{
		return GetModDamage(damage, Strength, 1);
	}
	
	int GetDamageForWeapon(int damage)
	{
		return GetModDamage(damage, Dexterity, 1);
	}
	
	int GetDamageForMagic(int damage)
	{
		return GetModDamage(damage, Magic, 1);
	}

	void SetProjectileDamage(Actor proj, int stat)
	{
		if (!proj)
			return;
		
		let newDamage = GetModDamage(proj.Damage, stat, 1);
		
		proj.SetDamage(newDamage);
	}
	
	void SetProjectileDamageForMelee(Actor proj)
	{
		SetProjectileDamage(proj, Strength);
	}

	void SetProjectileDamageForWeapon(Actor proj)
	{
		SetProjectileDamage(proj, Dexterity);
	}

	void SetProjectileDamageForMagic(Actor proj)
	{
		SetProjectileDamage(proj, Magic);
	}
	
	int CalcXPNeeded()
	{
		return ExpLevel * XPMULTI;
	}
	
	void GiveXP (int expEarned)
	{
		Exp += expEarned;
		
		while (Exp >= ExpNext)
		{
			GainLevel();
		}
	}
	
	virtual void BasicStatIncrease()
	{
	}

	virtual void GiveLevelSkill()
	{
	}
	
	void DoLevelGainBlend()
	{
		let blendColor = Color(122,	122, 122, 122);
		A_SetBlend(blendColor, 0.8, 40);
		
		string lvlMsg = String.Format("You are now level %d", ExpLevel);
		A_Print(lvlMsg);
	}
	
	void GainLevelHealth()
	{
		//health increases by random up to half Strength, min 5 (weighted for low end of flat scale)
		int halfStrength = Strength / 2;
		int healthBonus = random(1, halfStrength);
		if (healthBonus < 5)
			healthbonus = 5;

		int newHealth = MaxHealth + healthBonus;
		MaxHealth = newHealth;
		if (Health < MaxHealth)
			A_SetHealth(MaxHealth);
	}

	int GetRandomManaBonus()
	{
		//mana increases by random up to half Magic, min 5 (weighted for low end of flat scale)
		int halfMagic = Magic / 2;
		int manaBonus = random(1, halfMagic);
		if (manaBonus < 5)
			manaBonus = 5;
		
		return manaBonus;
	}

	void GainLevelManaByType(class<Inventory> type)
	{
		int bonus = GetRandomManaBonus();

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

	void GainLevelMana()
	{
		GainLevelManaByType("Mana1");
		GainLevelManaByType("Mana2");
	}

	//Gain a level
	void GainLevel()
	{
		if (Exp < ExpNext)
			return;

		ExpLevel++;
		Exp = Exp - ExpNext;
		ExpNext = CalcXpNeeded();
		
		//Distribute points randomly, giving weight to highest stats
		int statPoints = STATNUM;
		while (statPoints > 0)
		{
			int statStack = Strength + Dexterity + Magic;
			
			double rand = random(1, statStack);
			if (rand <= Strength)
			{
				Strength += 1;
			}
			else if (rand <= Strength + Dexterity)
			{
				Dexterity += 1;
			}
			else
			{
				Magic += 1;
			}
			statPoints--;
		}
		
		//BasicStatIncrease to call overrides in classes
		BasicStatIncrease();
		//Give class specific items or skills
		GiveLevelSkill();

		GainLevelHealth();
		GainLevelMana();
			
		DoLevelGainBlend();
	}

    void DoXPHit(Actor xpSource, int damage, name damagetype)
	{
        if (damage <= 0)
            return;
        
        if (!xpSource)
            return;

        if (!xpSource.bISMONSTER)
            return;

        int xp = damage;
        if (xp > MAXXPHIT)
            xp = MAXXPHIT;

        GiveXP(xp);
	}

	override void BeginPlay()
	{
		GiveLevelSkill();
		Super.BeginPlay();
	}
}
