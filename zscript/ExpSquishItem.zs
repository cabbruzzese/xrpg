class ExpSquishItem : Powerup
{
	Default
	{
		+INVENTORY.UNDROPPABLE
        +INVENTORY.UNTOSSABLE
        +INVENTORY.AUTOACTIVATE
        +INVENTORY.PERSISTENTPOWER
        +INVENTORY.UNCLEARABLE

        Powerup.Duration 0x7FFFFFFF;
	}

	//===========================================================================
	//
	// ModifyDamage
	//
	//===========================================================================

	override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if (!passive && damage > 0 && Owner && Owner.Player && Owner.Player.mo)
        {
            let xrpgPlayer = XRpgPlayer(Owner.Player.mo);
            if (xrpgPlayer)
            {
                xrpgPlayer.DoXPHit(source, damage, damageType);
            }
        }
	}
}

/*class SummonExpSquishItem : Powerup
{
	Default
	{
		+INVENTORY.UNDROPPABLE
        +INVENTORY.UNTOSSABLE
        +INVENTORY.AUTOACTIVATE
        +INVENTORY.PERSISTENTPOWER
        +INVENTORY.UNCLEARABLE

        Powerup.Duration 0x7FFFFFFF;
	}

	//===========================================================================
	//
	// ModifyDamage
	//
	//===========================================================================

	override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if (!passive && damage > 0 && Owner && Owner.bIsMonster && Owner.bFriendly)
        {
			//console.printf("Summoned monster attacked");
			if (!owner.tracer)
				return;
			
            let xrpgPlayer = XRpgPlayer(Owner.tracer);
            if (xrpgPlayer)
            {
                xrpgPlayer.DoXPHit(source, damage, damageType);
            }
        }
	}
}*/