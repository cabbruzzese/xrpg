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

//-------------
// Mage Spells
//-------------
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
		Inventory.Icon "SPSHG0";

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
		Inventory.Icon "CHNSG0";

        XRpgSpellItem.SpellType SPELLTYPE_DEATH;
	}
}

class LightningSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "MLF2P0";

        XRpgSpellItem.SpellType SPELLTYPE_LIGHTNING;
	}
}

class BloodSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "DEMEA0";

        XRpgSpellItem.SpellType SPELLTYPE_BLOOD;
	}
}