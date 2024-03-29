// The Mage's Frost Cone ----------------------------------------------------

class XRpgMWeapFrost : XRpgMageWeapon replaces MWeapFrost
{
	Default
	{
		+BLOODSPLATTER
		Weapon.SelectionOrder 1700;
		Weapon.AmmoUse1 3;
		Weapon.AmmoGive1 25;
		Weapon.KickBack 150;
		Weapon.YAdjust 20;
		Weapon.AmmoType1 "Mana1";
		Inventory.PickupMessage "$TXT_WEAPON_M2";
		Obituary "$OB_MPMWEAPFROST";
		Tag "$TAG_MWEAPFROST";
	}

	States
	{
	Spawn:
		WMCS ABC 8 Bright;
		Loop;
	Select:
		CONE A 1 A_Raise;
		Loop;
	Deselect:
		CONE A 1 A_Lower;
		Loop;
	Ready:
		CONE A 1 A_WeaponReady(WRF_ALLOWRELOAD|WRF_ALLOWZOOM);
		Loop;
	Fire:
		CONE B 3;
		CONE C 4;
	Hold:
		CONE D 3;
		CONE E 5;
		CONE F 3 A_FireConePL1;
		CONE G 3;
		CONE A 9;
		CONE A 10 A_ReFire;
		Goto Ready;
	AltFire:
		CONE A 0 A_AltFireCheckSpellSelected(WEAPON_ID_MAGE_FROST);
		CONE B 3;
		CONE C 1 A_FireSpell();
		CONE D 3;
		CONE E 5;
		CONE F 1;
	AltFireFinish:
		CONE G 3;
		CONE A 5;
		CONE A 4 A_ReFire;
		Goto Ready;
	RapidFireFinish:
		CONE F 2 A_ReFire;
		CONE G 3;
		CONE A 5;
		CONE A 4;
		Goto Ready;
	FlameSpell:
		CONE C 3;
		CONE D 3;
		CONE E 5;
        CONE F 3 Bright A_FireFlameSpell(MANA_FROST_FLAME_BLUE, MANA_FROST_FLAME_GREEN);
        Goto AltFireFinish;
    IceSpell:
		CONE C 1;
		CONE D 2;
		CONE E 2;
        CONE F 2 Bright A_FireMissileSpell("MageFrostIceMissile", MANA_FROST_ICE_BLUE, MANA_FROST_ICE_GREEN);
        Goto RapidFireFinish;
    PoisonSpell:
		CONE C 3;
		CONE D 3;
		CONE E 5;
        CONE F 3 Bright A_FireMissileSpell("MageFrostPoisonMissile", MANA_FROST_POISON_BLUE, MANA_FROST_POISON_GREEN);
        Goto AltFireFinish;
    WaterSpell:
		CONE C 1;
		CONE D 1;
		CONE E 1;
        CONE F 2 Bright A_FireMissileSpell("MageFrostWaterMissile", MANA_FROST_WATER_BLUE, MANA_FROST_WATER_GREEN);
        Goto AltFireFinish;
    SunSpell:
		CONE C 3;
		CONE D 3;
		CONE E 5;
        CONE F 3 Bright A_FireMissileSpell("MageFrostSunMissile", MANA_FROST_SUN_BLUE, MANA_FROST_SUN_GREEN);
        Goto AltFireFinish;
    MoonSpell:
		CONE C 3;
		CONE D 3;
		CONE E 5;
        CONE F 3 Bright A_FireMissileSpell("MageFrostMoonMissile", MANA_FROST_MOON_BLUE, MANA_FROST_MOON_GREEN);
        Goto AltFireFinish;
    DeathSpell:
		CONE C 3;
		CONE D 3;
		CONE E 5;
        CONE F 3 Bright A_FireMissileSpell("MageFrostDeathMissile", MANA_FROST_DEATH_BLUE, MANA_FROST_DEATH_GREEN);
        Goto AltFireFinish;
    LightningSpell:
		CONE C 3;
		CONE D 3;
		CONE E 5;
        CONE F 3 Bright A_FireLightningSpell(MANA_FROST_LIGHTNING_BLUE, MANA_FROST_LIGHTNING_GREEN);
        Goto AltFireFinish;
    BloodSpell:
		CONE C 3;
		CONE D 3;
		CONE E 5;
        CONE F 3 Bright A_FireBloodSpell(MANA_FROST_BLOOD_BLUE, MANA_FROST_BLOOD_GREEN);
        Goto AltFireFinish;
	Reload:
		#### # 8 A_NextSpell;
		Goto Ready;
    Zoom:
		#### # 8 A_PrevSpell;
		Goto Ready;
	}
	
