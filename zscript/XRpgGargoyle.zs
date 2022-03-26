//=======================================
// Gargoyle monsters spawned by statues
//=======================================
class StoneGargoyle : StatueFireDemon
{
    default {
        WonderingMonsterBase.DefaultLeaderFlag WML_STONE;
        WonderingMonsterBase.DefaultBossFlag (WMF_LEADER | WMF_BRUTE);
    }
}
class IceGargoyle : StatueFireDemon
{
    default {
        WonderingMonsterBase.DefaultLeaderFlag WML_ICE;
        WonderingMonsterBase.DefaultBossFlag (WMF_LEADER | WMF_BRUTE);
    }
}
class LightningGargoyle : StatueFireDemon
{
    default {
        WonderingMonsterBase.DefaultLeaderFlag WML_LIGHTNING;
        WonderingMonsterBase.DefaultBossFlag (WMF_LEADER | WMF_BRUTE);
    }
}
class FireGargoyle : StatueFireDemon
{
    default {
        WonderingMonsterBase.DefaultLeaderFlag WML_FIRE;
        WonderingMonsterBase.DefaultBossFlag (WMF_LEADER | WMF_BRUTE);
    }
}
class BloodGargoyle : StatueFireDemon
{
    default {
        WonderingMonsterBase.DefaultLeaderFlag WML_BLOOD;
        WonderingMonsterBase.DefaultBossFlag (WMF_LEADER | WMF_BRUTE);
    }
}
class PoisonGargoyle : StatueFireDemon
{
    default {
        WonderingMonsterBase.DefaultLeaderFlag WML_POISON;
        WonderingMonsterBase.DefaultBossFlag (WMF_LEADER | WMF_BRUTE);
    }
}

//=======================================
// Statue replacements
//=======================================
class XRpgStatueGargoyleGreenTall : XRpgStatueGargoyleBase replaces ZStatueGargoyleGreenTall
{
	Default
	{
        StatueMonster.SpawnMonsterChance 8;
        StatueMonster.StatueMonsterType "StoneGargoyle";
	}
	States
	{
	Spawn:
		STT2 A -1;
		Stop;
	StatueMonsterRise:
		STT2 B 1 A_Scream;
        STT2 B 1 A_SpawnStatueMonster;
		STT2 B -1;
        Stop;
	}
}
class XRpgStatueGargoyleGreenShort : XRpgStatueGargoyleShortBase replaces ZStatueGargoyleGreenShort
{
	Default
	{
        StatueMonster.SpawnMonsterChance 8;
        StatueMonster.StatueMonsterType "StoneGargoyle";
	}
	States
	{
	Spawn:
		STT4 A -1;
		Stop;
	StatueMonsterRise:
		STT4 B 1 A_Scream;
        STT4 B 1 A_SpawnStatueMonster;
		STT4 B -1;
        Stop;
	}
}

class XRpgStatueGargoyleBlueTall : XRpgStatueGargoyleBase replaces ZStatueGargoyleBlueTall
{
	Default
	{
        StatueMonster.SpawnMonsterChance 10;
        StatueMonster.StatueMonsterType "IceGargoyle";
        DeathSound "IceStartMove";
	}
	States
	{
	Spawn:
		STT3 A -1;
		Stop;
    StatueMonsterRise:
		STT3 B 1 A_Scream;
        STT3 B 1 A_SpawnStatueMonster;
		STT3 B -1;
        Stop;
	}
}
class XRpgStatueGargoyleBlueShort : XRpgStatueGargoyleShortBase replaces ZStatueGargoyleBlueShort
{
	Default
	{
        StatueMonster.SpawnMonsterChance 10;
        StatueMonster.StatueMonsterType "IceGargoyle";
        DeathSound "IceStartMove";
	}
	States
	{
	Spawn:
		STT5 A -1;
		Stop;
	StatueMonsterRise:
		STT5 B 1 A_Scream;
        STT5 B 1 A_SpawnStatueMonster;
		STT5 B -1;
        Stop;
	}
}

