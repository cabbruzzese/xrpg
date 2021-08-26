//Fighter spells
// (These are SKILLS but they use the spell items to activate)
const SPELLTYPE_FIGHTER_BERSERK = 2201;
const SPELLTYPE_FIGHTER_STUN = 2202;
const SPELLTYPE_FIGHTER_POWER = 2203;

const FIGHTERSPELL_MINLIFE = 50;
class BerserkSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "BERSA0";

        XRpgSpellItem.SpellType SPELLTYPE_FIGHTER_BERSERK;

		XRpgSpellItem.TimerVal 0;
		XRpgSpellItem.MaxTimer 400;

		XRpgSpellItem.MagicTimerMod 0;
		XRpgSpellItem.IsMultiSlot true;
        XRpgSpellItem.IsLifeCost true;
        XRpgSpellItem.MaxLifeCostTimer 10;
		XRpgSpellItem.LifeCostMin FIGHTERSPELL_MINLIFE;
	}
}

class StunSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "STUNA0";

        XRpgSpellItem.SpellType SPELLTYPE_FIGHTER_STUN;

		XRpgSpellItem.TimerVal 0;
		XRpgSpellItem.MaxTimer 400;

		XRpgSpellItem.MagicTimerMod 0;
		XRpgSpellItem.IsMultiSlot true;
        XRpgSpellItem.IsLifeCost true;
        XRpgSpellItem.MaxLifeCostTimer 16;
		XRpgSpellItem.LifeCostMin FIGHTERSPELL_MINLIFE;
	}
}

class PowerSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "POWRA0";

        XRpgSpellItem.SpellType SPELLTYPE_FIGHTER_POWER;

		XRpgSpellItem.TimerVal 0;
		XRpgSpellItem.MaxTimer 400;

		XRpgSpellItem.MagicTimerMod 0;
		XRpgSpellItem.IsMultiSlot true;
        XRpgSpellItem.IsLifeCost true;
        XRpgSpellItem.MaxLifeCostTimer 16;
		XRpgSpellItem.LifeCostMin FIGHTERSPELL_MINLIFE;
	}
}