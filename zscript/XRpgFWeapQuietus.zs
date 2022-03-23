// Fighter Weapon Piece -----------------------------------------------------

class XRpgFighterWeaponPiece : WeaponPiece replaces FighterWeaponPiece
{
	Default
	{
		Inventory.PickupSound "misc/w_pkup";
		Inventory.PickupMessage "$TXT_QUIETUS_PIECE";
		Inventory.ForbiddenTo "XRpgClericPlayer", "XRpgMagePlayer";
		WeaponPiece.Weapon "XRpgFWeapQuietus";
		+FLOATBOB
	}
}

// Fighter Weapon Piece 1 ---------------------------------------------------

class XRpgFWeaponPiece1 : XRpgFighterWeaponPiece replaces FWeaponPiece1
{
	Default
	{
		WeaponPiece.Number 1;
	}
	States
	{
	Spawn:
		WFR1 A -1 Bright;
		Stop;
	}
}

// Fighter Weapon Piece 2 ---------------------------------------------------

class XRpgFWeaponPiece2 : XRpgFighterWeaponPiece replaces FWeaponPiece2
{
	Default
	{
		WeaponPiece.Number 2;
	}
	States
	{
	Spawn:
		WFR2 A -1 Bright;
		Stop;
	}
}

// Fighter Weapon Piece 3 ---------------------------------------------------

class XRpgFWeaponPiece3 : XRpgFighterWeaponPiece replaces FWeaponPiece3
{
	Default
	{
		WeaponPiece.Number 3;
	}
	States
	{
	Spawn:
		WFR3 A -1 Bright;
		Stop;
	}
}

// Quietus Drop -------------------------------------------------------------

class XRpgQuietusDrop : Actor replaces QuietusDrop
{
	States
	{
	Spawn:
		TNT1 A 1;
		TNT1 A 1 A_DropWeaponPieces("XRpgFWeaponPiece1", "XRpgFWeaponPiece2", "XRpgFWeaponPiece3");
		Stop;
	}
}

// The Fighter's Sword (Quietus) --------------------------------------------
const SWORD_RANGE = 2 * DEFMELEERANGE;
const SWORD_CHARGE_MAX = 20;
class XRpgFWeapQuietus : XRpgFighterWeapon replaces FWeapQuietus
{
	Default
	{
		Health 3;
		Weapon.SelectionOrder 2900;
		+WEAPON.PRIMARY_USES_BOTH;
		+WEAPON.NOAUTOAIM; //Slash and step mover projectiles do not need aim assist
		+Inventory.NoAttenPickupSound
		Weapon.AmmoUse1 14;
		Weapon.AmmoUse2 14;
		Weapon.AmmoGive1 20;
		Weapon.AmmoGive2 20;
		Weapon.KickBack 150;
		Weapon.YAdjust 10;
		Weapon.AmmoType1 "Mana1";
		Weapon.AmmoType2 "Mana2";
		Inventory.PickupMessage "$TXT_WEAPON_F4";
		Inventory.PickupSound "WeaponBuild";
		Tag "$TAG_FWEAPQUIETUS";

		+WEAPON.AMMO_OPTIONAL
		+WEAPON.ALT_AMMO_OPTIONAL

		XRpgWeapon.MaxCharge SWORD_CHARGE_MAX;

		XRpgFighterWeapon.Pufftype "NormalSwordPuff";
        XRpgFighterWeapon.MeleePush 8;
        XRpgFighterWeapon.MeleeAdjust false;
		XRpgFighterWeapon.WeaponRange SWORD_RANGE;
	}

