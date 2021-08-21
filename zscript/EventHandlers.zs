//const RESPAWN_TICS_MIN = 1200; //1 minute
//const RESPAWN_TICS_MAX = 18000; //15 minutes

const BOSSTYPE_CHANCE_BRUTE = 10;
const BOSSTYPE_CHANCE_SPECTRE = 4;
const BOSSTYPE_CHANCE_LEADER = 2;
//const BOSSTYPE_CHANCE_RUNT = 6;

const BOSSTYPE_SUBCHANCE_POISON = 25;
const BOSSTYPE_SUBCHANCE_ICE = 25;
const BOSSTYPE_SUBCHANCE_FIRE = 25;
//const BOSSTYPE_SUBCHANCE_LIGHTNING = 25;
//const BOSSTYPE_SUBCHANCE_DEATH = 25;
const BOSSTYPE_SUBCHANCE_STONE = 25;

const DROP_AMMO_CHANCE = 128;
const DROP_AMMO_CHANCE_BIG = 196;

enum EWanderingMonsterFlags
{
	WMF_BRUTE = 1,
	WMF_SPECTRE = 2,
	WMF_LEADER = 4,
	WMF_RUNT = 8
};

enum ELeaderTypeFlags
{
	WML_STONE = 1,
	WML_POISON = 2,
	WML_ICE = 4,
	WML_FIRE = 8,
	WML_DEATH = 16,
	WML_LIGHTNING = 32,
};

struct LeaderProps
{
	int BossFlag;
	int LeaderFlag;
}

