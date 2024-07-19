class EttinMiniBoss : Ettin
{
    Default
    {
        Health 400;
        Radius 25;
        Height 68;
        Mass 175;
        Speed 13;
        PainChance 60;
        Monster;
        +FLOORCLIP
        +TELESTOMP

        // FRIGHTENING will be used as miniboss flag
        +FRIGHTENING
        
        MaxTargetRange 210;
        AttackSound "EttinSwing";//changed from default; it's now just a "swing" sound, with a melee impact sound declared in the melee function
        HowlSound "PuppyBeat";
        Obituary "%o was beat down by an Ettin.";
    }
    States
    {
        Spawn:
            CETN AA 10 A_Look;
            Loop;
        See:
            CETN ABCD 5 A_Chase;
            Loop;
        Pain:
            CETN H 7 A_Pain;
            Goto See;
        Melee:
            CETN EF 6 A_FaceTarget;
            CETN G 8 A_CustomMeleeAttack(random(1,8)*4, "EttinHit");
            Goto See;
        Missile: //this tends to miss flying targets, so use this attack at your discretion!  Added "OFFSETPITCH" to compensate somewhat.
            CETN EF 6 A_FaceTarget;
            CETN G 8 A_FireEttinFlail;
            Goto See;
        Death:
            CETN IJ 4;
            CETN K 4 A_Scream;
            CETN L 4 A_NoBlocking;
            CETN M 4 A_QueueCorpse;
            CETN NOP 4;
            CETN Q -1;
            Stop;
        XDeath:     
            CETN R 4;
            CETN S 4 A_NoBlocking;
            CETN T 4 A_SpawnItemEx("EttinMace", 0, 0, 8.5, random[DropMace](-128, 127)*0.03125,
                                random[DropMace](-128, 127)*0.03125, 10+random[DropMace](0, 255)*0.015625, 0,
                                SXF_ABSOLUTEVELOCITY);
            CETN U 4 A_Scream;
            CETN V 4 A_QueueCorpse;
            CETN WXYZ[ 4;
            CETN \ -1;
            Stop;
        Ice:
            CETN ] 5 A_FreezeDeath;
            CETN ] 1 A_FreezeDeathChunks;
            Wait;
    }

    action void A_FireEttinFlail()
    {
        A_SpawnProjectile('EttinMaceProjectile2', 40);
        A_SpawnProjectile('EttinMaceProjectile2Chain', 40);
        A_SpawnProjectile('EttinMaceProjectile2Chain2', 40);
        A_SpawnProjectile('EttinMaceProjectile2Chain3', 40);
    }
}

class EttinMaceProjectile2Chain : EttinMaceProjectile2
{
    Default
    {
        Damage 0;
        Speed 11;
        Scale 0.5;
    }
}

class EttinMaceProjectile2Chain2 : EttinMaceProjectile2Chain
{
    Default
    {
        Speed 8;
    }
}

class EttinMaceProjectile2Chain3 : EttinMaceProjectile2Chain
{
    Default
    {
        Speed 5;
    }
}

class EttinMaceProjectile2 : Actor
{
    Default
    {
        Radius 12;
        Height 12;
        Speed 14;	
        Damage 1;
        Health 26;
        Projectile;
        +RIPPER;
        +THRUGHOST
        SeeSound "EttinSwing";
        BounceSound "mace/bounce";
        DeathSound "mace/bounce";

		+BOUNCEONFLOORS
		+BOUNCEONCEILINGS
		+USEBOUNCESTATE
		+BOUNCEONWALLS
		+CANBOUNCEWATER
		+FORCEXYBILLBOARD

        scale 1.5;
    }

    States
    {
        Spawn:
            ETTH A 5;
            Loop;
        Bounce:
    		ETTH A 1;
	    	Goto Spawn;
        Death:
            ETTH A 5;
            Stop;
    }

