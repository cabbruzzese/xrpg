// The Cleric's Mace --------------------------------------------------------

class XRpgCWeapMace : XRpgClericWeapon replaces CWeapMace
{
	Default
	{
		+WEAPON.MELEEWEAPON
		Weapon.SelectionOrder 3500;
		Weapon.KickBack 150;
		Weapon.YAdjust -8;
		+BLOODSPLATTER
		Obituary "$OB_MPCWEAPMACE";
		Tag "$TAG_CWEAPMACE";
	}

	States
	{
	Select:
		CMCE A 1 A_Raise;
		Loop;
	Deselect:
		CMCE A 1 A_Lower;
		Loop;
	Ready:
		CMCE A 1 A_WeaponReady;
		Loop;
	Fire:
		CMCE B 2 Offset (60, 20);
		CMCE B 1 Offset (30, 33);
		CMCE B 2 Offset (8, 45);
		CMCE C 1 Offset (8, 45);
		CMCE D 1 Offset (8, 45);
		CMCE E 1 Offset (8, 45);
		CMCE E 1 Offset (-11, 58) A_CMaceAttack();
		CMCE F 1 Offset (8, 45);
		CMCE F 2 Offset (-8, 74);
		CMCE F 1 Offset (-20, 96);
		CMCE F 8 Offset (-33, 160);
		CMCE A 2 Offset (8, 75) A_ReFire;
		CMCE A 1 Offset (8, 65);
		CMCE A 2 Offset (8, 60);
		CMCE A 1 Offset (8, 55);
		CMCE A 2 Offset (8, 50);
		CMCE A 1 Offset (8, 45);
		Goto Ready;
	GlowAltFire:
		CMCE C 2 Offset (120, 85);
		CMCE C 2 Offset (80, 90);
		CMCL A 4 Bright Offset (1, 101);
		CMCL B 4 Bright Offset (1, 101);
		CMCL C 4 Bright Offset (1, 101);
	GlowAltHold:
		CMCL D 4 Bright Offset (1, 101) A_CMaceSwingAttack(true, true);
		CMCL E 4 Bright Offset (1, 101) A_CMaceSwingAttack(false, true);
		CMCL F 4 Bright Offset (1, 101) A_CMaceSwingAttack(false, true);
		CMCL C 2 Offset (-80, 110) A_CheckCMaceSwingFinish;
	AltGlowFinish:
		CMCL B 2 Offset (-120, 115);
		CMCL A 2 Offset (-160, 120);
		CMCE F 10 Offset (-160, 120);
		CMCE A 2 Offset (8, 75);
		CMCE A 1 Offset (8, 65);
		CMCE A 2 Offset (8, 60);
		CMCE A 1 Offset (8, 55);
		CMCE A 2 Offset (8, 50);
		CMCE A 1 Offset (8, 45);
		Goto Ready;
	AltHold:
		#### # 0 Offset (160, 80) A_CheckCMaceSwingHold;
	AltFire:
		CMCE C 2 Offset (160, 80) A_CheckCMaceSwing;
		CMCE C 2 Offset (120, 85);
		CMCE C 2 Offset (80, 90);
		CMCE D 2 Offset (40, 95) A_CMaceSwingAttack(true, false, -14);
		CMCE D 2 Offset (1, 101) A_CMaceSwingAttack(false, false,  0);
		CMCE E 2 Offset (-40, 108) A_CMaceSwingAttack(false, false, 14);
		CMCE E 2 Offset (-120, 115);
		CMCE F 10 Offset (-160, 120);
		CMCE A 2 Offset (8, 75);
		CMCE A 1 Offset (8, 65);
		CMCE A 2 Offset (8, 60);
		CMCE A 1 Offset (8, 55);
		CMCE A 2 Offset (8, 50);
		CMCE A 1 Offset (8, 45);
		Goto Ready;
	}

	action void A_CheckCMaceSwing()
	{
		if (A_IsSmite())
			A_SetWeapState("GlowAltFire");
	}

	action void A_CheckCMaceSwingFinish()
	{
		if (A_IsSmite())
			A_Refire();
		else
			A_SetWeapState("AltGlowFinish");
	}

	action void A_CheckCMaceSwingHold()
	{
		if (A_IsSmite())
			A_SetWeapState("GlowAltHold");
	}
	
	//===========================================================================
	//
	// A_CMaceAttack
	//
	//===========================================================================

	action void A_CMaceAttack()
	{
		FTranslatedLineTarget t;

		if (!player)
			return;

		int damage = random[CWeapMace](1, 40);

        let xrpgPlayer = XRpgPlayer(player.mo);
		if (xrpgPlayer != null)
			damage += xrpgPlayer.GetStrength();

		for (int i = 0; i < 16; i++)
		{
			for (int j = 1; j >= -1; j -= 2)
			{
				double ang = angle + j*i*(45. / 16);
				double slope = AimLineAttack(ang, 2 * DEFMELEERANGE, t, 0., ALF_CHECK3D);
				if (t.linetarget)
				{
					LineAttack(ang, 2 * DEFMELEERANGE, slope, damage, 'Melee', "HammerPuff", true, t);
					if (t.linetarget != null)
					{
						AdjustPlayerAngle(t);

						//Cast Smite
						A_CastSmite(t.linetarget);

						return;
					}
				}
			}
		}
		// didn't find any creatures, so try to strike any walls
		weaponspecial = 0;

		double slope = AimLineAttack (angle, DEFMELEERANGE, null, 0., ALF_CHECK3D);
		LineAttack (angle, DEFMELEERANGE, slope, damage, 'Melee', "HammerPuff");
	}
	

