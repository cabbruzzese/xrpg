const BOSSTYPE_CHANCE_BRUTE = 10;
const BOSSTYPE_CHANCE_SPECTRE = 4;
const BOSSTYPE_CHANCE_LEADER = 2;

const BOSSTYPE_LEADER_SUB_NUM = 7;

const DROP_AMMO_CHANCE = 32;
const DROP_AMMO_CHANCE_BIG = 72;
const DROP_HEALTH_CHANCE = 128;

const LIGHTNINGBOSS_TELEPORT_DIST = 256;
const LIGHTNINGBOSS_TELEPORT_FAIL_MAX = 20;

const BOSSTYPE_CHANCE_MAX = 75;

const BOSS_DAMAGE_RESIST = 4;
const BOSS_DAMAGE_VULNERABILITY = 2;

const DROP_WEAP_CHANCE = 16;
const DROP_SHIELD_CHANCE = 12;
const DROP_ARMOR_CHANCE = 24;

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
	WML_LIGHTNING = 16,
    WML_BLOOD = 32,
    WML_DEATH = 64
};

struct LeaderProps
{
	int BossFlag;
	int LeaderFlag;
}
const WMITEM_TIMEOUT_MAX = 30;
const WMITEM_THINK_MAX = 90;
class WanderingMonsterItem : Powerup
{
    int baseSpeed;
	int leaderType;
    int bossFlag;
    int timeoutVal;
    bool isSpectreable;
    int thinkTimout;

    property BaseSpeed : baseSpeed;
    property LeaderType : leaderType;
    property BossFlag : bossFlag;
    property IsSpectreable : isSpectreable;
    property ThinkTimout : thinkTimout;

	Default
	{
		+INVENTORY.UNDROPPABLE
        +INVENTORY.UNTOSSABLE
        +INVENTORY.AUTOACTIVATE
        +INVENTORY.PERSISTENTPOWER
        +INVENTORY.UNCLEARABLE

        Powerup.Duration 0x7FFFFFFF;

        WanderingMonsterItem.IsSpectreable true;

        WanderingMonsterItem.ThinkTimout 0;
	}

    bool IsTimedOutExpired()
    {
        return timeoutVal == 0;
    }

    void SetTimeout()
    {
        timeoutVal = WMITEM_TIMEOUT_MAX;
    }

    override void Tick()
    {
        if (timeoutVal > 0)
            timeoutVal--;

        if (Owner && Owner.Health > 0)
        {
            ThinkTimout++;
            if (ThinkTimout > WMITEM_THINK_MAX)
            {
                ThinkTimout = 0;
                DoThink();
            }
        }
        
        Super.Tick();
    }

    override bool Use(bool pickup)
    {
        SetBossMonster();

        return false;
    }

    bool TryDropEquipment()
    {
        if (!Owner)
            return false;
        
        if (Owner.bFriendly)
            return false;

        //Items automatically drop on XDEATH, don't spawn new ones
        if (Owner.Health <= Owner.GibHealth)
            return false;
        
        class<Actor> dropClass;
        int dropChance;

        if (Owner is "Ettin")
        {
            if (random[CentaurDrop](1,2) == 2)
            {
                dropClass = "EttinArmor";
                dropChance = DROP_ARMOR_CHANCE;
            }
            else
            {
                dropClass = "XRpgFWeapMorningStar";
                dropChance = DROP_WEAP_CHANCE;

                //If a cleric is in game, there's a 25% chance we drop a flail instead
                if (ActorUtils.ClericPlayerExists() && random[FlailDrop](1,4) == 1)
                {
                    dropClass = "XRpgCWeapFlail";
                    dropChance = DROP_ARMOR_CHANCE;
                }
            }
        }
        else if (Owner is "Centaur")
        {
            if (random[CentaurDrop](1,2) == 2)
            {
                dropClass = "XRpgFWeapRazor";
                dropChance = DROP_WEAP_CHANCE;
            }
            else
            {
                dropClass = "XRpgShield";
                dropChance = DROP_SHIELD_CHANCE;
            }
        }
        else if (Owner is "Wraith")
        {
            dropClass = "WraithHelmet";
            dropChance = DROP_ARMOR_CHANCE;
        }
        else if (Owner is "Bishop")
        {
            dropClass = "BishopGem";
            dropChance = DROP_ARMOR_CHANCE;
        }

        if (!dropClass)
            return false;

        return Owner.A_DropItem(dropClass, 1, dropChance);
    }

