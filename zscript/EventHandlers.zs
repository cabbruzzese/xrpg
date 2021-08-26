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

    override void WorldThingSpawned(WorldEvent e)
    {
        // Check that the Actor is valid and an enemy monster and not a boss
        if (e.thing && e.thing.bIsMonster && !e.thing.bFriendly && !e.thing.bBoss)
        {
            InitWanderingMonster(e.thing);
        }
    }
}