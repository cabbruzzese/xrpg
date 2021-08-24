// The fighter --------------------------------------------------------------

class XRpgFighterPlayer : XRpgPlayer
{
	Default
	{
		Health 100;
		Player.MaxHealth 100;
		PainChance 255;
		Radius 16;
		Height 64;
		Speed 1;
		+NOSKIN
		+NODAMAGETHRUST
		+PLAYERPAWN.NOTHRUSTWHENINVUL
		PainSound "PlayerFighterPain";
		RadiusDamageFactor 0.25;
		Player.JumpZ 9;
		Player.Viewheight 48;
		Player.SpawnClass "Fighter";
		Player.DisplayName "Fighter";
		Player.SoundClass "fighter";
		Player.ScoreIcon "FITEFACE";
		Player.HealRadiusType "Armor";
		Player.Hexenarmor 0, 25, 20, 15, 5;
		Player.StartItem "XRpgFWeapFist";
		Player.ForwardMove 1.08, 1.2;
		Player.SideMove 1.125, 1.475;
		Player.Portrait "P_FWALK1";
		Player.WeaponSlot 1, "XRpgFWeapFist";
		Player.WeaponSlot 2, "XRpgFWeapAxe";
		Player.WeaponSlot 3, "XRpgFWeapHammer";
		Player.WeaponSlot 4, "XRpgFWeapQuietus";
		
		Player.ColorRange 246, 254;
		Player.Colorset		0, "$TXT_COLOR_GOLD",		246, 254,    253;
		Player.ColorsetFile 1, "$TXT_COLOR_RED",		"TRANTBL0",  0xAC;
		Player.ColorsetFile 2, "$TXT_COLOR_BLUE",		"TRANTBL1",  0x9D;
		Player.ColorsetFile 3, "$TXT_COLOR_DULLGREEN",	"TRANTBL2",  0x3E;
		Player.ColorsetFile 4, "$TXT_COLOR_GREEN",		"TRANTBL3",  0xC8;
		Player.ColorsetFile 5, "$TXT_COLOR_GRAY",		"TRANTBL4",  0x2D;
		Player.ColorsetFile 6, "$TXT_COLOR_BROWN",		"TRANTBL5",  0x6F;
		Player.ColorsetFile 7, "$TXT_COLOR_PURPLE",		"TRANTBL6",  0xEE;

        Player.StartItem "ExpSquishItem";
		XRpgPlayer.Strength 10;
		XRpgPlayer.Dexterity 8;
		XRpgPlayer.Magic 4;

		//Player.StartItem "XRpgFWeapAxe";
		//Player.StartItem "XRpgFWeapHammer";
		//Player.StartItem "XRpgFWeapQuietus";
	}
	
	States
	{
	Spawn:
		PLAY A -1;
		Stop;
	See:
		PLAY ABCD 4;
		Loop;
	Missile:
	Melee:
		PLAY EF 8;
		Goto Spawn;
	Pain:
		PLAY G 4;
		PLAY G 4 A_Pain;
		Goto Spawn;
	Death:
		PLAY H 6;
		PLAY I 6 A_PlayerScream;
		PLAY JK 6;
		PLAY L 6 A_NoBlocking;
		PLAY M 6;
		PLAY N -1;
		Stop;		
	XDeath:
		PLAY O 5 A_PlayerScream;
		PLAY P 5 A_SkullPop("BloodyFighterSkull");
		PLAY R 5 A_NoBlocking;
		PLAY STUV 5;
		PLAY W -1;
		Stop;
	Ice:
		PLAY X 5 A_FreezeDeath;
		PLAY X 1 A_FreezeDeathChunks;
		Wait;
	Burn:
		FDTH A 5 BRIGHT A_StartSound("*burndeath");
		FDTH B 4 BRIGHT;
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

	override void BasicStatIncrease()
	{
		Strength += 1;

		//give one at random to other 2 stats
		if (random(1,2) == 2)
			Dexterity += 1;
		else
			Magic += 1;
	}

	override void Regenerate ()
	{
		int strengthRegen = Strength / 4 + REGENERATE_MIN_VALUE;
		RegenerateHealth(strengthRegen);
	}
}
