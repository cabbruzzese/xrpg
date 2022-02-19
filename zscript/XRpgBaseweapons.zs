// The Doom and Heretic players are not excluded from pickup in case
// somebody wants to use these weapons with either of those games.
class XRpgWeapon : Weapon
{
    int chargeValue;
    int maxCharge;
	property ChargeValue : chargeValue;
    property MaxCharge : maxCharge;

    Default
	{
        XRpgWeapon.ChargeValue 0;
        XRpgWeapon.MaxCharge 0;
    }

	action void A_ChargeUp()
	{
		invoker.ChargeValue++;
		if (invoker.chargeValue > invoker.MaxCharge)
			invoker.chargeValue = invoker.MaxCharge;
	}

    action void A_CheckMinCharge(int minCharge)
	{
        //If there is low charge attack
        if (minCharge > 0 && invoker.chargeValue < minCharge)
        {
            A_SetWeapState("ShortChargeAttack");
        }
	}

    action void A_Mirror()
    {
        A_OverlayFlags(1,PSPF_FLIP|PSPF_MIRROR,true);
    }

    action void A_RestoreMirror()
    {
        A_OverlayFlags(1,PSPF_FLIP|PSPF_MIRROR,false);
    }

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

    action int A_GetMana(class<Inventory> type)
    {
        let ammo = Inventory(FindInventory(type));
        if (!ammo)
            return 0;
        
        return ammo.Amount;
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
            angleSpread = frandom(-angleMax, angleMax);

        if (zAngleMax != 0)
            zMod = frandom(-zAngleMax, zAngleMax);
        
		Actor shard = SpawnPlayerMissile(missileType, angle + angleSpread + angleMod);
        if (shard)
        {
            shard.Vel.Z = shard.Vel.Z + zMod;
        }
	}

    action Actor A_FireVerticalMissilePos(Class<Actor> missileType, int xPos, int yPos, int zPos, int zSpeed = -90, bool isFloor = false)
    {
		Actor mo = SpawnPlayerMissile(missileType);
		if (!mo) return null;
		
        mo.SetOrigin((xPos, yPos, zPos), false);

        double newz;
        if (isFloor)
            newz = mo.CurSector.LowestFloorAt((mo.pos.x, mo.pos.y));
        else
            newz = mo.CurSector.HighestCeilingAt((mo.pos.x, mo.pos.y)) - mo.Height;

        /*if (isFloor)
            newz = mo.CurSector.NextLowestFloorAt(mo.pos.x, mo.pos.y, mo.pos.z, mo.pos.z, FFCF_NOPORTALS) + mo.height;
        else
		    newz = mo.CurSector.NextHighestCeilingAt(mo.pos.x, mo.pos.y, mo.pos.z, mo.pos.z, FFCF_NOPORTALS) - mo.height;*/

        
        mo.SetOrigin((xPos, yPos, newz), false);
		//mo.SetZ(newz);

		mo.Vel.X = MinVel; // Force collision detection
        mo.Vel.Y = MinVel; // Force collision detection
		mo.Vel.Z = zSpeed;
		mo.CheckMissileSpawn (radius);

        return mo;
    }

    action Actor A_FireVerticalMissile(Class<Actor> missileType, int xSpread = 0, int ySpread = 0, int zSpeed = -90, int xMod = 0, int yMod = 0)
	{
        int xo = 0;
        int yo = 0;
        if (xSpread != 0)
		    xo = frandom(-xSpread, xSpread);
        if (ySpread != 0)
		    yo = frandom(-ySpread, ySpread);

		Vector3 spawnpos = Vec2OffsetZ(xo + xMod, yo + yMod, pos.z);
		
        let mo = A_FireVerticalMissilePos(missileType, spawnpos.X, spawnpos.Y, spawnpos.Z, zSpeed, false);

        return mo;
	}
}

