// The Doom and Heretic players are not excluded from pickup in case
// somebody wants to use these weapons with either of those games.
class XRpgWeapon : Weapon
{
    action void A_SetWeapState(StateLabel stateName)
    {
        player.SetPsprite(PSP_WEAPON, player.ReadyWeapon.FindState(stateName));
    }

    action void A_AltFireCheckSpellSelected()
	{
		if (player == null)
			return;

        let magePlayer = XRpgMagePlayer(player.mo);
        if (!magePlayer || !magePlayer.ActiveSpell)
            A_SetWeapState("Ready");
	}

    action void A_AltHoldCheckSpellSelected()
	{
		if (player == null)
			return;

        let magePlayer = XRpgMagePlayer(player.mo);
        if (!magePlayer || !magePlayer.ActiveSpell)
            A_SetWeapState("AltFire");
	}

    action bool A_CheckMana(class<Inventory> type, int ammoUse)
    {
        if (ammoUse == 0)
            return true;

        let ammo = Inventory(FindInventory(type));
        if (!ammo || ammo.Amount < ammoUse)
            return false;
        
        return true;
    }

    action bool A_CheckAllMana(int blueAmmoUse, int greenAmmoUse)
    {
        let blueResult = A_CheckMana("Mana1", blueAmmoUse);
        let greenResult = A_CheckMana("Mana2", greenAmmoUse);
        
        return blueResult && greenResult;
    }

    action bool A_DepleteMana(class<Inventory> type, int ammoUse)
    {
        let ammo = Inventory(FindInventory(type));
        if (!ammo || ammo.Amount < ammoUse)
            return false;

        ammo.Amount -= ammoUse;
        return true;
    }

    action bool A_DepleteAllMana(int blueAmmoUse, int greenAmmoUse)
    {
        let blueResult = A_DepleteMana("Mana1", blueAmmoUse);
        let greenResult = A_DepleteMana("Mana2", greenAmmoUse);

        return blueResult && greenResult;
    }

    action void A_FireSpreadMissile(Class<Actor> missileType, int angleMax, int zAngleMax, int angleMod = 0)
	{
        int angleSpread = 0;
        int zMod = 0;

        if (angleMax != 0)
            angleSpread = random(-angleMax, angleMax);

        if (zAngleMax != 0)
            zMod = random(-zAngleMax, zAngleMax);
        
		Actor shard = SpawnPlayerMissile(missileType, angle + angleSpread + angleMod);
        if (shard)
        {
            shard.Vel.Z = shard.Vel.Z + zMod;
        }
	}

    void FireSpreadMissile(Class<Actor> missileType, int angleMax, int zAngleMax)
	{
		/*KILL ME!!!*/
	}

    action void A_FireVerticalMissile(Class<Actor> missileType, int xSpread = 0, int ySpread = 0, int zSpeed = -90, int xMod = 0, int yMod = 0)
	{
        int xo = 0;
        int yo = 0;
        if (xSpread != 0)
		    xo = random(-xSpread, xSpread);
        if (ySpread != 0)
		    yo = random(-ySpread, ySpread);

		Vector3 spawnpos = Vec2OffsetZ(xo + xMod, yo + yMod, pos.z);
		Actor mo = SpawnPlayerMissile(missileType);
		if (!mo) return;
		
        mo.SetOrigin(spawnpos, false);
		double newz = mo.CurSector.NextHighestCeilingAt(mo.pos.x, mo.pos.y, mo.pos.z, mo.pos.z, FFCF_NOPORTALS) - mo.height;
		mo.SetZ(newz);

		mo.Vel.X = MinVel; // Force collision detection
		mo.Vel.Z = zSpeed;
		mo.CheckMissileSpawn (radius);
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

    bool FireMissileSpell(Class<Actor> missileType, int blueAmmoUse = 0, int greenAmmoUse = 0, int angleMod = 0)
	{
		return true; /* KILL ME */
	}

    action bool A_FireMissileSpell(Class<Actor> missileType, int blueAmmoUse = 0, int greenAmmoUse = 0, int angleMod = 0, int angleSpread = 0, int zSpread = 0)
	{
		if (!A_AttemptFireSpell(blueAmmoUse, greenAmmoUse))
            return false;

        A_FireSpreadMissile(missileType, angleSpread, zSpread, angleMod);

        return true;
	}

    action bool A_AttemptFireSpell(int blueAmmoUse, int greenAmmoUse)
	{
		if (player == null)
			return false;

        if (!A_CheckAllMana(blueAmmoUse, greenAmmoUse))
        {
            A_SetWeapState("Ready");
            return false;
        }
        
        return A_DepleteAllMana(blueAmmoUse, greenAmmoUse);
	}

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
                    A_SetWeapState("FlameSpell");
                    break;
                case SPELLTYPE_ICE:
                    A_SetWeapState("IceSpell");
                    break;
                case SPELLTYPE_POISON:
                    A_SetWeapState("PoisonSpell");
                    break;
                case SPELLTYPE_WATER:
                    A_SetWeapState("WaterSpell");
                    break;
                case SPELLTYPE_SUN:
                    A_SetWeapState("SunSpell");
                    break;
                case SPELLTYPE_MOON:
                    A_SetWeapState("MoonSpell");
                    break;
                case SPELLTYPE_DEATH:
                    A_SetWeapState("DeathSpell");
                    break;
                case SPELLTYPE_LIGHTNING:
                    A_SetWeapState("LightningSpell");
                    break;
                case SPELLTYPE_BLOOD:
                    A_SetWeapState("BloodSpell");
                    break;
            }
        }
	}
}