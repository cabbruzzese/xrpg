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

    override void WorldThingDamaged (WorldEvent e)
    {
        if (!e || !e.DamageSource || !e.Thing)
            return;
        
        XRpgPlayer xrpgPlayer = XRpgPlayer(e.DamageSource);
        if (!xrpgPlayer)
            return;
        
        ExpSquishItem xpItem = ExpSquishItem(xrpgPlayer.FindInventory('ExpSquishItem'));
        if (xpItem)
        {
            xpItem.DamageToXP(e.Thing, e.Damage, e.DamageType);
        }
    }

    bool IsMonsterReplacementChance()
    {
        int playerLevel = ActorUtils.GetMaxPlayerLevel();
            
        int chance = clamp(playerLevel / 2, 1, 30);
        if (random(1,100) <= chance)
        {
            return true;
        }

        return false;
    }

    override void CheckReplacement(ReplaceEvent e)
    {
        if (e.Replacee is 'Ettin')
		{
            if (IsMonsterReplacementChance())
                e.replacement = 'EttinMiniBoss';
		}
        else if (e.Replacee is 'CentaurLeader')
        {
            if (IsMonsterReplacementChance())
                e.replacement = 'DeathknightMiniBoss';
        }
        else if (e.Replacee is 'Centaur')
        {
            if (IsMonsterReplacementChance())
                e.replacement = 'SkeletonMiniBoss';
        }
        else if (e.Replacee is 'FireDemon')
        {
            if (IsMonsterReplacementChance())
                e.replacement = 'AfritsMiniBoss';
        }
        else if (e.Replacee is 'Demon')
        {
            if (IsMonsterReplacementChance())
                e.replacement = 'DemonMiniBoss';
        }
    }
}