	//============================================================================
	//
	// A_FireConePL1
	//
	//============================================================================

	action void A_FireConePL1()
	{
		bool conedone=false;
		FTranslatedLineTarget t;

		if (player == null)
		{
			return;
		}

		Weapon weapon = player.ReadyWeapon;
		if (weapon != null)
		{
			if (!weapon.DepleteAmmo (false))//weapon.bAltFire))
				return;
		}
		A_StartSound ("MageShardsFire", CHAN_WEAPON);

		int damage = random[MageCone](90, 105);
		for (int i = 0; i < 16; i++)
		{
			double ang = angle + i*(45./16);
			double slope = AimLineAttack (ang, DEFMELEERANGE, t, 0., ALF_CHECK3D);
			if (t.linetarget)
			{
				t.linetarget.DamageMobj (self, self, damage, 'Ice', DMG_USEANGLE, t.angleFromSource);
				conedone = true;
				break;
			}
		}

		// didn't find any creatures, so fire projectiles
		if (!conedone)
		{
			Actor mo = SpawnPlayerMissile ("FrostMissile");
			if (mo)
			{
				mo.special1 = FrostMissile.SHARDSPAWN_LEFT|FrostMissile.SHARDSPAWN_DOWN|FrostMissile.SHARDSPAWN_UP|FrostMissile.SHARDSPAWN_RIGHT;
				mo.special2 = 3; // Set sperm count (levels of reproductivity)
				mo.target = self;
				mo.args[0] = 3;		// Mark Initial shard as super damage
			}
		}
	}

    action void A_FireFlameSpell(int blueManaUse, int greenManaUse)
	{
		if (!A_AttemptFireSpell(blueManaUse, greenManaUse))
            return;

        A_FireSpreadMissile("MageFrostFlameMissile", 9, 2);
        A_FireSpreadMissile("MageFrostFlameMissile", 9, 2);
        A_FireSpreadMissile("MageFrostFlameMissile", 9, 2);

		A_StartSound ("FireDemonAttack", CHAN_BODY);
	}

	action void A_FireLightningSpell(int blueManaUse, int greenManaUse)
	{
		if (!A_AttemptFireSpell(blueManaUse, greenManaUse))
            return;

		let mo = SpawnPlayerMissile("MageFrostLightningMissile2");
		if (mo)
		{
			mo.SetOrigin((mo.Pos.X, mo.Pos.Y, mo.Pos.Z - mo.Height), false);
		}
	}

    action void A_FireBloodSpell(int blueManaUse, int greenManaUse)
	{
		if (!A_AttemptFireSpell(blueManaUse, greenManaUse))
            return;

        SpawnPlayerMissile("MageFrostBloodMissile", angle + 8);
        SpawnPlayerMissile("MageFrostBloodMissile", angle - 8);
	}
}

class MageFrostFlameMissileSmoke : Actor
{
	Default
	{
	    +NOBLOCKMAP +NOGRAVITY +SHADOW
	    +NOTELEPORT +CANNOTPUSH +NODAMAGETHRUST
		RenderStyle "Translucent";
		Alpha 0.4;
        Scale 0.6;
		VSpeed 0.4;
	}
	States
	{
	Spawn:
		WRBL GHI 12 Bright;
		Stop;
	}
}
class MageFrostFlameMissile : TimedActor
{
	bool isDoneImpacting;
	bool hasExploded;

