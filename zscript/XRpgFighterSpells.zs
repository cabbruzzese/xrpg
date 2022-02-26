//Fighter spells
// (These are SKILLS but they use the spell items to activate)
const SPELLTYPE_FIGHTER_BERSERK = 2201;
const SPELLTYPE_FIGHTER_STUN = 2202;
const SPELLTYPE_FIGHTER_POWER = 2203;

const SPELLTYPE_FIGHTER_POWER_LIMIT = 3;

const FIGHTERSPELL_MINLIFE = 50;
class FighterSpellItem : XRpgSpellItem
{
	Default
	{
		-INVENTORY.INVBAR
	}

	override bool Use(bool pickup)
    {
		if (!pickup)
        	return false;

		return Super.Use(false);
    }
}

class BerserkSpell : FighterSpellItem
{
	Default
	{
		Inventory.Icon "POWRA0"; //Switched color with power spell

		Inventory.PickupMessage "$TXT_BERSERKSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_FIGHTER_BERSERK;

		XRpgSpellItem.TimerVal 0;
		XRpgSpellItem.MaxTimer 400;

		XRpgSpellItem.MagicTimerMod 0;
		XRpgSpellItem.IsMultiSlot true;
        XRpgSpellItem.IsLifeCost false;
        XRpgSpellItem.MaxLifeCostTimer 0;
		XRpgSpellItem.LifeCostMin 0; //FIGHTERSPELL_MINLIFE;
	}

	override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if (!Owner)
			return;
		
		let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return;

		if (xrpgPlayer.IsSpellActive(SPELLTYPE_FIGHTER_BERSERK, true))
			return;

		if (!source || !source.bIsMonster)
			return;
		
		if (passive && damage > 0 && Owner && Owner.Player && Owner.Player.mo)
        {
			let chance = random(1, 200) - (damage / 2);
			if (chance < xrpgPlayer.GetMagic())
			{
				xrpgPlayer.A_Print("BERSERKER RAGE!");
				xrpgPlayer.DoBlend(180, 180, 20, 20, 0.8, 160);
				Use(true);

				//Restore health if low
				int healthBoost = xrpgPlayer.GetMagic() * 3;
				xrpgPlayer.A_SetHealth(xrpgPlayer.Health + healthBoost);
				if (xrpgPlayer.Health > xrpgPlayer.MaxHealth)
					xrpgPlayer.A_SetHealth(xrpgPlayer.MaxHealth);
			}
        }
	}
}

class StunSpell : FighterSpellItem
{
	Default
	{
		Inventory.Icon "STUNA0";

		Inventory.PickupMessage "$TXT_STUNSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_FIGHTER_STUN;

		XRpgSpellItem.TimerVal 0;
		XRpgSpellItem.MaxTimer 400;

		XRpgSpellItem.MagicTimerMod 0;
		XRpgSpellItem.IsMultiSlot true;
        XRpgSpellItem.IsLifeCost false;
        XRpgSpellItem.MaxLifeCostTimer 0; //20;
		XRpgSpellItem.LifeCostMin 0; //FIGHTERSPELL_MINLIFE;
	}

	override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if (!Owner)
			return;
		
		let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return;

		if (!passive && damage > 0 && Owner && Owner.Player && Owner.Player.mo)
        {
			if (!source || !source.bISMONSTER || damageType != "Melee")
				return;

			let chance = random(1, 200) - (damage / 10);
			if (chance < xrpgPlayer.GetMagic())
			{
				xrpgPlayer.A_Print("Stunning strike!");
				xrpgPlayer.DoBlend(90, 0, 0, 180, 0.4, 60);
				DoStunHit(xrpgPlayer, source);
			}
        }
	}

	void DoStunHit(XRpgPlayer xRpgPlayer, Actor victim)
	{
		if (!victim || !victim.bIsMonster)
			return;
		
		if (xrpgPlayer)
		{
			let mo = Spawn("StunStars");
			mo.target = victim;
		}

		A_Print("stunning hit");
	}
}

class PowerSpell : FighterSpellItem
{
	Default
	{
		Inventory.Icon "BERSA0"; //Switched color with berserk

		Inventory.PickupMessage "$TXT_POWERSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_FIGHTER_POWER;

		XRpgSpellItem.TimerVal 0;
		XRpgSpellItem.MaxTimer 0;

		XRpgSpellItem.MagicTimerMod 0;
		XRpgSpellItem.IsMultiSlot true;
        XRpgSpellItem.IsLifeCost false;
        XRpgSpellItem.MaxLifeCostTimer 0; //32;
		XRpgSpellItem.LifeCostMin 0; //FIGHTERSPELL_MINLIFE;
		XRpgSpellItem.UseCrystals true;
		XRpgSpellItem.DrawInactive true;
	}

	void ThrowSpark(Actor victim)
    {
        let xo = random(-16, 16);
        let yo = random(-16, 16);
        let zo = victim.Height / 2;
        let sparkPos = victim.Pos + (xo, yo, zo);

        let vx = frandom(-2.0, 2.0);
        let vy = frandom(-2.0, 2.0);
        let vz = frandom(2.0, 4.0);

        let mo = Spawn("PowerSpark");
        if (!mo)
            return;

        mo.target = victim;
        mo.SetOrigin(sparkPos, false);
        mo.A_ChangeVelocity(vx, vy, vz, CVF_REPLACE);
    }

	void ThrowSparks(Actor victim)
	{
		for (int i = 0; i < 8; i++)
        {
            ThrowSpark(victim);
        }
	}

	override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if (!Owner)
			return;
		
		let xrpgPlayer = XRpgFighterPlayer(Owner);
        if (!xrpgPlayer)
			return;

		if (!passive && damage > 0 && Owner && Owner.Player && Owner.Player.mo)
        {
			if (!source || !source.bISMONSTER || damageType != "Melee")
				return;

			HitCount++;

			if (!xrpgPlayer.ActiveSpell2)
			{
				xrpgPlayer.SetActiveSpell(self);
			}

			if (HitCount > SPELLTYPE_FIGHTER_POWER_LIMIT)
			{

				HitCount = 0;
				
				let power = xrpgPlayer.GetStrength();

				let vecOffset = (source.Pos.X - xrpgPlayer.Pos.X, source.Pos.Y - xrpgPlayer.Pos.Y);
				let attackAngle = Vectorangle(vecOffset.x, vecOffset.y);
				source.Thrust(power, attackAngle);

				let magicDamage = xrpgPlayer.GetMagic() * 4;
				newdamage = damage + magicDamage;

				xrpgPlayer.DoBlend(90, 200, 200, 0, 0.2, 20);
				ThrowSparks(source);
			}
        }
	}
}