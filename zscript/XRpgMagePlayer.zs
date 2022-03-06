// The mage -----------------------------------------------------------------
const SPELL_LEVEL_TIER1 = 1;
const SPELL_LEVEL_TIER2 = 10;
const SPELL_LEVEL_TIER3 = 24;

const SPELL_LEVEL_BASE = 2;
const SPELL_LEVEL_GRANT = 5;

class XRpgMagePlayer : XRpgPlayer
{
	Default
	{
		Health 80;
		Player.MaxHealth 80;
		ReactionTime 0;
		PainChance 255;
		Radius 16;
		Height 64;
		Speed 1;
		+NOSKIN
		+NODAMAGETHRUST
		+PLAYERPAWN.NOTHRUSTWHENINVUL
		PainSound "PlayerMagePain";
		RadiusDamageFactor 0.25;
		Player.JumpZ 9;
		Player.Viewheight 48;
		Player.SpawnClass "Mage";
		Player.DisplayName "Mage";
		Player.SoundClass "mage";
		Player.ScoreIcon "MAGEFACE";
		Player.InvulnerabilityMode "Reflective";
		Player.HealRadiusType "Mana";
		Player.Hexenarmor 0, 5, 15, 10, 25;
		Player.StartItem "XRpgMWeapWand";
		Player.ForwardMove 0.88, 0.92;
		Player.SideMove 0.875, 0.925;
		Player.Portrait "P_MWALK1";
		Player.WeaponSlot 1, "XRpgMWeapWand";
		Player.WeaponSlot 2, "XRpgMWeapFrost";
		Player.WeaponSlot 3, "XRpgMWeapLightning";
		Player.WeaponSlot 4, "XRpgMWeapBloodscourge";
		Player.FlechetteType "ArtiPoisonBag2";
		
		Player.ColorRange 146, 163;
		Player.Colorset		0, "$TXT_COLOR_BLUE",		146, 163,    161;
		Player.ColorsetFile 1, "$TXT_COLOR_RED",		"TRANTBL7",  0xB3;
		Player.ColorsetFile 2, "$TXT_COLOR_GOLD",		"TRANTBL8",  0x8C;
		Player.ColorsetFile 3, "$TXT_COLOR_DULLGREEN",	"TRANTBL9",  0x41;
		Player.ColorsetFile 4, "$TXT_COLOR_GREEN",		"TRANTBLA",  0xC9;
		Player.ColorsetFile 5, "$TXT_COLOR_GRAY",		"TRANTBLB",  0x30;
		Player.ColorsetFile 6, "$TXT_COLOR_BROWN",		"TRANTBLC",  0x72;
		Player.ColorsetFile 7, "$TXT_COLOR_PURPLE",		"TRANTBLD",  0xEE;

        //Player.StartItem "ExpSquishItem";
		XRpgPlayer.InitStrength 5;
		XRpgPlayer.InitDexterity 5;
		XRpgPlayer.InitMagic 12;

		XRpgPlayer.RegenerateTicksMax 64;

		//Player.StartItem "XRpgMWeapFrost";
		//Player.StartItem "XRpgMWeapLightning";
		//Player.StartItem "XRpgMWeapBloodscourge";
	}

	States
	{
	Spawn:
		MAGE A -1;
		Stop;
	See:
		MAGE ABCD 4;
		Loop;
	Missile:
	Melee:
		MAGE EF 8;
		Goto Spawn;
	Pain:
		MAGE G 4;
		MAGE G 4 A_Pain;
		Goto Spawn;
	Death:
		MAGE H 6;
		MAGE I 6 A_PlayerScream;
		MAGE JK 6;
		MAGE L 6 A_NoBlocking;
		MAGE M 6;
		MAGE N -1;
		Stop;		
	XDeath:
		MAGE O 5 A_PlayerScream;
		MAGE P 5;
		MAGE R 5 A_NoBlocking;
		MAGE STUVW 5;
		MAGE X -1;
		Stop;
	Ice:
		MAGE Y 5 A_FreezeDeath;
		MAGE Y 1 A_FreezeDeathChunks;
		Wait;
	Burn:
		FDTH E 5 BRIGHT A_StartSound("*burndeath");
		FDTH F 4 BRIGHT;
		FDTH G 5 BRIGHT;
		FDTH H 4 BRIGHT A_PlayerScream;
		FDTH I 5 BRIGHT;
		FDTH J 4 BRIGHT;
		FDTH K 5 BRIGHT;
		FDTH L 4 BRIGHT;
		FDTH M 5 BRIGHT;
		FDTH N 4 BRIGHT;
		FDTH O 5 BRIGHT;
		FDTH P 4 BRIGHT;
		FDTH Q 5 BRIGHT;
		FDTH R 4 BRIGHT;
		FDTH S 5 BRIGHT A_NoBlocking;
		FDTH T 4 BRIGHT;
		FDTH U 5 BRIGHT;
		FDTH V 4 BRIGHT;
		ACLO E 35 A_CheckPlayerDone;
		Wait;
		ACLO E 8;
		Stop;
	}