	States
	{
	Spawn:
		TNT1 A -1;
		Stop;
	Select:
		//FSRD A 1 Bright A_Raise;
		FSRN A 1 A_Raise;
		Loop;
	Deselect:
		//FSRD A 1 Bright A_Lower;
		FSRN A 1 A_Lower;
		Loop;
	Ready:
		//FSRD AAAABBBBCCCC 1 Bright A_FSwordWeaponReady;
		FSRN A 1 A_FSwordWeaponReady;
		Loop;
	Fire:
	Cut:
	Hold:
		FSRN D 4 Offset (-50, 0) A_ChargeUp;
		FSRN D 4 Offset (-50, 0) A_Refire;
		FSRN D 1 Offset (-100, 0);
		FSRN D 1 Offset (-125, 0);
		FSRN J 2 Offset (1, 0);
		FSRN J 2 Offset (-5, 30);
		FSRN J 2 Offset (-10, 60) A_FSwordCut();
		FSRN J 1 Offset (-15, 90);
		FSRN J 1 Offset (-20, 120);
		FSRN J 1 Offset (-25, 150);
		FSRN J 1 Offset (-30, 180);
		FSRN A 8 Offset (0, 60);
		Goto Ready;
	AltFire:
	PowerCut:
	AltHold:
		FSRT D 4 Bright Offset (-50, 0) A_ChargeUp;
		FSRT D 4 Bright Offset (-50, 0) A_Refire;
		FSRT D 1 Bright Offset (-100, 0);
		FSRT D 1 Bright Offset (-125, 0);
		FSRT J 2 Bright Offset (1, 0);
		FSRT J 2 Bright Offset (-5, 30);
		FSRT J 2 Bright Offset (-10, 60) A_FSwordPowerCut();
		FSRT J 1 Bright Offset (-15, 90);
		FSRT J 1 Bright Offset (-20, 120);
		FSRT J 1 Bright Offset (-25, 150);
		FSRT J 1 Bright Offset (-30, 180);
		FSRD A 8 Offset (0, 60);
		Goto Ready;
	RightSwing:
		FSRN D 3 Bright Offset (5, 36);
		FSRN E 3 Offset (5, 36);
		FSRN F 2 Offset (5, 36) A_FWeaponMelee(1, 40, -15);
		FSRN G 3 Offset (5, 36) A_FWeaponMeleePuff(1, 40, 0, 1.0, 0.0, "NormalSwordPuffSilent");
		FSRN H 2 Offset (5, 36) A_FWeaponMeleePuff(1, 40, 15, 1.0, 0.0, "NormalSwordPuffSilent");
		TNT1 A 2 Offset (5, 36);
		TNT1 A 10 Offset (5, 150);
		FSRN A 1 Offset (5, 60);
		FSRN A 1 Offset (5, 55);
		FSRN A 1 Offset (5, 50);
		FSRN A 1 Offset (5, 45);
		FSRN A 1 Offset (5, 40);
		Goto Ready;
	LeftSwing:
		FSRN D 3 Offset (5, 36) A_Mirror;
		FSRN E 3 Offset (5, 36);
		FSRN F 2 Offset (5, 36) A_FWeaponMelee(1, 40, 15);
		FSRN G 3 Offset (5, 36) A_FWeaponMeleePuff(1, 40, 0, 1.0, 0.0, "NormalSwordPuffSilent");
		FSRN H 2 Offset (5, 36) A_FWeaponMeleePuff(1, 40, -15, 1.0, 0.0, "NormalSwordPuffSilent");
		TNT1 A 2 Offset (5, 36);
		TNT1 A 10 Offset (5, 150);
		FSRN A 1 Offset (5, 60) A_RestoreMirror;
		FSRN A 1 Offset (5, 55);
		FSRN A 1 Offset (5, 50);
		FSRN A 1 Offset (5, 45);
		FSRN A 1 Offset (5, 40);
		Goto Ready;
	PowerRightSwing:
		FSRT D 3 Bright Offset (5, 36);
		FSRT E 3 Bright Offset (5, 36);
		FSRD F 2 Bright Offset (5, 36);
		FSRD G 3 Bright Offset (5, 36) A_FSwordAttack();
		FSRD H 2 Bright Offset (5, 36);
		FSRD I 2 Bright Offset (5, 36);
		FSRD I 10 Bright Offset (5, 150);
		FSRD A 1 Bright Offset (5, 60);
		FSRD B 1 Bright Offset (5, 55);
		FSRD C 1 Bright Offset (5, 50);
		FSRD A 1 Bright Offset (5, 45);
		FSRD B 1 Bright Offset (5, 40);
		Goto Ready;
	PowerLeftSwing:
		FSRT D 3 Bright Offset (5, 36) A_Mirror;
		FSRT E 3 Bright Offset (5, 36);
		FSRD F 2 Bright Offset (5, 36);
		FSRD G 3 Bright Offset (5, 36) A_FSwordAttack(true);
		FSRD H 2 Bright Offset (5, 36);
		FSRD I 2 Bright Offset (5, 36);
		FSRD I 10 Bright Offset (5, 150);
		FSRD A 1 Bright Offset (5, 60) A_RestoreMirror;
		FSRD B 1 Bright Offset (5, 55);
		FSRD C 1 Bright Offset (5, 50);
		FSRD A 1 Bright Offset (5, 45);
		FSRD B 1 Bright Offset (5, 40);
		Goto Ready;
	BerserkRightSwing:
		FSRN D 2 Bright Offset (5, 36);
		FSRN E 2 Offset (5, 36);
		FSRN F 2 Offset (5, 36) A_FWeaponMelee(1, 40, -15);
		FSRN G 2 Offset (5, 36) A_FWeaponMeleePuff(1, 40, 0, 1.0, 0.0, "NormalSwordPuffSilent");
		FSRN H 2 Offset (5, 36) A_FWeaponMeleePuff(1, 40, 15, 1.0, 0.0, "NormalSwordPuffSilent");
		TNT1 A 2 Offset (5, 36);
		TNT1 A 6 Offset (5, 150);
		FSRN A 1 Offset (5, 60);
		FSRN A 1 Offset (5, 55);
		FSRN A 1 Offset (5, 50);
		FSRN A 1 Offset (5, 45);
		FSRN A 1 Offset (5, 40);
		Goto Ready;
	BerserkLeftSwing:
		FSRN D 2 Offset (5, 36) A_Mirror;
		FSRN E 2 Offset (5, 36);
		FSRN F 2 Offset (5, 36) A_FWeaponMelee(1, 40, 15);
		FSRN G 2 Offset (5, 36) A_FWeaponMeleePuff(1, 40, 0, 1.0, 0.0, "NormalSwordPuffSilent");
		FSRN H 2 Offset (5, 36) A_FWeaponMeleePuff(1, 40, -15, 1.0, 0.0, "NormalSwordPuffSilent");
		TNT1 A 2 Offset (5, 36);
		TNT1 A 6 Offset (5, 150);
		FSRN A 1 Offset (5, 60) A_RestoreMirror;
		FSRN A 1 Offset (5, 55);
		FSRN A 1 Offset (5, 50);
		FSRN A 1 Offset (5, 45);
		FSRN A 1 Offset (5, 40);
		Goto Ready;
	BerserkPowerRightSwing:
		FSRT D 2 Bright Offset (5, 36);
		FSRT E 2 Bright Offset (5, 36);
		FSRD F 2 Bright Offset (5, 36);
		FSRD G 2 Bright Offset (5, 36) A_FSwordAttack();
		FSRD H 2 Bright Offset (5, 36);
		FSRD I 2 Bright Offset (5, 36);
		FSRD I 6 Bright Offset (5, 150);
		FSRD A 1 Bright Offset (5, 60);
		FSRD B 1 Bright Offset (5, 55);
		FSRD C 1 Bright Offset (5, 50);
		FSRD A 1 Bright Offset (5, 45);
		FSRD B 1 Bright Offset (5, 40);
		Goto Ready;
	BerserkPowerLeftSwing:
		FSRT D 2 Bright Offset (5, 36) A_Mirror;
		FSRT E 2 Bright Offset (5, 36);
		FSRD F 2 Bright Offset (5, 36);
		FSRD G 2 Bright Offset (5, 36) A_FSwordAttack(true);
		FSRD H 2 Bright Offset (5, 36);
		FSRD I 2 Bright Offset (5, 36);
		FSRD I 6 Bright Offset (5, 150);
		FSRD A 1 Bright Offset (5, 60) A_RestoreMirror;
		FSRD B 1 Bright Offset (5, 55);
		FSRD C 1 Bright Offset (5, 50);
		FSRD A 1 Bright Offset (5, 45);
		FSRD B 1 Bright Offset (5, 40);
		Goto Ready;
	}