    override void Tick()
    {
        super.Tick();

        health--;
        if (health == 0 || !target)
        {
            Destroy();
        }
        else if (health <= 10)
        {
            let targetZ = target.Pos.Z + (target.Height / 2);
            let vecOffset = (target.Pos.X - Pos.X, target.Pos.Y - Pos.Y);
			let ang = Vectorangle(vecOffset.x, vecOffset.y);
			A_SetAngle(ang);
			
			let dist = Distance2D(target);

            //if too close, kill on next frame
            if (dist < 0.1)
                health = 0; 

			let vel = dist * 0.25;
			let aPitch = Vectorangle(dist, Pos.Z - targetZ);
			
			Vel3DFromAngle(vel, angle, aPitch);
        }
    }
}

class SkeletonMiniBoss : Centaur
{
    Default
    {
        Health 500;
        Radius 24;
        Height 72;
        Mass 700;
        Speed 10;
        PainChance 20;
        Obituary "%o thought he could kill a deathknight.";
        HitObituary "A Deathknight hacked %o into pieces.";
        SeeSound "monster/dknsit";
        PainSound "monster/dknpai";
        DeathSound "monster/dkndth";
        ActiveSound "monster/dknact";
        HowlSound "monster/dknpai";
        MONSTER;
        +FLOORCLIP
        +NOTARGET
        +NORADIUSDMG
        +BOSS
        +DEFLECT

        DamageFactor "Electric", 3;

        // FRIGHTENING will be used as miniboss flag
        +FRIGHTENING
    }

    States
    {
    Spawn:
        DKNT AB 10 A_Look();
        Loop;
    See:
        DKNT A 0 A_Jump(32,"See2");
        DKNT A 0 A_UnSetReflectiveInvulnerable();
        DKNT AABBCCDD 3 A_Chase();
        Goto See;
    See2:
        DKNT P 0 A_SetReflectiveInvulnerable();
        DKNT PPQQRRSS 3 A_Chase();
        DKNT PPQQRRSS 3 A_Chase();
        DKNT PPQQRRSS 3 A_Chase();
        DKNT PPQQRRSS 3 A_Chase();
        Goto See;
    Melee:
        DKNT E 0 A_UnSetReflectiveInvulnerable();
        DKNT E 6 A_FaceTarget();
        DKNT F 1 A_StartSound ("monster/dknswg");
        DKNT F 6 A_FaceTarget();
        DKNT G 6 A_CustomMeleeAttack(random(10, 40), "monster/dknhit");
        Goto See;
    Pain:
        DKNT H 2;
        DKNT H 2 A_Pain();
        DKNT H 0 A_FaceTarget();
        DKNT T 105 A_SetReflectiveInvulnerable();
        DKNT T 0 A_UnSetReflectiveInvulnerable();
        DKNT P 0 A_Jump(16, "See");
        Goto See2;
    Death:
        DKNT I 8 Bright;
        DKNT J 8 Bright A_Scream();
        DKNT K 8 Bright;
        DKNT L 8 Bright A_NoBlocking();
        DKNT MN 8 Bright;
        DKNT O -1;
        Stop;
    XDeath:
        DKNT I 0 Bright;
        DKNT I 8 Bright
        {
			A_SpawnItemEx("CentaurSword", 0, 0, 45,
								1 + random[CentaurDrop](-128,127)*0.03125,
								1 + random[CentaurDrop](-128,127)*0.03125,
								8 + random[CentaurDrop](0,255)*0.015625, 270);
			A_SpawnItemEx("CentaurShield", 0, 0, 45,
								1 + random[CentaurDrop](-128,127)*0.03125,
								1 + random[CentaurDrop](-128,127)*0.03125,
								8 + random[CentaurDrop](0,255)*0.015625, 90);
		}
        DKNT J 8 Bright A_Scream();
        DKNT K 8 Bright;
        DKNT L 8 Bright A_NoBlocking();
        DKNT MN 8 Bright;
        DKNT O -1;
        Stop;
    Raise:
        DKNT ONMLKJI 8 Bright;
        Goto See;
    }
}

class DeathknightMiniBoss : SkeletonMiniBoss
{
    Default
    {
        Health 600;
    }

