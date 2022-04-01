
// Ettin --------------------------------------------------------------------

class XRpgUndead : WonderingMonsterBase
{
	Default
	{
		Health 250;
		Radius 20;
		Height 52;
		Mass 100;
		Speed 10;
		Damage 3;
		Painchance 60;
        MaxTargetRange DEFMELEERANGE * 15;
		Monster;
		+FLOORCLIP
		+TELESTOMP
        SeeSound "WraithSight";
		AttackSound "EttinAttack";
		PainSound "WraithPain";
		DeathSound "WraithDeath";
		ActiveSound "WraithActive";
		Obituary "$OB_UNDEAD";
		Tag "$FN_UNDEAD";

        WonderingMonsterBase.DefaultLeaderFlag 0;
        WonderingMonsterBase.DefaultBossFlag 0;
	}
	States
	{
	Spawn:
		CPSZ AA 10 A_Look;
		Loop;
	See:
		CPSZ ABCD 5 A_Chase;
		Loop;
	Pain:
		CPSZ E 7 A_Pain;
		Goto See;
	Melee:
		CPSZ F 6 A_FaceTarget;
		CPSZ G 8 A_CustomMeleeAttack(random[UndeadAttack](1,20)*2);
		Goto See;
    Missile:
		CPSZ V 20 A_FaceTarget;
		CPSZ F 16 A_LeapAttack;
        CPSZ G 8 A_CustomMeleeAttack(random[UndeadAttack](10,30)*2);
        CPSZ AB 8;
		Goto See;
	Death:
	XDeath:		
		CPSZ HIJ 4;
		CPSZ K 4 A_Scream;
		CPSZ L 4 A_NoBlocking;
		CPSZ M 4 A_QueueCorpse;
		CPSZ NOPQRS 4;
		CPSZ T -1;
    Stop;
	Ice:
		CPSZ U 5 A_FreezeDeath;
		CPSZ U 1 A_FreezeDeathChunks;
		Wait;
	}

    const UNDEAD_LEAP_VELZ = 10;
    const UNDEAD_LEAP_VELF = 15;
    action void A_LeapAttack()
    {
        A_PlaySound("WraithSight");
        let newVel = invoker.Vel + (0,0,UNDEAD_LEAP_VELZ);
        invoker.A_ChangeVelocity(newVel.X, newVel.Y, newVel.Z, CVF_REPLACE);
        invoker.Thrust(UNDEAD_LEAP_VELF, angle);
    }
}



class UndeadStatue : StatueMonster
{
    Default
	{
		Radius 14;
		Height 108;
		DeathSound "WraithPain";
        DeathHeight 108;

        StatueMonster.SingleChance false;
        StatueMonster.SpawnMonsterChance 10;
        StatueMonster.StatueMonsterType "XRpgUndead";
        StatueMonster.EndSolid 0;
        StatueMonster.SpawnOnGround 1;
	}
}

class UndeadSpike : UndeadStatue replaces ZCorpseKabob
{
	Default
	{
		Radius 10;
		Height 92;
        DeathHeight 92;
	}
	States
	{
	Spawn:
		CPS1 A -1;
		Stop;
    StatueMonsterRise:
		CPS1 B 6 A_Scream;
        CPS1 CDE 6;
        CPS1 F 6 A_SpawnStatueMonster;
		CPS1 F -1;
        Stop;
	}
}

class UndeadSleeping : UndeadStatue replaces ZCorpseSleeping
{
	Default
	{
		Radius 20;
		Height 16;
        DeathHeight 16;
	}
    States
	{
	Spawn:
		CPS2 A -1;
		Stop;
    StatueMonsterRise:
		CPS2 B 6 A_Scream;
        CPS2 CDEF 6;
        CPS2 G 6;
        TNT1 A 1 A_SpawnStatueMonster;
        Stop;
	}
}


class UndeadSitting : UndeadStatue replaces ZCorpseSitting
{
	Default
	{
		Health 30;
		Radius 15;
		Height 35;
        Health 90;
		DeathSound "FireDemonDeath";

        StatueMonster.CanBeKilled 1;
	}

	States
	{
	Spawn:
		CPS6 A -1;
		Stop;
    StatueMonsterRise:
		CPS6 B 6 A_Scream;
        CPS6 CD 6;
        CPS6 E 6;
        TNT1 A 1 A_SpawnStatueMonster;
        Stop;
	Death:
		CPS6 A 1 A_CorpseExplode;
		Stop;
	}
	
	//============================================================================
	//
	// A_CorpseExplode
	//
	//============================================================================

	void A_CorpseExplode()
	{
		Actor mo;

		for (int i = random[CorpseExplode](3, 6); i; i--)
		{
			mo = Spawn ("CorpseBit", Pos, ALLOW_REPLACE);
			if (mo)
			{
				mo.SetState (mo.SpawnState + random[CorpseExplode](0, 2));
				mo.Vel.X = random2[CorpseExplode]() / 64.;
				mo.Vel.Y = random2[CorpseExplode]() / 64.;
				mo.Vel.Z = random[CorpseExplode](5, 12) * 0.75;
			}
		}
		// Spawn a skull
		mo = Spawn ("CorpseBit", Pos, ALLOW_REPLACE);
		if (mo)
		{
			mo.SetState (mo.SpawnState + 3);
			mo.Vel.X = random2[CorpseExplode]() / 64.;
			mo.Vel.Y = random2[CorpseExplode]() / 64.;
			mo.Vel.Z = random[CorpseExplode](5, 12) * 0.75;
		}
		A_StartSound (DeathSound, CHAN_BODY);
		Destroy ();
	}
}