    Default
    {
        Speed 15;
        Radius 8;
        Height 8;
        Damage 2;
		Projectile;
        +SPAWNSOUNDSOURCE
        Obituary "$OB_MPMWEAPFROST";
        DamageType "Fire";
        DeathSound "Fireball";
		Gravity 0.125;
		+NOBLOCKMAP +MISSILE +DROPOFF
		+NOTELEPORT
		+BOUNCEONFLOORS
		+BOUNCEONCEILINGS
		+BOUNCEONWALLS
		+USEBOUNCESTATE
		-NOGRAVITY
		Health 4;

		TimedActor.TimeLimit 150;
		TimedActor.DieOnTimer true;
    }
    States
    {
    Spawn:
        WRBL AABBCC 2 Bright A_SpawnItemEx("MageFrostFlameMissileSmoke", random2[Puff]()*0.015625, random2[Puff]()*0.015625, random2[Puff]()*0.015625, 
									0,0,0,0,SXF_ABSOLUTEPOSITION, 64);
        Loop;
	Bounce:
		FX18 M 1 A_VolcanoImpact;
		Goto Spawn;
    Death:
        WRBL D 4 Bright A_VolcBallImpact();
        WRBL EFGHI 4 Bright;
        Stop;
	Disappear:
		TNT1 A 1;
		Stop;
    }

	action void A_VolcanoExplode()
	{
		A_StopMoving();
		
		if (!invoker.isDestroyed && !invoker.hasExploded)
			A_Explode(40, 100);

		invoker.hasExploded = true;
		A_EndAllBounce();
	}

	action void A_VolcBallImpact ()
	{
		//If already exploded, this is a replay of death frame, so Disappear
		if (invoker.hasExploded)
		{
			SetStateLabel("Disappear");
			return;
		}

		//If timer is out, hide the sprite and stop
		if (invoker.isDestroyed)
		{
			SetStateLabel("Disappear");
			return;
		}

		//Explode damage and mark as exploded
		A_VolcanoExplode();
	}

	//Bounce
	action void A_VolcanoImpact()
	{
		Health--;

		if (invoker.isDoneImpacting)
			return;

		if (Health < 1)
		{
			SetStateLabel("Death");
			invoker.isDoneImpacting = true;

			//prevent collision from happening again just in case
			A_EndAllBounce();
			return;
		}

		A_StartSound ("SorcererBallBounce", CHAN_BODY);
	}

	action void A_EndAllBounce()
	{
		invoker.bBOUNCEONFLOORS = false;
		invoker.bBOUNCEONCEILINGS = false;
		invoker.bBOUNCEONWALLS = false;
		invoker.bUSEBOUNCESTATE = false;
		invoker.bNOGRAVITY = true;
	}
}

class MageFrostIceMissileShard : IceShard
{
	default
	{
		+DONTREFLECT
	}

	States
	{
	Spawn:
		SHRU ABC 3 Bright;
		Loop;
	}
}
const ICESTORM_SPREAD = 72;
const ICESTORM_ZSPEED = -30;
const ICESTORM_ZSPEED_MOD = 10;
const ICESTORM_NUM = 12;
class MageFrostIceMissile : Actor
{
    Default
    {
        Speed 120;
        Radius 12;
        Height 8;
        Damage 0;
		Projectile;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
		+SKYEXPLODE
		+NOSHIELDREFLECT
        Obituary "$OB_MPMWEAPFROST";
        DamageType "Ice";
        DeathSound "IceGuyMissileExplode";
		RenderStyle "None";
    }
    States
    {
    Spawn:
        SHRD A 4;
        Loop;
    Death:
        SHRD D 4 A_IceShower;
        Stop;
    }

	action void A_RainIce(Vector3 rainPos)
	{
		double xo = frandom[MSpellIce2](-ICESTORM_SPREAD, ICESTORM_SPREAD);
		double yo = frandom[MSpellIce2](-ICESTORM_SPREAD, ICESTORM_SPREAD);
		Vector3 spawnpos = rainPos + (xo, yo, 0);
		Actor mo = Spawn("MageFrostIceMissileShard", spawnpos, ALLOW_REPLACE);
		if (!mo) return;
		
		int newDamage = mo.damage * 2;
		mo.SetDamage(newDamage);
		
		double newz = mo.CurSector.NextHighestCeilingAt(mo.pos.x, mo.pos.y, mo.pos.z, mo.pos.z, FFCF_NOPORTALS) - (mo.height + 1);
		mo.SetZ(newz);

		mo.target = target;
		mo.Vel.X = MinVel; // Force collision detection
		let zMod = frandom[MSpellIce2](-ICESTORM_ZSPEED_MOD, ICESTORM_ZSPEED_MOD);
		mo.Vel.Z = ICESTORM_ZSPEED + zMod;
		mo.CheckMissileSpawn (radius);
		mo.A_SetPitch(90);
	}

