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

class StoppableActor : Actor
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