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

			// if (source) 
			// {
			// 	let modifiedDamage = source.GetModifiedDamage(damagetype, damage, passive, inflictor, source, flags);

			// 	string dmgMsg = String.Format("XP is %d and modified is %d", newdamage, modifiedDamage);
			// 	console.printf(dmgMsg);
			// }
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

const XP_GRANT_PLAYER_LIMIT = 10;
const XP_GRANT_PLAYER_RADIUS = 5000;

class SummonExpSquishItem : Powerup
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

    int GetPlayerCount()
	{
		int total = 0;
		for (int i = 0; i < MaxPlayers; i++)
		{
			if (playeringame[i])
				total++;
		}

		return total;
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
			if (source && source.bIsMonster)
			{
				int numPlayers = GetPlayerCount();
				if (numPlayers < 1)
					return;

				//Console.Printf(String.Format("Number of players: %d", numPlayers));

				int newXp = damage / numPlayers;

				newXP = Max(newXP, 1);
				newXP = Min(newXP, MAXXPHIT);
			
				Owner.A_RadiusGive("ExpBonusItem", XP_GRANT_PLAYER_RADIUS, RGF_PLAYERS, newXp, "", "", 0, XP_GRANT_PLAYER_LIMIT);
			}
        }
	}
}

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

class ExpBonusItem : Powerup
{
	Default
	{
		+INVENTORY.UNDROPPABLE
        +INVENTORY.UNTOSSABLE
        +INVENTORY.AUTOACTIVATE
	}

    override bool Use(bool pickup)
    {
		if (Owner && Owner.Player && Owner.Player.mo)
		{
			let xrpgPlayer = XRpgPlayer(Owner.Player.mo);
			if (xrpgPlayer)
			{
				xrpgPlayer.GrantXP(Amount);
			}
		}

        return true;
    }
}