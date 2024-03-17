// The Cleric's Mace --------------------------------------------------------
const FLAIL_MELEE_RANGE = DEFMELEERANGE * 2.25;
class XRpgCWeapFlail : XRpgClericShieldWeapon
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
        +WEAPON.AMMO_OPTIONAL +WEAPON.MELEEWEAPON
	}

	States
	{
    Spawn:
		WMST A -1;
		Stop;
	Select:
	WeaponSelect:
		CFLA A 1 A_Raise;
		Loop;
	Deselect:
	WeaponDeselect:
		CFLA A 1 A_Lower;
		Loop;
	Ready:
	WeaponReady:
		CFLA A 1 A_WeaponReady;
		Loop;
	Fire:
	WeaponFire:
		CFLA A 2;
        CFLA D 4;
        CFLA E 3;
        CFLA F 3 A_CFlailAttack;
        CFLA G 3;
        TNT1 A 10;
        TNT1 A 8 A_ReFire;
		Goto Ready;
	AltFire:
		Goto ShieldFrameAltFire;
    AltHold:
		Goto ShieldFrameAltHold;
	ShieldKiteFire:
		Goto ShieldFrameShieldKiteFire;
	ShieldKiteHold:
		Goto ShieldFrameShieldKiteHold;
	ShieldRoundFire:
		Goto ShieldFrameShieldRoundFire;
	ShieldRoundHold:
		Goto ShieldFrameShieldRoundHold;
	ShieldMetalFire:
		Goto ShieldFrameShieldMetalFire;
	ShieldMetalHold:
		Goto ShieldFrameShieldMetalHold;
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
            damage += xrpgPlayer.GetMagic();
        }

		for (int i = 0; i < 16; i++)
		{
			for (int j = 1; j >= -1; j -= 2)
			{
				double ang = angle + j*i*(45. / 16);
				double slope = AimLineAttack(ang, FLAIL_MELEE_RANGE, t, 0., ALF_CHECK3D);
				if (t.linetarget)
				{
					let puffObj = LineAttack(ang, FLAIL_MELEE_RANGE, slope, damage, 'Melee', puffType, true, t);
					if (t.linetarget != null)
					{
						AdjustPlayerAngle(t);

                        if (isSmite)
                        {
                            Vector3 dir = (AngleToVector(t.angleFromSource, cos(slope)), -sin(slope));
                            let hitBackoffPos = puffObj.Pos - (dir * FLAIL_ICE_OFFSET_DIST);
                            A_IceSpellMissileExplode(hitBackoffPos);
                        }

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
    const FLAIL_ICE_OFFSET_ACTORDIST = 16;
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
}

class SmallFlailIceSilent : Actor
{
	Default
	{
		+NOBLOCKMAP +NOGRAVITY
		+PUFFONACTORS
		+ZDOOMTRANS
		+PUFFONACTORS
		+ICESHATTER
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
		Damage 1;
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