//lvl 1
const SPELLTYPE_FIRE = 101;
const SPELLTYPE_ICE = 102;
const SPELLTYPE_POISON = 103;

//level 2
const SPELLTYPE_WATER = 201;
const SPELLTYPE_SUN = 202;
const SPELLTYPE_MOON = 203;

//level 3
const SPELLTYPE_DEATH = 301;
const SPELLTYPE_LIGHTNING = 302;
const SPELLTYPE_BLOOD = 303;

//Cleric Spells
const SPELLTYPE_CLERIC_SMITE = 1101;
const SPELLTYPE_CLERIC_HEAL = 1102;
const SPELLTYPE_CLERIC_PROTECT = 1103;
const SPELLTYPE_CLERIC_WRATH = 1104;
const SPELLTYPE_CLERIC_DIVINE = 1105;

class XRpgSpellItem : PowerupGiver
{
    int spellType;
	int timerVal;
	int maxTimer;
	int manaCostBlue;
	int manaCostGreen;
	int magicTimerMod;
	bool isMultiSlot;

    property SpellType : spellType;
	property TimerVal : timerVal;
	property MaxTimer : maxTimer;
	property ManaCostBlue : manaCostBlue;
	property ManaCostGreen : manaCostGreen;
	property MagicTimerMod : magicTimerMod;
	property IsMultiSlot : isMultiSlot;

	Default
	{
		+COUNTITEM
		+FLOATBOB
		Inventory.PickupFlash "PickupFlash";
		Inventory.InterHubAmount 1;
		Inventory.MaxAmount 1;

		XRpgSpellItem.TimerVal 0;
		XRpgSpellItem.MaxTimer 0;
		XRpgSpellItem.ManaCostBlue 0;
		XRpgSpellItem.ManaCostGreen 0;
		XRpgSpellItem.MagicTimerMod 1;
		XRpgSpellItem.IsMultiSlot false;
	}

	bool CheckMana(class<Inventory> type, int ammoUse)
    {
        if (ammoUse == 0)
            return true;

        let ammo = Inventory(Owner.FindInventory(type));
        if (!ammo || ammo.Amount < ammoUse)
            return false;
        
        return true;
    }

    bool CheckAllMana(int blueAmmoUse, int greenAmmoUse)
    {
        let blueResult = CheckMana("Mana1", blueAmmoUse);
        let greenResult = CheckMana("Mana2", greenAmmoUse);
        
        return blueResult && greenResult;
    }

    bool DepleteMana(class<Inventory> type, int ammoUse)
    {
        let ammo = Inventory(Owner.FindInventory(type));
        if (!ammo || ammo.Amount < ammoUse)
            return false;

        ammo.Amount -= ammoUse;
        return true;
    }

    bool DepleteAllMana(int blueAmmoUse, int greenAmmoUse)
    {
        let blueResult = DepleteMana("Mana1", blueAmmoUse);
        let greenResult = DepleteMana("Mana2", greenAmmoUse);

        return blueResult && greenResult;
    }
	
	virtual void CastSpell()
	{
	}
	
	override bool Use (bool pickup)
	{
		if (TimerVal > 0)
			return false;
		
		let xrpgPlayer = XRpgPlayer(Owner);
        if (!xrpgPlayer)
			return false;

		if (xrpgPlayer.IsSpellActive(SpellType, true))
			return false;
		
		//If multislot, check if slot is open
		if (IsMultiSlot)
		{
			if (!xrpgPlayer.IsSpellSlotOpen(xrpgPlayer.ActiveSpell, true) &&
				!xrpgPlayer.IsSpellSlotOpen(xrpgPlayer.ActiveSpell2, true))
				return false;
		}

		//If mana cost required, check if enough and spend it
		if (ManaCostBlue > 0 || manaCostGreen > 0)
		{
			if (!CheckAllMana(ManaCostBlue, manaCostGreen))
				return false;

			DepleteAllMana(manaCostBlue, manaCostGreen);
		}
		
		TimerVal = MaxTimer;

		//Add magic bonus (negative or positive)
		if (MaxTimer > 0)
		{
			let lowMaxMod = TimerVal / 2;
			let highMaxMod = MaxTimer * 2;
			TimerVal += xrpgPlayer.Magic * MagicTimerMod;

			if (TimerVal < lowMaxMod)
				TimerVal = lowMaxMod;
			else if (TimerVal > highMaxMod)
				TimerVal = highMaxMod;
		}

		xrpgPlayer.SetActiveSpell(self);

		CastSpell();

		return false;
	}
	