	override State GetAtkState (bool hold)
	{
		if (!Owner || !Owner.player || !Owner.player.mo)
			return FindState("Cut");
		
		let xrpgPlayer = XRpgPlayer(Owner.player.mo);
		if (!xrpgPlayer)
			return FindState("Cut");

		if (hold && ChargeValue > 0)
			return FindState("Hold");

		let sideMove = xrpgPlayer.GetPlayerInput(INPUT_SIDEMOVE);
		let rightMove = sideMove > 0;
		let leftMove = sideMove < 0;
		
		bool isBerserk = xrpgPlayer.IsSpellActive(SPELLTYPE_FIGHTER_BERSERK, true);
		
		if (rightMove)
			return isBerserk ? FindState ("BerserkRightSwing") : FindState ("RightSwing");
		else if (leftMove)
			return isBerserk ? FindState ("BerserkLeftSwing") : FindState ("LeftSwing");

		return Super.GetAtkState(hold);
	}
	override State GetAltAtkState (bool hold)
	{
		if (!Owner || !Owner.player || !Owner.player.mo)
			return FindState("PowerCut");
		
		let xrpgPlayer = XRpgPlayer(Owner.player.mo);
		if (!xrpgPlayer)
			return FindState("PowerCut");

		if (Ammo1.Amount < AmmoUse1 || Ammo2.Amount < AmmoUse2)
			return GetAtkState(hold);

		if (hold && ChargeValue > 0)
			return FindState("AltHold");

		let sideMove = xrpgPlayer.GetPlayerInput(INPUT_SIDEMOVE);
		let rightMove = sideMove > 0;
		let leftMove = sideMove < 0;
		
		bool isBerserk = xrpgPlayer.IsSpellActive(SPELLTYPE_FIGHTER_BERSERK, true);

		if (rightMove)
			return isBerserk ? FindState ("BerserkPowerRightSwing") : FindState ("PowerRightSwing");
		else if (leftMove)
			return isBerserk ? FindState ("BerserkPowerLeftSwing") : FindState ("PowerLeftSwing");

		return Super.GetAltAtkState(hold);
	}

