const BAT_LIFE_MAX = 1024;

class XRpgSummonBat : Actor
{
    int lifeCounter;

    property lifeCounter : LifeCounter;

	Default
	{
		Health 6;
		PainChance 25;
		Speed 17;
		Height 8;
        Radius 10;
		Mass 10;
		Damage 6;

		Monster;
		+NOGRAVITY +DROPOFF +FLOAT
		+FLOORCLIP +TELESTOMP

        +NOICEDEATH
        +FRIENDLY
		
        SeeSound "BatScream";
		AttackSound "BatScream";
		PainSound "BatScream";
		DeathSound "BatScream";
		ActiveSound "BatScream";
		HitObituary "$OB_WRAITHHIT";
		Obituary "$OB_WRAITH";
		Tag "$FN_WRAITH";

        XRpgSummonBat.LifeCounter WRAITH_LIFE_MAX;
	}

	States
	{
	Spawn:
		ABAT ABCABC 4 Bright;
		Goto Look;
	Look:
		ABAT ABC 4 Bright A_Look;
		Loop;
	See:
		ABAT ABC 4 Bright A_BatChase;
		Loop;
	Pain:
		ABAT ABCAB 2 Bright;
		ABAT C 2 Bright A_Pain;
		Goto See;
	Melee:
		ABAT A 4 Bright A_FaceTarget;
		ABAT B 4 Bright;
		ABAT G 4 Bright A_CustomMeleeAttack(damage, "", "", "Blood", true);
		Goto See;
	Death:
    XDeath:
	Ice:
		BDSH ABC 4 Bright;
        BDSH D 4 Bright A_BatDie();
		Stop;
	}
	
	action void A_BatDie()
	{
		Destroy();
	}
	
    override void Tick()
    {
        LifeCounter--;
        if (LifeCounter < 1 && Health > 0)
        {
            DamageMobj (null, null, TELEFRAG_DAMAGE, 'None');            
            SetStateLabel("Death");
        }
        Super.Tick();
    }

	action void A_BatChase()
	{
		int weaveindex = WeaveIndexZ;
		AddZ(BobSin(weaveindex));
		WeaveIndexZ = (weaveindex + 2) & 63;
		A_Chase ();
	}
}