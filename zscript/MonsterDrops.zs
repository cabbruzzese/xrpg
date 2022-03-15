const SHIELD_MAX_CHARGE = 40;
const SHIELD_MIN_CHARGE = 5;
const SHIELD_DEFENSE = 0.2;
const SHIELD_MISSILE_DEFENSE = 0.1;
const SHIELD_RANGE = 1.5 * DEFMELEERANGE;
class XRpgShield : Inventory replaces CentaurShield
{
    int shieldCharge;
    int shieldTimeout;

    property ShieldCharge : shieldCharge;
    property ShieldTimeout : shieldTimeout;

	Default
	{
		+FLOATBOB
		+INVENTORY.FANCYPICKUPSOUND
		Inventory.PickupFlash "PickupFlash";
		Inventory.Amount 1;
		Inventory.MaxAmount 1;
		Inventory.PickupSound "misc/p_pkup";
		RenderStyle "Translucent";
		Inventory.PickupMessage "$TXT_SHIELDITEM";
        Inventory.ForbiddenTo "XRpgClericPlayer", "XRpgMagePlayer";

        XRpgShield.ShieldCharge 0;
        XRpgShield.ShieldTimeout 0;
	}

	States
	{
	CTDP ABCDEF 3;
		CTDP G 4;
		CTDP H 4;
		CTDP I 4;
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
		
		let xrpgPlayer = XRpgFighterPlayer(Owner);
        if (!xrpgPlayer)
			return;
		
        if (!IsShieldTimeoutActive())
            return;

		if (passive && damage > 0 && Owner && Owner.Player && Owner.Player.mo)
        {
            if (inflictor.bMissile)
            {
                int chargeVal = Max(damage, 1);
			    AddCharge(chargeVal);

                newdamage = double(damage) * SHIELD_MISSILE_DEFENSE;
            }
            else
            {
                newdamage = double(damage) * SHIELD_DEFENSE;
            }

            Owner.A_StartSound("FlechetteBounce", CHAN_VOICE);

            xrpgPlayer.DoBlend("99 99 99", 0.6, 30);
        }
	}

    bool IsShieldTimeoutActive()
	{
		return ShieldTimeout > 0;
	}

	void SetShieldTimeout(int ammount = 10)
	{
		ShieldTimeout = ammount;
	}

    override void Tick()
	{
		if (ShieldTimeout > 0)
			ShieldTimeout--;

        // if (ShieldTimeout == 1)
        // {
        //     if (Owner)
        //         Owner.A_Print("Shield Expired");
        // }            
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