	override void BasicStatIncrease(PlayerLevelItem statItem)
	{
		statItem.Magic += 1;

		//give one at random to other 2 stats
		if (random[MLvlStat](1,2) == 2)
			statItem.Dexterity += 1;
		else
			statItem.Strength += 1;
	}

	const MAX_SPELL_GIVE_TRIES = 27;
	void GrantRandomSpell(int expLevel)
	{
		Array<class<Inventory> > availSpells;

		if (!FindInventory("FireSpell"))
			availSpells.Push( ClassTypeBag("FireSpell") );
		if (!FindInventory("IceSpell"))
			availSpells.Push( ClassTypeBag("IceSpell") );
		if (!FindInventory("PoisonSpell"))
			availSpells.Push( ClassTypeBag("PoisonSpell") );

		if (expLevel >= SPELL_LEVEL_TIER2)
		{
			if (!FindInventory("WaterSpell"))
				availSpells.Push( ClassTypeBag("WaterSpell") );
			if (!FindInventory("SunSpell"))
				availSpells.Push( ClassTypeBag("SunSpell") );
			if (!FindInventory("MoonSpell"))
				availSpells.Push( ClassTypeBag("MoonSpell") );
		}

		if (expLevel >= SPELL_LEVEL_TIER3)
		{
			if (!FindInventory("DeathSpell"))
				availSpells.Push( ClassTypeBag("DeathSpell") );
			if (!FindInventory("LightningSpell"))
				availSpells.Push( ClassTypeBag("LightningSpell") );
			if (!FindInventory("BloodSpell"))
				availSpells.Push( ClassTypeBag("BloodSpell") );
		}

		if (availSpells.Size() > 0)
		{
			int selection = random[MLvlSpell](0, availSpells.Size() - 1);
			GiveSpell(availSpells[selection]);
		}
	}

	override void GiveLevelSkill(PlayerLevelItem statItem)
	{
		if (statItem.ExpLevel == SPELL_LEVEL_BASE || statItem.ExpLevel % SPELL_LEVEL_GRANT == 0)
		{
			GrantRandomSpell(statItem.ExpLevel);
		}
	}

	override void Regenerate (PlayerLevelItem statItem)
	{
		int magicMax = (statItem.Magic / 4) + REGENERATE_MIN_VALUE;
		RegenerateHealth(statItem.Strength / 4);
		RegenerateManaType("Mana1", magicMax);
		RegenerateManaType("Mana2", magicMax);
	}

	XRpgSpellItem FindSpellItem(name invName)
	{
		let foundItem = FindInventory(invName);

		return XRpgSpellItem(foundItem);
	}

	AvailableSpells GetAvailSpells()
	{
		AvailableSpells availSpells =  new("AvailableSpells");

		XRpgSpellItem foundSpell;
		if (foundSpell = FindSpellItem("FireSpell"))
			availSpells.AddSpell(foundSpell);
		if (foundSpell = FindSpellItem("IceSpell"))
			availSpells.AddSpell(foundSpell);
		if (foundSpell = FindSpellItem("PoisonSpell"))
			availSpells.AddSpell(foundSpell);
		if (foundSpell = FindSpellItem("WaterSpell"))
			availSpells.AddSpell(foundSpell);
		if (foundSpell = FindSpellItem("SunSpell"))
			availSpells.AddSpell(foundSpell);
		if (foundSpell = FindSpellItem("MoonSpell"))
			availSpells.AddSpell(foundSpell);
		if (foundSpell = FindSpellItem("DeathSpell"))
			availSpells.AddSpell(foundSpell);
		if (foundSpell = FindSpellItem("LightningSpell"))
			availSpells.AddSpell(foundSpell);
		if (foundSpell = FindSpellItem("BloodSpell"))
			availSpells.AddSpell(foundSpell);

		return availSpells;
	}
}



class AvailableSpells
{
	XRpgSpellItem spellList[9];
	int arrayLen;

	void AddSpell (XRpgSpellItem spellItem)
	{
		spellList[arrayLen] = spellItem;
		arrayLen++;
	}

	int Size()
	{
		return arrayLen;
	}

	XRpgSpellItem GetItem(int itemNum)
	{
		return spellList[itemNum];
	}
}