	action void A_ChargeCheckAttack()
	{
		if (player == null)
			return;

		let xrpgPlayer = XRpgPlayer(player.mo);
		if (!xrpgPlayer)
			return;

		Weapon w = player.ReadyWeapon;
		if (!w)
			return;
		
		bool weaponspecial = true;
		// Don't spawn a missile if the player doesn't have enough mana
		if (player.ReadyWeapon == null ||
			!player.ReadyWeapon.CheckAmmo (player.ReadyWeapon.bAltFire ?
				Weapon.AltFire : Weapon.PrimaryFire, false, true))
		{ 
			weaponspecial = false;
		}

		if (weaponspecial)
		{
			if (invoker.ChargeValue > 5)
			{
				A_SetWeapState("AltFireBeam");
			}
			else if (weaponspecial)
			{
				A_SetWeapState("AltFireSlash");
			}
		}
		else
		{
			A_SetWeapState("FireSwing");
		}
	}
	
	action void A_FSwordWeaponReady()
	{
		invoker.ChargeValue = 0;
		A_WeaponReady();
	}
	
	//============================================================================
	//
	// A_FSwordAttack
	//
	//============================================================================

	action void A_FSwordAttack(bool mirrored = false)
	{
		if (player == null)
		{
			return;
		}

		Weapon weapon = player.ReadyWeapon;
		if (weapon != null)
		{
			if (!A_CheckAllMana(invoker.AmmoUse1, invoker.AmmoUse2))
				return;
			
			weapon.DepleteAmmo (false, true);
		}

		if (mirrored)
		{
			SpawnPlayerMissile ("FSwordSlashMissile1", Angle + (45./4),0, 0, 10);
			SpawnPlayerMissile ("FSwordSlashMissile2", Angle + (45./8),0, 0,  5);
			SpawnPlayerMissile ("FSwordSlashMissile3", Angle          ,0, 0,   0);
			SpawnPlayerMissile ("FSwordSlashMissile2", Angle - (45./8),0, 0,  -5);
			SpawnPlayerMissile ("FSwordSlashMissile1", Angle - (45./4),0, 0, -10);
		}
		else
		{
			SpawnPlayerMissile ("FSwordSlashMissile1", Angle + (45./4),0, 0, -10);
			SpawnPlayerMissile ("FSwordSlashMissile2", Angle + (45./8),0, 0,  -5);
			SpawnPlayerMissile ("FSwordSlashMissile3", Angle          ,0, 0,   0);
			SpawnPlayerMissile ("FSwordSlashMissile2", Angle - (45./8),0, 0,   5);
			SpawnPlayerMissile ("FSwordSlashMissile1", Angle - (45./4),0, 0,  10);
		}

		A_StartSound ("FighterSwordFire", CHAN_WEAPON);
	}

