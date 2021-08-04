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
		CONE A 1 A_WeaponReady;
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
		CONE B 3 A_AltFireCheckSpellSelected;
		CONE C 4;
		CONE D 3;
		CONE E 5;
		CONE F 3 A_FireSpell();
		CONE G 3;
		CONE A 9;
		CONE A 10 A_ReFire;
		Goto Ready;
    AltHold:
		CONE F 1 A_AltHoldCheckSpellSelected;
		CONE F 2 A_FireSpell();
		CONE F 2 A_ReFire;
		CONE G 3;
		CONE A 9;
		CONE A 10;
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

	override bool IsSpellRapidFire(int spellType)
    {
        if (spellType == SPELLTYPE_WATER)
            return true;
		if (spellType == SPELLTYPE_ICE)
			return true;

        return false;
    }

    override void FireFlameSpell()
	{
		if (!AttemptFireSpell(0, 8))
            return;

        FireSpreadMissile("MageFrostFlameMissile", 9, 2);
        FireSpreadMissile("MageFrostFlameMissile", 9, 2);
        FireSpreadMissile("MageFrostFlameMissile", 9, 2);
	}
    
    override void FireIceSpell()
	{
		FireMissileSpell("MageFrostIceMissile", 0, 1);
	}

    override void FirePoisonSpell()
	{
		FireMissileSpell("MageFrostPoisonMissile", 0, 8);
	}

    override void FireWaterSpell()
	{
		if (!AttemptFireSpell(0, 1))
            return;

        FireSpreadMissile("MageFrostWaterMissile", 2, 1);
	}

    override void FireSunSpell()
	{
		FireMissileSpell("MageFrostSunMissile", 0, 12);
	}

    override void FireMoonSpell()
	{
		FireMissileSpell("MageFrostMoonMissile", 0, 6);
	}

    override void FireDeathSpell()
	{
		FireMissileSpell("MageFrostDeathMissile", 0, 8);
	}

    override void FireLightningSpell()
	{
	}

    override void FireBloodSpell()
	{
	}
}

class MageFrostFlameMissile : Actor
{
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

    }
    States
    {
    Spawn:
        WRBL ABC 4 Bright;
        Loop;
	Bounce:
		FX18 M 1 A_VolcanoImpact;
		Goto Spawn;
    Death:
        WRBL D 4 Bright A_VolcBallImpact;
        WRBL EFGHI 4 Bright;
        Stop;
    }

	void A_VolcBallImpact ()
	{
		if (pos.Z <= floorz)
		{
			bNoGravity = true;
			Gravity = 1;
			AddZ(28);
		}
		A_Explode(40, 100);
	}

	//Bounce
	void A_VolcanoImpact()
	{
		Health--;
		if (Health < 1)
		{
			SetStateLabel("Death");
			return;
		}

		A_StartSound ("SorcererBallBounce", CHAN_BODY);
	}
}

const ICESTORM_SPREAD = 72;
const ICESTORM_ZSPEED = -30;
const ICESTORM_ZSPEED_MOD = 10;
const ICESTORM_NUM = 8;
class MageFrostIceMissile : FastProjectile
{
    Default
    {
        Speed 120;
        Radius 12;
        Height 8;
        Damage 0;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
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

	action void A_RainIce()
	{
		double xo = Random(-1 * ICESTORM_SPREAD, ICESTORM_SPREAD);
		double yo = Random(-1 * ICESTORM_SPREAD, ICESTORM_SPREAD);
		Vector3 spawnpos = Vec2OffsetZ(xo, yo, pos.z);
		Actor mo = Spawn("IceShard", spawnpos, ALLOW_REPLACE);
		if (!mo) return;
		
		double newz = mo.CurSector.NextHighestCeilingAt(mo.pos.x, mo.pos.y, mo.pos.z, mo.pos.z, FFCF_NOPORTALS) - (mo.height + 1);
		mo.SetZ(newz);

		mo.target = target;
		mo.Vel.X = MinVel; // Force collision detection
		let zMod = random(-1 * ICESTORM_ZSPEED_MOD, ICESTORM_ZSPEED_MOD);
		mo.Vel.Z = ICESTORM_ZSPEED + zMod;
		mo.CheckMissileSpawn (radius);
		mo.A_SetPitch(90);
	}

	action void A_IceShower()
	{
		for (int i = 0; i < ICESTORM_NUM; i++)
		{
			A_RainIce();
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
        Obituary "$OB_MPMWEAPWAND";
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

class MageFrostWaterMissile : FastProjectile
{
    Default
    {
        Speed 80;
        Radius 8;
        Height 6;
        Damage 2;
        +SPAWNSOUNDSOURCE
        -NOGRAVITY
        Gravity 0.25;
        Obituary "$OB_MPMWEAPWAND";
    }
    States
    {
    Spawn:
        SPSH A 4;
        Loop;
    Death:
        SPSH B 4 A_RadiusThrust(2000, 64);
        SPSH CD 4;
        Stop;
    }
}

class MageFrostSunMissile : Actor
{
    Default
    {
        Speed 1;
        Radius 12;
        Height 8;
        Damage 20;
        Projectile;
        +SPAWNSOUNDSOURCE
        Obituary "$OB_MPMWEAPWAND";
        Scale 4.0;
        DamageType "Fire";
        DeathSound "Fireball";
    }
    States
    {
    Spawn:
        FDMB B 96 Bright Light("YellowSunBig");
    Death:
        FDMB B 6 Bright Light("YellowSunBig") A_Explode(150, 200);
        FDMB C 3 Bright Light("YellowSunBigFade1");
        FDMB C 3 Bright Light("YellowSunBigFade2");
        FDMB D 3 Bright Light("YellowSunBigFade3");
        FDMB D 3 Bright Light("YellowSunBigFade4");
        FDMB E 3 Bright Light("YellowSunBigFade5");
        Stop;
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
        Obituary "$OB_MPMWEAPWAND";
        Translation "Ice";
        Scale 2.0;
    }
    States
    {
    Spawn:
        MSP1 ABCD 4 Light("MoonBigFade3") A_RadiusThrust(-2000, 100, RTF_NOIMPACTDAMAGE & RTF_THRUSTZ );
        Loop;
    Death:
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
const FROSTCHAIN_HEALTH = 128;
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
		int stateNum = random(1, 3);
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
		
		double xo = Random(-1 * FROSTCHAIN_SPREAD, FROSTCHAIN_SPREAD);
		double yo = Random(-1 * FROSTCHAIN_SPREAD, FROSTCHAIN_SPREAD);
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