	action void A_IceShower()
	{
		let forwardDist = ICESTORM_SPREAD / 2;
		Vector3 dir = (AngleToVector(angle, cos(pitch)), -sin(pitch));
		let forwardDir = (dir.X * forwardDist, dir.Y * forwardDist, dir.Z * forwardDist);
		let rainPos = Pos + forwardDir;

		for (int i = 0; i < ICESTORM_NUM; i++)
		{
			A_RainIce(rainPos);
		}
	}
}

class MageFrostPoisonMissile : Actor
{
    Default
    {
        Speed 6;
        Radius 16;
        Height 12;
        Damage 2;
        Projectile;
        +RIPPER
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        +ZDOOMTRANS
        SeeSound "PoisonShroomDeath";
        Obituary "$OB_MPMWEAPFROST";

		DamageType "Poison";
    }
    States
    {
    Spawn:
        PSBG EFGHI 4 Bright;
		Loop;
    Death:
        PSBG D 4 Bright;
        Stop;
    }
}

class MageFrostWaterSmoke : Actor
{
	Default
	{
	    +NOBLOCKMAP +NOGRAVITY +SHADOW
	    +NOTELEPORT +CANNOTPUSH +NODAMAGETHRUST
        RenderStyle "Translucent";
        Alpha 0.5;
	}
	States
	{
        Spawn:
            SPSH ABCD 4;
            Stop;
	}
}

class MageWaterDrip : Actor
{
	Default
	{
		Radius 20;
		Height 16;
        Projectile;
		+NOBLOCKMAP
		+NOTELEPORT
		+CANNOTPUSH
		+ZDOOMTRANS
        -NOGRAVITY
        +THRUACTORS;
        Gravity 0.25;
		RenderStyle "Add";
		DamageType "Water";
        Scale 0.5;
	}

	States
	{
	Spawn:
        SPSH A 48 BRIGHT;
    Death:
		SPSH EFGHIJK 4 BRIGHT;
		Stop;
	}	
}
class MageFrostWaterMissile : TimedActor
{
    Default
    {
        Speed 70;
        Radius 12;
        Height 8;
        Damage 20;
        Projectile;
        +SPAWNSOUNDSOURCE
        +CANPUSHWALLS
        +CANUSEWALLS
        +ACTIVATEIMPACT
        -DONTTHRUST
        -CANNOTPUSH
        -NODAMAGETHRUST
        MissileType "MageFrostWaterSmoke";
        Obituary "$OB_MPMWEAPFROST";
        Scale 3.0;

		DeathSound "WaterSplash";
		DamageType "Water";
    }
    States
    {
    Spawn:
        SPSH AAAAAAAAA 3 A_DripWater;
    Death:
        SPSH B 4;
        SPSH CD 4;
        Stop;
    }

    action void A_DripWater ()
	{
        Spawn("MageWaterDrip", pos, ALLOW_REPLACE);
	}

	override int DoSpecialDamage(Actor target, int damage, name damagetype)
	{
		A_PushTarget(target);

		return Super.DoSpecialDamage(target, damage, DamageType);
	}
}

