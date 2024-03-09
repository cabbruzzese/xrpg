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


//Cost Values
const MANA_WAND_FLAME_BLUE = 5;
const MANA_WAND_FLAME_GREEN = 0;
const MANA_WAND_ICE_BLUE = 1;
const MANA_WAND_ICE_GREEN = 0;
const MANA_WAND_POISON_BLUE = 2;
const MANA_WAND_POISON_GREEN = 0;
const MANA_WAND_WATER_BLUE = 4;
const MANA_WAND_WATER_GREEN = 0;
const MANA_WAND_SUN_BLUE = 8;
const MANA_WAND_SUN_GREEN = 0;
const MANA_WAND_MOON_BLUE = 4;
const MANA_WAND_MOON_GREEN = 0;
const MANA_WAND_DEATH_BLUE = 6;
const MANA_WAND_DEATH_GREEN = 0;
const MANA_WAND_LIGHTNIN_BLUE = 6;
const MANA_WAND_LIGHTNIN_GREEN = 0;
const MANA_WAND_BLOOD_BLUE = 5;
const MANA_WAND_BLOOD_GREEN = 0;

//-------------
// Mage Spells
//-------------
class FireSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "DMFXB5";

		Inventory.PickupMessage "$TXT_FIRESPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_FIRE;
	}
}

class IceSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "ICPRA0";

		Inventory.PickupMessage "$TXT_ICESPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_ICE;
	}
}

class PoisonSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "D2FXA1";

		Inventory.PickupMessage "$TXT_POISONSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_POISON;
	}
}

class WaterSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "SPSHG0";

		Inventory.PickupMessage "$TXT_WATERSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_WATER;
	}
}

class SunSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "FX12B1";

		Inventory.PickupMessage "$TXT_SUNSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_SUN;
	}
}

class MoonSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "RADEB0";

		Inventory.PickupMessage "$TXT_MOONSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_MOON;
	}
}

class DeathSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "CHNSG0";

		Inventory.PickupMessage "$TXT_DEATHSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_DEATH;
	}
}

class LightningSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "MLF2P0";

		Inventory.PickupMessage "$TXT_LIGHTNINGSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_LIGHTNING;
	}
}

class BloodSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "DEMEA0";

		Inventory.PickupMessage "$TXT_BLOODSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_BLOOD;
	}
}