// Cleric Weapon Piece ------------------------------------------------------

class XRpgClericWeaponPiece : WeaponPiece replaces ClericWeaponPiece
{
	Default
	{
		Inventory.PickupSound "misc/w_pkup";
		Inventory.PickupMessage "$TXT_WRAITHVERGE_PIECE";
		Inventory.ForbiddenTo "FighterPlayer", "MagePlayer";
		WeaponPiece.Weapon "XRpgCWeapWraithverge";
		+FLOATBOB
	}
}

// Cleric Weapon Piece 1 ----------------------------------------------------

class XRpgCWeaponPiece1 : XRpgClericWeaponPiece replaces CWeaponPiece1
{
	Default
	{
		WeaponPiece.Number 1;
	}
	States
	{
	Spawn:
		WCH1 A -1;
		Stop;
	}
}

// Cleric Weapon Piece 2 ----------------------------------------------------

class XRpgCWeaponPiece2 : XRpgClericWeaponPiece replaces CWeaponPiece2
{
	Default
	{
		WeaponPiece.Number 2;
	}
	States
	{
	Spawn:
		WCH2 A -1;
		Stop;
	}
}

// Cleric Weapon Piece 3 ----------------------------------------------------

class XRpgCWeaponPiece3 : XRpgClericWeaponPiece replaces CWeaponPiece3
{
	Default
	{
		WeaponPiece.Number 3;
	}
	States
	{
	Spawn:
		WCH3 A -1;
		Stop;
	}
}

// Wraithverge Drop ---------------------------------------------------------

class XRpgWraithvergeDrop : Actor replaces WraithvergeDrop
{
	States
	{
	Spawn:
		TNT1 A 1;
		TNT1 A 1 A_DropWeaponPieces("CWeaponPiece1", "CWeaponPiece2", "CWeaponPiece3");
		Stop;
	}
}

// Cleric's Wraithverge (Holy Symbol?) --------------------------------------

class XRpgCWeapWraithverge : XRpgClericWeapon replaces CWeapWraithverge
{
	int CHolyCount;
	
	Default
	{
		Health 3;
		Weapon.SelectionOrder 3000;
		+WEAPON.PRIMARY_USES_BOTH;
		+Inventory.NoAttenPickupSound
		Weapon.AmmoUse1 18;
		Weapon.AmmoUse2 18;
		Weapon.AmmoGive1 20;
		Weapon.AmmoGive2 20;
		Weapon.KickBack 150;
		Weapon.AmmoType1 "Mana1";
		Weapon.AmmoType2 "Mana2";		
		Inventory.PickupMessage "$TXT_WEAPON_C4";
		Tag "$TAG_CWEAPWRAITHVERGE";
		Inventory.PickupSound "WeaponBuild";

		+WEAPON.AMMO_OPTIONAL
		+WEAPON.ALT_AMMO_OPTIONAL
	}


	States
	{
	Spawn:
		TNT1 A -1;
		Stop;
	Ready:
		CHLY A 1 A_WeaponReady;
		Loop;
	Select:
		CHLY A 1 A_Raise;
		Loop;
	Deselect:
		CHLY A 1 A_Lower;
		Loop;
	Fire:
		CHLY A 1 Bright Offset (0, 40) A_CheckAmmo;
		CHLY B 1 Bright Offset (0, 40);
		CHLY CD 2 Bright Offset (0, 43);
		CHLY E 2 Bright Offset (0, 45);
		CHLY F 6 Bright Offset (0, 48) A_CHolyAttack;
		CHLY GG 2 Bright Offset (0, 40) A_CHolyPalette;
		CHLY G 2 Offset (0, 36) A_CHolyPalette;
		Goto Ready;
	AltFire:
		CHLY AB 1 Bright Offset (0, 40);
		CHLY CD 2 Bright Offset (0, 43);
		CHLY E 2 Bright Offset (0, 45);
		CHLY F 6 Bright Offset (0, 48) A_GhostarangAttack;
		CHLY GG 2 Bright Offset (0, 40) A_CHolyPalette;
		CHLY G 8 Offset (0, 36);
		Goto Ready;
	}

	override color GetBlend ()
	{
		if (paletteflash & PF_HEXENWEAPONS)
		{
			if (CHolyCount == 3)
				return Color(128, 70, 70, 70);
			else if (CHolyCount == 2)
				return Color(128, 100, 100, 100);
			else if (CHolyCount == 1)
				return Color(128, 130, 130, 130);
			else
				return Color(0, 0, 0, 0);
		}
		else
		{
			return Color(CHolyCount * 128 / 3, 131, 131, 131);
		}
	}

	action void A_CheckAmmo()
	{
		// Don't spawn a hammer if the player doesn't have enough mana
		if (player.ReadyWeapon == null ||
			!player.ReadyWeapon.CheckAmmo (player.ReadyWeapon.bAltFire ?
				Weapon.AltFire : Weapon.PrimaryFire, false, true))
				A_SetWeapState("AltFire");
		
	}
	//============================================================================
	//
	// A_CHolyAttack
	//
	//============================================================================

	action void A_CHolyAttack()
	{
		FTranslatedLineTarget t;

		if (player == null)
		{
			return;
		}
		Weapon weapon = player.ReadyWeapon;
		if (weapon != null)
		{
			if (!weapon.DepleteAmmo (weapon.bAltFire, false))
				return;
		}
		Actor missile = SpawnPlayerMissile ("HolyMissile2", angle, pLineTarget:t);
		if (missile != null && !t.unlinked)
		{
			missile.tracer = t.linetarget;
		}

		if (A_IsSmite())
		{
			Actor(SpawnPlayerMissile ("GhostarangMissile", angle));
			Actor(SpawnPlayerMissile ("GhostarangMissile", angle - 6));
			Actor(SpawnPlayerMissile ("GhostarangMissile", angle + 6));
		}

		invoker.CHolyCount = 3;
		A_StartSound ("HolySymbolFire", CHAN_WEAPON);
	}

