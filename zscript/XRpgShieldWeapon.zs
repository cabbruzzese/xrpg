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
const SHIELD_DAMAGE_CLERIC_MAX = 15;
const SHIELD_STR_MOD = 0.8;
const SHIELD_KNOCKBACK = 20;
const TORCH_DAMAGE_MIN = 15;
const TORCH_DAMAGE_MAX = 40;

const SHIELD_TYPE_ROUND = 0;
const SHIELD_TYPE_SPIKED = 1;
const SHIELD_TYPE_KITE = 2;
const SHIELD_TYPE_METAL = 3;
const SHIELD_TYPE_TORCH = 4;
const SHIELD_TYPE_LANTERN = 5;
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
	ShieldTorchFire:
		FTCH A 5;
		FTCH B 4;
		FTCH C 4 A_TorchAttack;
		FTCH D 4;
		FTCH E 3;
		TNT1 A 4;
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
			case SHIELD_TYPE_TORCH:
				A_SetWeapState("ShieldTorchFire");
				return;
			case SHIELD_TYPE_LANTERN:
				A_SetWeapState("Ready");
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
			case SHIELD_TYPE_TORCH:
				A_SetWeapState("ShieldTorchFire");
				return;
			case SHIELD_TYPE_LANTERN:
				A_SetWeapState("Ready");
				return;
		}

		//default to fist
		A_SetWeapState("FistFire");
        return;
    }

	action void A_TorchAttack()
	{
        A_FWeaponMeleeAttack(TORCH_DAMAGE_MIN, TORCH_DAMAGE_MAX, 0, 0.5, 0.85, 2*DEFMELEERANGE, "TorchPuff", false, 0);
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

class XRpgClericShieldWeapon : XRpgClericWeapon
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
        CSHL A 0 A_CheckShield;
    ShieldFrameAltHold:
        CSHL E 0 A_CheckShieldHold;
	ShieldFrameShieldKiteFire:
		CSH2 A 1;
        CSH2 BC 1;
        CSH2 D 1 A_ShieldBashMelee;
	ShieldFrameShieldKiteHold:
		CSH2 E 8 A_UseShield;
		CSH2 E 4 A_Refire;
        CSH2 E 4;
        CSH2 DCBA 2;
        Goto Ready;
	ShieldFrameShieldRoundFire:
		CSH3 A 1;
        CSH3 BC 1;
        CSH3 D 1 A_ShieldBashMelee;
	ShieldFrameShieldRoundHold:
		CSH3 E 8 A_UseShield;
		CSH3 E 4 A_Refire;
        CSH3 E 4;
        CSH3 DCBA 2;
        Goto Ready;
	ShieldFrameShieldMetalFire:
		CSH4 A 1;
        CSH4 BC 1;
        CSH4 D 1 A_ShieldBashMelee;
	ShieldFrameShieldMetalHold:
		CSH4 E 8 A_UseShield;
		CSH4 E 4 A_Refire;
        CSH4 E 4;
        CSH4 DCBA 2;
        Goto Ready;
	ShieldFrameSwing:
		TNT1 A 0 A_ForwardSwing;
	ShieldTorchFire:
		CTCH A 5;
		CTCH B 4;
		CTCH C 4 A_TorchAttack;
		CTCH D 4;
		CTCH E 3;
		TNT1 A 4;
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
	action void A_ForwardSwing()
	{
		A_SetWeapState("Swing");
	}

	action void A_CheckShield()
    {
        if (!player)
			return;

		let xrpgPlayer = XRpgClericPlayer(player.mo);
        if (!xrpgPlayer)
            return;

		let shieldItem = xrpgPlayer.GetShield();
        if (!shieldItem)
        {
            A_SetWeapState("Swing");
            return;
        }
		
		// console.printf(string.format("Shield Type: %d", shieldItem.ShieldType));
		switch (shieldItem.ShieldType)
		{
			case SHIELD_TYPE_KITE:
				A_SetWeapState("ShieldKiteFire");
				return;
			case SHIELD_TYPE_ROUND:
				A_SetWeapState("ShieldRoundFire");
				return;
			case SHIELD_TYPE_METAL:
				A_SetWeapState("ShieldMetalFire");
				return;
			case SHIELD_TYPE_TORCH:
				A_SetWeapState("ShieldTorchFire");
				return;
			case SHIELD_TYPE_LANTERN:
				A_SetWeapState("Ready");
				return;
		}

		//default to ready state
		A_SetWeapState("Swing");
        return;
    }

	action void A_CheckShieldHold()
    {
        if (!player)
			return;

		let xrpgPlayer = XRpgClericPlayer(player.mo);
        if (!xrpgPlayer)
            return;

		let shieldItem = xrpgPlayer.GetShield();
        if (!shieldItem)
        {
            A_SetWeapState("Swing");
            return;
        }
		
		// console.printf(string.format("Shield Type Hold: %d", shieldItem.ShieldType));
		switch (shieldItem.ShieldType)
		{
			case SHIELD_TYPE_KITE:
				A_SetWeapState("ShieldKiteHold");
				return;
			case SHIELD_TYPE_ROUND:
				A_SetWeapState("ShieldRoundHold");
				return;
			case SHIELD_TYPE_METAL:
				A_SetWeapState("ShieldMetalHold");
				return;
			case SHIELD_TYPE_TORCH:
				A_SetWeapState("ShieldTorchFire");
				return;
			case SHIELD_TYPE_LANTERN:
				A_SetWeapState("Ready");
				return;
		}

		//default to fist
		A_SetWeapState("Swing");
        return;
    }

	action void A_TorchAttack()
	{
        A_CWeaponMeleeAttack(TORCH_DAMAGE_MIN, TORCH_DAMAGE_MAX, 0, 0.5, 0.85, 2*DEFMELEERANGE, "TorchPuff", false, 0);
	}

	action void A_ShieldBashMelee()
    {
        A_CWeaponMeleeAttack(SHIELD_DAMAGE_MIN, SHIELD_DAMAGE_CLERIC_MAX, 0, SHIELD_STR_MOD, 0, SHIELD_RANGE, "AxePuff", false, SHIELD_KNOCKBACK);
    }

    action void A_UseShield(bool checkCharged = true)
    {
        if (!player)
			return;

		let xrpgPlayer = XRpgClericPlayer(player.mo);
        if (!xrpgPlayer)
            return;

        let shield = xrpgPlayer.GetShield();
        if (!shield)
        {
            A_SetWeapState("Ready");
            return;
        }

        //Make sure weapon is not mirrored if shield is being used.
        A_RestoreMirror();

        //console.printf("Charging Shield");
        shield.SetShieldTimeout();
    }
}

class TorchPuff : Actor
{
	Default
	{
		+NOBLOCKMAP +NOGRAVITY
		+PUFFONACTORS
		+BLOODLESSIMPACT
		RenderStyle "Translucent";
		Alpha 0.6;
		SeeSound "FighterHammerExplode";
		AttackSound "DemonMissileFire";
		ActiveSound "DemonMissileFire";
		VSpeed 1;
		DamageType "Fire";
		Scale 0.8;
	}
	States
	{
	Spawn:
		DRFX GHIJKL 2;
		Stop;
	}
}