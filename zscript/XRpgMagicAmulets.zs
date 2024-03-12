const AMULET_TIMEOUT_MAX = 14;
class MagicAmulet : XRpgMagicItem
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
		Inventory.PickupFlash "PickupFlash";
		Inventory.Icon "RAMUA0";
		Inventory.PickupSound "misc/p_pkup";
		Inventory.PickupMessage "$TXT_MAGICITEMPICKUP";
		Tag "$TAG_ARTIBOOSTARMOR";

		XRpgMagicItem.EffectMessage "$TXT_REGENAMULET_USE";
	}
	States
	{
	Spawn:
		RAMU A 4 Bright;
		Loop;
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
		Inventory.PickupFlash "PickupFlash";
		Inventory.Icon "MAMUA0";
		Inventory.PickupSound "misc/p_pkup";
		Inventory.PickupMessage "$TXT_MAGICITEMPICKUP";
		Tag "$TAG_ARTIBOOSTARMOR";

		XRpgMagicItem.EffectMessage "$TXT_MANAAMULET_USE";
        MagicAmulet.timerMax 15;
	}
	States
	{
	Spawn:
		MAMU A 4 Bright;
		Loop;
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
