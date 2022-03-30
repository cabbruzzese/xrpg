class ExplodableJunk : Actor
{
	Class<Actor> junkType1;
	Class<Actor> junkType2;
	int junk1Min;
	int junk1Max;
	int dropZOffset;

	property JunkType1 : junkType1;
	property JunkType2 : junkType2;
	property Junk1Min : junk1Min;
	property Junk1Max : junk1Max;
	property DropZOffset : dropZOffset;


	Default
	{
        Radius 15;
		Height 32;
        Health 10;
        DeathHeight 12;
        Mass 0x7fffffff;
        DeathSound "TreeBreak";
		+SOLID +SHOOTABLE +NOBLOOD +NOICEDEATH
        +DONTRIP +CANTSEEK +NEVERTARGET +NOTAUTOAIMED

		ExplodableJunk.JunkType1 "";
		ExplodableJunk.JunkType2 "";
		ExplodableJunk.Junk1Min 0;
		ExplodableJunk.Junk1Max 0;
		ExplodableJunk.dropZOffset 0;
	}

    action void A_SpawnJunk(Class<Actor> junkType)
    {
		if (!junkType)
			return;
		
        A_SpawnItemEx(junkType, 0,0,8.5, 
								random[JunkExplode](-128,127) * 0.03125,
								random[JunkExplode](-128,127) * 0.03125,
								10 + random[JunkExplode](0,255) * 0.015625, 0, SXF_ABSOLUTEVELOCITY);
    }

	virtual Name GetDropType ()
	{
		return "ArtiHealth";
	}

	action void A_ThrowStuff()
    {
        int debrisCount = random[BarrelExplode](invoker.Junk1Min,invoker.Junk1Max);
        for (int i = 0; i < debrisCount; i++)
        {
            A_SpawnJunk(invoker.JunkType1);
        }

		A_SpawnJunk(invoker.JunkType2);

		let dropType = invoker.GetDropType();
		if (dropType)
		{
			bool success;
			Actor mo;
			[success, mo] = A_SpawnItemEx(dropType, 0, 0, invoker.dropZOffset);
			if (mo && invoker.dropZOffset != 0)
			{
				mo.bSPAWNFLOAT = false;
				mo.bFLOATBOB = false;
				mo.bNOGRAVITY = true;
			}
		}

        A_Scream();
    }
}

class JunkDebris : Actor
{
	Default
	{
		Radius 5;
		Height 5;
		+DROPOFF
		+CORPSE
		+NOTELEPORT
		+FLOORCLIP
	}

    action void A_RandomMirror()
    {
        if (random[BarrelExplode](1,2) == 1)
			A_SetScale(-1, 1);
    }
}

class XRpgBarrel : ExplodableJunk replaces ZBarrel
{
	Default
	{
        Radius 15;
		Height 32;
        Health 250;
        DeathHeight 12;
		DeathSound "TreeBreak";

		ExplodableJunk.JunkType1 "BarrelBoard";
		ExplodableJunk.JunkType2 "BarrelRing";
		ExplodableJunk.Junk1Min 2;
		ExplodableJunk.Junk1Max 8;
	}
	States
	{
	Spawn:
		ZBAR A -1;
		Stop;
    Death:
        BARL B 1 A_ThrowStuff;
        BARL B -1;
        Stop;
	}

	override Name GetDropType()
	{
		Name spawnItem = "CrystalVial";

		//Spawn random item
        int itemNum = random[BarrelExplode](1,4);
        if (itemNum == 1)
            spawnItem = "XRpgCWeapFlail";
		else
		{
			int artiNum = random[BarrelExplode](1,10);
			if (artiNum == 1)
				spawnItem = "ArtiTorch";
			else if (artiNum == 2)
				spawnItem = "ArtiBoostArmor";
			else if (artiNum == 3)
				spawnItem = "ArtiHealth";
			else if (artiNum <= 5)
				spawnItem = "ArtiBlastRadius";
		}

		return spawnItem;
	}
}

class BarrelRing : JunkDebris
{
	States
	{
	Spawn:
		BARR ABCDE 5;
		Loop;
	Crash:
		BARR F 1 A_QueueCorpse;
        BARR F -1;
        Stop;
	}
}

class BarrelBoard : JunkDebris
{
	States
	{
	Spawn:
		BARP A 5 A_RandomMirror;
        BARP BCDE 5;
		Loop;
	Crash:
		BARP F 1 A_QueueCorpse;
        BARP F -1;
        Stop;
	}
}

class XRpgVasePillar : ExplodableJunk replaces ZVasePillar
{
	Default
	{
		Radius 12;
		Height 54;
		Health 10;
		DeathHeight 30;

		ExplodableJunk.JunkType1 "VaseShard";
		ExplodableJunk.JunkType2 "";
		ExplodableJunk.Junk1Min 10;
		ExplodableJunk.Junk1Max 20;
		ExplodableJunk.DropZOffset 12;
	}
	States
	{
	Spawn:
		VASE A -1;
		Stop;
	Death:
        VASE B 1 A_ThrowStuff;
        VASE B -1;
        Stop;
	}

	override Name GetDropType()
	{
		Name spawnItem = "ArtiHealth";
		//Spawn random item
        int itemNum = random[BarrelExplode](1,10);
        if (itemNum == 1)
            spawnItem = "ArtiBoostMana";
        else if (itemNum <= 4)
            spawnItem = "ArtiSuperHealth";

		return spawnItem;
	}
}

class VaseShard : JunkDebris
{
	Default
	{
		Translation "StoneSkin";
	}
	States
	{
	Spawn:
		SGSA A 5 A_RandomMirror;
        SGSA BCDE 5;
		Loop;
	Crash:
		SGSA A 1 A_QueueCorpse;
        SGSA A -1;
        Stop;
	}
}