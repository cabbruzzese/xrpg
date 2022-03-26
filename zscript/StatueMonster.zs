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
    Class<Actor> statueMonsterType;
    int spawnMonsterChance;
    int transformHeight;
    bool singleChance;

    property StatueMonsterType : statueMonsterType;
    property SpawnMonsterChance : spawnMonsterChance;
    property TransformHeight : transformHeight;
    property SingleChance : singleChance;

    Default
    {
        Health 2000;
		Mass 0x7fffffff;
		+SOLID +SHOOTABLE +NOBLOOD +NOICEDEATH
        +DONTRIP +NORADIUSDMG +CANTSEEK +NEVERTARGET +NOTAUTOAIMED
    }

    action void A_SpawnStatueMonster()
    {
        if (!invoker.statueMonsterType)
            return;

        if (invoker.TransformHeight > 0)
            invoker.Height = invoker.TransformHeight;
        else
            invoker.Height *= 0.66;

        let spawnPos = invoker.Pos + (0, 0, invoker.height + STATUEMONSTER_OFFSET_Z);
        Actor mo = Spawn(invoker.statueMonsterType, spawnPos, ALLOW_REPLACE);
    }

    override int TakeSpecialDamage(Actor inflictor, Actor source, int damage, Name damagetype)
	{
        if (random[statuespawn](1, 100) < SpawnMonsterChance)
        {
            SetNotShootable();

            SetState(FindState("StatueMonsterRise"));
        }

        if (SingleChance) //if single chance, turn off ability to be hit after first try
            SetNotShootable();

        super.TakeSpecialDamage(inflictor, source, damage, damagetype);

		return 0;
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

        StatueMonster.TransformHeight 72;
        StatueMonster.SingleChance true;
	}
}

class XRpgStatueGargoyleShortBase : XRpgStatueGargoyleBase
{
    Default
	{
        Radius 14;
		Height 62;
        StatueMonster.TransformHeight 24;
	}
}