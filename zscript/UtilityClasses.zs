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

class TimedActor : Actor
{
    int timeLimit;
    property TimeLimit : timeLimit;

    Default
    {
        TimedActor.TimeLimit 100;
    }

    override void Tick()
    {
        Super.Tick();

        TimeLimit--;
        if (TimeLimit < 1)
        {
            Destroy();
        }
    }
}