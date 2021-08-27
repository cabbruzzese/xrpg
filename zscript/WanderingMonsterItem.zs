const BOSSTYPE_CHANCE_BRUTE = 10;
const BOSSTYPE_CHANCE_SPECTRE = 4;
const BOSSTYPE_CHANCE_LEADER = 2;

const BOSSTYPE_LEADER_SUB_NUM = 7;

const DROP_AMMO_CHANCE = 128;
const DROP_AMMO_CHANCE_BIG = 196;

const LIGHTNINGBOSS_TELEPORT_DIST = 256;
const LIGHTNINGBOSS_TELEPORT_FAIL_MAX = 20;
const LIGHTNINGBOSS_TELEPORT_CHANCE = 60;

const BOSSTYPE_CHANCE_MAX = 75;

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
class WanderingMonsterItem : Powerup
{
    int baseSpeed;
	int leaderType;
    int bossFlag;
    int timeoutVal;
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
        
        Super.Tick();
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
        int sizeCount = 1;
        float bruteScale = frandom(1.2, 2.0);

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

        int bruteChance = min(BOSSTYPE_CHANCE_BRUTE + playerLevel, BOSSTYPE_CHANCE_MAX);
        if (random(0, 100) < bruteChance)
            props.BossFlag |= WMF_BRUTE;

        int leaderChance = min(BOSSTYPE_CHANCE_LEADER + playerLevel, BOSSTYPE_CHANCE_MAX);
        if (random(1,100) < leaderChance)
		{
			props.BossFlag |= WMF_LEADER;
			
			let bossRoll = random(1, BOSSTYPE_LEADER_SUB_NUM);
			
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
		if (!(props.BossFlag & WMF_LEADER) && random(1,100) < spectreChance)
			props.BossFlag |= WMF_SPECTRE;

        ApplyBossMonster(props);
    }

    void DoLightningLeaderTakeDamage(int damage, Name damageType, Actor inflictor, Actor source)
    {
        //Only teleport away sometimes
        if (random(1,100) < LIGHTNINGBOSS_TELEPORT_CHANCE)
            return;

        //don't teleport on death
        if (Owner.Health - damage < 0)
            return;

        if (!IsTimedOutExpired())
            return;
        SetTimeout();
        
        int badPosCount = 1;
        Vector3 newPos;
        let oldPos = Owner.Pos;

        while (badPosCount > 0 && badPosCount < LIGHTNINGBOSS_TELEPORT_FAIL_MAX)
        {
            badPosCount++;
            newPos.x = random(-LIGHTNINGBOSS_TELEPORT_DIST, LIGHTNINGBOSS_TELEPORT_DIST) + Owner.Pos.X;
            newPos.y = random(-LIGHTNINGBOSS_TELEPORT_DIST, LIGHTNINGBOSS_TELEPORT_DIST) + Owner.Pos.Y;
            newPos.z = Owner.CurSector.LowestFloorAt((newPos.x, newPos.y)) + 1;

            if (Owner.CheckMove((newPos.x, newPos.y), PCM_DROPOFF))
            {
                badPosCount = 0;
            }
        }

        if (badPosCount == 0)
        {
            let mo = Spawn("LightningLeaderFx1");
            if (mo)
                mo.SetOrigin(oldPos + (0,0,28), false);

            Owner.TeleportMove(newPos, false, true);
        }
    }

    void DoDeathLeaderTakeDamage(int damage, Name damageType, Actor inflictor, Actor source)
    {
        //Only work on random hits
        if (random(1,2) != 1)
            return;

        if (!IsTimedOutExpired())
            return;
        SetTimeout();

        Owner.A_RadiusGive("RaiseWraithItem", 200, RGF_CORPSES);
    }

    void DoFireLeaderTakeDamage(int damage, Name damageType, Actor inflictor, Actor source)
    {
        if (!source || !source.Player)
            return;

        if (!IsTimedOutExpired())
            return;
        SetTimeout();

        for (int i = 0; i < 6; i++)
        {
            let xVel = frandom(-2, 2);
            let yVel = frandom(-2, 2);
            let zVel = frandom(3.0, 6.0);

            let xo = random(-16, 16);
            let yo = random(-16, 16);

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
            case WML_FIRE:
                DoFireLeaderTakeDamage(damage, damageType, inflictor, source);
                if (damageType == 'Fire')
                    newdamage = damage / 2;
                else if (damageType == 'Water')
                    newdamage = damage * 2;
                break;
            case WML_ICE:
                DoIceLeaderTakeDamage(damage, damageType, inflictor, source);
                if (damageType == 'Ice' ||
                    damageType == 'Water')
                    newdamage = damage / 2;
                else if (damageType == 'Fire')
                    newdamage = damage * 2;
                break;
            case WML_LIGHTNING:
                DoLightningLeaderTakeDamage(damage, damageType, inflictor, source);
                if (damageType == 'Electric')
                    newdamage = damage / 2;
                else if (damageType == 'Water')
                    newdamage = damage * 2;
                break;
            case WML_DEATH:
                DoDeathLeaderTakeDamage(damage, damageType, inflictor, source);

                if (damageType == 'Death')
                    newdamage = damage / 2;
                else if (damageType == 'Fire')
                    newdamage = damage * 2;
                break;
            case WML_POISON:
                if (damageType == 'Poison' ||
                    damageType == 'PoisonCloud')
                    newdamage = damage / 2;
                else if (damageType == 'Water' ||
                    damageType == 'Ice')
                    newdamage = damage * 2;
                break;
            case WML_BLOOD:
                if (damageType == 'Blood')
                    newdamage = damage / 2;
                else if (damageType == 'Death')
                    newdamage = damage * 2;
                break;
            case WML_STONE:
                if (damageType == 'Poison' || 
                    damageType == 'PoisonCloud' ||
                    damageType == 'Blood')
                    newdamage = damage / 2;
                else if (damageType == 'Electric')
                    newdamage = damage * 2;
                break;
        }
   }

   void DoBossCauseDamage(int damage, Name damageType, Actor damageTarget)
   {
       //Brutes push
        if (BossFlag & WMF_BRUTE)
        {
            if (damageTarget)
                damageTarget.Thrust(20, Owner.angle);
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
                if (damageTarget && damageTarget.Health > 0)
                {
                    //Heal
                    Owner.A_SetHealth(Owner.Health + damage);
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

                //if (newdamage != damage)
                    //console.printf("Damage resisted: " .. damage .. " reduced to: " .. newdamage);
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

    Actor VerticleProjectile(Class<Actor> projType, int xPos, int yPos, double xVel, double yVel, double zVel, bool isFloor = false)
    {
        Actor mo = Spawn(projType);
        if (!mo)
            return null;
        
        mo.target = Owner;
        mo.SetOrigin((xPos, yPos, mo.z), false);

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