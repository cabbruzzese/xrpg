const BOSSTYPE_CHANCE_BRUTE = 10;
const BOSSTYPE_CHANCE_SPECTRE = 4;
const BOSSTYPE_CHANCE_LEADER = 2;

const BOSSTYPE_SUBCHANCE_POISON = 25;
const BOSSTYPE_SUBCHANCE_ICE = 25;
const BOSSTYPE_SUBCHANCE_FIRE = 25;
const BOSSTYPE_SUBCHANCE_LIGHTNING = 25;
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
	WML_LIGHTNING = 16
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
		else if (LeaderType & WML_LIGHTNING)
		{
			Owner.A_SetTranslation("YellowSkin");
            Owner.A_SetHealth(Owner.Health * 2);
		}
		else
		{
			Owner.A_SetTranslation("StoneSkin");
            Owner.A_SetHealth(Owner.Health * 3.5);
    		Owner.DamageMultiply += 1;
		}
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
                                BOSSTYPE_SUBCHANCE_LIGHTNING + 
								BOSSTYPE_SUBCHANCE_STONE;
			
			let bossRoll = random(1,bossMaxChance);
			
			if (bossRoll < BOSSTYPE_SUBCHANCE_POISON)
				props.LeaderFlag = WML_POISON;
			else if (bossRoll < BOSSTYPE_SUBCHANCE_POISON + BOSSTYPE_SUBCHANCE_ICE)
				props.LeaderFlag = WML_ICE;
			else if (bossRoll < BOSSTYPE_SUBCHANCE_POISON + BOSSTYPE_SUBCHANCE_ICE + BOSSTYPE_SUBCHANCE_FIRE)
				props.LeaderFlag = WML_FIRE;
			else if (bossRoll < BOSSTYPE_SUBCHANCE_POISON + BOSSTYPE_SUBCHANCE_ICE + BOSSTYPE_SUBCHANCE_FIRE + BOSSTYPE_SUBCHANCE_LIGHTNING)
				props.LeaderFlag = WML_LIGHTNING;
			else
				props.LeaderFlag = WML_STONE;
		}

        //Don't make Leader types invisible
		if (!(props.BossFlag & WMF_LEADER) && random(1,100) < BOSSTYPE_CHANCE_SPECTRE + playerLevel)
			props.BossFlag |= WMF_SPECTRE;

        ApplyBossMonster(props);
   }

    void DoLightningLeaderTakeDamage(int damage, Name damageType, Actor inflictor, Actor source)
    {
        //Only teleport away sometimes
        if (random(1,100) < LIGHTNINGBOSS_TELEPORT_CHANCE)
            return;
        
        int badPosCount = 1;
        Vector3 newPos;
        let oldPos = Owner.Pos;

        while (badPosCount > 0 && badPosCount < LIGHTNINGBOSS_TELEPORT_FAIL_MAX)
        {
            badPosCount++;
            newPos.x = random(-LIGHTNINGBOSS_TELEPORT_DIST, LIGHTNINGBOSS_TELEPORT_DIST) + Owner.Pos.X;
            newPos.y = random(-LIGHTNINGBOSS_TELEPORT_DIST, LIGHTNINGBOSS_TELEPORT_DIST) + Owner.Pos.Y;
            newPos.z = Owner.CurSector.LowestFloorAt((newPos.x, newPos.y)) + 1;

            if (Owner.CheckPosition((newPos.x, newPos.y)))
            {
                badPosCount = 0;
            }
        }

        if (badPosCount == 0)
        {
            VerticleProjectile("LightningLeaderMissile", oldPos.x, oldPos.y, 0, 0, -90, false);
            let mo = Spawn("LightningLeaderFx1");
            if (mo)
                mo.SetOrigin(oldPos + (0,0,28), false);

            Owner.TeleportMove(newPos, false);
        }
   }

   void DoLeaderTakeDamage(int damage, Name damageType, Actor inflictor, Actor source)
   {
       switch (LeaderType)
        {
            case WML_FIRE:
                if (source && source.Player)
                {
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
                break;
            case WML_ICE:
                if (source && source.Player)
                {
                    for (int i = 0; i < 8; i++)
                    {
                        FireProjectile("IceGuyFX2", i*45., -0.3);
                        FireProjectile("IceGuyFX2", (i*45.) - 22.5, -0.3, 48);
                    }
                }
                break;
            case WML_LIGHTNING:
                DoLightningLeaderTakeDamage(damage, damageType, inflictor, source);
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
        }
   }

   override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
        //React to hits
        if (passive && damage > 0 && Owner)
        {
            if (BossFlag & WMF_LEADER)
            {
                DoLeaderTakeDamage(damage, damageType, inflictor, source);
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

class FireLeaderLava : Actor
{
    Default
    {
        Speed 2;
        Radius 8;
        Height 8;
        Damage 3;
		Projectile;
		VSpeed 2;
        +SPAWNSOUNDSOURCE
        DamageType "Fire";
        DeathSound "Fireball";
		Gravity 0.25;
		+NOBLOCKMAP +MISSILE +DROPOFF
		+NOTELEPORT
		-NOGRAVITY
    }
    States
    {
    Spawn:
        WRBL ABC 4 Bright;
        Loop;
    Death:
        WRBL D 4 Bright A_FireLeaderLavaImpact;
        WRBL EFGHI 4 Bright;
        Stop;
    }

	void A_FireLeaderLavaImpact ()
	{
		if (pos.Z <= floorz)
		{
			bNoGravity = true;
			Gravity = 1;
			AddZ(28);
		}
		A_Explode(10, 100, false);
	}
}

class PoisonLeaderCloud : Actor
{
	Default
	{
		Radius 20;
		Height 30;
		Mass 0x7fffffff;
		+NOBLOCKMAP +NOGRAVITY +DROPOFF
		+NODAMAGETHRUST
		+DONTSPLASH +FOILINVUL +CANBLAST +BLOODLESSIMPACT +BLOCKEDBYSOLIDACTORS +FORCEZERORADIUSDMG +OLDRADIUSDMG
		RenderStyle "Translucent";
		Alpha 0.6;
		DeathSound "PoisonShroomDeath";
		DamageType "PoisonCloud";
	}

	States
	{
	Spawn:
		PSBG D 1;
		PSBG D 1 A_Scream;
		PSBG DEEEFFFGGGHHHII 2 A_PoisonBagDamage;
		PSBG I 2 A_PoisonBagCheck;
		PSBG I 1 A_PoisonBagCheck;
		Goto Spawn + 3;
	Death:
		PSBG HG 7;
		PSBG FD 6;
		Stop;
	}

	override void BeginPlay ()
	{
		Vel.X = MinVel; // missile objects must move to impact other objects
		special1 = random[PoisonCloud](24, 31);
		special2 = 0;
	}

	override int DoSpecialDamage (Actor victim, int damage, Name damagetype)
	{
		if (victim.player)
		{
            damage = random[PoisonCloud](15, 30);
            // Handle passive damage modifiers (e.g. PowerProtection)
            damage = victim.GetModifiedDamage(damagetype, damage, true);
            // Modify with damage factors
            damage = victim.ApplyDamageFactor(damagetype, damage);
            if (damage > 0)
            {
                victim.player.PoisonDamage (self, random[PoisonCloud](15, 30), false); // Don't play painsound

                // If successful, play the poison sound.
                if (victim.player.PoisonPlayer (self, self.target, 50))
                    victim.A_StartSound ("*poison", CHAN_VOICE);
            }

			return -1;
		}
        else if (victim.bIsMonster && !victim.bFriendly)
        {
            return -1;
        }
		else if (!victim.bIsMonster)
		{ // only damage monsters/players with the poison cloud
			return -1;
		}
		return damage;
	}

	void A_PoisonBagCheck()
	{
		if (--special1 <= 0)
		{
			SetStateLabel("Death");
		}
	}

	void A_PoisonBagDamage()
	{
		A_Explode(4, 40, false);
		AddZ(BobSin(special2) / 16);
		special2 = (special2 + 1) & 63;
	}
}

const LIGHTNINGBOSS_TELEPORT_DIST = 256;
const LIGHTNINGBOSS_TELEPORT_FAIL_MAX = 20;
const LIGHTNINGBOSS_TELEPORT_CHANCE = 60;
class LightningLeaderMissile : FastProjectile
{
    Default
    {
        Speed 120;
        Radius 12;
        Height 2;
        Damage 2;
        Projectile;
        +RIPPER
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        MissileType "SmiteningMissileSmoke";
        DeathSound "MageLightningFire";
		SeeSound "ThunderCrash";
		DamageType "Fire";

		Health 0;
    }
    States
    {
    Spawn:
        MLFX K 2 Bright;
		Loop;
    Death:
        MLFX M 2 Bright A_LightningLeaderMissileExplode;
        Stop;
    }

	action void A_LightningLeaderMissileExplode()
	{
		int damage = 50;
		int range = 150;
		
		A_Explode(damage, range, false);
	}
}
class LightningLeaderFx1 : Actor
{
    Default
	{
		+NOBLOCKMAP +NOGRAVITY +NOCLIP +FLOAT
		+NOTELEPORT
		RenderStyle "Translucent";
		Alpha 0.6;
	}
	States
	{
	    Spawn:
		    FAXE RSTUVWX 4 Bright;
		    Stop;
	}
}