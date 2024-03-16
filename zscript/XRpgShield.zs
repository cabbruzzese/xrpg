const SHIELD_MAX_CHARGE = 40;
const SHIELD_MIN_CHARGE = 5;
const SHIELD_DEFENSE = 0.4;
const SHIELD_MISSILE_DEFENSE = 0;
const SHIELD_RANGE = 1.5 * DEFMELEERANGE;
const SHIELD_MANA_COST_MIN = 2;
const SHIELD_MANA_COST_MAX = 10;
const SHIELD_MANA_COST_MOD = 0.2;
const SHIELD_DAMAGE_MIN = 1;
const SHIELD_DAMAGE_MAX = 20;
const SHIELD_STR_MOD = 0.8;
const SHIELD_KNOCKBACK = 20;

const SHIELD_TYPE_ROUND = 0;
const SHIELD_TYPE_SPIKED = 1;
const SHIELD_TYPE_KITE = 2;
const SHIELD_TYPE_METAL = 3;

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

class XRpgFighterShieldWeapon : XRpgFighterWeapon
{
	States
	{
	Select:
		TNT1 A 0 A_ForwardToSelect;
	Deselect:
		TNT1 A 0 A_ForwardToDeselect;
	Ready:
		TNT1 A 0 A_ForwardToReady;
	Fire:
		TNT1 A 0 A_ForwardToFire;
	ShieldFrameAltFire:
        FSHL A 0 A_CheckShield;
	ShieldFrameShieldSpikedFire:
        FSHL A 1;
        FSHL BC 1;
        FSHL D 1 A_ShieldBashMelee;
    ShieldFrameAltHold:
        FSHL E 0 A_CheckShieldHold;
	ShieldFrameShieldSpikedHold:
		FSHL E 8 A_UseShield;
		FSHL E 4 A_Refire;
        FSHL E 4 A_CheckShieldCharged;
        FSHL DCBA 2;
        Goto Ready;
	ShieldFrameShieldKiteFire:
		FSH2 A 1;
        FSH2 BC 1;
        FSH2 D 1 A_ShieldBashMelee;
	ShieldFrameShieldKiteHold:
		FSH2 E 8 A_UseShield;
		FSH2 E 4 A_Refire;
        FSH2 E 4 A_CheckShieldCharged;
        FSH2 DCBA 2;
        Goto Ready;
	ShieldFrameShieldRoundFire:
		FSH3 A 1;
        FSH3 BC 1;
        FSH3 D 1 A_ShieldBashMelee;
	ShieldFrameShieldRoundHold:
		FSH3 E 8 A_UseShield;
		FSH3 E 4 A_Refire;
        FSH3 E 4 A_CheckShieldCharged;
        FSH3 DCBA 2;
        Goto Ready;
	ShieldFrameShieldMetalFire:
		FSH4 A 1;
        FSH4 BC 1;
        FSH4 D 1 A_ShieldBashMelee;
	ShieldFrameShieldMetalHold:
		FSH4 E 8 A_UseShield;
		FSH4 E 4 A_Refire;
        FSH4 E 4 A_CheckShieldCharged;
        FSH4 DCBA 2;
        Goto Ready;
    ShieldFrameShieldCharged:
        FSHL FGH 2 BRIGHT A_UseShield(false);
		FSHL F 2 BRIGHT A_Refire;
        FSHL G 2 BRIGHT A_ShieldFire;
    ShieldFrameShieldFireFinish:
		FSHL DCBA 2;
        Goto Ready;
	ShieldFrameFistFire:
		FPCH B 5 Offset (5, 40) A_Mirror;
		FPCH C 4 Offset (5, 40);
		FPCH D 4 Offset (5, 40) A_OffhandPunchAttack;
		FPCH C 4 Offset (5, 40);
		FPCH B 3 Offset (5, 40);
		FPCH B 3 Offset (5, 40) A_Refire;
		FPCH E 1 Offset (0, 150) A_RestoreMirror;
		Goto Ready;
	}

	action void A_ForwardToReady()
	{
		A_SetWeapState("WeaponReady");
	}
	action void A_ForwardToSelect()
	{
		A_SetWeapState("WeaponSelect");
	}
	action void A_ForwardToDeselect()
	{
		A_SetWeapState("WeaponDeselect");
	}
		action void A_ForwardToFire()
	{
		A_SetWeapState("WeaponFire");
	}

	action void A_CheckShield()
    {
        if (!player)
			return;

		let xrpgPlayer = XRpgFighterPlayer(player.mo);
        if (!xrpgPlayer)
            return;

		let shieldItem = xrpgPlayer.GetShield();
        if (!shieldItem)
        {
            A_SetWeapState("FistFire");
            return;
        }
		
		// console.printf(string.format("Shield Type: %d", shieldItem.ShieldType));
		switch (shieldItem.ShieldType)
		{
			case SHIELD_TYPE_SPIKED:
				A_SetWeapState("ShieldSpikedFire");
				return;
			case SHIELD_TYPE_KITE:
				A_SetWeapState("ShieldKiteFire");
				return;
			case SHIELD_TYPE_ROUND:
				A_SetWeapState("ShieldRoundFire");
				return;
			case SHIELD_TYPE_METAL:
				A_SetWeapState("ShieldMetalFire");
				return;
		}

		//default to fist
		A_SetWeapState("FistFire");
        return;
    }

	action void A_CheckShieldHold()
    {
        if (!player)
			return;

		let xrpgPlayer = XRpgFighterPlayer(player.mo);
        if (!xrpgPlayer)
            return;

		let shieldItem = xrpgPlayer.GetShield();
        if (!shieldItem)
        {
            A_SetWeapState("FistFire");
            return;
        }
		
		// console.printf(string.format("Shield Type Hold: %d", shieldItem.ShieldType));
		switch (shieldItem.ShieldType)
		{
			case SHIELD_TYPE_SPIKED:
				A_SetWeapState("ShieldSpikedHold");
				return;
			case SHIELD_TYPE_KITE:
				A_SetWeapState("ShieldKiteHold");
				return;
			case SHIELD_TYPE_ROUND:
				A_SetWeapState("ShieldRoundHold");
				return;
			case SHIELD_TYPE_METAL:
				A_SetWeapState("ShieldMetalHold");
				return;
		}

		//default to fist
		A_SetWeapState("FistFire");
        return;
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

        //Make sure weapon is not mirrored if shield is being used.
        A_RestoreMirror();

        if (checkCharged && shield.IsCharged() && shield.CanCharge)
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
        if (!shield || !shield.CanCharge)
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
        if (!shield || !shield.CanCharge)
            return;
        
        shield.ShootShield();
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

class ShieldFX : Actor
{
	Default
	{
		Speed 20;
		Damage 10;
		Projectile;
		+SPAWNSOUNDSOURCE
		+ZDOOMTRANS
		RenderStyle "Add";
		SeeSound "CentaurLeaderAttack";
		DeathSound "CentaurMissileExplode";
	}
	States
	{
	Spawn:
		CTFX A -1 Bright;
		Stop;
	Death:
		CTFX B 4 Bright;
		CTFX C 3 Bright;
		CTFX D 4 Bright;
		CTFX E 3 Bright;
		CTFX F 2 Bright;
		Stop;
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