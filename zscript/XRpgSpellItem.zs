//lvl 1
const SPELLTYPE_FIRE = 101;
const SPELLTYPE_ICE = 102;
const SPELLTYPE_POISON = 103;

//level 2
const SPELLTYPE_WATER = 201;
const SPELLTYPE_SUN = 202;
const SPELLTYPE_MOON = 203;

//level 3
const SPELLTYPE_DEATH = 301;
const SPELLTYPE_LIGHTNING = 302;
const SPELLTYPE_BLOOD = 303;

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

class WaterSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "SBS4A0";

        XRpgSpellItem.SpellType SPELLTYPE_WATER;
	}
}

class SunSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "FX12B1";

        XRpgSpellItem.SpellType SPELLTYPE_SUN;
	}
}

class MoonSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "RADEB0";

        XRpgSpellItem.SpellType SPELLTYPE_MOON;
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

class BloodSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "SBS4A0";

        XRpgSpellItem.SpellType SPELLTYPE_BLOOD;
	}
}