class MageFrostSunMissile : OffsetSpriteActor
{
    Default
    {
        Speed 1;
        Radius 12;
        Height 8;
        Damage 20;
        Projectile;
        +SPAWNSOUNDSOURCE
        Obituary "$OB_MPMWEAPFROST";
        Scale 4.0;
        DamageType "Fire";
		SeeSound "TreeExplode";
        OffsetSpriteActor.OffsetSpriteX 0;
        OffsetSpriteActor.OffsetSpriteY 30;
    }
    States
    {
    Spawn:
        FDMB B 96 Bright Light("YellowSunBig");
    Death:
        FDMB B 6 Bright Light("YellowSunBig") A_SunExplode;
        FDMB C 3 Bright Light("YellowSunBigFade1");
        FDMB C 3 Bright Light("YellowSunBigFade2");
        FDMB D 3 Bright Light("YellowSunBigFade3");
        FDMB D 3 Bright Light("YellowSunBigFade4");
        FDMB E 3 Bright Light("YellowSunBigFade5");
        Stop;
    }

	action void A_SunExplode()
	{
		A_Explode(150, 200);
		A_StartSound("Fireball", CHAN_BODY);
	}
}

class MageFrostMoonMissile : Actor
{
    Default
    {
        Speed 30;
        Radius 12;
        Height 8;
        Damage 0;
        Projectile;
		+DONTREFLECT
        Obituary "$OB_MPMWEAPFROST";
        Translation "Ice";
        Scale 2.0;

		SeeSound "SorcererBallWoosh";
		DeathSound "SorcererBallExplode";
    }
    States
    {
    Spawn:
        MSP1 ABCD 4 Light("MoonBigFade3") A_RadiusThrust(-2000, 100, RTF_NOIMPACTDAMAGE & RTF_THRUSTZ );
        Loop;
    Death:
		TNT1 A 0 A_SpriteOffset(4, 28);
        RADE DDEE 3 Light("MoonBigFade3") FrostMoonPull;
        RADE FFGG 3 Light("MoonBigFade4") FrostMoonPull;
        RADE HI 3 Light("MoonBigFade5");
        Stop;
    }

	action void FrostMoonPull()
	{
		A_RadiusThrust(-3000, 100, RTF_NOIMPACTDAMAGE & RTF_THRUSTZ );
		A_Explode(15, 64);
	}
}

class MageFrostChainLink : Actor
{
	Default
	{
		+NOBLOCKMAP
		+NOGRAVITY
		+NOTELEPORT
		+CANNOTPUSH
		+THRUACTORS

		Speed 0;
	}

	States
	{
	Spawn:
		CHNS B FROSTCHAIN_HEALTH;
	Death:
		Stop;
	}

	void Dispose()
	{
		Destroy();
	}
}

const FROSTCHAIN_MAX_LINKS = 10;
const FROSTCHAIN_HOOK_HEIGHT = 32;
const FROSTCHAIN_CHAIN_HEIGHT = 64;
const FROSTCHAIN_SPREAD = 32;
const FROSTCHAIN_LIFT = 16;
const FROSTCHAIN_HEALTH = 196;
class MageFrostChain : Actor
{
	MageFrostChainLink chainLinks[FROSTCHAIN_MAX_LINKS];
	Default
	{
		+NOBLOCKMAP
		+NOGRAVITY
		+NOTELEPORT
		+CANNOTPUSH

		Speed 0;
	}

	States
	{
	Spawn:
	Hook1:
		CHNS D 4;
		Loop;
	Hook2:
		CHNS E 4;
		Loop;
	Hook3:
		CHNS F 4;
		Loop;
	}

	void DestroyChain(MageFrostChainLink chain)
	{
		if (!chain)
			return;

		chain.Dispose();
	}

	void Dispose()
	{
		for (int i = 0; i++; i < FROSTCHAIN_MAX_LINKS)
		{
			DestroyChain(chainLinks[i]);
		}

		Destroy();
	}

	MageFrostChainLink CreateChain(Class<Actor> hookType, Vector3 spawnPos, double newZ)
	{
		let mo = MageFrostChainLink(Spawn (hookType, (spawnPos.X, spawnPos.Y, newZ), ALLOW_REPLACE));

		return mo;
	}

	void SetRandomHook()
	{
		int stateNum = random[MSpellDeath2](1, 3);
		switch(stateNum)
		{
			case 1:
				SetStateLabel("Hook1");
				break;
			case 1:
				SetStateLabel("Hook2");
				break;
			case 1:
				SetStateLabel("Hook3");
				break;
		}
	}