class XRpgStatueGargoyleStripeTall : XRpgStatueGargoyleBase replaces ZStatueGargoyleStripeTall
{
	Default
	{
        StatueMonster.SpawnMonsterChance 15;
        StatueMonster.StatueMonsterType "PoisonGargoyle";
	}
	States
	{
	Spawn:
		GAR1 A -1;
		Stop;
    StatueMonsterRise:
		GAR1 B 1 A_Scream;
        GAR1 B 1 A_SpawnStatueMonster;
		GAR1 B -1;
        Stop;
	}
}

class XRpgStatueGargoyleDarkRedTall : XRpgStatueGargoyleBase replaces ZStatueGargoyleDarkRedTall
{
	Default
	{
        StatueMonster.SpawnMonsterChance 10;
        StatueMonster.StatueMonsterType "FireGargoyle";
	}
	States
	{
	Spawn:
		GAR2 A -1;
		Stop;
    StatueMonsterRise:
		GAR2 B 1 A_Scream;
        GAR2 B 1 A_SpawnStatueMonster;
		GAR2 B -1;
        Stop;
	}
}
class XRpgStatueGargoyleDarkRedShort : XRpgStatueGargoyleShortBase replaces ZStatueGargoyleDarkRedShort
{
	Default
	{
        StatueMonster.SpawnMonsterChance 10;
        StatueMonster.StatueMonsterType "FireGargoyle";
	}
	States
	{
	Spawn:
		GAR6 A -1;
		Stop;
	StatueMonsterRise:
		GAR6 B 1 A_Scream;
        GAR6 B 1 A_SpawnStatueMonster;
		GAR6 B -1;
        Stop;
	}
}

class XRpgStatueGargoyleRedTall : XRpgStatueGargoyleBase replaces ZStatueGargoyleRedTall
{
	Default
	{
        StatueMonster.SpawnMonsterChance 10;
        StatueMonster.StatueMonsterType "BloodGargoyle";
	}
	States
	{
	Spawn:
		GAR3 A -1;
		Stop;
    StatueMonsterRise:
		GAR3 B 1 A_Scream;
        GAR3 B 1 A_SpawnStatueMonster;
		GAR3 B -1;
        Stop;
	}
}
class XRpgStatueGargoyleRedShort : XRpgStatueGargoyleShortBase replaces ZStatueGargoyleRedShort
{
	Default
	{
        StatueMonster.SpawnMonsterChance 10;
        StatueMonster.StatueMonsterType "BloodGargoyle";
	}
	States
	{
	Spawn:
		GAR7 A -1;
		Stop;
	StatueMonsterRise:
		GAR7 B 1 A_Scream;
        GAR7 B 1 A_SpawnStatueMonster;
		GAR7 B -1;
        Stop;
	}
}

class XRpgStatueGargoyleTanTall : XRpgStatueGargoyleBase replaces ZStatueGargoyleTanTall
{
	Default
	{
        StatueMonster.SpawnMonsterChance 25;
        StatueMonster.StatueMonsterType "LightningGargoyle";
	}
	States
	{
	Spawn:
		GAR4 A -1;
		Stop;
    StatueMonsterRise:
		GAR4 B 1 A_Scream;
        GAR4 B 1 A_SpawnStatueMonster;
		GAR4 B -1;
        Stop;
	}
}
class XRpgStatueGargoyleTanShort : XRpgStatueGargoyleShortBase replaces ZStatueGargoyleTanShort
{
	Default
	{
        StatueMonster.SpawnMonsterChance 25;
        StatueMonster.StatueMonsterType "LightningGargoyle";
	}
	States
	{
	Spawn:
		GAR8 A -1;
		Stop;
	StatueMonsterRise:
		GAR8 B 1 A_Scream;
        GAR8 B 1 A_SpawnStatueMonster;
		GAR8 B -1;
        Stop;
	}
}