    override void OwnerDied()
    {
        TryDropEquipment();

        if (BossFlag & WMF_LEADER)
        {
            Owner.A_DropItem("Mana3", 20, DROP_AMMO_CHANCE_BIG);
        }
        else if (BossFlag & WMF_BRUTE)
        {
            Owner.A_DropItem("Mana1", 20, DROP_AMMO_CHANCE);
        }
        else if (BossFlag & WMF_SPECTRE)
        {
            Owner.A_DropItem("Mana2", 20, DROP_AMMO_CHANCE);
        }

        int randomDrop = random[WMFDrop](0, 100);
        if (randomDrop < 50)
        {
            if (randomDrop > 25)
                Owner.A_DropItem("CrystalVial", 10, DROP_HEALTH_CHANCE);
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
		if (!xrpgPlayer)
			return 1;

        let statItem = xrpgPlayer.GetStats();
        return statItem.ExpLevel;
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
    }

    void SetBrute()
    {
        int sizeCount = 1;
        float bruteScale = frandom[WMFDropScale](1.2, 2.0);

        while(sizeCount < 6)
        {
            sizeCount++;

            let newRadius = Owner.radius * (bruteScale / 2);
            let newHeight = owner.height * bruteScale;

            if (Owner.A_SetSize(newRadius, newHeight, true))
            {
		        Owner.A_SetScale(bruteScale);
                Owner.A_SetHealth(Owner.Health * (bruteScale * 1.5));
                return;
            }

            bruteScale -= 0.1;
        }
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
		else if (LeaderType & WML_LIGHTNING)
		{
			Owner.A_SetTranslation("YellowSkin");
            Owner.A_SetHealth(Owner.Health * 2);
		}
        else if (LeaderType & WML_BLOOD)
        {
			Owner.A_SetTranslation("BloodSkin");
            Owner.A_SetHealth(Owner.Health * 3);
        }
        else if (LeaderType & WML_DEATH)
        {
			Owner.A_SetTranslation("DeathSkin");
            Owner.A_SetHealth(Owner.Health * 2);
        }
		else
		{
			Owner.A_SetTranslation("StoneSkin");
            Owner.A_SetHealth(Owner.Health * 3.5);
    		Owner.DamageMultiply += 1;
		}

        Owner.DamageMultiply += 0.5;
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

        if (Owner is "WonderingMonsterBase")
        {
            let wonderingMonster = WonderingMonsterBase(Owner);
            props.LeaderFlag = wonderingMonster.DefaultLeaderFlag;
            props.BossFlag = wonderingMonster.DefaultBossFlag;
        }
        else
        {
            int bruteChance = min(BOSSTYPE_CHANCE_BRUTE + playerLevel, BOSSTYPE_CHANCE_MAX);
            if (random[WMFBrute](0, 100) < bruteChance)
                props.BossFlag |= WMF_BRUTE;

            int leaderChance = min(BOSSTYPE_CHANCE_LEADER + playerLevel, BOSSTYPE_CHANCE_MAX);
            if (random[WMFLeader](1,100) < leaderChance && !(Owner is "MonsterSummonWraith"))
            {
                props.BossFlag |= WMF_LEADER;
                
                let bossRoll = random[WMLType](1, BOSSTYPE_LEADER_SUB_NUM);
                
                if (bossRoll == 1)
                    props.LeaderFlag = WML_POISON;
                else if (bossRoll == 2)
                    props.LeaderFlag = WML_ICE;
                else if (bossRoll == 3)
                    props.LeaderFlag = WML_FIRE;
                else if (bossRoll == 4)
                    props.LeaderFlag = WML_LIGHTNING;
                else if (bossRoll == 5)
                    props.LeaderFlag = WML_BLOOD;
                else if (bossRoll == 6)
                    props.LeaderFlag = WML_DEATH;
                else
                    props.LeaderFlag = WML_STONE;
            }

            //Don't make Leader types invisible
            int spectreChance = min(BOSSTYPE_CHANCE_SPECTRE + playerLevel, BOSSTYPE_CHANCE_MAX);
            if (!(props.BossFlag & WMF_LEADER) && random[WMFSpectre](1,100) < spectreChance)
                props.BossFlag |= WMF_SPECTRE;
        }

        ApplyBossMonster(props);
    }

    void DoLightningLeaderTakeDamage(int damage, Name damageType, Actor inflictor, Actor source)
    {
        //don't teleport on death
        if (Owner.Health - damage < 0)
            return;

        if (damageType == "Water" || damageType == "Ice")
            return;

        if (!IsTimedOutExpired())
            return;
        SetTimeout();
        
        int moveTries = 0;
        Vector3 newPos;
        let oldPos = Owner.Pos;
        int newAngle = 0;
        int newDist = 0;

        while (moveTries >= 0 && moveTries < 10)
        {
            moveTries++;

            newPos.x = random[WMLLightningTele](-LIGHTNINGBOSS_TELEPORT_DIST, LIGHTNINGBOSS_TELEPORT_DIST) + Owner.Pos.X;
            newPos.y = random[WMLLightningTele](-LIGHTNINGBOSS_TELEPORT_DIST, LIGHTNINGBOSS_TELEPORT_DIST) + Owner.Pos.Y;
            newPos.Z = Owner.Pos.Z;

            let vecOffset = newPos - oldPos;
            let vecLen = vecOffset.Length();
            let vecAngle = VectorAngle(vecOffset.x, vecOffset.y);
            let newPitch = VectorAngle(vecLen, vecOffset.Z);

            bool traceFail = Owner.LineTrace(vecAngle, vecLen, newPitch);

            Owner.SetOrigin(newPos, false);
            
            //move to floor if not flying
            if (!Owner.bNoGravity)
                newPos.z = Owner.CurSector.NextLowestFloorAt(Owner.pos.x, Owner.pos.y, Owner.pos.z, Owner.pos.z, FFCF_NOPORTALS);

            Owner.SetZ(newPos.z);

            if (traceFail || ActorUtils.IsPositionInvalid(Owner))
            {
                //Move unsuccessful, move back
                Owner.SetOrigin(oldPos, false);
            }
            else
            {
                //Move Successful, spawn lightning and exit
                let mo = Spawn("LightningLeaderFx1");
                if (mo)
                    mo.SetOrigin(oldPos + (0,0,28), false);
                
                moveTries = -1;
            }
        }
    }

    const WML_DEATH_RAISE_LIMIT = 1;
    void DoDeathLeaderSpecial()
    {
        //Friendly leaders do not raise the dead
        if (Owner.bFriendly)
            return;

        if (Owner.bDormant)
            return;
        
        if (Owner.InStateSequence(Owner.CurState, Owner.ResolveState("Spawn")))
            return;

        Owner.A_RadiusGive("RaiseWraithItem", 200, RGF_CORPSES, 1, "", "", 0, WML_DEATH_RAISE_LIMIT);
        Owner.A_RadiusGive("RaiseStatueItem", 400, RGF_OBJECTS, 1, "", "", 0, WML_DEATH_RAISE_LIMIT);
    }

    void DoFireLeaderSpecial()
    {
        if (Owner.bDormant)
            return;
        
        if (Owner.InStateSequence(Owner.CurState, Owner.ResolveState("Spawn")))
            return;

        for (int i = 0; i < 6; i++)
        {
            let xVel = frandom[WMLFireBall](-2, 2);
            let yVel = frandom[WMLFireBall](-2, 2);
            let zVel = frandom[WMLFireBall](3.0, 6.0);

            let xo = random[WMLFireBall](-16, 16);
            let yo = random[WMLFireBall](-16, 16);

            TossProjectile("FireLeaderLava", xo, yo, xVel, yVel, zVel, true);
        }
    }

    void DoIceLeaderTakeDamage(int damage, Name damageType, Actor inflictor, Actor source)
    {
        if (!IsTimedOutExpired())
            return;
        SetTimeout();

        for (int i = 0; i < 8; i++)
        {
            FireProjectile("IceLeaderFx1", i*45., -0.3);
            FireProjectile("IceLeaderFx1", (i*45.) - 22.5, -0.3, 48);
        }
    }

   void DoLeaderTakeDamage(int damage, Name damageType, Actor inflictor, Actor source, out int newdamage)
   {
       switch (LeaderType)
        {
            case WML_ICE:
                DoIceLeaderTakeDamage(damage, damageType, inflictor, source);
                break;
            case WML_LIGHTNING:
                DoLightningLeaderTakeDamage(damage, damageType, inflictor, source);
                break;
        }
   }

    void DoLeaderAbsorbDamage(int damage, Name damageType, Actor inflictor, Actor source, out int newdamage)
    {
        switch (LeaderType)
        {
            case WML_FIRE:
                if (damageType == 'Fire')
                    newdamage = damage / BOSS_DAMAGE_RESIST;
                else if (damageType == 'Water')
                    newdamage = damage * BOSS_DAMAGE_VULNERABILITY;
                break;
            case WML_ICE:
                if (damageType == 'Ice' ||
                    damageType == 'Water')
                    newdamage = damage / BOSS_DAMAGE_RESIST;
                else if (damageType == 'Fire')
                    newdamage = damage * BOSS_DAMAGE_VULNERABILITY;
                break;
            case WML_LIGHTNING:
                if (damageType == 'Electric')
                    newdamage = damage / BOSS_DAMAGE_RESIST;
                else if (damageType == 'Water')
                    newdamage = damage * BOSS_DAMAGE_VULNERABILITY;
                break;
            case WML_DEATH:
                if (damageType == 'Death')
                    newdamage = damage / BOSS_DAMAGE_RESIST;
                else if (damageType == 'Fire' ||
                        damageType == 'Holy')
                    newdamage = damage * BOSS_DAMAGE_VULNERABILITY;
                break;
            case WML_POISON:
                if (damageType == 'Poison' ||
                    damageType == 'PoisonCloud')
                    newdamage = damage / BOSS_DAMAGE_RESIST;
                else if (damageType == 'Water' ||
                    damageType == 'Ice')
                    newdamage = damage * BOSS_DAMAGE_VULNERABILITY;
                break;
            case WML_BLOOD:
                if (damageType == 'Blood')
                    newdamage = damage / BOSS_DAMAGE_RESIST;
                else if (damageType == 'Death')
                    newdamage = damage * BOSS_DAMAGE_VULNERABILITY;
                break;
            case WML_STONE:
                if (damageType == 'Poison' || 
                    damageType == 'PoisonCloud' ||
                    damageType == 'Blood')
                    newdamage = damage / BOSS_DAMAGE_RESIST;
                else if (damageType == 'Electric')
                    newdamage = damage * BOSS_DAMAGE_VULNERABILITY;
                break;
        }
    }

   void DoBossCauseDamage(int damage, Name damageType, Actor damageTarget)
   {
       //Brutes push
        if (BossFlag & WMF_BRUTE)
        {
            if (!damageTarget)
                return;

            if (damageTarget.bDONTTHRUST)
                return;
            
            let xrpgPlayer = XRpgPlayer(damageTarget);
            if (damageTarget.bIsMonster || xrpgPlayer)
            {
                damageTarget.Thrust(12, Owner.angle);
            }
        }
   }

   void DoLeaderCauseDamage(int damage, Name damageType, Actor damageTarget)
   {
        switch (LeaderType)
        {
            case WML_POISON:
                if (DamageType != 'PoisonCloud')
                {
                    Actor mo = Spawn("PoisonLeaderCloud", damageTarget.pos + (0, 0, 28), ALLOW_REPLACE);
                    if (mo)
                    {
                        mo.target = Owner;
                    }
                }
                break;
            case WML_BLOOD:
                if (damageTarget && damageTarget.Health > 0 && Owner && Owner.Health > 0)
                {
                    //Heal
                    int healAmount = damage * 3;
                    Owner.GiveBody(healAmount);
                    Owner.A_StartSound("WraithAttack", CHAN_BODY);
                }
                break;
        }
   }

   override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
        //React to hits
        if (passive && damage > 0 && Owner)
        {
            if (BossFlag & WMF_LEADER)
            {
                DoLeaderTakeDamage(damage, damageType, inflictor, source, newdamage);
            }
        }

        //Extra damage effects
		if (!passive && damage > 0 && Owner)
        {
            DoBossCauseDamage(damage, damageType, source);

            if (BossFlag & WMF_LEADER)
            {
                DoLeaderCauseDamage(damage, damageType, source);
            }
        }
	}