	override void Tick()
	{
		//Count down timer
		if (TimerVal > 0)
			TimerVal --;

		//Remove spell if it is a timed spell
        let xrpgPlayer = XRpgPlayer(Owner);
        if (xrpgPlayer != null)
		{
			if (MaxTimer != 0 && TimerVal == 0)
			{
				if (xrpgPlayer.ActiveSpell == self)
				{
					xrpgPlayer.ActiveSpell = null;
				}
				else if(xrpgPlayer.ActiveSpell2 == self)
				{
					xrpgPlayer.ActiveSpell2 = null;
				}
			}
		}
		
		// Spells cannot exist outside an inventory
		if (Owner == NULL)
		{
			Destroy ();
		}
	}
}

//-------------
// Mage Spells
//-------------
class FireSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "DMFXB5";

        XRpgSpellItem.SpellType SPELLTYPE_FIRE;
	}
}

class IceSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "ICPRA0";

        XRpgSpellItem.SpellType SPELLTYPE_ICE;
	}
}

class PoisonSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "D2FXA1";

        XRpgSpellItem.SpellType SPELLTYPE_POISON;
	}
}

class WaterSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "SPSHG0";

        XRpgSpellItem.SpellType SPELLTYPE_WATER;
	}
}

class SunSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "FX12B1";

        XRpgSpellItem.SpellType SPELLTYPE_SUN;
	}
}

class MoonSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "RADEB0";

        XRpgSpellItem.SpellType SPELLTYPE_MOON;
	}
}

class DeathSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "CHNSG0";

        XRpgSpellItem.SpellType SPELLTYPE_DEATH;
	}
}

class LightningSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "MLF2P0";

        XRpgSpellItem.SpellType SPELLTYPE_LIGHTNING;
	}
}

class BloodSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "DEMEA0";

        XRpgSpellItem.SpellType SPELLTYPE_BLOOD;
	}
}

//--------------
//Cleric Spells
//--------------
class SmiteSpell : XRpgSpellItem
{
	Default
	{
		Inventory.Icon "SMITA0";

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
			int healMax = xrpgPlayer.Magic * SPELL_CLERIC_HEALOTHER_MOD;
			int healAmount = random(xrpgPlayer.Magic, healMax);
			xrpgPlayer.A_RadiusGive("Health", 512, RGF_PLAYERS | RGF_GIVESELF, healAmount);
		}

	}
}

const SPELL_CLERIC_PROTECT_MAX = 3;
const SPELL_CLERIC_PROTECT_PERCENT = 0.5;
const SPELL_CLERIC_PROTECT_BIGPERCENT = 0.1;
class ProtectSpell : XRpgSpellItem
{
	int hitCount;
	property HitCount : hitCount;

	Default
	{
		Inventory.Icon "PROTA0";

        XRpgSpellItem.SpellType SPELLTYPE_CLERIC_PROTECT;

		XRpgSpellItem.TimerVal 0;
		XRpgSpellItem.MaxTimer 800;

		ProtectSpell.HitCount 0;

		XRpgSpellItem.ManaCostBlue 10;
		XRpgSpellItem.ManaCostGreen 10;

		XRpgSpellItem.MagicTimerMod 10;
		XRpgSpellItem.IsMultiSlot true;
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
			if (random(1,2) == 2)
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