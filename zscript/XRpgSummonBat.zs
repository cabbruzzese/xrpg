const BAT_LIFE_MAX = 1024;

class XRpgSummonBat : Actor
{
    int lifeCounter;

    property lifeCounter : LifeCounter;

	Default
	{
		Health 5;
		PainChance 25;
		Speed 17;
		Height 8;
        Radius 10;
		Mass 10;
		Damage 4;

		Monster;
		+NOGRAVITY +DROPOFF +FLOAT
		+FLOORCLIP +TELESTOMP

        +NOICEDEATH
        +FRIENDLY
		
        SeeSound "WraithSight";
		AttackSound "WraithAttack";
		PainSound "WraithPain";
		DeathSound "WraithDeath";
		ActiveSound "WraithActive";
		HitObituary "$OB_WRAITHHIT";
		Obituary "$OB_WRAITH";
		Tag "$FN_WRAITH";

        XRpgSummonBat.LifeCounter WRAITH_LIFE_MAX;
	}

	States
	{
	Spawn:
		ABAT ABCABC 4;
		Goto Look;
	Look:
		ABAT ABC 4 A_Look;
		Loop;
	See:
		ABAT ABC 4 A_BatChase;
		Loop;
	Pain:
		ABAT ABCAB 2;
		ABAT C 2 A_Pain;
		Goto See;
	Melee:
		ABAT A 4 A_FaceTarget;
		ABAT B 4;
		ABAT G 4 A_CustomMeleeAttack(damage);
		Goto See;
	Death:
    XDeath:
	Ice:
		BDSH ABC 4;
        BDSH D 4 A_BatDie();
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