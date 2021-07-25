// The Doom and Heretic players are not excluded from pickup in case
// somebody wants to use these weapons with either of those games.
class XRpgWeapon : Weapon
{
    action void A_AltFireCheckSpellSelected()
	{
		if (player == null)
			return;

        let magePlayer = XRpgMagePlayer(player.mo);
        if (!magePlayer || !magePlayer.ActiveSpell)
            player.SetPsprite(PSP_WEAPON, player.ReadyWeapon.FindState("Fire"));
	}

    action void A_AltHoldCheckSpellSelected()
	{
		if (player == null)
			return;

        let magePlayer = XRpgMagePlayer(player.mo);
        if (!magePlayer || !magePlayer.ActiveSpell || !invoker.IsSpellRapidFire(magePlayer.ActiveSpell.SpellType))
            player.SetPsprite(PSP_WEAPON, player.ReadyWeapon.FindState("AltFire"));
	}

    virtual bool IsSpellRapidFire(int spellType)
    {
        return false;
    }

    action bool DepleteMana(class<Inventory> type, int used)
    {
        let ammo = Inventory(FindInventory(type));
        if (!ammo || ammo.Amount < used)
            return false;

        ammo.Amount -= used;
        return true;
    }

    action bool DepleteBlueMana(int used)
    {
        return DepleteMana("Mana1", used);
    }

    action bool DepleteGreenMana(int used)
    {
        return DepleteMana("Mana2", used);
    }
}

class XRpgFighterWeapon : XRpgWeapon
{
	Default
	{
		Weapon.Kickback 150;
		Inventory.ForbiddenTo "ClericPlayer", "MagePlayer";
	}
}

class XRpgClericWeapon : XRpgWeapon
{
	Default
	{
		Weapon.Kickback 150;
		Inventory.ForbiddenTo "FighterPlayer", "MagePlayer";
	}
}

class XRpgMageWeapon : XRpgWeapon
{
	Default
	{
		Weapon.Kickback 150;
		Inventory.ForbiddenTo "FighterPlayer", "ClericPlayer";
	}
}