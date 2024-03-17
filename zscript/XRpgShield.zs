class MagicShield : XRpgShieldItem
{
    int shieldCharge;
    int shieldTimeout;
	bool canCharge;
	int shieldType;

    property ShieldCharge : shieldCharge;
    property ShieldTimeout : shieldTimeout;
	property CanCharge: canCharge;
	property ShieldType: shieldType;

	void AddCharge(int amount)
    {
        ShieldCharge += amount;

        if (ShieldCharge > SHIELD_MAX_CHARGE)
            ShieldCharge = SHIELD_MAX_CHARGE;
    }

    void ClearCharge()
    {
        ShieldCharge = 0;
    }

    virtual bool IsCharged()
    {
        return false;
    }

    virtual void ShootShield()
    {
    }

    override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if (!Owner)
			return;

		if (!inflictor)
			return;
		
		let xrpgPlayer = XRpgFighterPlayer(Owner);
        if (!xrpgPlayer)
			return;
		
        if (!IsShieldTimeoutActive())
            return;

		if (passive && damage > 0 && Owner && Owner.Player && Owner.Player.mo)
        {
			newdamage = double(damage) * SHIELD_DEFENSE;
            
            Owner.A_StartSound("FlechetteBounce", CHAN_VOICE);
        }
	}

    bool IsShieldTimeoutActive()
	{
		return ShieldTimeout > 0;
	}

	void SetShieldTimeout(int ammount = 20)
	{
		ShieldTimeout = ammount;
	}

	void ClearShieldTimeout()
	{
		ShieldTimeout = 0;
	}

    override void Tick()
	{
		Super.Tick();

		if (!Owner)
			return;
		let xrpgPlayer = XRpgFighterPlayer(Owner);
        if (!xrpgPlayer)
			return;

		if (ShieldTimeout > 0)
		{
			ShieldTimeout--;

			xrpgPlayer.bDONTTHRUST = true;
		}
		else
		{
			xrpgPlayer.bDONTTHRUST = false;
		}    
	}
}

class XRpgShield : MagicShield replaces CentaurShield
{
	Default
	{
		+INVENTORY.RESTRICTABSOLUTELY
        Inventory.ForbiddenTo "XRpgClericPlayer", "XRpgMagePlayer", "ClericPlayer", "MagePlayer";

		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "FSHLK0";
		Inventory.PickupSound "misc/p_pkup";
		
		Tag "$TAG_CENTAURSHIELD";
		Inventory.PickupMessage "$TXT_SHIELDITEM";
        XRpgEquipableItem.EffectMessage "$TXT_CENTAURSHIELD_USE";
				
		XRpgEquipableItem.ArmorBonus 5;
		MagicShield.CanCharge true;
		MagicShield.ShieldType SHIELD_TYPE_SPIKED;
	}

	States
	{
	Spawn:
		CTDP ABCDEFGHIJ 3;
		CTDP J -1;
		Stop;
	}

    override bool IsCharged()
    {
        return ShieldCharge >= SHIELD_MIN_CHARGE;
    }

    override void ShootShield()
    {
        if (!Owner)
			return;

        let xrpgPlayer = XRpgFighterPlayer(Owner);
        if (!xrpgPlayer)
			return;
        
        if (ShieldCharge < SHIELD_MIN_CHARGE)
            return;

        let mo = xrpgPlayer.SpawnPlayerMissile ("ShieldFX");
        if (mo)
            mo.SetDamage(mo.Damage + ShieldCharge);

        ClearCharge();
    }

    override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if (!Owner)
			return;

		if (!inflictor)
			return;
		
		let xrpgPlayer = XRpgFighterPlayer(Owner);
        if (!xrpgPlayer)
			return;
		
        if (!IsShieldTimeoutActive())
            return;

		if (passive && damage > 0 && Owner && Owner.Player && Owner.Player.mo)
        {
			int manaCost = damage * SHIELD_MANA_COST_MOD;
			manaCost = max(manaCost, SHIELD_MANA_COST_MIN);
			manaCost = min(manaCost, SHIELD_MANA_COST_MAX);
            if (inflictor.bMissile && xrpgPlayer.CheckAllMana(manaCost, manaCost))
            {
				xrpgPlayer.DepleteAllMana(manaCost, manaCost);
                int chargeVal = Max(damage, 1);
			    AddCharge(chargeVal);

                newdamage = double(damage) * SHIELD_MISSILE_DEFENSE;

				xrpgPlayer.DoBlend("99 99 99", 0.6, 30);
            }
            else
            {
                newdamage = double(damage) * SHIELD_DEFENSE;
            }

            Owner.A_StartSound("FlechetteBounce", CHAN_VOICE);
        }
	}
}

class FalconLargeShield : MagicShield
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "AR_2A0";
		Inventory.PickupSound "misc/p_pkup";
		
		Tag "$TAG_FALCONSHIELD";
        XRpgEquipableItem.EffectMessage "$TXT_FALCONSHIELD_USE";
				
		XRpgEquipableItem.ArmorBonus 20;
		XRpgEquipableItem.SpeedBoost -0.25;
		XRpgArmorItem.IsHeavy true;
		MagicShield.ShieldType SHIELD_TYPE_KITE;
	}
	States
	{
	Spawn:
		AR_2 A -1;
		Stop;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, 12);
    }
}

class RoundShield : MagicShield
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "FSH3F0";
		Inventory.PickupSound "misc/p_pkup";
		
		Tag "$TAG_ROUNDSHIELD";
        XRpgEquipableItem.EffectMessage "$TXT_ROUNDSHIELD_USE";
				
		XRpgEquipableItem.ArmorBonus 10;
		MagicShield.ShieldType SHIELD_TYPE_ROUND;
	}
	States
	{
	Spawn:
		FSH3 F -1;
		Stop;
	}

	override void AbsorbDamage (int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags)
    {
        if (!IsActive())
            return;
        
        if (damage > 0 && (damageType =='Fire'))
        {
            newdamage = damage * 1.5;
        }
    }

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, -12);
    }
}

class SilverSmallShield : MagicShield
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.Icon "FSH4F0";
		Inventory.PickupSound "misc/p_pkup";
		
		Tag "$TAG_SILVERSHIELD";
        XRpgEquipableItem.EffectMessage "$TXT_SILVERSHIELD_USE";
				
		XRpgEquipableItem.ArmorBonus 10;
		MagicShield.ShieldType SHIELD_TYPE_METAL;
	}
	States
	{
	Spawn:
		FSH4 F -1;
		Stop;
	}

	override void AbsorbDamage (int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags)
    {
        if (!IsActive())
            return;
        
        if (damage > 0 && (damageType =='Fire'))
        {
            newdamage = damage / 2;
        }
    }

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, -12);
    }
}