class XRpgStatueGargoyleRustTall : XRpgStatueGargoyleBase replaces ZStatueGargoyleRustTall
{
	Default
	{
        StatueMonster.SpawnMonsterChance 15;
        StatueMonster.StatueMonsterType "StoneGargoyle";
	}
	States
	{
	Spawn:
		GAR5 A -1;
		Stop;
    StatueMonsterRise:
		GAR5 B 1 A_Scream;
        GAR5 B 1 A_SpawnStatueMonster;
		GAR5 B -1;
        Stop;
	}
}
class XRpgStatueGargoyleRustShort : XRpgStatueGargoyleShortBase replaces ZStatueGargoyleRustShort
{
	Default
	{
        StatueMonster.SpawnMonsterChance 15;
        StatueMonster.StatueMonsterType "StoneGargoyle";
	}
	States
	{
	Spawn:
		GAR9 A -1;
		Stop;
	StatueMonsterRise:
		GAR9 B 1 A_Scream;
        GAR9 B 1 A_SpawnStatueMonster;
		GAR9 B -1;
        Stop;
	}
}

//====================================================================================
// Redefining afrits monster class to remove dormant period, and change inheritance
//====================================================================================

class StatueFireDemon : WonderingMonsterBase
{
	const FIREDEMON_ATTACK_RANGE = 64*8.;
	int fdstrafecount;

	Default
	{
		Health 160;
		ReactionTime 8;
		PainChance 1;
		Speed 13;
		Radius 20;
		Height 68;
		Mass 75;
		Damage 1;
		Monster;
		+DROPOFF +NOGRAVITY +FLOAT
		+FLOORCLIP +INVULNERABLE +TELESTOMP
		SeeSound "FireDemonSpawn";
		PainSound "FireDemonPain";
		DeathSound "FireDemonDeath";
		ActiveSound "FireDemonActive";
		Obituary "$OB_FIREDEMON";
		Tag "$FN_FIREDEMON";
	}

	States
	{
	Spawn:
		FDMN HI 10 Bright A_FiredRocks;
        FDMN J 10 Bright A_UnSetInvulnerable;
    SpawnStand:
		FDMN ABC 5 Bright A_Look;
		Goto SpawnStand;
	See:
		FDMN ABC 5 Bright;
	Chase:
		FDMN ABC 5 Bright A_FiredChase;
		Loop;
	Pain:
		FDMN D 0 Bright;
		FDMN D 6 Bright A_Pain;
		Goto Chase;
	Missile:
		FDMN K 3 Bright A_FaceTarget;
		FDMN KKK 5 Bright A_FiredAttack;
		Goto Chase;
	Crash:
	XDeath:
		FDMN M 5 A_FaceTarget;
		FDMN N 5 A_NoBlocking;
		FDMN O 5 A_FiredSplotch;
		Stop;
	Death:
		FDMN D 4 Bright A_FaceTarget;
		FDMN L 4 Bright A_Scream;
		FDMN L 4 Bright A_NoBlocking;
		FDMN L 200 Bright;
		Stop;
	Ice:
		FDMN R 5 A_FreezeDeath;
		FDMN R 1 A_FreezeDeathChunks;
		Wait;
	}
	
	


	//============================================================================
	// Fire Demon AI
	//
	// special1			index into floatbob
	// fdstrafecount			whether strafing or not
	//============================================================================

	//============================================================================
	//
	// A_FiredSpawnRock
	//
	//============================================================================

