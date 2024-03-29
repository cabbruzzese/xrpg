class MagicArmor : XRpgMagicItem
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.PickupSound "misc/p_pkup";
	}
    override void DoEquipBlend()
	{
		if (!Owner)
			return;
		
		Owner.A_SetBlend("11 99 99", 0.8, 40);
	}

    override void Equip()
	{
		super.Equip();

		if (!Owner)
			return;

        let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return;
        
		xrpgPlayer.ApplyDexArmorBonus();
		xrpgPlayer.ApplyMovementBonus();
	}

    override void Unequip()
    {
		super.Unequip();

        let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return;
        
		xrpgPlayer.ApplyDexArmorBonus();
		xrpgPlayer.ApplyMovementBonus();
    }
}

//-----------------------------------
// Magic Items
//-----------------------------------

class DragonBracers : MagicArmor
{
	Default
	{
		Inventory.Icon "ARTIBRAC";
		Tag "$TAG_DRAGONBRACERS";

        XRpgEquipableItem.EffectMessage "$TXT_DRAGONBRACERS_USE";
		XRpgEquipableItem.ArmorBonus 10;
	}
	States
	{
	Spawn:
		BRAC D 4 Bright;
		Loop;
	}

    override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, 32);
    }
}

class BootsOfSpeed : MagicArmor
{
	Default
	{
		Inventory.Icon "ARTISPED";
		Tag "$TAG_BOOTSOFSPEED";

        XRpgEquipableItem.EffectMessage "$TXT_BOOTSOFSPEED_USE";
		XRpgEquipableItem.SpeedBoost 0.3;
	}
	States
	{
	Spawn:
		SPED B 4 Bright;
		Loop;
	}

	override void DoEquipBlend()
	{
		if (!Owner)
			return;
		
		Owner.A_SetBlend("99 99 55", 0.8, 40);
	}

    override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, 20);
    }
}

const PHOENIXBRACERS_COOLDOWN_MAX = 600;
const PHOENIXBRACERS_HEALTH_MIN = 20;
const PHOENIXBRACERS_GIVE_HEALTH = 80;
class PhoenixBracers : MagicArmor
{
	Default
	{
		Inventory.Icon "PHXBA0";
		Tag "$TAG_PHOENIXBRACERS";

        XRpgEquipableItem.EffectMessage "$TXT_PHOENIXBRACERS_USE";

		XRpgEquipableItem.MaxCooldown PHOENIXBRACERS_COOLDOWN_MAX;
	}
	States
	{
	Spawn:
		PHXB A -1;
		Loop;
	}

    override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, -8);
    }

	override void AbsorbDamage (int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags)
    {        
        if (!Owner)
			return;
		
		let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return;

        if (!IsActive())
            return;

        if (!IsCooldownDone())
            return;

		if (damage > 0 && Owner && Owner.Player && Owner.Player.mo)
        {
			//reduce all damage if below threshold
			if (xrpgPlayer.Health < PHOENIXBRACERS_HEALTH_MIN)
			{
				newdamage = damage / 4;

				//respawn if dead sometimes
				if (xrpgPlayer.Health < damage)
				{
					if (random[PhoenixBracers](1,100) < 50)
					{
						newdamage = 0;

						int healNum = min(PHOENIXBRACERS_GIVE_HEALTH, xrpgPlayer.MaxHealth);
						xrpgPlayer.A_SetHealth(healNum);

						xrpgPlayer.A_SetBlend("77 66 22", 0.8, 40);
						xrpgPlayer.TeleportToStart(false);

						StartCooldown();
					}
				}
			}

        }
    }
}

const SHIELDBRACELET_COOLDOWN_MAX = 15;
class ShieldBracelet : MagicArmor
{
	Default
	{
		Inventory.Icon "MBRCA0";
		Tag "$TAG_SHIELDBRACELET";

        XRpgEquipableItem.EffectMessage "$TXT_SHIELDBRACELET_USE";

		XRpgEquipableItem.MaxCooldown SHIELDBRACELET_COOLDOWN_MAX;
	}
	States
	{
	Spawn:
		MBRC A -1;
		Loop;
	}

