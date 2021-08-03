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

    void FireSpreadMissile(Class<Actor> missileType, int angleMax, int zAngleMax)
	{
		Actor shard = owner.SpawnPlayerMissile(missileType, owner.angle + random(-1 * angleMax, angleMax));
        if (shard)
        {
            shard.Vel.Z = shard.Vel.Z + random(-1 * zAngleMax, zAngleMax);
        }
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

    bool FireMissileSpell(Class<Actor> missileType, int ammoUse)
	{
		if (owner.player == null)
			return false;

        if (!DepleteBlueMana(ammoUse))
        {
            owner.player.SetPsprite(PSP_WEAPON, owner.player.ReadyWeapon.FindState("Fire"));
            return false;
        }

        owner.SpawnPlayerMissile(missileType);

        return true;
	}

    virtual void FireFlameSpell() {}
    virtual void FireIceSpell() {}
    virtual void FirePoisonSpell() {}

    virtual void FireWaterSpell() {}
    virtual void FireSunSpell() {}
    virtual void FireMoonSpell() {}

    virtual void FireDeathSpell() {}
    virtual void FireLightningSpell() {}
    virtual void FireBloodSpell() {}

    action void A_FireSpell()
	{
		if (player == null)
			return;

        let magePlayer = XRpgMagePlayer(player.mo);
        if (magePlayer && magePlayer.ActiveSpell)
        {

            switch (magePlayer.ActiveSpell.SpellType)
            {
                case SPELLTYPE_FIRE:
                    invoker.FireFlameSpell();
                    break;
                case SPELLTYPE_ICE:
                    invoker.FireIceSpell();
                    break;
                case SPELLTYPE_POISON:
                    invoker.FirePoisonSpell();
                    break;
                case SPELLTYPE_WATER:
                    invoker.FireWaterSpell();
                    break;
                case SPELLTYPE_SUN:
                    invoker.FireSunSpell();
                    break;
                case SPELLTYPE_MOON:
                    invoker.FireMoonSpell();
                    break;
                case SPELLTYPE_DEATH:
                    invoker.FireDeathSpell();
                    break;
                case SPELLTYPE_LIGHTNING:
                    invoker.FireLightningSpell();
                    break;
                case SPELLTYPE_BLOOD:
                    invoker.FireBloodSpell();
                    break;
            }
        }
	}
}