const ACTORLISTMAX = 128;
class ActorList
{
	Actor actors[ACTORLISTMAX];
	int arrayLen;
    int arrayLenMax;

    void Init(int maxLen)
    {
        Clear();
        arrayLenMax = maxLen;
    }

	void Clear ()
	{
		for (int i = 0; i < arrayLenMax; i++)
		{
			let mo = actors[i];
			if (mo)
			{
				//mo.Destroy();
				actors[i] = null;
			}
		}
		arrayLen = 0;
	}

	void Shift()
	{
		if (arrayLen < 1)
			return;
		
		//actors[0].Destroy();
		for (int i = 0; i < arrayLen; i++)
		{
			actors[i - 1] = actors[i];
		}
		
		arrayLen--;
		actors[arrayLen] = null;
	}

	void Push(Actor newActor)
	{
		if (arrayLen >= arrayLenMax)
		{
			Shift();
		}

		actors[arrayLen] = newActor;
		arrayLen++;
	}

	Actor Pop()
	{
		if (arrayLen == 0)
			return Actor(null);

		arrayLen--;
		let mo = actors[arrayLen];
		actors[arrayLen] = null;

		return mo;
	}

	Actor GetItem(int itemIndex)
	{
        if (itemIndex < 0 || itemIndex > arrayLen)
            return Actor(null);
        
	    let mo = actors[itemIndex];
        return mo;
	}

	int GetSize()
	{
		return arrayLen;
	}

    int GetMaxSize()
	{
		return arrayLenMax;
	}
}

class TimedActor : StoppableActor
{
    int timeLimit;
	bool dieOnTimer;
    property TimeLimit : timeLimit;
	property DieOnTimer : dieOnTimer;

    Default
    {
        TimedActor.TimeLimit 100;
		TimedActor.DieOnTimer false;
    }

    override void Tick()
    {
        Super.Tick();

        TimeLimit--;
        if (TimeLimit < 1)
        {
			if (DieOnTimer)
			{
				A_StopMoving(true);
			}
			else
			{
            	Destroy();
			}
        }
    }
}

class StoppableActor : OffsetSpriteActor
{
	double oldSpeed;
	property OldSpeed : oldSpeed;

    Default
    {
        Projectile;
    }

	action void A_PushTarget(Actor victim, double power = 30.0)
	{
		if (!victim)
			return;
		
		if (victim.bDONTTHRUST)
			return;

		if (victim.bIsMonster || (victim is "PlayerPawn"))
		{
			victim.thrust(power, angle);
		}
	}

	action void A_StopMoving(bool gotoDeath = false)
	{
		invoker.OldSpeed = invoker.Speed;

		invoker.A_ChangeVelocity(0, 0, 0, CVF_REPLACE);
		invoker.A_SetSpeed(0);

		if (gotoDeath)
		{
			invoker.bRipper = false;
			invoker.bMissile = false;
			invoker.SetStateLabel("Death");
		}
	}

	void AdjustSpeed (double speedMod)
	{
		Speed *= speedMod;
		A_ChangeVelocity(Vel.X * speedMod, Vel.Y * speedMod, Vel.Z * speedMod);
	}

	action void A_RenewSpeed()
	{
		if (invoker.Speed > invoker.OldSpeed)
			invoker.OldSpeed = invoker.Speed;

		invoker.A_SetSpeed(invoker.OldSpeed);
		Vector3 dir = (AngleToVector(invoker.angle, cos(invoker.pitch)), -sin(invoker.pitch));
		Vector3 vel = (dir.X * invoker.Speed, dir.Y * invoker.Speed, dir.Z * invoker.Speed);
		invoker.A_ChangeVelocity(vel.X, vel.Y, vel.Z, CVF_REPLACE);
	}

	action void A_RenewMissile()
	{
		invoker.bMissile = true;
		A_RenewSpeed();
	}
}

class OffsetSpriteActor : Actor
{
	double offsetSpriteX;
	double offsetSpriteY;
	property OffsetSpriteX : offsetSpriteX;
	property OffsetSpriteY : offsetSpriteY;
    
    override void PostBeginPlay()
	{
		if (offsetSpriteX != 0 || offsetSpriteY != 0)
			A_SpriteOffset(offsetSpriteX, offsetSpriteY);
    }
}

class PowerSpark : Actor
{
    Default
    {
        Radius 5;
		Mass 5;
		Projectile;
		-ACTIVATEPCROSS
		-ACTIVATEIMPACT
        -NOGRAVITY
		BounceType "HexenCompat";
		BounceFactor 0.3;
        Scale 0.25;
    }

    States
	{
	Spawn:
		SGSA FGHIJ 4;
		SGSA FGHIJ 4;
		SGSA FGHIJ 4;
		Stop;
	Death:
		Stop;
	}
}

class ActorUtils : Actor
{
	static void CopyStyles(Actor copySource, Actor copyTarget, bool copyAngle = false)
	{
		if (!copySource)
			return;
		if (!copyTarget)
			return;

		if (copyAngle)
			copyTarget.A_SetAngle(copySource.angle);
	
		copyTarget.Translation = copySource.Translation;
		copyTarget.A_SetScale(copySource.Scale.X);

		copyTarget.A_SetRenderStyle(copySource.alpha, copySource.GetRenderStyle());
	}

	static void ThrowSpark(Actor victim, Name sparkType)
    {
		if (!victim)
			return;
		
		if (!sparkType)
			return;
		
        let xo = random[FSpellPowerSpark](-16, 16);
        let yo = random[FSpellPowerSpark](-16, 16);
        let zo = victim.Height / 2;
        let sparkPos = victim.Pos + (xo, yo, zo);

        let vx = frandom[FSpellPowerSpark](-2.0, 2.0);
        let vy = frandom[FSpellPowerSpark](-2.0, 2.0);
        let vz = frandom[FSpellPowerSpark](2.0, 4.0);

        let mo = Spawn(sparkType);
        if (!mo)
            return;

        mo.target = victim;
        mo.SetOrigin(sparkPos, false);
        mo.A_ChangeVelocity(vx, vy, vz, CVF_REPLACE);
    }

	static void ThrowSparks(Actor victim, Name sparkType)
	{
		if (!victim)
			return;
		
		if (!sparkType)
			return;

		for (int i = 0; i < 8; i++)
        {
            ThrowSpark(victim, sparkType);
        }
	}

	static bool ClericPlayerExists()
    {
        for (int i = 0; i < MaxPlayers; i++)
        {
            if (players[i].mo && players[i].mo is "XRpgClericPlayer")
            {
                return true;
            }
        }

        return false;
    }

	static bool IsPositionInvalid(Actor tester)
	{
		if (!tester)
			return true;
		
		return(!tester.TestMobjLocation() || tester.height > (tester.ceilingz - tester.floorz) || !tester.CheckMove(tester.Pos.XY));
	}

}