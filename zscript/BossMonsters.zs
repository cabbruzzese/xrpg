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
        SeeSound "EttinSight";
        AttackSound "EttinSwing";//changed from default; it's now just a "swing" sound, with a melee impact sound declared in the melee function
        PainSound "EttinPain";
        DeathSound "EttinDeath";
        ActiveSound "EttinActive";
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
            CETN G 8 A_SpawnProjectile('EttinMaceProjectile2', 40);
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