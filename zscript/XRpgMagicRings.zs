class FireSparks: PowerSpark
{
	States
	{
	Spawn:
		FFSM ABCDE 4 Light("LittleFireLight1");
		FFSM ABCDE 4 Light("LittleFireLight2");
		FFSM AB 4 Light("LittleFireLight3");
		FFSM C 4 Light("LittleFireLight4");
		FFSM D 4 Light("LittleFireLight5");
		FFSM E 4;
		Stop;
	Death:
		Stop;
	}
}

class IceSparks: PowerSpark
{
	Default
	{
		Scale 1;
	}
	States
	{
	Spawn:
		TLGL ABCDE 4;
		TLGL ABCDE 4;
		TLGL ABCDE 4;
		Stop;
	Death:
		Stop;
	}
}

class LightningSparks: PowerSpark
{
	Default
	{
		Scale 0.25;
		Mass 1;
		BounceType "None";
		+NOGRAVITY;
	}
	States
	{
	Spawn:
		MLFX UTSRQPON 2;
		Stop;
	Death:
		Stop;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

		double randSpeed = random(-4.0, 4.0);
        A_ChangeVelocity(Vel.X * 2, Vel.Y * 2, randSpeed, CVF_REPLACE);
    }
}

const MAGICITEM_DAMAGE_THRESHOLD = 5;
const MAGICITEM_DAMAGE_MIN = 1;
const MAGICITEM_DAMAGE_MAX = 25;
class DamageMagicItem : XRpgMagicItem
{
	Name sparkType;
	property SparkType: sparkType;
	Name ringDamageType;
	property RingDamageType: ringDamageType;

	int damageMin;
	int damageMax;
	int damageThreshold;
	property DamageMin: damageMin;
	property DamageMax: damageMax;
	property DamageThreshold: damageThreshold;

	Default
	{
		XRpgEquipableItem.EffectMessage "$TXT_FIRERING_USE";

		DamageMagicItem.SparkType "FireSparks";
		DamageMagicItem.RingDamageType "Fire";
		DamageMagicItem.damageMin MAGICITEM_DAMAGE_MIN;
		DamageMagicItem.damageMax MAGICITEM_DAMAGE_MAX;
		DamageMagicItem.DamageThreshold MAGICITEM_DAMAGE_THRESHOLD;

		XRpgMagicItem.ModifyDamageBypass0 true;

		Inventory.PickupFlash "PickupFlash";
		Inventory.PickupSound "misc/p_pkup";
		Inventory.PickupMessage "$TXT_MAGICITEMPICKUP";
	}

	virtual void SpecialDamageEffect(int newDamage, Actor damageTarget)
	{		
	}

    override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if (!Owner)
			return;
		
		if (!IsActive())
			return;
		
		let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return;
		
		//Do ring damage effect
		if (!passive && damage > 0 && Owner && Owner.Player && Owner.Player.mo)
        {
			//ring damage cannot be over 15% of original damage
			int damageMaxTotal = Math.Clamp(damageMax, damageMin, damage * 0.15);
			int ringDamage = random[FireRingDamage](damageMin, damageMaxTotal);
			int totalRingDamage = 0;

			if (inflictor.bRipper)
			{
				//Lowest damage bonus ripper attacks
				ringDamage = damageMin;		

				//Only 5% chance for rippers to gain damage
				if (random(1,20) > 1)
					ringDamage = 0;
			} 
			
			
			if (damage < DamageThreshold)
			{
				//Lowest damage bonus for all low damage attacks
				ringDamage = 1;
			
				//20% chance for low damage attacks to gain damage
				if (random(1,5) < 5)
					ringDamage = 0;
			}
			
			//If damage is the same as the ring, just boost damage
			if (damageType == RingDamageType)
			{
				newdamage = damage + ringDamage;
				totalRingDamage = newdamage;
			}
			//If damage is a normal type, completely replace this attack with a new one
			else if (damageType == "Melee" || damageType == "Normal" || damageType == "None")
			{
				//Added special damage to 1 less than total (minimum 1)
				int totalDamage = damage + ringDamage;

				//Damage target with ring damage type and ring as inflictor so we can ignore second damage calculation
				source.DamageMobj(Owner, Owner, totalDamage, RingDamageType);

				//Give 1 point of normal damage to allow other effects
				newdamage = 0;

				totalRingDamage = totalDamage;
			}
			//If damage is a special type, apply extra damage of ring type
			else
			{
				//Damage target with ring damage type and ring as inflictor so we can ignore second damage calculation
				source.DamageMobj(Owner, Owner, ringDamage, RingDamageType);

				totalRingDamage = ringDamage;
			}

			ActorUtils.ThrowSparks(source, SparkType, ringDamage);
			SpecialDamageEffect(newDamage, source);
        }
	}
}