class XRpgFighterWeapon : XRpgWeapon
{
	Default
	{
		Weapon.Kickback 150;
		Inventory.ForbiddenTo "XRpgClericPlayer", "XRpgMagePlayer";
	}

    action void A_CheckBerserk(bool isAltFire)
	{
		let xrpgPlayer = XRpgPlayer(player.mo);
		if (!xrpgPlayer)
			return;

		if (xrpgPlayer.IsSpellActive(SPELLTYPE_FIGHTER_BERSERK, true))
		{
			if (isAltFire)
				A_SetWeapState("BerserkAltFire");
			else
				A_SetWeapState("BerserkFire");
		}
	}
}

class XRpgClericWeapon : XRpgWeapon
{
	Default
	{
		Weapon.Kickback 150;
		Inventory.ForbiddenTo "XRpgFighterPlayer", "XRpgMagePlayer";
	}

    action bool A_IsSmite()
	{
		if (!player)
			return false;
		
		let clericPlayer = XRpgClericPlayer(player.mo);
        if (!clericPlayer)
            return false;
        
        return clericPlayer.IsSpellActive(SPELLTYPE_CLERIC_SMITE, true);
	}
}

class XRpgMageWeapon : XRpgWeapon
{
	Default
	{
		Weapon.Kickback 150;
		Inventory.ForbiddenTo "XRpgFighterPlayer", "XRpgClericPlayer";
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

class TimedActor : Actor
{
    int timeLimit;
    property TimeLimit : timeLimit;

    Default
    {
        TimedActor.TimeLimit 100;
    }

    override void Tick()
    {
        Super.Tick();

        TimeLimit--;
        if (TimeLimit < 1)
        {
            Destroy();
        }
    }
}

class PowerSpark : Actor
{
    Default
    {
        Radius 5;
		Mass 5;
		Projectile;
		-ACTIVATEPCROSS
		-ACTIVATEIMPACT
        -NOGRAVITY
		BounceType "HexenCompat";
		BounceFactor 0.3;
        Scale 0.25;
    }

    States
	{
	Spawn:
		SGSA FGHIJ 4;
		SGSA FGHIJ 4;
		SGSA FGHIJ 4;
		Stop;
	Death:
		Stop;
	}
}

const STUNSTARS_DIST = 16;
const STUNSTARS_VDIST = 16;
class StunStars : Bridge
{
    int oldSpeed;
	Default
	{
		Speed 0;
        Radius 0;
        Height 0;

		+NOBLOCKMAP +NOGRAVITY +NOCLIP +FLOAT
		+NOTELEPORT
        -SOLID
		-NOLIFTDROP
		-ACTLIKEBRIDGE
	}

	states
	{
	Spawn:
    See:
        TLGL A 2 A_BridgeInit;
        TLGL B 2 StarsInit;
		TLGL ABCDEABCDE 16 Bright A_CauseTargetPain;
		Stop;
	Death:
		TLGL A 2;
		TLGL A 300;
		Stop;
	}

    void StarsInit()
    {
        StopTarget();
    }

    void StopTarget()
    {
        if (!target || !target.bIsMonster || target.Health < 1)
            return;

        oldSpeed = target.Speed;
        target.A_SetSpeed(0);
    }

    void StartTarget()
    {
        if (!target || !target.bIsMonster || target.Health < 1)
            return;

        //If speed was 0 at the beginning, then something else will restore it before this one ends
        if (oldSpeed > 0)
            target.A_SetSpeed(oldSpeed);
    }

    action void A_CauseTargetPain()
    {
        if (target && target.bIsMonster && target.Health > 0)
            target.TriggerPainChance("Melee", true);
    }

    override void Tick()
    {
        if (target)
        {
            let zo = target.Height + STUNSTARS_VDIST;
            let newPos = target.Pos + (0,0, zo);
            SetOrigin(newPos, true);
        }

        Super.Tick();

        if (target.Health < 1)
            Destroy();
    }

    override void OnDestroy()
	{
        StartTarget();

		Super.OnDestroy();
	}
}