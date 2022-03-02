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
		if (Owner is "Wraith")
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