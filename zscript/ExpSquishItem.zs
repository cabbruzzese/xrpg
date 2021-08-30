class PlayerLevelItem : Inventory
{
	int expLevel;
	int exp;
	int expNext;
	int strength;
	int dexterity;
	int magic;
	int maxHealth;

	property ExpLevel : expLevel;
	property Exp : exp;
	property ExpNext : expNext;
	property Strength : strength;
	property Dexterity : dexterity;
	property Magic : magic;
	property MaxHealth : maxHealth;

	Default
	{
		+INVENTORY.UNDROPPABLE
        +INVENTORY.UNTOSSABLE
        +INVENTORY.UNCLEARABLE

		PlayerLevelItem.ExpLevel 1;
		PlayerLevelItem.Exp 0;
		PlayerLevelItem.ExpNext XPMULTI;
	}

	override void OwnerDied() 
	{
		//reduce all gained XP for this level
		Exp = 0;

		//reduce max health
		if (MaxHealth > Strength)
		{
			int healthLoss = ExpLevel;
			int minHealth = Strength + REGENERATE_MIN_VALUE;
			int newMax = Max(minHealth, MaxHealth - healthLoss);

			MaxHealth = newMax;
		}
	}
}

class ExpSquishItem : Powerup
{
	Default
	{
		+INVENTORY.UNDROPPABLE
        +INVENTORY.UNTOSSABLE
        +INVENTORY.AUTOACTIVATE
        +INVENTORY.PERSISTENTPOWER
        +INVENTORY.UNCLEARABLE

        Powerup.Duration 0x7FFFFFFF;
	}

	//===========================================================================
	//
	// ModifyDamage
	//
	//===========================================================================

	override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if (!passive && damage > 0 && Owner && Owner.Player && Owner.Player.mo)
        {
            let xrpgPlayer = XRpgPlayer(Owner.Player.mo);
            if (xrpgPlayer)
            {
                xrpgPlayer.DoXPHit(source, damage, damageType);
            }
        }
	}

	override void EndEffect()
	{
		//console.printf("item ended!");
	}

	override void OnDestroy()
	{
		//console.printf("Destroy item!");
	}

	override void OwnerDied() {}
}

/*class SummonExpSquishItem : Powerup
{
	Default
	{
		+INVENTORY.UNDROPPABLE
        +INVENTORY.UNTOSSABLE
        +INVENTORY.AUTOACTIVATE
        +INVENTORY.PERSISTENTPOWER
        +INVENTORY.UNCLEARABLE

        Powerup.Duration 0x7FFFFFFF;
	}

	//===========================================================================
	//
	// ModifyDamage
	//
	//===========================================================================

	override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if (!passive && damage > 0 && Owner && Owner.bIsMonster && Owner.bFriendly)
        {
			//console.printf("Summoned monster attacked");
			if (!owner.tracer)
				return;
			
            let xrpgPlayer = XRpgPlayer(Owner.tracer);
            if (xrpgPlayer)
            {
                xrpgPlayer.DoXPHit(source, damage, damageType);
            }
        }
	}
}*/

class ExpSquishItemGiver : PowerupGiver
{
	Default
	{
		Powerup.Type "ExpSquishItem";

		+INVENTORY.UNDROPPABLE
        +INVENTORY.UNTOSSABLE
        +INVENTORY.AUTOACTIVATE
        +INVENTORY.PERSISTENTPOWER
        +INVENTORY.UNCLEARABLE
	}
	States
	{
	Spawn:
		DEFN ABCD 3;
		Loop;
	}
}