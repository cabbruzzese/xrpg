
const WRAITH_LIFE_MAX = 1024;
class XRpgSummonWraith : Wraith
{
    int lifeCounter;

    property lifeCounter : LifeCounter;

	Default
	{
		Health 25;

        +NOICEDEATH
        +FRIENDLY
        Translation "Ice";
        RenderStyle "Translucent";
        Alpha 0.6;

        XRpgSummonWraith.LifeCounter WRAITH_LIFE_MAX;
	}

    States
	{
	Death:
		WRTH I 4;
		WRTH J 4 A_Scream;
		WRTH KL 4;
		WRTH M 4 A_NoBlocking;
		WRTH N 4 A_QueueCorpse;
		WRTH O 4;
		WRTH PQ 5 A_DestroyCorpse;
		WRTH R -1;
		Stop;
	XDeath:
		WRT2 A 5;
		WRT2 B 5 A_Scream;
		WRT2 CD 5;
		WRT2 E 5 A_NoBlocking;
		WRT2 F 5;
		WRT2 G 5 A_DestroyCorpse;
		WRT2 H -1;
		Stop;
	}

    override void Tick()
    {
        LifeCounter--;
        if (LifeCounter < 1 && Health > 0)
        {
            DamageMobj (null, null, TELEFRAG_DAMAGE, 'None');            
            SetStateLabel("Death");
        }
        Super.Tick();
    }

    action void A_DestroyCorpse()
    {
        Destroy();
    }
}