class RaiseDeadItem : Inventory
{
	Class<Actor> summonType;
	property SummonType : summonType;

	Default
	{
		+INVENTORY.UNDROPPABLE
		+INVENTORY.UNTOSSABLE
		+INVENTORY.AUTOACTIVATE
		+INVENTORY.PERSISTENTPOWER
		+INVENTORY.UNCLEARABLE

		RaiseDeadItem.SummonType "XRpgSummonWraith";
	}

    override bool Use(bool pickup)
    {
        if (!Owner || Owner.bFriendly)
			return false;
		
		//Don't summon dying wraiths
		if (Owner is "Wraith" || Owner is "XRpgUndead")
			return false;

		Actor mo = Spawn(self.SummonType, Owner.Pos, ALLOW_REPLACE);
		Spawn("MinotaurSmoke", Owner.Pos, ALLOW_REPLACE);
		Owner.A_StartSound(mo.ActiveSound, CHAN_VOICE);

		Owner.Destroy();

        return false;
    }
}

class RaiseWraithItem : RaiseDeadItem
{
    Default
    {
        RaiseDeadItem.SummonType "MonsterSummonWraith";
    }
}

class RaiseStatueItem : Inventory
{
	Default
	{
		+INVENTORY.UNDROPPABLE
		+INVENTORY.UNTOSSABLE
		+INVENTORY.AUTOACTIVATE
		+INVENTORY.PERSISTENTPOWER
		+INVENTORY.UNCLEARABLE
	}

    override bool Use(bool pickup)
    {
		if (!Owner)
			return false;
		
		let statueMo = StatueMonster(Owner);
		if (!statueMo)
			return false;
		
		if (!statueMo.IsSpawnFinished() && statueMo.StatueMonsterType)
		{
			statueMo.SetState(statueMo.FindState("StatueMonsterRise"));
		}

        return false;
    }
}