class BossMaker : EventHandler
{
    WanderingMonsterItem InitWanderingMonster(Actor monsterObj)
    {
        let wmItem = WanderingMonsterItem(monsterObj.FindInventory("WanderingMonsterItem"));

        if (wmItem)
            return wmItem;
        
        wmItem = WanderingMonsterItem(monsterObj.GiveInventoryType("WanderingMonsterItem"));

        wmItem.BaseSpeed = monsterObj.Speed;

        return wmItem;
    }

    SummonExpSquishItem InitFriendlySummon(Actor monsterObj)
    {
        let fsItem = SummonExpSquishItem(monsterObj.FindInventory("SummonExpSquishItem"));

        if (fsItem)
            return fsItem;
        
        fsItem = SummonExpSquishItem(monsterObj.GiveInventoryType("SummonExpSquishItem"));

        return fsItem;
    }

    override void WorldThingSpawned(WorldEvent e)
    {        
        // Check that the Actor is valid and a monster
        if (e.thing)
        {
            if (e.thing.bIsMonster)
            {
                //if a monster, but not a boss, give wandering monster item
                if (!e.thing.bFriendly && !e.thing.bBoss)
                {
                    InitWanderingMonster(e.thing);
                }

                //if friendly, give summoned monster item
                if (e.thing.bFriendly)
                {
                    InitFriendlySummon(e.thing);
                }
            }
        }
    }

    override void CheckReplacement(ReplaceEvent e)
	{
		if (e.Replacee is 'ArtiBoostArmor')
		{
			Name spawnType;
            int magicItemNum = random[MagicItemSpawn](1,4);
            switch (magicItemNum)
            {
                case 1:
                    e.Replacement = 'DragonBracers';
                    break;
                case 2:
                    e.Replacement = 'FireRing';
                    break;
                case 3:
                    e.Replacement = 'IceRing';
                    break;
                case 4:
                    e.Replacement = 'RegenAmulet';
                    break;
                case 5:
                    e.replacement = 'LightningRing';
                    break;
            }
		}
	}
}
