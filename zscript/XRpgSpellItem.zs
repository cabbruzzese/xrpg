const SPELLTYPE_FIRE = 1;
const SPELLTYPE_ICE = 2;
const SPELLTYPE_POISON = 3;
const SPELLTYPE_DEATH = 4;
const SPELLTYPE_LIGHTNING = 5;
const SPELLTYPE_WATER = 6;
const SPELLTYPE_BLOOD = 7;

class XRpgSpellItem : PowerupGiver
{
    int spellType;
    property SpellType : spellType;

	Default
	{
		+COUNTITEM
		+FLOATBOB
		Inventory.PickupFlash "PickupFlash";
		Inventory.InterHubAmount 1;
		Inventory.MaxAmount 1;
	}
	
	virtual void CastSpell(XRpgPlayer bPlayer)
	{
	}
	
	override bool Use (bool pickup)
	{
        let magePlayer = XRpgMagePlayer(Owner);
        if (magePlayer != null)
        {
            magePlayer.ActiveSpell = self;
        }

		return false;
	}
	
	override void Tick()
	{
		// Spells cannot exist outside an inventory
		if (Owner == NULL)
		{
			Destroy ();
		}
	}
}

class FireSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "DMFXB5";

        XRpgSpellItem.SpellType SPELLTYPE_FIRE;
	}
}

class IceSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "ICPRA0";

        XRpgSpellItem.SpellType SPELLTYPE_ICE;
	}
}

class PoisonSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "D2FXA1";

        XRpgSpellItem.SpellType SPELLTYPE_POISON;
	}
}

class DeathSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "SBS4A0";

        XRpgSpellItem.SpellType SPELLTYPE_DEATH;
	}
}

class LightningSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "MLF2P0";
		Scale 0.5;

        XRpgSpellItem.SpellType SPELLTYPE_LIGHTNING;
	}
}