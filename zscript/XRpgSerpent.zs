// Serpent ------------------------------------------------------------------

class XRpgSerpent : Serpent replaces Serpent
{
	States
	{
	XDeath:
		SSXD A 4;
		SSXD B 4 A_SpawnSerpentHead;
		SSXD C 4 A_NoBlocking;
		SSXD DE 4;
		SSXD FG 3;
		SSXD H 3 A_SerpentTranslatedSpawnGibs;
		Stop;
	}

    action void A_SpawnSerpentHead()
    {
        bool success;
        Actor mo;

        int headDist = 45 * Scale.X;

        [success, mo] = A_SpawnItemEx("SerpentHead", 0, 0, headDist);
        if (mo)
        {
            ActorUtils.CopyStyles(self, mo);
        }
    }

    action void A_SerpentTranslatedSpawnGibs()
    {
        static const class<Actor> GibTypes[] =
		{
			"SerpentGib3",
			"SerpentGib2",
			"SerpentGib1"
		};

		for (int i = 2; i >= 0; --i)
		{
			double x = (random[SerpentGibs]() - 128) / 16.;
			double y = (random[SerpentGibs]() - 128) / 16.;

			Actor mo = Spawn (GibTypes[i], Vec2OffsetZ(x, y, floorz + 1), ALLOW_REPLACE);
			if (mo)
			{
				mo.Vel.X = (random[SerpentGibs]() - 128) / 1024.f;
				mo.Vel.Y = (random[SerpentGibs]() - 128) / 1024.f;
				mo.Floorclip = 6;

                ActorUtils.CopyStyles(self, mo);
			}
		}
    }
}