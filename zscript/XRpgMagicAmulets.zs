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

		XRpgMagicItem.EffectMessage "$TXT_AMULET_USE";
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