class FireRing : DamageMagicItem
{
	Default
	{
		Inventory.Icon "FRNGA0";
		Tag "$TAG_FIRERING";

		XRpgEquipableItem.EffectMessage "$TXT_FIRERING_USE";

		DamageMagicItem.SparkType "FireSparks";
		DamageMagicItem.RingDamageType "Fire";
		DamageMagicItem.damageMax 13; //Fire doubles damage, reduce total bonus
	}
	States
	{
	Spawn:
		FRNG A -1;
		Stop;
	}

	override void DoEquipBlend()
	{
		if (!Owner)
			return;
		
		Owner.A_SetBlend("99 11 11", 0.8, 40);
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

class IceRing : DamageMagicItem
{
	Default
	{
		Inventory.Icon "IRNGA0";
		Tag "$TAG_ICERING";

		XRpgEquipableItem.EffectMessage "$TXT_ICERING_USE";

		DamageMagicItem.SparkType "IceSparks";
		DamageMagicItem.RingDamageType "Ice";
	}
	States
	{
	Spawn:
		IRNG A -1;
		Stop;
	}

    override void DoEquipBlend()
	{
		if (!Owner)
			return;
		
		Owner.A_SetBlend("11 11 99", 0.8, 40);
	}

	override void AbsorbDamage (int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags)
    {
        if (!IsActive())
            return;
        
        if (damage > 0 && (damageType =='Ice'))
        {
            newdamage = damage / 2;
        }
    }
}

class LightningRing : DamageMagicItem
{
	Default
	{
		Inventory.Icon "LRNGA0";
		Tag "$TAG_LIGHTNINGRING";

		XRpgEquipableItem.EffectMessage "$TXT_LIGHTNINGRING_USE";

		DamageMagicItem.SparkType "LightningSparks";
		DamageMagicItem.RingDamageType "Electric";
	}
	States
	{
	Spawn:
		LRNG A -1;
		Stop;
	}

    override void DoEquipBlend()
	{
		if (!Owner)
			return;
		
		Owner.A_SetBlend("77 77 33", 0.8, 40);
	}

	override void SpecialDamageEffect(int newDamage, Actor damageTarget)
	{
		if (!damageTarget || !damageTarget.bIsMonster || damageTarget.Health < 1)
			return;
		
		//If hit is big enough
		if (newDamage < 2)
			return;

		//Force pain sound
		if (random[LightningRingChance](1,2) == 1)
			damageTarget.Howl();
	}


	override void AbsorbDamage (int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags)
    {
        if (!IsActive())
            return;
        
        if (damage > 0 && (damageType =='Electric'))
        {
            newdamage = damage / 2;
        }
    }
}

class ShadowRing : MagicArmor
{
	Default
	{
		Inventory.Icon "VRNGA0";
		Tag "$TAG_SHADOWRING";

		XRpgEquipableItem.EffectMessage "$TXT_SHADOWRING_USE";
	}
	States
	{
	Spawn:
		VRNG A -1;
		Stop;
	}

    override void DoEquipBlend()
	{
		if (!Owner)
			return;
		
		Owner.A_SetBlend("11 11 11", 0.8, 40);
	}

	override void Equip()
	{
		super.Equip();

		let xrpgPlayer = XRpgPlayer(Owner);
		if (!xrpgPlayer)
			return;

		let power = Powerup(Spawn ("RingInvisibilityPowerup"));
		power.CallTryPickup (xrpgPlayer);
	}

	override void Unequip()
	{
		super.Unequip();
		
		let xrpgPlayer = XRpgPlayer(Owner);
		if (!xrpgPlayer)
			return;

		let pItem = xrpgPlayer.FindInventory("RingInvisibilityPowerup");
		let powerupObj = Powerup(pItem);
		if (powerupObj)
			powerupObj.EndEffect();

		if (pItem)
		{
			xrpgPlayer.RemoveInventory(pItem);
		}
	}
}

class RingInvisibilityPowerup : PowerShadow
{
	Default
	{
		Powerup.Duration  0x7FFFFFFF;
	}
}