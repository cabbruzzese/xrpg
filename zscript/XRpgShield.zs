class MagicShield : XRpgShieldItem
{
    int shieldCharge;
    int shieldTimeout;
	bool canCharge;
	int shieldType;
	bool mageCanUse;

    property ShieldCharge : shieldCharge;
    property ShieldTimeout : shieldTimeout;
	property CanCharge: canCharge;
	property ShieldType: shieldType;
	property MageCanUse:mageCanUse;

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
		
		let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return;
		
		//Only apply if activated
		if (!IsActive())
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
		let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return;

		//Only apply if activated
		if (!IsActive())
			return;

		if (ShieldTimeout > 0)
		{
			ShieldTimeout--;

			xrpgPlayer.bDONTTHRUST = true;
			//console.printf("Don't thrust!");
		}
		else
		{
			//console.printf("Don't thrust again!");
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

		Inventory.Icon "FSHLK0";
		
		Tag "$TAG_CENTAURSHIELD";
		Inventory.PickupMessage "$TXT_SHIELDITEM";
        XRpgEquipableItem.EffectMessage "$TXT_CENTAURSHIELD_USE";
				
		XRpgEquipableItem.ArmorBonus 5;
		MagicShield.CanCharge true;
		MagicShield.ShieldType SHIELD_TYPE_SPIKED;
		XRpgArmorItem.IsHeavy true;
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

		if (!IsActive())
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
		Inventory.Icon "AR_2A0";
		
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
		Inventory.Icon "FSH3F0";
		
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
		Inventory.Icon "FSH4F0";
		
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
            newdamage = damage * 0.70;

			//if shield up, absorb most fire damage
			if (IsShieldTimeoutActive())
            	newdamage = damage / 12;

        }
    }

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, -12);
    }
}

class OffhandTorch : MagicShield replaces ArtiTorch
{
	Default
	{
		Inventory.Icon "ARTITRCH";
		
		Tag "$TAG_ARTITORCH";
        XRpgEquipableItem.EffectMessage "$TXT_TORCH_USE";
		Inventory.PickupMessage "$TXT_TORCH_PICKUP";
				
		MagicShield.ShieldType SHIELD_TYPE_TORCH;

		MagicShield.MageCanUse true;
	}
	States
	{
	Spawn:
		TRCH ABC 3 Bright;
		Loop;
	}

	override void AbsorbDamage (int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags)
    {
        return;
    }

	override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		return;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, 19);
    }

	const OFFHANDTORCH_LIGHT_MIN = 100;
	const OFFHANDTORCH_LIGHT_MAX = 125;
	const OFFHANDTORCH_LIGHT_NAME = "OffhandTorch";

    override void Equip()
	{
		super.Equip();

		if (!Owner)
			return;

		Owner.A_AttachLight(OFFHANDTORCH_LIGHT_NAME, DynamicLight.RandomFlickerLight, "99 66 11", OFFHANDTORCH_LIGHT_MIN, OFFHANDTORCH_LIGHT_MAX);
	}

    override void Unequip()
    {
		super.Unequip();

        if (!Owner)
			return;

		Owner.A_RemoveLight(OFFHANDTORCH_LIGHT_NAME);
    }
}