	action void A_CMaceSwingAttack(bool isMainSwing, bool isSmite, int angleMod = 0)
	{
		FTranslatedLineTarget t;

		if (!player)
			return;

		int damage = random[CWeapMaceSwing](1, 16);

        let xrpgPlayer = XRpgPlayer(player.mo);
		if (!xrpgPlayer)
			return;

		class<Actor> puffType = "SmallMacePuffSilent";
		if (isMainSwing)
			puffType = "SmallMacePuff";

		if (isSmite)
		{
			damage += (xrpgPlayer.GetMagic() * 0.5);
			puffType = "SmallMacePuffGlowSilent";
			if (isMainSwing)
				puffType = "SmallMacePuffGlow";
		}
		else
		{
			damage += (xrpgPlayer.GetStrength() * 0.5);
		}

		for (int i = 0; i < 16; i++)
		{
			for (int j = 1; j >= -1; j -= 2)
			{
				double ang = angle + angleMod + j*i*(45. / 16);
				double slope = AimLineAttack(ang, 2 * DEFMELEERANGE, t, 0., ALF_CHECK3D);
				if (t.linetarget)
				{
					LineAttack(ang, 2 * DEFMELEERANGE, slope, damage, 'Melee', puffType, true, t);
					if (t.linetarget != null)
					{
						if (t.linetarget.bIsMonster || t.linetarget.player)
						{

							if (isSmite)
							{

								AdjustPlayerAngle(t);

								Thrust(1, t.attackAngleFromSource);
							}
							else
							{
								A_ThrustTarget(t.linetarget, 1, t.attackAngleFromSource);
							}
						}

						return;
					}
				}
			}
		}

		double slope = AimLineAttack (angle + angleMod, DEFMELEERANGE, null, 0., ALF_CHECK3D);
		LineAttack (angle + angleMod, DEFMELEERANGE, slope, damage, 'Melee', puffType);
	}

	action void A_CastSmite(Actor lineTarget)
	{
		if (!A_IsSmite())
			return;

		A_FireVerticalMissilePos("SmiteningMissile", lineTarget.Pos.X, lineTarget.Pos.Y, lineTarget.Pos.Z, -90, false);
	}
}

class SmiteningMissileSmoke : Actor
{
	Default
	{
		Height 16;
	    +NOBLOCKMAP +NOGRAVITY +SHADOW
	    +NOTELEPORT +CANNOTPUSH +NODAMAGETHRUST
		XScale 0.5;
		YScale 0.75;
	}
	States
	{
	Spawn:
		MLFX L 12;
		Stop;
	Spawn2:
		MLFX I 12;
		Stop;
	Spawn3:
		MLFX J 12;
		Stop;
	Spawn4:
		MLFX K 12;
		Stop;
	Spawn5:
		MLFX M 12;
		Stop;
	}

	override void PostBeginPlay()
	{
		A_SpriteOffset(0, -48);

		int frameNum = random(1,5);
		if (frameNum == 2)
			SetStateLabel("Spawn2");
		if (frameNum == 3)
			SetStateLabel("Spawn3");
		if (frameNum == 4)
			SetStateLabel("Spawn4");
		if (frameNum == 5)
			SetStateLabel("Spawn5");
    }

}
class SmiteningMissile : FastProjectile
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
        Obituary "$OB_MPCWEAPMACE";
		DamageType "Fire";

		Health 0;
    }
    States
    {
    Spawn:
        MLFX K 2 Bright;
		Loop;
    Death:
        MLFX M 2 Bright A_SmiteningExplode;
		MLFX E 0 A_ResizeSmiteningBlast;
		MLFX EFG 4;
        Stop;
    }

	action void A_SmiteningExplode()
	{
		int damage = 20;
		int range = 90;

		let xrpgPlayer = XRpgPlayer(target);
		if (xrpgPlayer != null)
		{
			damage = xrpgPlayer.GetDamageForMagic(damage);
			range += xrpgPlayer.GetMagic();
		}
		
		A_Explode(damage, range, 0, false, 0, 0, 10, "BulletPuff", 'Holy');
	}

	action void A_ResizeSmiteningBlast()
	{
		A_SetScale(0.5, 0.75);
	}
}

class SmallMacePuffSilent : Actor
{
	Default
	{
		+NOBLOCKMAP +NOGRAVITY
		+PUFFONACTORS
		RenderStyle "Translucent";
		Alpha 0.6;
		AttackSound "FighterHammerHitWall";
		SeeSound "FighterAxeHitThing";
		VSpeed 1;
	}
	States
	{
	Spawn:
		FHFX STUVW 4;
		Stop;
	}
}

class SmallMacePuff : SmallMacePuffSilent
{
	Default
	{
		AttackSound "FighterHammerHitWall";
		SeeSound "FighterHammerMiss";
		ActiveSound "FighterHammerMiss";
	}
}

class SmallMacePuffGlowSilent : Actor
{
	Default
	{
		+NOBLOCKMAP +NOGRAVITY
		+PUFFONACTORS
		+ZDOOMTRANS
		+PUFFONACTORS
		RenderStyle "Translucent";
		Alpha 0.6;
		AttackSound "MageLightningZap";
		ActiveSound "MageLightningZap";
		Scale 0.5;
	}
	States
	{
	Spawn:
		FAXE RSTUVWX 4 Bright;
		Stop;
	}
}
class SmallMacePuffGlow : SmallMacePuffGlowSilent
{
	Default
	{
		SeeSound "MageLightningContinuous";
	}
}