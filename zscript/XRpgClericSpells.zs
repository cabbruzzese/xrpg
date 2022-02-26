//Cleric Spells
const SPELLTYPE_CLERIC_SMITE = 1101;
const SPELLTYPE_CLERIC_HEAL = 1102;
const SPELLTYPE_CLERIC_PROTECT = 1103;
const SPELLTYPE_CLERIC_WRATH = 1104;
const SPELLTYPE_CLERIC_DIVINE = 1105;

//--------------
//Cleric Spells
//--------------
class SmiteSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "SMITA0";

		Inventory.PickupMessage "$TXT_SMITESPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_CLERIC_SMITE;

		XRpgSpellItem.TimerVal 0;
		XRpgSpellItem.MaxTimer 500;

		XRpgSpellItem.ManaCostBlue 15;

		XRpgSpellItem.MagicTimerMod 5;
		XRpgSpellItem.IsMultiSlot true;
	}
}

const SPELL_CLERIC_HEALOTHER_MOD = 2;
class HealSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "TST7A0";

		Inventory.PickupMessage "$TXT_HEALSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_CLERIC_HEAL;

		XRpgSpellItem.TimerVal 0;
		XRpgSpellItem.MaxTimer 100;

		XRpgSpellItem.ManaCostBlue 8;

		XRpgSpellItem.MagicTimerMod -1;
		XRpgSpellItem.IsMultiSlot true;
	}

	override void CastSpell()
	{
		if (!Owner)
			return;
		
		let xrpgPlayer = XRpgPlayer(Owner);
        if (xrpgPlayer != null)
		{
			let statItem = xrpgPlayer.GetStats();
			int healMax = statItem.Magic * SPELL_CLERIC_HEALOTHER_MOD;
			int healAmount = random[CSpellHeal](statItem.Magic, healMax);
			xrpgPlayer.A_RadiusGive("Health", 512, RGF_PLAYERS | RGF_GIVESELF, healAmount);

			if (xrpgPlayer.player)
				xrpgPlayer.player.poisoncount = 0;
		}

	}
}

const SPELL_CLERIC_PROTECT_MAX = 3;
const SPELL_CLERIC_PROTECT_PERCENT = 0.5;
const SPELL_CLERIC_PROTECT_BIGPERCENT = 0.1;
class ProtectSpell : XRpgSpellItem
{

	Default
	{
		Inventory.Icon "PROTA0";

		Inventory.PickupMessage "$TXT_PROTECTSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_CLERIC_PROTECT;

		XRpgSpellItem.TimerVal 0;
		XRpgSpellItem.MaxTimer 800;

		XRpgSpellItem.ManaCostBlue 10;
		XRpgSpellItem.ManaCostGreen 10;

		XRpgSpellItem.MagicTimerMod 10;
		XRpgSpellItem.IsMultiSlot true;
		XRpgSpellItem.UseCrystals true;
	}

	override void CastSpell()
	{
		HitCount = 0;
	}

	override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if (!Owner)
			return;
		
		let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return;

		if (!xrpgPlayer.IsSpellActive(SPELLTYPE_CLERIC_PROTECT, true))
			return;
		
		if (passive && damage > 0 && Owner && Owner.Player && Owner.Player.mo)
        {
			HitCount++;
			if (HitCount >= SPELL_CLERIC_PROTECT_MAX)
			{

				HitCount = 0;
				Owner.A_Blast(BF_NOIMPACTDAMAGE, 255, 120);

				newdamage = damage * SPELL_CLERIC_PROTECT_BIGPERCENT;
			}
			else
			{
				newdamage = damage * SPELL_CLERIC_PROTECT_PERCENT;
			}
        }
	}
}

class WrathSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "WRATA0";

		Inventory.PickupMessage "$TXT_WRATHSPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_CLERIC_WRATH;

		XRpgSpellItem.TimerVal 0;
		XRpgSpellItem.MaxTimer 800;

		XRpgSpellItem.ManaCostBlue 15;
		XRpgSpellItem.ManaCostGreen 15;

		XRpgSpellItem.MagicTimerMod 5;
		XRpgSpellItem.IsMultiSlot true;
	}

	override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if (!Owner)
			return;
		
		let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return;

		if (!xrpgPlayer.IsSpellActive(SPELLTYPE_CLERIC_WRATH, true))
			return;

		if (passive && damage > 0 && Owner && Owner.Player && Owner.Player.mo)
        {
			Actor targetMonster;
			if (inflictor && inflictor.bIsMonster)
				targetMonster = inflictor;
			else if (source && source.bIsMonster)
				targetMonster = source;
			else if (inflictor.target && inflictor.target.bIsMonster)
				targetMonster = inflictor.target;

			if (!targetMonster)
				return;

			//Randomly smite attacker
			if (random[CSpellSmite](1,2) == 2)
			{
				Actor mo = Owner.SpawnPlayerMissile("SmiteningMissile");
				if (!mo) return;
				
				mo.SetOrigin(targetMonster.Pos, false);
				double newz = mo.CurSector.NextHighestCeilingAt(mo.pos.x, mo.pos.y, mo.pos.z, mo.pos.z, FFCF_NOPORTALS) - mo.height;
				mo.SetZ(newz);

				mo.Vel.X = MinVel; // Force collision detection
				mo.Vel.Y = MinVel; // Force collision detection
				mo.Vel.Z = -90;
				mo.CheckMissileSpawn (radius);
			}
        }
	}
}

const SPELL_CLERIC_DIVINE_HEALPERCENT = 0.75;
class DivineSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "DIVIA0";

		Inventory.PickupMessage "$TXT_DIVINESPELLPICKUP";

        XRpgSpellItem.SpellType SPELLTYPE_CLERIC_DIVINE;

		XRpgSpellItem.TimerVal 0;
		XRpgSpellItem.MaxTimer 300;

		XRpgSpellItem.ManaCostBlue 25;
		XRpgSpellItem.ManaCostGreen 25;

		XRpgSpellItem.MagicTimerMod -1;
		XRpgSpellItem.IsMultiSlot true;
	}

	override void CastSpell()
	{
		let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return;

		//Restore most health
		if (xrpgPlayer.Health < xrpgPlayer.MaxHealth * SPELL_CLERIC_DIVINE_HEALPERCENT)
			xrpgPlayer.A_SetHealth(xrpgPlayer.MaxHealth * SPELL_CLERIC_DIVINE_HEALPERCENT);

		//Teleport to start
		Vector3 dest;
		int destAngle;

		if (deathmatch)
		{
			[dest, destAngle] = level.PickDeathmatchStart();
		}
		else
		{
			[dest, destAngle] = level.PickPlayerStart(Owner.PlayerNumber());
		}
		dest.Z = ONFLOORZ;
		Owner.Teleport (dest, destAngle, TELF_SOURCEFOG | TELF_DESTFOG);

		Playerinfo p = Owner.player;
		if (p && p.morphTics && (p.MorphStyle & MRF_UNDOBYCHAOSDEVICE))
		{ // Teleporting away will undo any morph effects (pig)
			p.mo.UndoPlayerMorph (p, MRF_UNDOBYCHAOSDEVICE);
		}

		//Add short term invul
		let power = Powerup(Spawn ("PowerInvulnerable"));
		power.EffectTics = 250;
		/*power.bAlwaysPickup |= bAlwaysPickup;
		power.bAdditiveTime |= bAdditiveTime;
		power.bNoTeleportFreeze |= bNoTeleportFreeze;*/
		power.CallTryPickup (xrpgPlayer);
	}
}