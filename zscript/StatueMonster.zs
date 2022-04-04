class WonderingMonsterBase : Actor
{
    int defaultLeaderFlag;
    int defaultBossFlag;
    property DefaultLeaderFlag : defaultLeaderFlag;
    property DefaultBossFlag : defaultBossFlag;

    default {
        +AMBUSH;
        +LOOKALLAROUND;
        WonderingMonsterBase.DefaultLeaderFlag 0;
        WonderingMonsterBase.DefaultBossFlag 0;
    }
}

const STATUEMONSTER_OFFSET_Z = 4;
class StatueMonster : Actor
{
    int damageFaceAngle;
    bool spawnFinished;

    Class<Actor> statueMonsterType;
    int spawnMonsterChance;
    bool singleChance;
    bool endSolid;
    bool spawnOnGround;
    bool canBeKilled;

    property StatueMonsterType : statueMonsterType;
    property SpawnMonsterChance : spawnMonsterChance;
    property SingleChance : singleChance;
    property EndSolid : endSolid;
    property SpawnOnGround : spawnOnGround;
    property CanBeKilled : canBeKilled;

    Default
    {
        Health 2000;
		Mass 0x7fffffff;
		+SOLID +SHOOTABLE +NOBLOOD +NOICEDEATH
        +DONTRIP +NORADIUSDMG +CANTSEEK +NEVERTARGET +NOTAUTOAIMED

        StatueMonster.EndSolid 1;
        StatueMonster.SpawnOnGround 0;
        StatueMonster.CanBeKilled 0;
    }

    bool IsSpawnFinished()
    {
        return spawnFinished;
    }

    action void A_SpawnStatueMonster()
    {
        invoker.spawnFinished = true;

        if (!invoker.EndSolid)
            A_NoBlocking();

        if (!invoker.statueMonsterType)
            return;

        int heightOffset = invoker.DeathHeight;
        if (invoker.SpawnOnGround)
            heightOffset = 0;

        invoker.Height = DeathHeight;
        
        let spawnPos = invoker.Pos + (0, 0, heightOffset + STATUEMONSTER_OFFSET_Z);
        Actor mo = Spawn(invoker.statueMonsterType, spawnPos, ALLOW_REPLACE);

        if (mo)
        {
            mo.A_SetAngle(invoker.damageFaceAngle);
        }
    }

    override int TakeSpecialDamage(Actor inflictor, Actor source, int damage, Name damagetype)
	{
        if (random[statuespawn](1, 100) < SpawnMonsterChance)
        {
            SetNotShootable();

            //Set angle to face after attack
            if (source)
                damageFaceAngle = AngleTo(source);
            else if (inflictor)
                damageFaceAngle = AngleTo(inflictor);
            else
                damageFaceAngle = angle;

            SetState(FindState("StatueMonsterRise"));
        }

        if (SingleChance) //if single chance, turn off ability to be hit after first try
            SetNotShootable();

        int damageResult = super.TakeSpecialDamage(inflictor, source, damage, damagetype);

        if (!CanBeKilled)
		    return 0;
        
        return damageResult;
	}

    void SetNotShootable()
    {
        bShootable = false;
        SpawnMonsterChance = 0;
    }
}

class XRpgStatueGargoyleBase : StatueMonster
{
    Default
	{
		Radius 14;
		Height 108;
		DeathSound "EarthStartMove";
        DeathHeight 64;

        StatueMonster.SingleChance true;
	}
}

class XRpgStatueGargoyleShortBase : XRpgStatueGargoyleBase
{
    Default
	{
        Radius 14;
		Height 62;
        DeathHeight 24;
	}
}