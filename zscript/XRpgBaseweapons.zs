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
        +INVENTORY.RESTRICTABSOLUTELY
        XRpgWeapon.ChargeValue 0;
        XRpgWeapon.MaxCharge 0;
    }

	action void A_ChargeUp(int overchargeMax = 0, StateLabel overchargeState = "Hold")
	{
		invoker.ChargeValue++;

		if (invoker.chargeValue > invoker.MaxCharge)
        {
            if (overchargeMax > 0)
            {
                if (invoker.chargeValue > overchargeMax)
                {
                    invoker.chargeValue = invoker.MaxCharge;
                    A_SetWeapState(overchargeState);
                }
            }
            else
            {
                invoker.chargeValue = invoker.MaxCharge;
            }
        }
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
            angleSpread = frandom[BaseWeaponSpread](-angleMax, angleMax);

        if (zAngleMax != 0)
            zMod = frandom[BaseWeaponSpread](-zAngleMax, zAngleMax);
        
		Actor shard = SpawnPlayerMissile(missileType, angle + angleSpread + angleMod);
        if (shard)
        {
            shard.Vel.Z = shard.Vel.Z + zMod;
        }
	}

    action Actor A_FireVerticalMissilePos(Class<Actor> missileTypeName, int xPos, int yPos, int zPos, int zSpeed = -90, bool isFloor = false)
    {
		Actor mo = SpawnPlayerMissile(missileTypeName);
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

    action Actor A_FireVerticalMissile(Class<Actor> missileTypeName, int xSpread = 0, int ySpread = 0, int zSpeed = -90, int xMod = 0, int yMod = 0)
	{
        int xo = 0;
        int yo = 0;
        if (xSpread != 0)
		    xo = frandom[BaseWeaponSpread](-xSpread, xSpread);
        if (ySpread != 0)
		    yo = frandom[BaseWeaponSpread](-ySpread, ySpread);

		Vector3 spawnpos = Vec2OffsetZ(xo + xMod, yo + yMod, pos.z);
		
        let mo = A_FireVerticalMissilePos(missileTypeName, spawnpos.X, spawnpos.Y, spawnpos.Z, zSpeed, false);

        return mo;
	}

    action void A_ThrustTarget (Actor thrustTarget, double thrustSpeed, double thrustAngle)
    {
        if (!thrustTarget)
            return;
        
        if (thrustTarget.bDONTTHRUST)
            return;

        thrustTarget.Thrust(thrustSpeed, thrustAngle);
    }

    // Chance to play grunt sound.
    // Chance is percentage. -1 always plays
    action void A_GruntSound(int chance)
    {
        if (chance > 0 && random[GruntSound](1,100) > chance)
            return;

        A_StartSound ("*fistgrunt", CHAN_VOICE);
    }

    action void A_ChargeForward(int thrust)
	{
		Thrust(thrust, angle);
	}
}

class XRpgFighterWeapon : XRpgWeapon
{
    class<Actor> puffType;
    int weaponRange;
    int meleePush;
    bool MeleeAdjust;

    property Pufftype : puffType;
    property WeaponRange : weaponRange;
    property MeleePush : meleePush;
    property MeleeAdjust : meleeAdjust;

