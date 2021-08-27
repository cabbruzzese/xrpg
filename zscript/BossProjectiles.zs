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

        Obituary "$OB_FIREBOSS";
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

	override int DoSpecialDamage (Actor victim, int damage, Name damagetype)
	{
		//Don't hurt friendlies
		if (damage > 0 && victim && victim.bIsMonster && !victim.bFriendly)
			return 0;

		return super.DoSpecialDamage(victim, damage, damagetype);
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
            //Only poison player if poison expired
            if (victim.player.poisoncount >= 4)
                return -1;

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

class LightningLeaderFx1 : Actor
{
    Default
	{
		+NOBLOCKMAP +NOGRAVITY +NOCLIP +FLOAT
		+NOTELEPORT
		RenderStyle "Translucent";
		Alpha 0.6;

		SeeSound "ThunderCrash";
	}
	States
	{
	    Spawn:
            FAXE R 4 Bright;
            FAXE S 4 Bright A_LightningBurst;
		    FAXE STUVWX 4 Bright;
		    Stop;
	}

    action void A_LightningBurst()
	{
		A_Explode(50, 150, false);
        A_RadiusThrust(3000, 150, RTF_NOIMPACTDAMAGE);
	}

	override int DoSpecialDamage (Actor victim, int damage, Name damagetype)
	{
		//Don't hurt friendlies
		if (damage > 0 && victim && victim.bIsMonster && !victim.bFriendly)
			return 0;

		return super.DoSpecialDamage(victim, damage, damagetype);
	}
}

class IceLeaderFx1 : Actor
{
	Default
	{
		Speed 10;
		Radius 4;
		Height 4;
		Damage 1;
		DamageType "Ice";
		Gravity 0.125;
		+NOBLOCKMAP +DROPOFF +MISSILE
		+NOTELEPORT
		+STRIFEDAMAGE
	}
	States
	{
	Spawn:
		ICPR NOP 3 Bright;
		Loop;
	}

	override int DoSpecialDamage (Actor victim, int damage, Name damagetype)
	{
		//Don't hurt friendlies
		if (damage > 0 && victim && victim.bIsMonster && !victim.bFriendly)
			return 0;

		return super.DoSpecialDamage(victim, damage, damagetype);
	}
}