class MagicRing : XRpgMagicItem
{
    override void Equip()
	{
		if (!Owner)
			return;
		
		Owner.A_SetBlend("99 11 11", 0.8, 40);
	}
}

class FireSparks: PowerSpark
{
	States
	{
	Spawn:
		FFSM ABCDE 4;
		FFSM ABCDE 4;
		FFSM ABCDE 4;
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

const RING_DAMAGE_THRESHOLD = 5;
const RING_DAMAGEMIN = 1;
const RING_DAMAGEMAX = 25;
class DamageMagicRing : MagicRing
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

		DamageMagicRing.SparkType "FireSparks";
		DamageMagicRing.RingDamageType "Fire";
		DamageMagicRing.damageMin RING_DAMAGEMIN;
		DamageMagicRing.damageMax RING_DAMAGEMAX;
		DamageMagicRing.DamageThreshold RING_DAMAGE_THRESHOLD;
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
		
		if (!passive && damage > 0 && Owner && Owner.Player && Owner.Player.mo)
        {
			//Do ring damage effect
			int ringDamage = random[FireRingDamage](damageMin, damageMax);

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
				//Damage target with ring damage type, but do not let player items modify damage again (no enhance)
				source.DamageMobj(Owner, source, totalDamage, RingDamageType, DMG_NO_ENHANCE);

				//Give XP for hit since EXP item won't run
				if (source.bIsMonster)
					xrpgPlayer.GrantXP(totalDamage);

				//Do not give normal damage
				newdamage = 0;
			}
			//If damage is a special type, apply extra damage of ring type
			else
			{
				//Damage target with ring damage type, but do not let player items modify damage again (no enhance)
				source.DamageMobj(Owner, source, ringDamage, RingDamageType, DMG_NO_ENHANCE);

				//Give XP for hit at average ammount
				if (source.bIsMonster)
					xrpgPlayer.GrantXP(ringDamage);
			}

			ActorUtils.ThrowSparks(source, SparkType);
        }
	}
}

class FireRing : DamageMagicRing
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		Inventory.Icon "FRNGA0";
		Inventory.PickupSound "misc/p_pkup";
		Inventory.PickupMessage "$TXT_MAGICITEMPICKUP";
		Tag "$TAG_ARTIBOOSTARMOR";

		XRpgMagicItem.EffectMessage "$TXT_FIRERING_USE";

		DamageMagicRing.SparkType "FireSparks";
		DamageMagicRing.RingDamageType "Fire";
	}
	States
	{
	Spawn:
		FRNG A 4 Bright;
		Loop;
	}

    override void Equip()
	{
		if (!Owner)
			return;
		
		Owner.A_SetBlend("99 11 11", 0.8, 40);
	}
}

class IceRing : DamageMagicRing
{
	Default
	{
		Inventory.PickupFlash "PickupFlash";
		Inventory.Icon "IRNGA0";
		Inventory.PickupSound "misc/p_pkup";
		Inventory.PickupMessage "$TXT_MAGICITEMPICKUP";
		Tag "$TAG_ARTIBOOSTARMOR";

		XRpgMagicItem.EffectMessage "$TXT_ICERING_USE";

		DamageMagicRing.SparkType "IceSparks";
		DamageMagicRing.RingDamageType "Ice";
	}
	States
	{
	Spawn:
		IRNG A 4 Bright;
		Loop;
	}

    override void Equip()
	{
		if (!Owner)
			return;
		
		Owner.A_SetBlend("11 11 99", 0.8, 40);
	}
}