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

const MANA_FROST_FLAME_BLUE = 0;
const MANA_FROST_FLAME_GREEN = 5;
const MANA_FROST_ICE_BLUE = 0;
const MANA_FROST_ICE_GREEN = 1;
const MANA_FROST_POISON_BLUE = 0;
const MANA_FROST_POISON_GREEN = 6;
const MANA_FROST_WATER_BLUE = 0;
const MANA_FROST_WATER_GREEN = 4;
const MANA_FROST_SUN_BLUE = 0;
const MANA_FROST_SUN_GREEN = 8;
const MANA_FROST_MOON_BLUE = 0;
const MANA_FROST_MOON_GREEN = 4;
const MANA_FROST_DEATH_BLUE = 0;
const MANA_FROST_DEATH_GREEN = 6;
const MANA_FROST_LIGHTNING_BLUE = 0;
const MANA_FROST_LIGHTNING_GREEN = 3;
const MANA_FROST_BLOOD_BLUE = 0;
const MANA_FROST_BLOOD_GREEN = 7;

const MANA_LIGHTNING_FLAME_BLUE = 3;
const MANA_LIGHTNING_FLAME_GREEN = 2;
const MANA_LIGHTNING_ICE_BLUE = 3;
const MANA_LIGHTNING_ICE_GREEN = 3;
const MANA_LIGHTNING_POISON_BLUE = 2;
const MANA_LIGHTNING_POISON_GREEN = 2;
const MANA_LIGHTNING_WATER_BLUE = 6;
const MANA_LIGHTNING_WATER_GREEN = 2;
const MANA_LIGHTNING_SUN_BLUE = 10;
const MANA_LIGHTNING_SUN_GREEN = 10;
const MANA_LIGHTNING_MOON_BLUE = 8;
const MANA_LIGHTNING_MOON_GREEN = 8;
const MANA_LIGHTNING_DEATH_BLUE = 10;
const MANA_LIGHTNING_DEATH_GREEN = 10;
const MANA_LIGHTNING_LIGHTNING_BLUE = 10;
const MANA_LIGHTNING_LIGHTNING_GREEN = 10;
const MANA_LIGHTNING_BLOOD_BLUE = 7;
const MANA_LIGHTNING_BLOOD_GREEN = 7;

const MANA_BLOODSCOURGE_FLAME_BLUE = 2;
const MANA_BLOODSCOURGE_FLAME_GREEN = 2;
const MANA_BLOODSCOURGE_ICE_BLUE = 3;
const MANA_BLOODSCOURGE_ICE_GREEN = 3;
const MANA_BLOODSCOURGE_POISON_BLUE = 9;
const MANA_BLOODSCOURGE_POISON_GREEN = 9;
const MANA_BLOODSCOURGE_WATER_BLUE = 6;
const MANA_BLOODSCOURGE_WATER_GREEN = 6;
const MANA_BLOODSCOURGE_SUN_BLUE = 2;
const MANA_BLOODSCOURGE_SUN_GREEN = 2;
const MANA_BLOODSCOURGE_MOON_BLUE = 3;
const MANA_BLOODSCOURGE_MOON_GREEN = 3;
const MANA_BLOODSCOURGE_DEATH_BLUE = 3;
const MANA_BLOODSCOURGE_DEATH_GREEN = 3;
const MANA_BLOODSCOURGE_LIGHTNING_BLUE = 3;
const MANA_BLOODSCOURGE_LIGHTNING_GREEN = 3;
const MANA_BLOODSCOURGE_BLOOD_BLUE = 1;
const MANA_BLOODSCOURGE_BLOOD_GREEN = 1;

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

		XRpgSpellItem.SpellCostBlue1 MANA_WAND_FLAME_BLUE;
		XRpgSpellItem.SpellCostGreen1 MANA_WAND_FLAME_GREEN;
		XRpgSpellItem.SpellCostBlue2 MANA_FROST_FLAME_BLUE;
		XRpgSpellItem.SpellCostGreen2 MANA_FROST_FLAME_GREEN;
		XRpgSpellItem.SpellCostBlue3 MANA_LIGHTNING_FLAME_BLUE;
		XRpgSpellItem.SpellCostGreen3 MANA_LIGHTNING_FLAME_GREEN;
		XRpgSpellItem.SpellCostBlue4 MANA_BLOODSCOURGE_FLAME_BLUE;
		XRpgSpellItem.SpellCostGreen4 MANA_BLOODSCOURGE_FLAME_GREEN;
	}
}

class IceSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "ICPRA0";

		Inventory.PickupMessage "$TXT_ICESPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_ICE;

		XRpgSpellItem.SpellCostBlue1 MANA_WAND_ICE_BLUE;
		XRpgSpellItem.SpellCostGreen1 MANA_WAND_ICE_GREEN;
		XRpgSpellItem.SpellCostBlue2 MANA_FROST_ICE_BLUE;
		XRpgSpellItem.SpellCostGreen2 MANA_FROST_ICE_GREEN;
		XRpgSpellItem.SpellCostBlue3 MANA_LIGHTNING_ICE_BLUE;
		XRpgSpellItem.SpellCostGreen3 MANA_LIGHTNING_ICE_GREEN;
		XRpgSpellItem.SpellCostBlue4 MANA_BLOODSCOURGE_ICE_BLUE;
		XRpgSpellItem.SpellCostGreen4 MANA_BLOODSCOURGE_ICE_GREEN;
	}
}

class PoisonSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "D2FXA1";

		Inventory.PickupMessage "$TXT_POISONSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_POISON;

		XRpgSpellItem.SpellCostBlue1 MANA_WAND_POISON_BLUE;
		XRpgSpellItem.SpellCostGreen1 MANA_WAND_POISON_GREEN;
		XRpgSpellItem.SpellCostBlue2 MANA_FROST_POISON_BLUE;
		XRpgSpellItem.SpellCostGreen2 MANA_FROST_POISON_GREEN;
		XRpgSpellItem.SpellCostBlue3 MANA_LIGHTNING_POISON_BLUE;
		XRpgSpellItem.SpellCostGreen3 MANA_LIGHTNING_POISON_GREEN;
		XRpgSpellItem.SpellCostBlue4 MANA_BLOODSCOURGE_POISON_BLUE;
		XRpgSpellItem.SpellCostGreen4 MANA_BLOODSCOURGE_POISON_GREEN;
	}
}

class WaterSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "SPSHG0";

		Inventory.PickupMessage "$TXT_WATERSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_WATER;

		XRpgSpellItem.SpellCostBlue1 MANA_WAND_WATER_BLUE;
		XRpgSpellItem.SpellCostGreen1 MANA_WAND_WATER_GREEN;
		XRpgSpellItem.SpellCostBlue2 MANA_FROST_WATER_BLUE;
		XRpgSpellItem.SpellCostGreen2 MANA_FROST_WATER_GREEN;
		XRpgSpellItem.SpellCostBlue3 MANA_LIGHTNING_WATER_BLUE;
		XRpgSpellItem.SpellCostGreen3 MANA_LIGHTNING_WATER_GREEN;
		XRpgSpellItem.SpellCostBlue4 MANA_BLOODSCOURGE_WATER_BLUE;
		XRpgSpellItem.SpellCostGreen4 MANA_BLOODSCOURGE_WATER_GREEN;
	}
}

class SunSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "FX12B1";

		Inventory.PickupMessage "$TXT_SUNSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_SUN;

		XRpgSpellItem.SpellCostBlue1 MANA_WAND_SUN_BLUE;
		XRpgSpellItem.SpellCostGreen1 MANA_WAND_SUN_GREEN;
		XRpgSpellItem.SpellCostBlue2 MANA_FROST_SUN_BLUE;
		XRpgSpellItem.SpellCostGreen2 MANA_FROST_SUN_GREEN;
		XRpgSpellItem.SpellCostBlue3 MANA_LIGHTNING_SUN_BLUE;
		XRpgSpellItem.SpellCostGreen3 MANA_LIGHTNING_SUN_GREEN;
		XRpgSpellItem.SpellCostBlue4 MANA_BLOODSCOURGE_SUN_BLUE;
		XRpgSpellItem.SpellCostGreen4 MANA_BLOODSCOURGE_SUN_GREEN;
	}
}

class MoonSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "RADEB0";

		Inventory.PickupMessage "$TXT_MOONSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_MOON;

		XRpgSpellItem.SpellCostBlue1 MANA_WAND_MOON_BLUE;
		XRpgSpellItem.SpellCostGreen1 MANA_WAND_MOON_GREEN;
		XRpgSpellItem.SpellCostBlue2 MANA_FROST_MOON_BLUE;
		XRpgSpellItem.SpellCostGreen2 MANA_FROST_MOON_GREEN;
		XRpgSpellItem.SpellCostBlue3 MANA_LIGHTNING_MOON_BLUE;
		XRpgSpellItem.SpellCostGreen3 MANA_LIGHTNING_MOON_GREEN;
		XRpgSpellItem.SpellCostBlue4 MANA_BLOODSCOURGE_MOON_BLUE;
		XRpgSpellItem.SpellCostGreen4 MANA_BLOODSCOURGE_MOON_GREEN;
	}
}

class DeathSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "CHNSG0";

		Inventory.PickupMessage "$TXT_DEATHSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_DEATH;

		XRpgSpellItem.SpellCostBlue1 MANA_WAND_DEATH_BLUE;
		XRpgSpellItem.SpellCostGreen1 MANA_WAND_DEATH_GREEN;
		XRpgSpellItem.SpellCostBlue2 MANA_FROST_DEATH_BLUE;
		XRpgSpellItem.SpellCostGreen2 MANA_FROST_DEATH_GREEN;
		XRpgSpellItem.SpellCostBlue3 MANA_LIGHTNING_DEATH_BLUE;
		XRpgSpellItem.SpellCostGreen3 MANA_LIGHTNING_DEATH_GREEN;
		XRpgSpellItem.SpellCostBlue4 MANA_BLOODSCOURGE_DEATH_BLUE;
		XRpgSpellItem.SpellCostGreen4 MANA_BLOODSCOURGE_DEATH_GREEN;
	}
}

class LightningSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "MLF2P0";

		Inventory.PickupMessage "$TXT_LIGHTNINGSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_LIGHTNING;

		XRpgSpellItem.SpellCostBlue1 MANA_WAND_LIGHTNIN_BLUE;
		XRpgSpellItem.SpellCostGreen1 MANA_WAND_LIGHTNIN_GREEN;
		XRpgSpellItem.SpellCostBlue2 MANA_FROST_LIGHTNING_BLUE;
		XRpgSpellItem.SpellCostGreen2 MANA_FROST_LIGHTNING_GREEN;
		XRpgSpellItem.SpellCostBlue3 MANA_LIGHTNING_LIGHTNING_BLUE;
		XRpgSpellItem.SpellCostGreen3 MANA_LIGHTNING_LIGHTNING_GREEN;
		XRpgSpellItem.SpellCostBlue4 MANA_BLOODSCOURGE_LIGHTNING_BLUE;
		XRpgSpellItem.SpellCostGreen4 MANA_BLOODSCOURGE_LIGHTNING_GREEN;
	}
}

class BloodSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "DEMEA0";

		Inventory.PickupMessage "$TXT_BLOODSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_BLOOD;

		XRpgSpellItem.SpellCostBlue1 MANA_WAND_BLOOD_BLUE;
		XRpgSpellItem.SpellCostGreen1 MANA_WAND_BLOOD_GREEN;
		XRpgSpellItem.SpellCostBlue2 MANA_FROST_BLOOD_BLUE;
		XRpgSpellItem.SpellCostGreen2 MANA_FROST_BLOOD_GREEN;
		XRpgSpellItem.SpellCostBlue3 MANA_LIGHTNING_BLOOD_BLUE;
		XRpgSpellItem.SpellCostGreen3 MANA_LIGHTNING_BLOOD_GREEN;
		XRpgSpellItem.SpellCostBlue4 MANA_BLOODSCOURGE_BLOOD_BLUE;
		XRpgSpellItem.SpellCostGreen4 MANA_BLOODSCOURGE_BLOOD_GREEN;
	}
}