    States
    {
    Missile:
        DKNT T 9 Bright A_FaceTarget();
        DKNT T 3 Bright A_FaceTarget();
        DKNT U 3 Bright A_SpawnProjectile("DKbolt2",44,-4,0,0);
        DKNT T 3 Bright A_FaceTarget();
        DKNT U 3 Bright A_SpawnProjectile("DKbolt2",44,-4,0,0);
        DKNT T 3 Bright A_FaceTarget();
        DKNT U 2 Bright A_SpawnProjectile("DKbolt2",44,-4,0,0);
        DKNT T 6 Bright;
        Goto See;
    }
}

Class RedPuff2 : Actor
{
  Default
  {
    Radius 0;
    Height 1;
    Speed 0;
    RENDERSTYLE "Add";
    ALPHA 0.85;
    PROJECTILE;
    +ClientSideOnly
  }

  States
  {
  Spawn:
    TNT1 A 3 Bright;
    RPUF ABCDE 3 Bright;
    Stop;
  }
}

Class DKboltBase : Actor
{
  Default
  {
    Radius 8;
    Height 8;
    Speed 15;
    Damage 8;
    RENDERSTYLE "Add";
    ALPHA 0.80;
    DamageType "Fire";
    SeeSound "Weapons/boltfi";
    DeathSound "weapons/firex4";
    PROJECTILE;
    +THRUGHOST
  }

  States
  {
  Spawn:
    BOLT A 1 Bright A_BishopMissileWeave();
    BOLT A 0 A_SpawnItem("RedPuff2",0,0);
    loop;
  Death:
    HBAL EFHI 2 Bright;
    stop;
  }
}

Class DKbolt2 : DKboltBase
{
  Default
  {
    Damage 3;
  }
}

class AfritsMiniBoss : HereticImp
{
    Default
    {
        Health 160;
        Radius 16;
        Height 36;
        Mass 50;
        Speed 15;
        Painchance 50;
        scale 1.2;
        Monster;
        +FLOAT
        +NOGRAVITY
        +SPAWNFLOAT
        +DONTOVERLAP
        +MISSILEMORE
        +AVOIDMELEE
        MaxTargetRange 2048;
        AttackSound "ethit1";
		SeeSound "wing1";
		PainSound "FireDemonPain";
		DeathSound "FireDemonDeath";
		ActiveSound "wing1";
        Obituary "%o was burnt by a Dark Gargoyle.";
        HitObituary "%o was slashed by a Dark Gargoyle.";

        // FRIGHTENING will be used as miniboss flag
        +FRIGHTENING
    }
  
  States
  {
    Spawn:
        WATC ABCB 10 A_Look;
        Loop;
    See:
        WATC AABBCCBB 3 A_Chase;
        Loop;
    Melee:
        WATC DE 4 BRIGHT A_FaceTarget;
        WATC F 4 BRIGHT A_CustomMeleeAttack(random[ImpMeAttack](7,14), "SerpentMeleeHit");
        WATC "[^]" 4 BRIGHT A_FaceTarget;
        WATC "]" 0 BRIGHT A_CustomMeleeAttack(random[ImpMeAttack](7,14), "SerpentMeleeHit");
        Goto See;
    Missile:
        WATC E 0 BRIGHT A_jump(120,"beastball");
        WATC DE 4 BRIGHT A_FaceTarget;
        WATC F 4 BRIGHT A_CustomComboAttack("HereticImpBall3", 28, 14);
        WATC "[^]" 4 BRIGHT A_FaceTarget;
        WATC "]" 0 BRIGHT A_CustomComboAttack("HereticImpBall3", 28, -14);
        WATC DE 4 BRIGHT A_FaceTarget;
        WATC F 4 BRIGHT A_CustomComboAttack("HereticImpBall3", 28, 14);
        Goto See;
    Beastball:
        WATC DDDE 6 BRIGHT A_FaceTarget;
        WATC F 6 BRIGHT A_CustomComboAttack('HereticImpBall4', 28, random[BeastAttack](1,8)*3);
        WATC F 6 BRIGHT;
        Goto See;
    Pain:
        WATC G 3;
        WATC G 3 A_Pain;
        Goto See;
    Death:
        WATC G 4 A_ImpDeath;
        WATC H 5;
        Wait;
    XDeath:
        WATC S 5 A_ImpXDeath1;
        WATC TU 5;
        WATC V 5 A_Gravity;
        WATC W 5;
        Wait;
    Crash:
        WATC I 7 A_ImpExplode;
        WATC J 7 A_Scream;
        WATC K 7;
        WATC L -1;
        Stop;
    XCrash:
        WATC X 7;
        WATC Y 7;
        WATC Z -1;
        Stop;
    }
}