	//============================================================================
	//
	// A_CHolyPalette
	//
	//============================================================================

	action void A_CHolyPalette()
	{
		if (invoker.CHolyCount > 0) invoker.CHolyCount--;
	}

	action void A_GhostarangAttack()
	{
		if (player == null)
		{
			return;
		}
		
		SpawnPlayerMissile ("GhostarangMissile", angle);
			
		if (A_IsSmite())
		{
			Actor(SpawnPlayerMissile ("GhostarangMissile", angle - 6));
			Actor(SpawnPlayerMissile ("GhostarangMissile", angle + 6));
		}

		A_StartSound ("HolySymbolFire", CHAN_WEAPON);
	}
}

const GHOSTARANG_HEALTH_MAX = 8;
const GHOSTARANG_HEALTH_STOP = 6;
const GHOSTARANG_TARGETZ_OFFSET = 15;
const GHOSTARANG_SPEED = 80;

class GhostarangMissile : Actor
{
	Default
	{
		Radius 10;
		Height 6;
		Speed GHOSTARANG_SPEED;
		Damage 8;
		Health GHOSTARANG_HEALTH_MAX;
		Projectile;
		+RIPPER
		+ZDOOMTRANS
		Obituary "$OB_MPCWEAPWRAITHVERGE";
		Scale 1.5;
		+BOUNCEONFLOORS
		+BOUNCEONCEILINGS
		+USEBOUNCESTATE
		+BOUNCEONWALLS
		+CANBOUNCEWATER

		DamageType "Holy";

		RenderStyle "Translucent";
		Alpha 0.6;
	}

	States
	{
	Spawn:
		SPIR AB 4 A_MoveGhostarang(0);
		Loop;
	Bounce:
		SPIR A 1 A_GhostarangImpact;
		Goto Spawn;
	Death:
		SPIR A 1;
		Goto Spawn;
	EndGhost:
		SPIR EFGHI 4;
		Stop;
	}
	
	//Bounce
	void A_GhostarangImpact()
	{
		//A_StartSound ("weapons/macebounce", CHAN_BODY);
		A_SetSpeed(0);
		A_ChangeVelocity(0,0,0, CVF_REPLACE);
	}
	
	override void Die(Actor source, Actor inflictor, int dmgflags, Name MeansOfDeath)
	{
		A_GhostarangImpact();
	}
	
	action void A_MoveGhostarang(int powered)
	{
		if (target == null || target.health <= 0)
		{ // Shooter is dead or nonexistent
			SetStateLabel("EndGhost");
			return;
		}
		
		Health--;
		if (Health < 1)
		{
			SetStateLabel("EndGhost");
			return;
		}
		
		let targetZ = target.Pos.Z + GHOSTARANG_TARGETZ_OFFSET;

		if (Health <= GHOSTARANG_HEALTH_STOP)
		{
			A_SetSpeed(0);
			A_ChangeVelocity(0,0,0, CVF_REPLACE);
		}
	}
}

class HolyMissile2 : Actor
{
	Default
	{
		Speed 30;
		Radius 15;
		Height 8;
		Damage 4;
		Projectile;
		-ACTIVATEIMPACT -ACTIVATEPCROSS
		+EXTREMEDEATH

		DamageType "Holy";
	}

	States
	{
	Spawn:
		SPIR PPPP 3 Bright A_SpawnItemEx("HolyMissilePuff");
	Death:
		SPIR P 1 Bright A_CHolyAttack2;
		Stop;
	}
	
	//============================================================================
	//
	// A_CHolyAttack2 
	//
	// 	Spawns the spirits
	//============================================================================

	void A_CHolyAttack2()
	{
		for (int j = 0; j < 4; j++)
		{
			Actor mo = Spawn("HolySpirit2", Pos, ALLOW_REPLACE);
			if (!mo)
			{
				continue;
			}
			switch (j)
			{ // float bob index

				case 0:
					mo.WeaveIndexZ = random[HolyAtk2](0, 7); // upper-left
					break;
				case 1:
					mo.WeaveIndexZ = random[HolyAtk2](32, 39); // upper-right
					break;
				case 2:
					mo.WeaveIndexXY = random[HolyAtk2](32, 39); // lower-left
					break;
				case 3:
					mo.WeaveIndexXY = random[HolyAtk2](32, 39);
					mo.WeaveIndexZ = random[HolyAtk2](32, 39);
					break;
			}
			mo.SetZ(pos.z);
			mo.angle = angle + 67.5 - 45.*j;
			mo.Thrust();
			mo.target = target;
			mo.args[0] = 10; // initial turn value
			mo.args[1] = 0; // initial look angle
			if (deathmatch)
			{ // Ghosts last slightly less longer in DeathMatch
				mo.health = 85;
			}
			if (tracer)
			{
				mo.tracer = tracer;
				mo.bNoClip = true;
				mo.bSkullFly = true;
				mo.bMissile = false;
			}
			HolyTail.SpawnSpiritTail (mo);
		}
	}
}

// Holy Spirit --------------------------------------------------------------

class HolySpirit2 : HolySpirit
{
	Default
	{
		DamageType "Holy";
	}
}