	action void A_FSwordCut()
	{
		FTranslatedLineTarget t;

		if (!player)
			return;

		let xrpgPlayer = XRpgPlayer(player.mo);
		if (!xrpgPlayer)
			return;

		//If berserk, all attacks are at least half of max charge
		bool isBerserk = xrpgPlayer.IsSpellActive(SPELLTYPE_FIGHTER_BERSERK, true);
		if (isBerserk)
			invoker.ChargeValue = Max(invoker.ChargeValue, invoker.MaxCharge / 2);

		double chargeDamage = 150.0 * (double(invoker.ChargeValue) / double(SWORD_CHARGE_MAX));
		int damage = random[FWeapBigSword](1, 100) + chargeDamage;

		A_FWeaponMelee(chargeDamage, chargeDamage + 100);
	}

	action void A_FSwordPowerCut ()
	{
		if (!player)
			return;
		
		Weapon weapon = player.ReadyWeapon;
		if (weapon != null)
		{
			if (!A_CheckAllMana(invoker.AmmoUse1, invoker.AmmoUse2))
				return;
			
			weapon.DepleteAmmo (false, true);
		}
		
		let xrpgPlayer = XRpgPlayer(player.mo);
		if (!xrpgPlayer)
			return;

		//If berserk, all attacks are at least half of max charge
		bool isBerserk = xrpgPlayer.IsSpellActive(SPELLTYPE_FIGHTER_BERSERK, true);
		if (isBerserk)
			invoker.ChargeValue = Max(invoker.ChargeValue, invoker.MaxCharge / 2);
		
		int chargeCount = invoker.ChargeValue / 3;

		SwordRainMissile mo = SwordRainMissile(SpawnPlayerMissile ("SwordRainMissile"));
		if (mo)
		{
			mo.TimeLimit += chargeCount;
		}
	}
}

class NormalSwordPuffSilent : Actor
{
	Default
	{
		+NOBLOCKMAP +NOGRAVITY
		+PUFFONACTORS
		RenderStyle "Translucent";
		Alpha 0.6;
		VSpeed 0.8;
		SeeSound "FighterAxeHitThing";
		AttackSound "FighterHammerHitWall";
	}
	States
	{
	Spawn:
		FHFX STUVW 4;
		Stop;
	}
}
class NormalSwordPuff : NormalSwordPuffSilent
{
	Default
	{
		ActiveSound "FighterHammerMiss";
	}
}


const SWORDRAIN_SPEED = -20;
class SwordRainMissile : TimedActor
{
	Default
	{
		Projectile;
		-ACTIVATEIMPACT
		-ACTIVATEPCROSS
		Radius 2;
		Height 2;
		Speed 30;
		Damage 0;
		+CEILINGHUGGER
		+RIPPER
		RenderStyle "Add";
		Obituary "$OB_MPFWEAPQUIETUS";

		TimedActor.TimeLimit 10;
		TimedActor.DieOnTimer true;
	}
	
