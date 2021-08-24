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
        if (e.thing && e.thing.bIsMonster && !e.thing.bFriendly) // Check that the Actor is valid and a monster
        {
            InitWanderingMonster(e.thing);
        }
    }
}