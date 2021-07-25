
// The Mage's Wand ----------------------------------------------------------

class XRpgMWeapWand : XRpgMageWeapon replaces MWeapWand
{
	Default
	{
		Weapon.SelectionOrder 3600;
		Weapon.KickBack 0;
		Weapon.YAdjust 9;
		Tag "$TAG_MWEAPWAND";
	}
	States
	{
	Select:
		MWND A 1 A_Raise;
		Loop;
	Deselect:
		MWND A 1 A_Lower;
		Loop;
	Ready:
		MWND A 1 A_WeaponReady;
		Loop;
	Fire:
		MWND A 6;
		MWND B 6 Bright Offset (0, 48) A_FireProjectile ("MageWandMissile");
		MWND A 3 Offset (0, 40);
		MWND A 3 Offset (0, 36) A_ReFire;
		Goto Ready;
    AltFire:
		MWND A 6 A_AltFireCheckSpellSelected;
		MWND B 6 Bright Offset (0, 48) A_FireWandSpell();
		MWND A 3 Offset (0, 40);
		MWND A 3 Offset (0, 36) A_ReFire;
		Goto Ready;
    AltHold:
        MWND A 2 A_AltHoldCheckSpellSelected;
        MWND B 2 Bright Offset (0, 48) A_FireWandSpell();
		MWND A 1 Offset (0, 36) A_ReFire;
        Goto Ready;
	}

    override bool IsSpellRapidFire(int spellType)
    {
        if (spellType == SPELLTYPE_ICE)
            return true;
        if (spellType == SPELLTYPE_POISON)
            return true;

        return false;
    }

    action void A_FireWandSpell()
	{
		if (player == null)
			return;

        let magePlayer = XRpgMagePlayer(player.mo);
        if (magePlayer && magePlayer.ActiveSpell)
        {

            switch (magePlayer.ActiveSpell.SpellType)
            {
                case SPELLTYPE_FIRE:
                    A_FireFlameMissile();
                    break;
                case SPELLTYPE_ICE:
                    A_FireIceMissile();
                    break;
                case SPELLTYPE_POISON:
                    A_FirePoisonMissile();
                    break;
                case SPELLTYPE_DEATH:
                    A_FireDeathMissile();
                    break;
                case SPELLTYPE_LIGHTNING:
                    A_FireLightningMissile();
                    break;
            }
        }
	}

    action void A_FireFlameMissile()
	{
        int ammoUse = 2;

		if (player == null)
		{
			return;
		}

        if (!DepleteBlueMana(ammoUse))
        {
            player.SetPsprite(PSP_WEAPON, player.ReadyWeapon.FindState("Fire"));
            return;
        }

		A_FireProjectile ("MageWandFlameMissile");
	}

    action void A_FireIceMissile()
	{
        int ammoUse = 1;

		if (player == null)
		{
			return;
		}

        if (!DepleteBlueMana(ammoUse))
        {
            player.SetPsprite(PSP_WEAPON, player.ReadyWeapon.FindState("Fire"));
            return;
        }

        Actor shard = SpawnPlayerMissile("MageWandIceMissile", angle + random(-3, 3));
        if (shard)
        {
            shard.Vel.Z = shard.Vel.Z + random(-3, 3);
        }
	}

    action void A_FirePoisonMissile()
	{
        int ammoUse = 2;

		if (player == null)
		{
			return;
		}

        if (!DepleteBlueMana(ammoUse))
        {
            player.SetPsprite(PSP_WEAPON, player.ReadyWeapon.FindState("Fire"));
            return;
        }

        SpawnPlayerMissile("MageWandPoisonMissile", angle);
	}

    action void A_FireDeathMissile()
	{
        int ammoUse = 5;

		if (player == null)
		{
			return;
		}

        if (!DepleteBlueMana(ammoUse))
        {
            player.SetPsprite(PSP_WEAPON, player.ReadyWeapon.FindState("Fire"));
            return;
        }

        SpawnPlayerMissile("MageWandDeathMissile", angle);
        SpawnPlayerMissile("MageWandDeathMissile", angle + 12);
        SpawnPlayerMissile("MageWandDeathMissile", angle - 12);
	}