	void DrawChains(Actor target)
	{
		if (!target)
			return;

		tracer = target;
		
		double xo = frandom[MSpellDeath2](-FROSTCHAIN_SPREAD, FROSTCHAIN_SPREAD);
		double yo = frandom[MSpellDeath2](-FROSTCHAIN_SPREAD, FROSTCHAIN_SPREAD);
		Vector3 spawnPos = Vec2OffsetZ(xo, yo, 0);

		SetOrigin((spawnPos.X, spawnPos.Y, tracer.Pos.Z + FROSTCHAIN_HOOK_HEIGHT ), false);
		SetRandomHook();

		double baseZ = tracer.Pos.Z;
		double topZ = tracer.CurSector.NextHighestCeilingAt(tracer.pos.x, tracer.pos.y, tracer.pos.z, tracer.pos.z, FFCF_NOPORTALS);
		let curZ = baseZ + FROSTCHAIN_CHAIN_HEIGHT;

		int chainCount = 0;
		while (curZ < topZ && chainCount < FROSTCHAIN_MAX_LINKS)
		{
			chainLinks[chainCount] = CreateChain("MageFrostChainLink", spawnPos, curZ);

			curZ += FROSTCHAIN_CHAIN_HEIGHT;
			chainCount++;
		}
	}
}

class MageFrostDeathMissile : Actor
{
	MageFrostChain Chain1;
	MageFrostChain Chain2;
	MageFrostChain Chain3;
	int oldSpeed;

    Default
    {
        Speed 70;
        Radius 12;
        Height 8;
        Damage 30;
		Projectile;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        Obituary "$OB_MPMWEAPFROST";
		Health FROSTCHAIN_HEALTH;
		DamageType "Death";

		DeathSound "Ambient12";
    }
    States
    {
    Spawn:
        RIPP ABC 4;
        Loop;
    Death:
        RIPP D 1;
	ChainAttack:
		RIPP A 1 A_UpdateChains;
		Loop;
    }

	void RemoveChain(MageFrostChain chain)
	{
		if (!chain)
			return;

		chain.Dispose();
	}

	void Dispose()
	{
		if (tracer)
		{
			//If speed was 0 at the beginning, then something else will restore it before this one ends
			if (oldSpeed > 0)
				tracer.A_SetSpeed(oldSpeed);

			tracer.bNOGRAVITY = false;
		}

		RemoveChain(Chain1);
		RemoveChain(Chain2);
		RemoveChain(Chain3);

		Destroy();
	}

	MageFrostChain CreateChain(Actor target)
	{
		if (!target)
			return null;
		
		let chainObj = MageFrostChain(Spawn ("MageFrostChain", target.Pos, ALLOW_REPLACE));
		chainObj.DrawChains(target);

		return chainObj;
	}

	override int DoSpecialDamage(Actor target, int damage, name damagetype)
	{
		int result = Super.DoSpecialDamage(target, damage, damagetype);

		if (!target.bIsMonster)
		{
			A_StartSound("FlechetteBounce", CHAN_BODY);
			Dispose();
			return result;
		}

		tracer = target;
		oldSpeed = tracer.Speed;
		tracer.bNOGRAVITY = true;
		tracer.A_SetSpeed(0);
		tracer.SetOrigin((tracer.Pos.X, tracer.Pos.Y, Tracer.Pos.Z + FROSTCHAIN_LIFT), true);

		A_SetRenderStyle(0.0, STYLE_None);
		SetStateLabel("ChainAttack");

		Chain1 = CreateChain(tracer);
		Chain2 = CreateChain(tracer);
		Chain3 = CreateChain(tracer);

		return result;
	}

	action void A_UpdateChains()
	{
		Health--;

		if (Health <= 0)
		{
			invoker.Dispose();
			return;
		}
	}
}



const FROSTLIGHTNING_WOBBLE = 4.0;
const FROSTLIGHTNING_DIST = 12.0;
const FROSTLIGHTNING_ZSPEED = -90;
class MageFrostLightningMissile1 : Actor
{
	Default
	{
		Radius 10;
		Height 6;
		Speed 20;
		FastSpeed 26;
		Damage 4;
		DamageType "Fire";
		Projectile;
		-ACTIVATEIMPACT
		-ACTIVATEPCROSS
		+ZDOOMTRANS
		RenderStyle "Add";
		Obituary "$OB_MPMWEAPFROST";
	}
	States
	{
	Spawn:
		MLF2 A 6 Bright;
		Loop;
	Death:
		MLF2 BCDE 5 Bright;
		Stop;
	}
}