	private void A_FiredSpawnRock ()
	{
		Actor mo;
		class<Actor> rtype;

		switch (random[FireDemonRock](0, 4))
		{
			case 0:
				rtype = "FireDemonRock1";
				break;
			case 1:
				rtype = "FireDemonRock2";
				break;
			case 2:
				rtype = "FireDemonRock3";
				break;
			case 3:
				rtype = "FireDemonRock4";
				break;
			case 4:
			default:
				rtype = "FireDemonRock5";
				break;
		}

		double xo = (random[FireDemonRock]() - 128) / 16.;
		double yo = (random[FireDemonRock]() - 128) / 16.;
		double zo = random[FireDemonRock]() / 32.;
		mo = Spawn (rtype, Vec3Offset(xo, yo, zo), ALLOW_REPLACE);
		if (mo)
		{
			mo.target = self;
			mo.Vel.X = (random[FireDemonRock]() - 128) / 64.;
			mo.Vel.Y = (random[FireDemonRock]() - 128) / 64.;
			mo.Vel.Z = (random[FireDemonRock]() / 64.);
			mo.special1 = 2;		// Number bounces
		}

		// Initialize fire demon
		fdstrafecount = 0;
		bJustAttacked = false;
	}

	//============================================================================
	//
	// A_FiredRocks
	//
	//============================================================================
	void A_FiredRocks()
	{
		A_FiredSpawnRock ();
		A_FiredSpawnRock ();
		A_FiredSpawnRock ();
		A_FiredSpawnRock ();
		A_FiredSpawnRock ();
	}

	//============================================================================
	//
	// A_FiredAttack
	//
	//============================================================================

	void A_FiredAttack()
	{
		if (target == null)	return;
		Actor mo = SpawnMissile (target, "FireDemonMissile");
		if (mo) A_StartSound ("FireDemonAttack", CHAN_BODY);
	}

	//============================================================================
	//
	// A_FiredChase
	//
	//============================================================================

	void A_FiredChase()
	{
		int weaveindex = special1;
		double ang;
		double dist;

		if (reactiontime) reactiontime--;
		if (threshold) threshold--;

		// Float up and down
		AddZ(BobSin(weaveindex));
		special1 = (weaveindex + 2) & 63;

		// Ensure it stays above certain height
		if (pos.Z < floorz + 64)
		{
			AddZ(2);
		}

		if(!target || !target.bShootable)
		{	// Invalid target
			LookForPlayers (true);
			return;
		}

		// Strafe
		if (fdstrafecount > 0)
		{
			fdstrafecount--;
		}
		else
		{
			fdstrafecount = 0;
			Vel.X = Vel.Y = 0;
			dist = Distance2D(target);
			if (dist < FIREDEMON_ATTACK_RANGE)
			{
				if (random[FiredChase]() < 30)
				{
					ang = AngleTo(target);
					if (random[FiredChase]() < 128)
						ang += 90;
					else
						ang -= 90;
					Thrust(8, ang);
					fdstrafecount = 3;		// strafe time
				}
			}
		}

		FaceMovementDirection ();

		// Normal movement
		if (!fdstrafecount)
		{
			if (--movecount<0 || !MonsterMove ())
			{
				NewChaseDir ();
			}
		}

		// Do missile attack
		if (!bJustAttacked)
		{
			if (CheckMissileRange () && (random[FiredChase]() < 20))
			{
				SetState (MissileState);
				bJustAttacked = true;
				return;
			}
		}
		else
		{
			bJustAttacked = false;
		}

		// make active sound
		if (random[FiredChase]() < 3)
		{
			PlayActiveSound ();
		}
	}

	//============================================================================
	//
	// A_FiredSplotch
	//
	//============================================================================

	void A_FiredSplotch()
	{
		Actor mo;

		mo = Spawn ("FireDemonSplotch1", Pos, ALLOW_REPLACE);
		if (mo)
		{
			mo.Vel.X = (random[FireDemonSplotch]() - 128) / 32.;
			mo.Vel.Y = (random[FireDemonSplotch]() - 128) / 32.;
			mo.Vel.Z = (random[FireDemonSplotch]() / 64.) + 3;
		}
		mo = Spawn ("FireDemonSplotch2", Pos, ALLOW_REPLACE);
		if (mo)
		{
			mo.Vel.X = (random[FireDemonSplotch]() - 128) / 32.;
			mo.Vel.Y = (random[FireDemonSplotch]() - 128) / 32.;
			mo.Vel.Z = (random[FireDemonSplotch]() / 64.) + 3;
		}
	}
	
}