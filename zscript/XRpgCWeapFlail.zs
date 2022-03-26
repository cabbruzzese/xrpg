// The Cleric's Mace --------------------------------------------------------
const FLAIL_MELEE_RANGE = DEFMELEERANGE * 2.25;
class XRpgCWeapFlail : XRpgClericWeapon
{
	Default
	{
		Weapon.SelectionOrder 3500;
		Weapon.KickBack 150;
		+BLOODSPLATTER
		Inventory.PickupMessage "$TXT_WEAPON_FLAIL";
		Obituary "$OB_CWEAPFLAIL";
		Tag "$TAG_CWEAPFLAIL";
        Inventory.MaxAmount 1;
        +WEAPON.AMMO_OPTIONAL
	}

	States
	{
    Spawn:
		WMST A -1;
		Stop;
	Select:
		CFLA A 1 A_Raise;
		Loop;
	Deselect:
		CFLA A 1 A_Lower;
		Loop;
	Ready:
		CFLA A 1 A_WeaponReady;
		Loop;
	Fire:
		CFLA A 2;
        CFLA D 4;
        CFLA E 3;
        CFLA F 3 A_CFlailAttack;
        CFLA G 3;
        TNT1 A 10;
        TNT1 A 8 A_ReFire;
		Goto Ready;
	AltFire:
        CFLA B 4;
        CFLA C 3 A_CFlailSwingAttack(true, 25);
        CFLA H 3 A_CFlailSwingAttack(false, 0);
        CFLA I 3 A_CFlailSwingAttack(false, -25);
        CFLA J 6;
        TNT1 A 12;
        TNT1 A 6 A_ReFire;
		Goto Ready;
	}

	action void A_CFlailAttack()
	{
		FTranslatedLineTarget t;

		if (!player)
			return;

		int damage = random[CWeapFlail](30, 90);

        let xrpgPlayer = XRpgPlayer(player.mo);
		if (xrpgPlayer != null)
			damage += xrpgPlayer.GetStrength() * 1.5;
    
        bool isSmite = A_IsSmite();

        Class<Actor> puffType = "HammerPuff";
        if (isSmite)
        {
            puffType = "SmallFlailIce";
            damage += xrpgPlayer.GetMagic() * 2;
        }

		for (int i = 0; i < 16; i++)
		{
			for (int j = 1; j >= -1; j -= 2)
			{
				double ang = angle + j*i*(45. / 16);
				double slope = AimLineAttack(ang, FLAIL_MELEE_RANGE, t, 0., ALF_CHECK3D);
				if (t.linetarget)
				{
					LineAttack(ang, FLAIL_MELEE_RANGE, slope, damage, 'Melee', puffType, true, t);
					if (t.linetarget != null)
					{
						AdjustPlayerAngle(t);

						return;
					}
				}
			}
		}
		// didn't find any creatures, so try to strike any walls
		weaponspecial = 0;

		double slope = AimLineAttack (angle, FLAIL_MELEE_RANGE, null, 0., ALF_CHECK3D);
        bool miss = !(LineAttack (angle, FLAIL_MELEE_RANGE, slope, damage, 'Melee', puffType, true));

		FLineTraceData RemoteRay;
		bool hit = LineTrace (angle, FLAIL_MELEE_RANGE, slope, TRF_THRUACTORS, 32, 0, 0, RemoteRay);
		if (hit && isSmite)
        {
            let hitBackoffPos = RemoteRay.HitLocation - (RemoteRay.HitDir * FLAIL_ICE_OFFSET_DIST);
            A_IceSpellMissileExplode(hitBackoffPos);
        }
            
	}

    const FLAIL_ICE_OFFSET_Z = 9;
    const FLAIL_ICE_OFFSET_DIST = 5;
    action void A_IceSpellMissileExplode(Vector3 targetPos)
	{
        if (!player || !player.mo)
			return;
        
		for (int i = 0; i < 32; i++)
		{
			Actor mo = player.mo.SpawnMissileAngleZ (targetPos.z+FLAIL_ICE_OFFSET_Z, "FlailIceMissile", i*11.25, -0.3);
			if (mo)
			{
                mo.SetOrigin(targetPos + (0,0,FLAIL_ICE_OFFSET_Z), false);
				mo.target = player.mo;
			}
		}
	}
	
	action void A_CFlailSwingAttack(bool isMainSwing, int angleMod = 0)
	{
		FTranslatedLineTarget t;

		if (!player)
			return;

		int damage = random[CWeapFlailSwing](15, 35);

        let xrpgPlayer = XRpgPlayer(player.mo);
		if (!xrpgPlayer)
			return;

        bool isSmite = A_IsSmite();

		class<Actor> puffType = "SmallMacePuffSilent";
		if (isMainSwing)
			puffType = "SmallMacePuff";
        
        damage += (xrpgPlayer.GetStrength() * 0.5);
        if (isSmite)
        {
            damage += xrpgPlayer.GetMagic() * 1.5;
            puffType = "SmallFlailIceSilent";
            if (isMainSwing)
			    puffType = "SmallFlailIce";
        }

		for (int i = 0; i < 16; i++)
		{
			for (int j = 1; j >= -1; j -= 2)
			{
				double ang = angle + angleMod + j*i*(45. / 16);
				double slope = AimLineAttack(ang, FLAIL_MELEE_RANGE, t, 0., ALF_CHECK3D);
				if (t.linetarget)
				{
					LineAttack(ang, FLAIL_MELEE_RANGE, slope, damage, 'Melee', puffType, true, t);
					if (t.linetarget != null)
					{
						if (t.linetarget.bIsMonster || t.linetarget.player)
						{
                            AdjustPlayerAngle(t);
                            A_ThrustTarget(t.linetarget, 4, t.attackAngleFromSource);
						}

						return;
					}
				}
			}
		}

		double slope = AimLineAttack (angle + angleMod, FLAIL_MELEE_RANGE, null, 0., ALF_CHECK3D);
		LineAttack (angle + angleMod, FLAIL_MELEE_RANGE, slope, damage, 'Melee', puffType);
	}
}

class SmallFlailIceSilent : Actor
{
	Default
	{
		+NOBLOCKMAP +NOGRAVITY
		+PUFFONACTORS
		+ZDOOMTRANS
		+PUFFONACTORS
		RenderStyle "Translucent";
		Alpha 0.25;
		AttackSound "MageShardsExplode";
		SeeSound "MageShardsExplode";
        DamageType "Ice";
	}
	States
	{
	Spawn:
		ICPR DEFGH 4 Bright;
		Stop;
	}
}
class SmallFlailIce : SmallFlailIceSilent
{
	Default
	{
		ActiveSound "FighterHammerMiss";
	}
}

class FlailIceMissile : Actor
{
	Default
	{
		Speed 10;
		Radius 4;
		Height 4;
		Damage 3;
		DamageType "Ice";
		Gravity 0.125;
        Projectile;
		+NOBLOCKMAP +DROPOFF +MISSILE
		+NOTELEPORT
		+STRIFEDAMAGE
        Obituary "$OB_CWEAPFLAIL";
	}
	States
	{
	Spawn:
		ICPR NOP 3 Bright;
		Loop;
	}
}