    override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, -4);
    }

	override void AbsorbDamage (int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags)
    {        
        if (!Owner)
			return;
		
		let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return;

        if (!IsActive())
            return;

        if (!IsCooldownDone())
            return;

		if (damage > 0 && Owner && Owner.Player && Owner.Player.mo)
        {
			//reduce all damage if below threshold
			if (random[ShieldBraceletChance](1,10) < 10)
			{				
				int cost = Max(damage / 3, 1);

				let ammo1 = Inventory(xrpgPlayer.FindInventory('Mana1'));
				let ammo2 = Inventory(xrpgPlayer.FindInventory('Mana2'));

				if (ammo1.Amount >= cost && ammo2.Amount >= cost)
				{
					newdamage = 0;
					xrpgPlayer.A_StartSound("BishopBlur", CHAN_BODY);

					//Reduce mana, but never go below 0
					ammo1.Amount = Max(ammo1.Amount - cost, 0);
					ammo2.Amount = Max(ammo2.Amount - cost, 0);

					xrpgPlayer.A_SetBlend("44 22 44", 0.8, 40);

					StartCooldown();
				}
			}

        }
    }
}

//-----------------------------------------
// Body Armor
//-----------------------------------------

class EttinArmor : XRpgBodyItem
{
	Default
	{
		Inventory.Icon "ABDYH0";
		
		Tag "$TAG_ETTINARMOR";
        XRpgEquipableItem.EffectMessage "$TXT_ARMOR_ETTINARMOR";
				
		XRpgEquipableItem.ArmorBonus 10;
		XRpgEquipableItem.SpeedBoost -0.15;
		XRpgArmorItem.IsHeavy true;
	}
	States
	{
	Spawn:
		ABDY ABCDEFG 4;
		ABDY G -1;
		Stop;
	}
}

class MeshBodyArmor : XRpgBodyItem
{
	Default
	{
		Inventory.Icon "AR_1A0";
		
		Tag "$TAG_MESHARMOR";
        XRpgEquipableItem.EffectMessage "$TXT_MESHARMOR_USE";
				
		XRpgEquipableItem.ArmorBonus 10;
		XRpgArmorItem.IsHeavy true;
	}
	States
	{
	Spawn:
		AR_1 A -1;
		Stop;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, 16);
    }
}

class LeatherBodyArmor : XRpgBodyItem
{
	Default
	{
		Inventory.Icon "LTHRA0";
		
		Tag "$TAG_LEATHERARMOR";
        XRpgEquipableItem.EffectMessage "$TXT_LEATHERARMOR_USE";
				
		XRpgEquipableItem.ArmorBonus 5;
		XRpgArmorItem.IsLight true;
	}
	States
	{
	Spawn:
		LTHR A -1;
		Stop;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, -14);
    }
}

class MagicRobes : XRpgBodyItem
{
	Default
	{
		Inventory.Icon "ROBEB0";
		
		Tag "$TAG_MAGICROBES";
        XRpgEquipableItem.EffectMessage "$TXT_MAGICROBES_USE";
				
		XRpgEquipableItem.SpeedBoost -0.10;

		XRpgEquipableItem.ArmorBonus 5;
		XRpgArmorItem.mageArmorOverride 15;
		XRpgArmorItem.IsLight true;
	}
	States
	{
	Spawn:
		ROBE A -1;
		Stop;
	}

	override void AbsorbDamage (int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags)
    {        
        if (!Owner)
			return;
		
		let xrpgPlayer = XRpgMagePlayer(Owner);
        if (!xrpgPlayer)
			return;

        if (!IsActive())
            return;

        if (!IsCooldownDone())
            return;

		if (damage > 0 && Owner && Owner.Player && Owner.Player.mo)
        {
			Actor targetMonster;
			if (inflictor && inflictor.bIsMonster)
				targetMonster = inflictor;
			else if (source && source.bIsMonster)
				targetMonster = source;
			else if (inflictor && inflictor.target && inflictor.target.bIsMonster)
				targetMonster = inflictor.target;

			if (!targetMonster)
				return;

			//Randomly absorb into mana
			if (random[BishopGem](1,3) == 1)
			{
				newdamage = damage / 3;

				int absorb = Math.Clamp(damage / 4, 1, 9);

				xrpgPlayer.GiveInventory("Mana1", absorb);
				xrpgPlayer.GiveInventory("Mana2", absorb);
				xrpgPlayer.A_StartSound("WraithAttack", CHAN_BODY);

				StartCooldown();

				xrpgPlayer.A_SetBlend("77 11 77", 0.8, 40);
			}
        }
    }
}