    action void A_FireLightningMissile()
	{
        int ammoUse = 5;

		if (player == null)
		{
			return;
		}

        if (!DepleteBlueMana(ammoUse))
        {
            player.SetPsprite(PSP_WEAPON, player.ReadyWeapon.FindState("Fire"));
            return;
        }

        A_FireProjectile ("MageWandLightningMissile");
	}
}

class MageWandFlameMissile : FastProjectile
{
    Default
    {
        Speed 60;
        Radius 12;
        Height 8;
        Damage 4;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        Obituary "$OB_MPMWEAPWAND";
        Scale 0.75;
        DamageType "Fire";
        DeathSound "Fireball";
    }
    States
    {
    Spawn:
        DMFX ABD 4 Bright;
        Loop;
    Death:
        DMFX D 4 A_Explode(40, 100);
        DMFX EFGH 4 Bright;
        Stop;
    }
}

class MageWandIceMissile : FastProjectile
{
    Default
    {
        Speed 120;
        Radius 12;
        Height 8;
        Damage 4;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        SeeSound "IceGuyMissileExplode";
        Obituary "$OB_MPMWEAPWAND";
        DamageType "Ice";
        DeathSound "IceGuyMissileExplode";
    }
    States
    {
    Spawn:
        SHRD ABC 4 Bright;
        Loop;
    Death:
        ICPR IJKLM 4 Bright;
        Stop;
    }
}

class MageWandPoisonMissile : Actor
{
    Default
    {
        Speed 10;
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
        D2FX FGHIJK 4 Bright;
    Death:
        D2FX L 4 Bright;
        Stop;
    }
}

class MageWandDeathMissile : Actor
{
    Default
    {
        Speed 18;
        Radius 12;
        Height 8;
        Damage 10;
        Projectile;
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        +ZDOOMTRANS
        SeeSound "BishopAttack";
        Obituary "$OB_MPMWEAPWAND";
        Scale 0.5;
    }
    States
    {
    Spawn:
        SBS4 ABC 4 Bright;
        Loop;
    Death:
        SBFX CDEFG 4 Bright;
        Stop;
    }
}

class MageWandLightningSmoke : Actor
{
	Default
	{
	+NOBLOCKMAP +NOGRAVITY +SHADOW
	+NOTELEPORT +CANNOTPUSH +NODAMAGETHRUST
    Scale 0.25;
	}
	States
	{
	Spawn:
		MLF2 O 8;
		Stop;
	}
}
class MageWandLightningMissile : FastProjectile
{
    Default
    {
        Speed 110;
        Radius 8;
        Height 6;
        Damage 1;
        Projectile;
        +RIPPER
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
        MissileType "MageWandLightningSmoke";
        SeeSound "MageLightningFire";
        Obituary "$OB_MPMWEAPWAND";
        Scale 0.25;
    }
    States
    {
    Spawn:
        MLF2 P 1 Bright;
        MLF2 Q 1 Bright;
        MLF2 Q 1 Bright WandLightiningSplit;
    Death:
        MLF2 NO 1 Bright;
        Stop;
    }

	action void WandLightiningSplit ()
	{
		if (target == null)
		{
			return;
		}
		
		A_SplitWandLightiningFire();
		A_SplitWandLightiningFire();
	}

    action void A_SplitWandLightiningFire()
	{
		if (target == null)
		{
			return;
		}
		
        int randAngle = random(-12, 12);
        int randPitch = random(-8, 8);
		let mo = target.SpawnPlayerMissile ("MageWandLightningMissile", angle + randAngle);
		if (mo != null)
		{
			mo.SetOrigin(Pos, false);
			mo.target = target;
			mo.A_SetPitch(pitch + randPitch);
			mo.Vel.Z = Vel.Z + randPitch;
			//mo.SetDamage(Damage);
		}
	}
}