    override void AbsorbDamage (int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags)
    {
        if (damage > 0)
        {
            DoLeaderAbsorbDamage(damage, damageType, inflictor, source, newdamage);
        }
    }

    void DoThink()
    {
        switch (LeaderType)
        {
            case WML_DEATH:
                DoDeathLeaderSpecial();
                break;
            case WML_FIRE:
                DoFireLeaderSpecial();
                break;
        }
    }

    Actor VerticleProjectile(Class<Actor> projType, int xPos, int yPos, double xVel, double yVel, double zVel, bool isFloor = false)
    {
        Actor mo = Spawn(projType);
        if (!mo)
            return null;
        
        mo.target = Owner;
        mo.SetOrigin((xPos, yPos, mo.Pos.Z), false);

        double newz;
        if (isFloor)
            newz = mo.CurSector.NextLowestFloorAt(mo.pos.x, mo.pos.y, mo.pos.z, mo.pos.z, FFCF_NOPORTALS) + mo.height;
        else
            newz = mo.CurSector.NextHighestCeilingAt(mo.pos.x, mo.pos.y, mo.pos.z, mo.pos.z, FFCF_NOPORTALS) + mo.height;
        
        mo.SetZ(newz);

        mo.Vel.X = xVel;
        mo.Vel.Y = yVel;
        mo.Vel.Z = zVel;

        mo.CheckMissileSpawn (radius);

        return mo;
    }

    Actor TossProjectile(Class<Actor> projType, int xOffset, int yOffset, double xVel, double yVel, double zVel, bool isFloor = false)
    {
        Actor mo = VerticleProjectile(projType, Owner.Pos.X + xOffset, Owner.Pos.Y + yOffset, xVel, yVel, zVel, isFloor);

        return mo;
    }

    Actor FireProjectile(Class<Actor> projType, double angle, double vSpeed, double zOffset = 32)
    {
        Actor mo = Owner.SpawnMissileAngleZ (Owner.Pos.z+zOffset, projType, angle, vSpeed);
        if (!mo)
            return null;

        mo.target = Owner;

        return mo;
    }
}