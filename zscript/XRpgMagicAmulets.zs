const AMULET_TIMEOUT_MAX = 14;
class MagicAmulet : XRpgNeckItem
{
    int timer;

    int timerMax;
    property TimerMax: timerMax;

    Default
    {
        MagicAmulet.timerMax AMULET_TIMEOUT_MAX;
    }

    override void Tick()
	{
		super.Tick();

        timer += 1;

        if (timer == TimerMax)
        {
            timer = 0;

            if (!IsActive())
                return;

            ApplyEffect();
        }
	}

    virtual void ApplyEffect()
    {
    }
}

const AMULET_REGEN_HEAL = 1;
const AMULET_REGEN_MAX = 100;
class RegenAmulet : MagicAmulet
{
    Default
	{
		Inventory.Icon "RAMUA0";
		Inventory.PickupMessage "$TXT_MAGICITEMPICKUP";
		Tag "$TAG_REGENAMULET";

		XRpgEquipableItem.EffectMessage "$TXT_REGENAMULET_USE";
	}
	States
	{
	Spawn:
		RAMU A -1 Bright;
		Stop;
	}

	override void DoEquipBlend()
	{
		if (!Owner)
			return;
		
		Owner.A_SetBlend("88 88 88", 0.8, 40);
	}

    override void ApplyEffect()
    {
        if (!Owner)
            return;

        let xrpgPlayer = XRpgPlayer(Owner);
        if (xrpgPlayer && xrpgPlayer.Health < AMULET_REGEN_MAX)
        {
            xrpgPlayer.Heal(AMULET_REGEN_HEAL);
        }
    }

    override void AbsorbDamage (int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags)
    {
        if (!IsActive())
            return;
        
        if (damage > 0 && (damageType =='Poison' || damageType == 'PoisonCloud'))
        {
            newdamage = damage / 10;
        }
    }
}

const MANA_REGEN_THRESHOLD = 80;
class ManaAmulet : MagicAmulet
{
    int manaNum;

    Default
	{
		Inventory.Icon "MAMUA0";
		Inventory.PickupMessage "$TXT_MAGICITEMPICKUP";
		Tag "$TAG_MANAAMULET";

		XRpgEquipableItem.EffectMessage "$TXT_MANAAMULET_USE";
        MagicAmulet.timerMax 22;
	}
	States
	{
	Spawn:
		MAMU A -1 Bright;
		Stop;
	}

    bool TryGiveBlueMana(int blueAmmo)
    {
        let ammo = Inventory(Owner.FindInventory('Mana1'));
        if (!ammo || ammo.Amount < blueAmmo)
        {
            GiveInventory("Mana1", 1);
            return true;
        }
        
        return false;
    }

    bool TryGiveGreenMana(int greenAmmo)
    {
        let ammo = Inventory(Owner.FindInventory('Mana2'));
        if (!ammo || ammo.Amount < greenAmmo)
        {
            GiveInventory("Mana2", 1);
            return true;
        }
        
        return false;
    }

	override void DoEquipBlend()
	{
		if (!Owner)
			return;
		
		Owner.A_SetBlend("75 0 99", 0.8, 40);
	}

    override void ApplyEffect()
    {
        if (!Owner)
            return;

        let xrpgPlayer = XRpgPlayer(Owner);
        if (xrpgPlayer)
        {
            manaNum++;
            if (manaNum == 1)
                TryGiveBlueMana(MANA_REGEN_THRESHOLD);
            else
                TryGiveGreenMana(MANA_REGEN_THRESHOLD);

            if (manaNum > 1)
                manaNum = 0;
        }
    }
}

class WardingAmulet : XRpgNeckItem
{
	Default
	{
		Inventory.Icon "AR_4B0";
		
		Tag "$TAG_WARDINGAMULET";
        XRpgEquipableItem.EffectMessage "$TXT_WARDINGAMULET_USE";
				
		XRpgEquipableItem.ArmorBonus 10;
		XRpgArmorItem.mageArmorOverride 15;
		XRpgEquipableItem.SpawnOffsetY -1;
	}
	States
	{
	Spawn:
		AR_4 B -1;
		Stop;
	}
}

const BISHOPGEM_COOLDOWN_MAX = 20;
class BishopGem : XRpgNeckItem
{
    int fireCooldown;

	Default
	{
		Inventory.Icon "AAMUA0";
		
		Tag "$TAG_BISHOPGEM";
        XRpgEquipableItem.EffectMessage "$TXT_ARMOR_BISHOPGEM";
				
		XRpgEquipableItem.ArmorBonus 10;
		XRpgArmorItem.mageArmorOverride 20;

        XRpgEquipableItem.MaxCooldown BISHOPGEM_COOLDOWN_MAX;
	}
	States
	{
	Spawn:
		AAMU ABCD 8;
		AAMU D -1;
		Stop;
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
			Actor targetMonster;
			if (inflictor && inflictor.bIsMonster)
				targetMonster = inflictor;
			else if (source && source.bIsMonster)
				targetMonster = source;
			else if (inflictor && inflictor.target && inflictor.target.bIsMonster)
				targetMonster = inflictor.target;

			if (!targetMonster)
				return;

			//Randomly retaliate against attacker
			if (random[BishopGem](1,4) > 1)
			{
				Actor mo = Owner.SpawnMissile(targetMonster, "BishopGemMissile");
                StartCooldown();

                xrpgPlayer.A_SetBlend("99 65 99", 0.8, 40);
			}
        }
    }
}

class BishopGemMissile : MageWandDeathMissile
{
    Default
    {
        Obituary "$OB_BISHOPGEM";
    }
}

const FEATHERAMULET_Z_MAX = -40;
class FeatherAmulet : XRpgNeckItem
{
	Default
	{
		Inventory.Icon "FAMUB0";
		Tag "$TAG_FEATHERAMULET";

        XRpgEquipableItem.EffectMessage "$TXT_FEATHERAMULET_USE";

		XRpgEquipableItem.MaxCooldown 100;
	}
	States
	{
	Spawn:
		FAMU A -1;
		Stop;
	}

	override void DoEquipBlend()
	{
		if (!Owner)
			return;
		
		Owner.A_SetBlend("99 99 99", 0.8, 40);
	}

	override void Tick()
	{
		super.Tick();

		if (!Owner)
			return;
		
		if (!IsActive() || !IsCooldownDone())
			return;
		
		let xrpgPlayer = xrpgPlayer(Owner);
		if (!xrpgPlayer)
			return;

		if (!xrpgPlayer.player.onGround && xrpgPlayer.Vel.z < FEATHERAMULET_Z_MAX)
		{
			xrpgPlayer.A_SetBlend("99 99 99", 0.8, 40);
			xrpgPlayer.TeleportToStart(false);

			StartCooldown();
		}
	}
}