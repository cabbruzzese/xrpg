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
	}
	States
	{
	Spawn:
		MLFX NOPQRSTU 4;
		Stop;
	Death:
		Stop;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

		double randSpeed = random(60, 120) / 10;
        A_ChangeVelocity(Vel.X, Vel.Y, randSpeed, CVF_REPLACE);
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
		XRpgMagicItem.EffectMessage "$TXT_FIRERING_USE";

		DamageMagicItem.SparkType "FireSparks";
		DamageMagicItem.RingDamageType "Fire";
		DamageMagicItem.damageMin MAGICITEM_DAMAGE_MIN;
		DamageMagicItem.damageMax MAGICITEM_DAMAGE_MAX;
		DamageMagicItem.DamageThreshold MAGICITEM_DAMAGE_THRESHOLD;
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
			}
			//If damage is a normal type, completely replace this attack with a new one
			else if (damageType == "Melee" || damageType == "Normal" || damageType == "None")
			{
				int totalDamage = damage + ringDamage;

				//Damage target with ring damage type and ring as inflictor so we can ignore second damage calculation
				source.DamageMobj(Owner, self, totalDamage, RingDamageType, 0);

				//Do not give normal damage
				newdamage = 0;
			}
			//If damage is a special type, apply extra damage of ring type
			else
			{
				//Damage target with ring damage type and ring as inflictor so we can ignore second damage calculation
				source.DamageMobj(Owner, self, ringDamage, RingDamageType, 0);
			}

			ActorUtils.ThrowSparks(source, SparkType);
        }
	}
}

class FireRing : DamageMagicItem
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		Inventory.Icon "FRNGA0";
		Inventory.PickupSound "misc/p_pkup";
		Inventory.PickupMessage "$TXT_MAGICITEMPICKUP";
		Tag "$TAG_ARTIBOOSTARMOR";

		XRpgMagicItem.EffectMessage "$TXT_FIRERING_USE";

		DamageMagicItem.SparkType "FireSparks";
		DamageMagicItem.RingDamageType "Fire";
		DamageMagicItem.damageMax 13; //Fire doubles damage, reduce total bonus
	}
	States
	{
	Spawn:
		FRNG A 4 Bright;
		Loop;
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

		console.printf(damageType);
    }
}

class IceRing : DamageMagicItem
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		Inventory.Icon "IRNGA0";
		Inventory.PickupSound "misc/p_pkup";
		Inventory.PickupMessage "$TXT_MAGICITEMPICKUP";
		Tag "$TAG_ARTIBOOSTARMOR";

		XRpgMagicItem.EffectMessage "$TXT_ICERING_USE";

		DamageMagicItem.SparkType "IceSparks";
		DamageMagicItem.RingDamageType "Ice";
	}
	States
	{
	Spawn:
		IRNG A 4 Bright;
		Loop;
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
		Inventory.PickupFlash "PickupFlash";
		Inventory.Icon "LRNGA0";
		Inventory.PickupSound "misc/p_pkup";
		Inventory.PickupMessage "$TXT_MAGICITEMPICKUP";
		Tag "$TAG_ARTIBOOSTARMOR";

		XRpgMagicItem.EffectMessage "$TXT_LIGHTNINGRING_USE";

		DamageMagicItem.SparkType "LightningSparks";
		DamageMagicItem.RingDamageType "Electric";
		DamageMagicItem.damageMax 30;
	}
	States
	{
	Spawn:
		LRNG A 4 Bright;
		Loop;
	}

    override void DoEquipBlend()
	{
		if (!Owner)
			return;
		
		Owner.A_SetBlend("77 77 33", 0.8, 40);
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