class BossMaker : EventHandler
{
    WanderingMonsterItem InitWanderingMonster(Actor monsterObj)
    {
        let wmItem = WanderingMonsterItem(monsterObj.FindInventory("WanderingMonsterItem"));

        if (wmItem)
            return wmItem;
        
        wmItem = WanderingMonsterItem(monsterObj.GiveInventoryType("WanderingMonsterItem"));

        wmItem.BaseSpeed = monsterObj.Speed;
        wmItem.LeaderType = 0;

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

class WanderingMonsterItem : Powerup
{
    int baseSpeed;
	int leaderType;
    int bossFlag;
    bool isSpectreable;

    property BaseSpeed : baseSpeed;
    property LeaderType : leaderType;
    property BossFlag : bossFlag;
    property IsSpectreable : isSpectreable;

	Default
	{
		+INVENTORY.UNDROPPABLE
        +INVENTORY.UNTOSSABLE
        +INVENTORY.AUTOACTIVATE
        +INVENTORY.PERSISTENTPOWER
        +INVENTORY.UNCLEARABLE

        Powerup.Duration 0x7FFFFFFF;

        WanderingMonsterItem.IsSpectreable true;
	}

    override bool Use(bool pickup)
    {
        SetBossMonster();

        return false;
    }

    override void OwnerDied()
    {
        if (BossFlag & WMF_LEADER)
        {
            switch(LeaderType)
            {
                case WML_STONE:
                    Owner.A_DropItem("Mana3", 20, DROP_AMMO_CHANCE_BIG);
                    break;
                case WML_FIRE:
                    Owner.A_DropItem("Mana3", 20, DROP_AMMO_CHANCE_BIG);
                    break;
                case WML_ICE:
                    Owner.A_DropItem("Mana1", 20, DROP_AMMO_CHANCE_BIG);
                    break;
                case WML_POISON:
                    Owner.A_DropItem("Mana2", 20, DROP_AMMO_CHANCE_BIG);
                    break;
            }
        }
        else if (BossFlag & WMF_BRUTE)
        {
            Owner.A_DropItem("Mana1", 20, DROP_AMMO_CHANCE);
        }
        else if (BossFlag & WMF_SPECTRE)
        {
            Owner.A_DropItem("Mana2", 20, DROP_AMMO_CHANCE);
        }

        int randomDrop = random(0, 100);
        if (randomDrop < 50)
        {
            if (randomDrop > 25)
                Owner.A_DropItem("CrystalVial", 10, DROP_AMMO_CHANCE);
            else if (randomDrop > 15)
                Owner.A_DropItem("Mana1", 15, DROP_AMMO_CHANCE);
            else if (randomDrop > 5)
                Owner.A_DropItem("Mana2", 15, DROP_AMMO_CHANCE);
            else
                Owner.A_DropItem("Mana3", 20, DROP_AMMO_CHANCE);
        }
    }

    int GetPlayerLevel(int playerNum)
    {
        let xrpgPlayer = XRpgPlayer(players[playerNum].mo);		
		if (xrpgPlayer == null)
			return 1;

        return xrpgPlayer.ExpLevel;
    }

    int GetMaxPlayerLevel()
    {
        int maxLevel = 1;
        for (int i = 0; i < MaxPlayers; i++)
        {
            int playerLevel = GetPlayerLevel(i);

            if (playerLevel > maxLevel)
                maxLevel = playerLevel;
        }
    
		return maxLevel;
    }

    void SetNormal()
    {
        Owner.A_SetScale(1);
		Owner.DamageMultiply = 1;
		Owner.Translation = 0;
		Owner.bALWAYSFAST = false;
		LeaderType = 0;
        BossFlag = 0;
		
		Owner.A_SetRenderStyle(1.0, STYLE_Normal);
		
		//if (BaseSpeed != -1)
			//Owner.A_SetSpeed(BaseSpeed);//Restore saved speed
    }

    void SetBrute()
    {
        let bruteSize = frandom(1.0, 3.0);
		float bruteScale = 0.6 + bruteSize / 3.0;
		
		Owner.A_SetScale(float(bruteScale));
        Owner.A_SetHealth(Owner.Health * bruteSize);
    }

    void SetSpectre()
	{
		if (!IsSpectreable)
			return;

		Owner.A_SetRenderStyle(HR_SHADOW, STYLE_Translucent);
		Owner.DamageMultiply = 1.5;
	}

    void SetLeader()
	{
		if (LeaderType & WML_ICE)
		{
			Owner.A_SetTranslation("Ice");
            Owner.A_SetHealth(Owner.Health * 2);
		}
		else if (LeaderType & WML_POISON)
		{
			Owner.A_SetTranslation("GreenSkin");
            Owner.A_SetHealth(Owner.Health * 2);
		}
		else if (LeaderType & WML_FIRE)
		{
			Owner.A_SetTranslation("RedSkin");
            Owner.A_SetHealth(Owner.Health * 2);
		}
		else
		{
			Owner.A_SetTranslation("StoneSkin");
            Owner.A_SetHealth(Owner.Health * 3.5);
		}

		Owner.DamageMultiply += 1;
	}

    void ApplyBossMonster(LeaderProps props)
    {
        SetNormal();
		
		LeaderType = props.LeaderFlag;
        BossFlag = props.BossFlag;

        if (props.BossFlag & WMF_BRUTE)
            SetBrute();
        if (props.BossFlag & WMF_SPECTRE)
            SetSpectre();
        if (props.BossFlag & WMF_LEADER)
            SetLeader();
    }

    void SetBossMonster()
    {
        int playerLevel = GetMaxPlayerLevel();
        LeaderProps props;

        if (random(0, 100) < BOSSTYPE_CHANCE_BRUTE + playerLevel)
            props.BossFlag |= WMF_BRUTE;

        if (random(1,100) < BOSSTYPE_CHANCE_LEADER + playerLevel)
		{
			props.BossFlag |= WMF_LEADER;
			
			let bossMaxChance = BOSSTYPE_SUBCHANCE_POISON + 
								BOSSTYPE_SUBCHANCE_ICE + 
								BOSSTYPE_SUBCHANCE_FIRE + 
								BOSSTYPE_SUBCHANCE_STONE;
			
			let bossRoll = random(1,bossMaxChance);
			
			if (bossRoll < BOSSTYPE_SUBCHANCE_POISON)
				props.LeaderFlag = WML_POISON;
			else if (bossRoll < BOSSTYPE_SUBCHANCE_POISON + BOSSTYPE_SUBCHANCE_ICE)
				props.LeaderFlag = WML_ICE;
			else if (bossRoll < BOSSTYPE_SUBCHANCE_POISON + BOSSTYPE_SUBCHANCE_ICE + BOSSTYPE_SUBCHANCE_FIRE)
				props.LeaderFlag = WML_FIRE;
			else
				props.LeaderFlag = WML_STONE;
		}

        //Don't make Leader types invisible
		if (!(props.BossFlag & WMF_LEADER) && random(1,100) < BOSSTYPE_CHANCE_SPECTRE + playerLevel)
			props.BossFlag |= WMF_SPECTRE;

        ApplyBossMonster(props);
   }
}