class HereticImpBall3 : HereticImpBall
{
    Default
    {
        SeeSound "DemonMissileFire";
        DeathSound "DemonMissileExplode";
    }

    States
    {
        Spawn:
            HIB1 ABC 6 Bright;
            Loop;
        Death:
            HIB1 DEFG 5 Bright;
            Stop;
    }
}

class HereticImpBall4 : Demon1FX1
{
    Default
    {
        SeeSound "DemonMissileFire";
        DeathSound "DemonMissileExplode";
        Damage 8;
    }
}

class DemonMiniBoss : Actor
{
    Default
    {   
        OBITUARY "%o was killed by a shadow beast.";
        Bloodcolor "70 AC 00";
        Health 600;
        Radius 40;
        Height 80;
        Mass 500;
        Speed 12;
        PainChance 144;
        SEESOUND "shadowbeast/sight";
        PAINSOUND "shadowbeast/pain";
        DEATHSOUND "shadowbeast/death";
        ACTIVESOUND "shadowbeast/active";
        ATTACKSOUND "DemonAttack";
        MONSTER;
        +FloorClip
        MaxTargetRange 2048;

        DamageFactor "Poison", 0.25; 

        // FRIGHTENING will be used as miniboss flag
        +FRIGHTENING
    }
  
    States
    {
    Spawn:
        BDEM AB 10 A_Look;
        Loop;
    See:
        TNT1 A 0 A_JumpIfHealthLower (250, "Run");
        BDEM ABCDEF 6 A_Chase;
        Loop;
    Run:
        TNT1 A 0 A_StartSound("shadowbeast/sight");
        BDEM AABBCCDDEEFF 2 A_Chase();
        BDEM AABBCCDDEEFF 2 A_Chase();
        BDEM AABBCCDDEEFF 2 A_Chase();
        Goto Missile;
    Melee:
        BDEM B 5 A_FaceTarget;
        BDEM H 5 A_FaceTarget;
        BDEM I 6 A_CustomMeleeAttack(random(10, 50), "DemonAttack");
        Goto See;
    Missile:
        TNT1 A 0 A_JumpIfHealthLower (250, "MissileHurt") ;
        TNT1 A 0 A_Jump(90, "Missile2");
        BDEM H 6 A_FaceTarget;
        BDEM I 6 A_SpawnProjectile ("ShadowBeast_Ball1_1", 56, 0, 0);
        BDEM I 0 A_SpawnProjectile ("ShadowBeast_Ball1_1", 56, 0, -3);
        BDEM I 0 A_SpawnProjectile ("ShadowBeast_Ball1_1", 56, 0, 3);
        Goto See;
    Missile2:
        BDEM H 4 A_FaceTarget;
        BDEM I 4 A_SpawnProjectile ("ShadowBeast_Ball2_1", 56, 0, -16);
        BDEM I 0 A_FaceTarget;
        BDEM I 4 A_SpawnProjectile ("ShadowBeast_Ball2_1", 56, 0, -8);
        BDEM I 0 A_FaceTarget;
        BDEM I 4 A_SpawnProjectile ("ShadowBeast_Ball2_1", 56, 0, 0);
        BDEM I 0 A_FaceTarget;
        BDEM I 4 A_SpawnProjectile ("ShadowBeast_Ball2_1", 56, 0, 8);
        BDEM I 0 A_FaceTarget;
        BDEM I 4 A_SpawnProjectile ("ShadowBeast_Ball2_1", 56, 0, 16);
        BDEM I 0 A_FaceTarget;
        BDEM I 4 A_SpawnProjectile ("ShadowBeast_Ball2_1", 56, 0, 32);
        Goto See;
    MissileHurt:
        TNT1 A 0 A_Jump(90, "MissileHurt2");
        BDEM H 6 A_FaceTarget;
        BDEM I 2 A_SpawnProjectile ("ShadowBeast_BallFire_1", 56, 0, random(-1,1));
        BDEM I 2 A_SpawnProjectile ("ShadowBeast_BallFire_2", 56, 0, random(-8,8));
        BDEM I 2 A_SpawnProjectile ("ShadowBeast_BallFire_2", 56, 0, random(-8,8));
        BDEM I 2 A_SpawnProjectile ("ShadowBeast_BallFire_2", 56, 0, random(-8,8));
        BDEM I 2 A_SpawnProjectile ("ShadowBeast_BallFire_2", 56, 0, random(-8,8));
        BDEM I 2 A_SpawnProjectile ("ShadowBeast_BallFire_2", 56, 0, random(-8,8));
        Goto See;
    MissileHurt2:
        BDEM H 16 A_FaceTarget;
        BDEM I 1 A_SpawnProjectile ("ShadowBeast_Ball2_1", 56, 0, 0);
        BDEM I 0 A_SpawnProjectile ("ShadowBeast_Ball2_1", 56, 0, -16);
        BDEM I 1 A_SpawnProjectile ("ShadowBeast_Ball2_1", 56, 0, 16);  
        BDEM I 0 A_SpawnProjectile ("ShadowBeast_Ball2_1", 56, 0, -8);
        BDEM I 1 A_SpawnProjectile ("ShadowBeast_Ball2_1", 56, 0, 8);  
        BDEM I 6;
        Goto See;
    Pain:
        TNT1 A 0;
        BDEM G 4 A_Pain;
        Goto See;
    Death:
        BDEM R 8;
        BDEM S 8 A_Scream;
        BDEM TUVWX 6;
        BDEM Y 6 A_NoBlocking;
        BDEM Z -1;
        Stop;
    }
    