class MageFrostLightningMissile2 : MageFrostLightningMissile1
{
	Default
	{
		Radius 5;
		Height 20;
		Speed 20;
		FastSpeed 20;
		Damage FLAMEFLOOR_DAMAGE;
		+CEILINGHUGGER
		RenderStyle "Add";
		
		+RIPPER
	}
	
	states
	{
	Spawn:
		MLF2 AAAAAAAAAAAAAA 2 Bright A_SpellFloorFire;
	Death:
		MLF2 ABCDE 6 BRIGHT;
		Stop;
	}
	
	void A_SpellFloorFire()
	{
		//Add wobble velocity
		Vel.X += frandom[FrostLightningWobble](-FROSTLIGHTNING_WOBBLE, FROSTLIGHTNING_WOBBLE);
		Vel.Y += frandom[FrostLightningWobble](-FROSTLIGHTNING_WOBBLE, FROSTLIGHTNING_WOBBLE);

		// Actor mo = SpawnPlayerMissile("MageFrostLightningStrike");
		// if (!mo) return;

		// double offsetX = frandom[FrostLightningWobble](-FROSTLIGHTNING_DIST, FROSTLIGHTNING_DIST);		
		// double offsetY = frandom[FrostLightningWobble](-FROSTLIGHTNING_DIST, FROSTLIGHTNING_DIST);		
        // double newz = mo.CurSector.HighestCeilingAt((pos.X, pos.Y));
        // mo.SetOrigin((Pos.X + offsetX, Pos.Y + offsetY, newz), false);

		// mo.Vel.X = MinVel; // Force collision detection
        // mo.Vel.Y = MinVel; // Force collision detection
		// mo.Vel.Z = FROSTLIGHTNING_ZSPEED;
		// mo.CheckMissileSpawn (radius);

		if (!target)
			return;
		let xrpgPlayer = XRpgPlayer(target);
		if (!xrpgPlayer)
			return;

		xrpgPlayer.A_FireVerticalMissile("MageFrostLightningStrike", FROSTLIGHTNING_DIST, FROSTLIGHTNING_DIST, FROSTLIGHTNING_ZSPEED, Pos.X, Pos.Y);
	}
}

class MageFrostLightningSmoke : Actor
{
	Default
	{
	    +NOBLOCKMAP +NOGRAVITY +SHADOW
	    +NOTELEPORT +CANNOTPUSH +NODAMAGETHRUST
		Scale 0.5;
	}
	States
	{
	Spawn:
		MLFX L 12;
		Stop;
	}
}
class MageFrostLightningStrike : FastProjectile
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
        MissileType "MageFrostLightningSmoke";
        DeathSound "MageLightningFire";
        Obituary "$OB_MPMWEAPFROST";

		DamageType "Electric";
    }
    States
    {
    Spawn:
        MLFX K 2 Bright;
		Loop;
    Death:
        MLFX M 2 Bright;
        Stop;
    }
}

class MageFrostBloodMissile : Actor
{
    Default
    {
        Speed 12;
        Radius 16;
        Height 12;
        Damage 1;
        Projectile;
        +RIPPER
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        +ZDOOMTRANS
		+NOSHIELDREFLECT
        Obituary "$OB_MPMWEAPFROST";
		SeeSound "WraithAttack";

		DamageType "Blood";
    }
    States
    {
    Spawn:
        TELE CDEFGH 2 Bright;
    Death:
        TELE H 2 Bright;
        Stop;
    }

	override int DoSpecialDamage(Actor targetMonster, int damage, name damagetype)
	{
		let playerObj = XRpgPlayer(target);
		if (playerObj && playerObj.Health > 0)
		{
			playerObj.Heal(1);
		}
		
		return Super.DoSpecialDamage(targetMonster, damage, damagetype);
	}
}