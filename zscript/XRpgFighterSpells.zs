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

		if (IsEffectTimeoutActive())
			return;
		
		if (passive && damage > 0 && Owner && Owner.Player && Owner.Player.mo)
        {
			let chance = random[FSpellBerserk](1, 200) - (damage / 5);
			int magicMin = Min(50, xrpgPlayer.GetMagic());
			if (chance < magicMin)
			{
				xrpgPlayer.A_Print("BERSERKER RAGE!");
				xrpgPlayer.DoBlend("99 00 00", 0.6, 120);
				Use(true);

				//Restore health if low
				int healthBoost = xrpgPlayer.GetMagic();
				xrpgPlayer.Heal(healthBoost);
			}

			SetEffectTimeout();
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
		
		if (IsEffectTimeoutActive())
			return;

		if (!passive && Owner && Owner.Player && Owner.Player.mo)
        {
			if (!source || !source.bISMONSTER || damageType != "Melee")
				return;

			//If no damage and not an item that bypasses modify item
			let magicItem = XRpgMagicItem(xrpgPlayer.ActiveMagicItems[PAPERDOLL_SLOT_ACCESSORY]);
			if (damage <= 0 && (!magicItem || !magicItem.ModifyDamageBypass0))
				return; //do not do effect


			//Stunning korax makes the game unbeatable
			if (source is "Korax")
				return;

			let chance = random[FSpellStun](1, 200);
			int magicMin = Min(50, xrpgPlayer.GetMagic());
			if (chance < magicMin)
			{
				DoStunHit(xrpgPlayer, source);
			}

			SetEffectTimeout();
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

	override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if (!Owner)
			return;
		
		let xrpgPlayer = XRpgFighterPlayer(Owner);
        if (!xrpgPlayer)
			return;
		
		if (IsEffectTimeoutActive())
			return;

		if (!passive && Owner && Owner.Player && Owner.Player.mo)
        {
			if (!source || !source.bISMONSTER || damageType != "Melee")
				return;

			//If no damage and not an item that bypasses modify item
			let magicItem = XRpgMagicItem(xrpgPlayer.ActiveMagicItems[PAPERDOLL_SLOT_ACCESSORY]);
			if (damage <= 0 && (!magicItem || !magicItem.ModifyDamageBypass0))
				return; //do not do effect

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

				if (!source.bDONTTHRUST)
					source.Thrust(power, attackAngle);

				let magicDamage = xrpgPlayer.GetMagic() * 4;
				newdamage = damage + magicDamage;

				xrpgPlayer.DoBlend("55 CC CC", 0.2, 20);
				ActorUtils.ThrowSparks(source, "PowerSpark");
			}

			SetEffectTimeout();
        }
	}
}