	Default
	{
		Weapon.Kickback 150;
		Inventory.ForbiddenTo "XRpgClericPlayer", "XRpgMagePlayer", "ClericPlayer", "MagePlayer";

        XRpgFighterWeapon.Pufftype "HammerPuff";
        XRpgFighterWeapon.WeaponRange 1.5 * DEFMELEERANGE;
        XRpgFighterWeapon.MeleePush 0;
        XRpgFighterWeapon.MeleeAdjust true;
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

    action void A_FWeaponMelee(int damageMin, int damageMax, int angleMod = 0, double strengthMod = 1.0, double magicMod = 0.0)
	{
        if (!player)
			return;
        
        Weapon weapon = player.ReadyWeapon;
        XRpgFighterWeapon weap = XRpgFighterWeapon(weapon);
        if (!weap)
            return;

		A_FWeaponMeleeAttack(damageMin, damageMax, angleMod, strengthMod, magicMod, 
                            weap.WeaponRange, weap.Pufftype, 
                            weap.MeleeAdjust, weap.MeleePush);
    }

    action void A_FWeaponMeleePuff(int damageMin, int damageMax, int angleMod = 0, double strengthMod = 1.0, double magicMod = 0.0, class<actor> puffClass = "HammerPuff")
	{
        if (!player)
			return;
        
        Weapon weapon = player.ReadyWeapon;
        XRpgFighterWeapon weap = XRpgFighterWeapon(weapon);
        if (!weap)
            return;

		A_FWeaponMeleeAttack(damageMin, damageMax, angleMod, strengthMod, magicMod, 
                            weap.WeaponRange, puffClass, 
                            weap.MeleeAdjust, weap.MeleePush);
    }

    action void A_FWeaponMeleeAttack(int damageMin, int damageMax, int angleMod, double strengthMod, double magicMod, int range, class<actor> puffClass, bool isAdjust, int push)
	{
		FTranslatedLineTarget t;

		if (!player)
			return;

		int damage = random[FWeeaponMelee](damageMin, damageMax);

		let xrpgPlayer = XRpgPlayer(player.mo);
        if (!xrpgPlayer)
        return;

        if (strengthMod > 0)
            damage += xrpgPlayer.GetStrength() * strengthMod;

        if (magicMod > 0)
            damage += xrpgPlayer.GetMagic() * magicMod;
  
		for (int i = 0; i < 16; i++)
		{
			for (int j = 1; j >= -1; j -= 2)
			{
				double ang = angle + j*i*(45. / 32) + angleMod;
				double slope = AimLineAttack(ang, range, t, 0., ALF_CHECK3D);
				if (t.linetarget != null)
				{
					LineAttack(ang, range, slope, damage, 'Melee', puffClass, true, t);
					if (t.linetarget != null)
					{
                        if (isAdjust)
						    AdjustPlayerAngle(t);
                        
						if (push != 0 && (t.linetarget.bIsMonster || t.linetarget.player))
						{
                            A_ThrustTarget(t.linetarget, push, t.attackAngleFromSource);
						}
						weaponspecial = false;
						return;
					}
				}
			}
		}
		// didn't find any targets in meleerange
		double slope = AimLineAttack (angle + angleMod, range, null, 0., ALF_CHECK3D);
		weaponspecial = (LineAttack (angle + angleMod, range, slope, damage, 'Melee', puffClass, true) == null);
	}

    action void A_CheckShield()
    {
        if (!player)
			return;

		let xrpgPlayer = XRpgFighterPlayer(player.mo);
        if (!xrpgPlayer)
            return;

        if (!xrpgPlayer.GetShield())
        {
            A_SetWeapState("FistFire");
            return;
        }
    }

    action void A_OffhandPunchAttack()
	{
        A_FWeaponMeleeAttack(1, 45, 0, 1, 0, 2*DEFMELEERANGE, "PunchPuff", false, 0);
	}
	
    action void A_ShieldBashMelee()
    {
        A_FWeaponMeleeAttack(SHIELD_DAMAGE_MIN, SHIELD_DAMAGE_MAX, 0, SHIELD_STR_MOD, 0, SHIELD_RANGE, "AxePuff", false, SHIELD_KNOCKBACK);
    }

    action void A_UseShield(bool checkCharged = true)
    {
        if (!player)
			return;

		let xrpgPlayer = XRpgFighterPlayer(player.mo);
        if (!xrpgPlayer)
            return;

        let shield = xrpgPlayer.GetShield();
        if (!shield)
        {
            A_SetWeapState("FistFire");
            return;
        }

        //Make sure weapon is no mirrored if shield is being used.
        A_RestoreMirror();

        if (checkCharged && shield.IsCharged())
        {
            A_SetWeapState("ShieldCharged");
            return;
        }

        //console.printf("Charging Shield");
        shield.SetShieldTimeout();
    }

    action void A_CheckShieldCharged()
    {
        if (!player)
			return;

		let xrpgPlayer = XRpgFighterPlayer(player.mo);
        if (!xrpgPlayer)
            return;

        let shield = xrpgPlayer.GetShield();
        if (!shield)
            return;
        
        //console.printf("Clearing Shield");
        shield.ClearShieldTimeout();
        shield.ClearCharge();
        A_SetWeapState("ShieldFireFinish");
    }

    action void A_ShieldFire()
    {
        if (!player)
			return;

		let xrpgPlayer = XRpgFighterPlayer(player.mo);
        if (!xrpgPlayer)
            return;

        //console.printf("Try to fire");

        let shield = xrpgPlayer.GetShield();
        if (!shield)
            return;
        
        shield.ShootShield();
    }

    action void A_FighterChargeUp(int overchargeMax = 0, StateLabel overchargeState = "Hold", bool skipOnBerserk = false)
	{
        if (skipOnBerserk)
        {
            let xrpgPlayer = XRpgPlayer(player.mo);
            if (!xrpgPlayer)
                return;

            if (xrpgPlayer.IsSpellActive(SPELLTYPE_FIGHTER_BERSERK, true))
            {
                invoker.chargeValue = invoker.MaxCharge;
                A_SetWeapState(overchargeState);
                return;
            }
        }

        A_ChargeUp(overchargeMax, overchargeState);
	}
}

class XRpgClericWeapon : XRpgWeapon
{
	Default
	{
		Weapon.Kickback 150;
		Inventory.ForbiddenTo "XRpgFighterPlayer", "XRpgMagePlayer", "FighterPlayer", "MagePlayer";
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
		Inventory.ForbiddenTo "XRpgFighterPlayer", "XRpgClericPlayer", "FighterPlayer", "ClericPlayer";
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

    action void A_NextSpell()
    {
        if (player == null)
			return;

        A_GetNextSpell();
    }
    action void A_PrevSpell()
    {
        if (player == null)
			return;

        A_GetPrevSpell();
    }

	action void A_GetNextSpell() 
	{
		if (!player)
            return;

        let magePlayer = XRpgMagePlayer(player.mo);
        if (!magePlayer || !magePlayer.ActiveSpell)
			return;

		int currentSpellType = magePlayer.ActiveSpell.SpellType;
		
		let availSpells = magePlayer.GetAvailSpells();

		if (availSpells.Size() < 2)
		{
			return;
		}

		int sPos = 0;
		for (int i = 0; i < availSpells.Size(); i++)
		{
			if (availSpells.GetItem(i).SpellType == currentSpellType)
				sPos = i;
		}

		sPos++;
		if (sPos == availSpells.Size())
			sPos = 0;
		
        magePlayer.SetActiveSpell(availSpells.GetItem(sPos));
	}
	action void A_GetPrevSpell() 
	{
        if (!player)
            return;

        let magePlayer = XRpgMagePlayer(player.mo);
        if (!magePlayer || !magePlayer.ActiveSpell)
			return;

        let activeSpell = magePlayer.ActiveSpell;
		int currentSpellType = activeSpell.SpellType;
		
		let availSpells = magePlayer.GetAvailSpells();

		if (availSpells.Size() < 2)
		{
			return;
		}

		int sPos = 0;
		for (int i = 0; i < availSpells.Size(); i++)
		{
			if (availSpells.GetItem(i).SpellType == currentSpellType)
				sPos = i;
		}

		sPos--;
		if (sPos < 0)
			sPos = availSpells.Size() - 1;
		
        magePlayer.SetActiveSpell(availSpells.GetItem(sPos));
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

            if (target is "Centaur" && target.Health > 0 && target.bInvulnerable)
            {
                target.bInvulnerable = false;
            }
        }

        Super.Tick();

        if (target && target.Health < 1)
            Destroy();
    }

    override void OnDestroy()
	{
        StartTarget();

		Super.OnDestroy();
	}
}