class DragonScaleArmor : XRpgBodyItem
{
	Default
	{
		Inventory.Icon "DSCLB0";
		
		Tag "$TAG_DRAGONSCALE";
        XRpgEquipableItem.EffectMessage "$TXT_DRAGONSCALE_USE";
				
		XRpgEquipableItem.SpeedBoost -0.15;
		XRpgEquipableItem.ArmorBonus 15;
		XRpgArmorItem.IsHeavy true;
	}
	States
	{
	Spawn:
		DSCL A -1;
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
}

class PlateMail : XRpgBodyItem
{
	Default
	{
		Inventory.Icon "PLTEB0";
		
		Tag "$TAG_PLATEMAIL";
        XRpgEquipableItem.EffectMessage "$TXT_PLATEMAIL_USE";
				
		XRpgEquipableItem.SpeedBoost -0.25;
		XRpgEquipableItem.ArmorBonus 20;
		XRpgArmorItem.IsHeavy true;
		XRpgArmorItem.IsPlate true;
	}
	States
	{
	Spawn:
		PLTE A -1;
		Stop;
	}
}

class HalfPlate : XRpgBodyItem
{
	Default
	{
		Inventory.Icon "PLTHB0";
		
		Tag "$TAG_HALFPLATE";
        XRpgEquipableItem.EffectMessage "$TXT_HALFPLATE_USE";
				
		XRpgEquipableItem.ArmorBonus 10;
		XRpgArmorItem.IsPlate true;
	}
	States
	{
	Spawn:
		PLTH A -1;
		Stop;
	}
}

//--------------------------------------------------
// Helmets
//--------------------------------------------------
class PlatinumHelmet : XRpgHelmetItem
{
	Default
	{
		Inventory.Icon "AR_3A0";
		
		Tag "$TAG_PLATINUMHELM";
        XRpgEquipableItem.EffectMessage "$TXT_PLATINUMHELM_USE";
				
		XRpgEquipableItem.ArmorBonus 5;
		XRpgArmorItem.IsHeavy true;
	}
	States
	{
	Spawn:
		AR_3 A -1;
		Loop;
	}

    override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, 32);
    }
}

class SuitHelmet : XRpgHelmetItem
{
	Default
	{
		+INVENTORY.RESTRICTABSOLUTELY
        Inventory.ForbiddenTo "XRpgClericPlayer", "XRpgMagePlayer", "ClericPlayer", "MagePlayer";

		Inventory.Icon "SUITL0";
		
		Tag "$TAG_SUITHELMET";
        XRpgEquipableItem.EffectMessage "$TXT_ARMOR_SUITHELMET";
				
		XRpgEquipableItem.SpeedBoost -0.15;
		XRpgEquipableItem.ArmorBonus 15;
		XRpgArmorItem.IsHeavy true;
		XRpgArmorItem.IsPlate true;

		XRpgHelmetItem.VisorImage "VSRHLM1";
	}
	States
	{
	Spawn:
		ZSUI F 4;
		ZSUI F -1;
		Stop;
	}
}

class WraithHelmet : XRpgHelmetItem
{
	Default
	{
		Inventory.Icon "AHLMA0";
		
		Tag "$TAG_WRAITHHELM";
        XRpgEquipableItem.EffectMessage "$TXT_ARMOR_WRAITHHELM";
				
		XRpgEquipableItem.ArmorBonus 10;
		XRpgArmorItem.mageArmorOverride 5;
	}
	States
	{
	Spawn:
		AHLM ABCDA 4;
		AHLM A -1;
		Stop;
	}
}

class MetalCap : XRpgHelmetItem
{
	Default
	{
		Inventory.Icon "CAPHA0";
		
		Tag "$TAG_METALCAP";
        XRpgEquipableItem.EffectMessage "$TXT_METALCAP_USE";
				
		XRpgEquipableItem.ArmorBonus 5;
	}
	States
	{
	Spawn:
		CAPH A -1;
		Stop;
	}
}

class WingedHelmet : XRpgHelmetItem
{
	Default
	{
		Inventory.Icon "CAPWA0";
		
		Tag "$TAG_WINGEDHELM";
        XRpgEquipableItem.EffectMessage "$TXT_WINGEDHELM_USE";
				
		XRpgEquipableItem.SpeedBoost 0.15;
		XRpgEquipableItem.ArmorBonus 5;
		XRpgArmorItem.IsLight true;
	}
	States
	{
	Spawn:
		CAPW A -1;
		Loop;
	}

    override void PostBeginPlay()
	{
		Super.PostBeginPlay();

        A_SpriteOffset(0, -8);
    }
}