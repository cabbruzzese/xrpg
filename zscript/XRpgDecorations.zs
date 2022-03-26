class ExplodableJunk : Actor
{
    action void A_SpawnJunk(Class<Actor> junkType)
    {
        A_SpawnItemEx(junkType, 0,0,8.5, 
								random[JunkExplode](-128,127) * 0.03125,
								random[JunkExplode](-128,127) * 0.03125,
								10 + random[JunkExplode](0,255) * 0.015625, 0, SXF_ABSOLUTEVELOCITY);
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
        Mass 0x7fffffff;
        DeathSound "TreeBreak";
		+SOLID +SHOOTABLE +NOBLOOD +NOICEDEATH
        +DONTRIP +CANTSEEK +NEVERTARGET +NOTAUTOAIMED
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

    action void A_ThrowStuff()
    {
        A_SpawnJunk("BarrelRing");

        int boardCount = random[BarrelExplode](2,8);
        for (int i = 0; i < boardCount; i++)
        {
            A_SpawnJunk("BarrelBoard");
        }

        //Spawn random item
        int itemNum = random[BarrelExplode](1,5);
        if (itemNum == 1)
            A_SpawnItemEx("ArtiBlastRadius");
        else if (itemNum == 2)
            A_SpawnItemEx("ArtiHealth");
        else if (itemNum == 3)
            A_SpawnItemEx("ArtiBoostMana");
        else if (itemNum == 4)
            A_SpawnItemEx("ArtiBoostArmor");
         else if (itemNum == 5)
            A_SpawnItemEx("XRpgCWeapFlail");

        A_Scream();
    }
}

class BarrelRing : Actor
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

class BarrelBoard : Actor
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

    action void A_RandomMirror()
    {
        if (random[BarrelExplode](1,2) == 1)
            A_OverlayFlags(1,PSPF_FLIP|PSPF_MIRROR,true);
    }
}