	states
	{
	Spawn:
		TNT1 A 1 Bright A_ShootSwordRain;
		Loop;
	Death:
		TNT1 A 1;
		Stop;
	}

	void A_ShootSwordRain()
	{
		SetZ(floorz);
		double x = Random2[MntrFloorFire]() / 64.;
		double y = Random2[MntrFloorFire]() / 64.;
		
		Vector3 spawnpos = (Pos.X, Pos.Y, 0);
		Actor mo = Spawn("SwordRain", spawnpos, ALLOW_REPLACE);
		if (mo)
		{
			double newz = mo.CurSector.NextHighestCeilingAt(mo.pos.x, mo.pos.y, mo.pos.z, mo.pos.z, FFCF_NOPORTALS) - (mo.height + 1);
			mo.SetZ(newz);

			mo.target = target;
			mo.Vel.X = MinVel;
			mo.Vel.Z = SWORDRAIN_SPEED;
			mo.CheckMissileSpawn (radius);
			mo.A_SetPitch(90);
		}
	}
}

class SwordRainSmoke : Actor
{
	Default
	{
		Height 16;
	    +NOBLOCKMAP +NOGRAVITY +SHADOW
	    +NOTELEPORT +CANNOTPUSH +NODAMAGETHRUST
		Scale 0.5;
	}
	States
	{
	Spawn:
		SBS3 NOPQRST 2;
		Stop;
	}
}

class SwordRain : Actor
{
    Default
    {
        Speed 120;
        Radius 2;
        Height 2;
        Damage 5;
        Projectile;
        +RIPPER
        +CANNOTPUSH +NODAMAGETHRUST
        +SPAWNSOUNDSOURCE
		+EXTREMEDEATH
        DeathSound "FighterSwordExplode";
		SeeSound "FighterSwordFire";
        Obituary "$OB_MPFWEAPQUIETUS";
		Scale 2;
		Health 0;
    }
    States
    {
    Spawn:
        FSFX NOPQRST 2 Bright;
		Loop;
    Death:
        SBS3 D 2 Bright A_SwordRainExplode;
		SBS3 EFGH 2 Bright;
        Stop;
    }

	action void A_SwordRainExplode()
	{
		A_SetScale(0.5);
		int damage = 40;
		int range = 90;

		let xrpgPlayer = XRpgPlayer(target);
		if (xrpgPlayer != null)
		{
			damage += xrpgPlayer.GetDamageForMagic(20);
			range += xrpgPlayer.GetMagic();
		}
		
		A_Explode(damage, range, 0, false, 0, 0, 10, "BulletPuff");
	}
}

const SWORD_SLASH_MISSILE_SPEED = 12;
const SWORD_SLASH_MISSILE_SPEED_MOD = 3;
class FSwordSlashMissile1 : TimedActor
{
	Default
	{
		Speed SWORD_SLASH_MISSILE_SPEED;
		Radius 2;
		Height 2;
		Damage 5;
		Projectile;
		+EXTREMEDEATH
		+ZDOOMTRANS
		+RIPPER
		RenderStyle "Add";
		DeathSound "FighterSwordExplode";
		Obituary "$OB_MPFWEAPQUIETUS";
	}

	States
	{
	Spawn:
		FSFX ABCABC 3 Bright;
		FSFX B 1 A_StopMoving(true);
	Death:
		FSFX D 4 Bright;
		FSFX E 3 Bright;
		FSFX F 4 Bright;
		FSFX G 3 Bright;
		FSFX H 4 Bright;
		FSFX I 3 Bright;
		FSFX J 4 Bright;
		FSFX KLM 3 Bright;
		Stop;
	}
}

class FSwordSlashMissile2 : FSwordSlashMissile1
{
	Default
	{
		Speed SWORD_SLASH_MISSILE_SPEED + (SWORD_SLASH_MISSILE_SPEED_MOD * 1);
	}
}
class FSwordSlashMissile3 : FSwordSlashMissile1
{
	Default
	{
		Speed SWORD_SLASH_MISSILE_SPEED + (SWORD_SLASH_MISSILE_SPEED_MOD * 2);
	}
}