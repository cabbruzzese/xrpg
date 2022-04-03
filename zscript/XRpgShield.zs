const SHIELD_MAX_CHARGE = 40;
const SHIELD_MIN_CHARGE = 5;
const SHIELD_DEFENSE = 0.4;
const SHIELD_MISSILE_DEFENSE = 0;
const SHIELD_RANGE = 1.5 * DEFMELEERANGE;
const SHIELD_MANA_COST = 1;
class XRpgShield : Inventory replaces CentaurShield
{
    int shieldCharge;
    int shieldTimeout;

    property ShieldCharge : shieldCharge;
    property ShieldTimeout : shieldTimeout;

	Default
	{
		+INVENTORY.RESTRICTABSOLUTELY
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.PickupFlash "PickupFlash";
		Inventory.Amount 1;
		Inventory.MaxAmount 1;
		Inventory.PickupSound "misc/p_pkup";
		Inventory.PickupMessage "$TXT_SHIELDITEM";
        Inventory.ForbiddenTo "XRpgClericPlayer", "XRpgMagePlayer", "ClericPlayer", "MagePlayer";

        XRpgShield.ShieldCharge 0;
        XRpgShield.ShieldTimeout 0;
	}

	States
	{
	Spawn:
		CTDP ABCDEFGHIJ 3;
		CTDP J -1;
		Stop;
	}

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

    bool IsCharged()
    {
        return ShieldCharge >= SHIELD_MIN_CHARGE;
    }

    void ShootShield()
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
            if (inflictor.bMissile && xrpgPlayer.CheckAllMana(SHIELD_MANA_COST, SHIELD_MANA_COST))
            {
				xrpgPlayer.DepleteAllMana(SHIELD_MANA_COST, SHIELD_MANA_COST);
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

class ShieldFX : Actor
{
	Default
	{
		Speed 20;
		Damage 15;
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