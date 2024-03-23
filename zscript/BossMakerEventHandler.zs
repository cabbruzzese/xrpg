class BossMakerEventHandler : EventHandler
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
                    e.replacement = 'LightningRing';
                    break;
            }
		}
        else if (e.replacee is 'AmuletOfWarding')
        {
            Name spawnType;
            int magicItemNum = random[MagicItemSpawn](1,3);
            switch (magicItemNum)
            {
                case 1:
                    e.Replacement = 'WardingAmulet';
                    break;
                case 2:
                    e.Replacement = 'RegenAmulet';
                    break;
                case 3:
                    e.replacement = 'ManaAmulet';
                    break;
            }
        }
        else if (e.Replacee is 'FalconShield')
		{
			Name spawnType;
            int magicItemNum = random[MagicItemSpawn](1,3);
            switch (magicItemNum)
            {
                case 1:
                    e.Replacement = 'FalconLargeShield';
                    break;
                case 2:
                    e.Replacement = 'RoundShield';
                    break;
                case 3:
                    e.Replacement = 'SilverSmallShield';
                    break;
            }
		}
        else if (e.Replacee is 'MeshArmor')
        {
            Name spawnType;
            int magicItemNum = random[MagicItemSpawn](1,3);
            switch (magicItemNum)
            {
                case 1:
                    e.Replacement = 'MeshBodyArmor';
                    break;
                case 2:
                    e.Replacement = 'LeatherBodyArmor';
                    break;
                case 3:
                    e.Replacement = 'PlateMail';
                    break;
            }

            //Small chance for magic robes
            magicItemNum = random[MagicItemSpawn](1,8);
            if (magicItemNum == 1)
                e.Replacement = 'MagicRobes';
            else if (magicItemNum == 2)
                e.Replacement = 'DragonScaleArmor';
        }
        else if (e.Replacee is 'PlatinumHelm')
        {
            Name spawnType;
            int magicItemNum = random[MagicItemSpawn](1,3);
            switch (magicItemNum)
            {
                case 1:
                    e.Replacement = 'PlatinumHelmet';
                    break;
                case 2:
                    e.Replacement = 'MetalCap';
                    break;
                case 3:
                    e.Replacement = 'WingedHelmet';
                    break;
            }
        } 
	}
}