    void A_SetNoPain(bool value)
    {
        bNoPain = value;
    }
}

class ShadowBeast_BallFire_1 : Actor
{
    Default
    {
        Alpha 1.0;
        Renderstyle "Add";
        Speed 15;
        Radius 10;
        Height 6;
        Damage 1;
        DamageType "Poison";
        Projectile;
        +SPAWNSOUNDSOURCE;
        +RIPPER;
        SeeSound "shadowbeast/pr1death";
        Decal 'MummyScorch';
        +BLOODLESSIMPACT;
    }

    States
    {
    Spawn:
        BDP2 DEFGH 5 Bright;
        Goto Death;
    Death:
        TNT1 A 0;
        Stop;
    }
}

class ShadowBeast_BallFire_2 : ShadowBeast_BallFire_1
{
    Default
    {
        Damage 0;
    }
}

class ShadowBeast_Ball1_1 : Actor
{
    Default
    {
        Alpha 1.0;
        Renderstyle "Add";
        Speed 15;
        Radius 10;
        Height 6;
        Damage 2;
        DamageType "Poison";
        Projectile;
        +SPAWNSOUNDSOURCE
        SeeSound "shadowbeast/pr1sight";
        DeathSound "shadowbeast/pr1death";
    }
    States
    {
    Spawn:
        BDP2 ABC 4 Bright;
        Loop;
    Death:
        BDP2 DE 4 Bright;
        BDP2 FGH 3 Bright;
        Stop;
    }
}

class ShadowBeast_Ball2_1 : Actor
{
    Default
    {
        Alpha 1.0;
        Renderstyle "Add";
        Radius 8;
        Height 6;
        Damage 1;
        DamageType "Poison";
        Speed 16;
        PROJECTILE;
        +Randomize
        SeeSound "shadowbeast/pr1sight";
        DeathSound "shadowbeast/pr2death";
        Decal 'PlasmaScorchLower';
    }
    States
    {
    Spawn:
        BDP1 D 1 A_BishopMissileWeave;
        BDP1 E 1 A_BishopMissileWeave;
        loop;
    Death:
        BDP1 FGHI 3;
        Stop;
    }
}