// The Fighter's Axe --------------------------------------------------------

class XRpgFWeapAxe : XRpgFighterWeapon replaces FWeapAxe
{
	const AXERANGE = (2.25 * DEFMELEERANGE);

	Default
	{
		Weapon.SelectionOrder 1500;
		+WEAPON.AXEBLOOD +WEAPON.AMMO_OPTIONAL +WEAPON.MELEEWEAPON
		Weapon.AmmoUse1 2;
		Weapon.AmmoGive1 25;
		Weapon.KickBack 150;
		Weapon.YAdjust -12;
		Weapon.AmmoType1 "Mana1";
		Inventory.PickupMessage "$TXT_WEAPON_F2";
		Obituary "$OB_MPFWEAPAXE";
		Tag "$TAG_FWEAPAXE";
	}

	States
	{
	Spawn:
		WFAX A -1;
		Stop;
	Select:
		FAXE A 1 A_FAxeCheckUp;
		Loop;
	Deselect:
		FAXE A 1 A_Lower;
		Loop;
	Ready:
		FAXE A 1 A_FAxeCheckReady;
		Loop;
	Fire:
		FAXE B 4 Offset (15, 32) A_FAxeCheckAtk(0);
		FAXE C 3 Offset (15, 32);
		FAXE D 2 Offset (15, 32);
		FAXE D 1 Offset (-5, 70) A_FAxeAttack;
	EndAttack:
		FAXE D 2 Offset (-25, 90);
		FAXE E 1 Offset (15, 32);
		FAXE E 2 Offset (10, 54);
		FAXE E 7 Offset (10, 150);
		FAXE A 1 Offset (0, 60) A_ReFire;
		FAXE A 1 Offset (0, 52);
		FAXE A 1 Offset (0, 44);
		FAXE A 1 Offset (0, 36);
		FAXE A 1;
		Goto Ready;
	SelectGlow:
		FAXE L 1 A_FAxeCheckUpG;
		Loop;
	DeselectGlow:
		FAXE L 1 A_Lower;
		Loop;
	ReadyGlow:
		FAXE LLL 1 A_FAxeCheckReadyG;
		FAXE MMM 1 A_FAxeCheckReadyG;
		Loop;
	FireGlow:
		FAXE N 4 Offset (15, 32);
		FAXE O 3 Offset (15, 32);
		FAXE P 2 Offset (15, 32);
		FAXE P 1 Offset (-5, 70) A_FAxeAttack;
		FAXE P 2 Offset (-25, 90);
		FAXE Q 1 Offset (15, 32);
		FAXE Q 2 Offset (10, 54);
		FAXE Q 7 Offset (10, 150);
		FAXE A 1 Offset (0, 60) A_ReFire;
		FAXE A 1 Offset (0, 52);
		FAXE A 1 Offset (0, 44);
		FAXE A 1 Offset (0, 36);
		FAXE A 1;
		Goto ReadyGlow;
	AltFire:
		FAXE B 4 Offset (15, 32) A_FAxeCheckAtk(1);
		FAXE C 3 Offset (15, 32);
		FAXE D 2 Offset (15, 32);
		FAXE D 1 Offset (-5, 70);
		FAXE D 2 Offset (-25, 90);
		TNT1 A 1 Offset (15, 32) A_FireWindAxe(0);
		TNT1 A 2 Offset (10, 54);
	WindAxeWait:
		TNT1 A 4 Offset (10, 150) A_WindAxeFinish;
		Loop;
	WindAxeFinish:
		FAXE A 1 Offset (0, 60);
		FAXE A 1 Offset (0, 52);
		FAXE A 1 Offset (0, 44);
		FAXE A 1 Offset (0, 36);
		FAXE A 1;
		Goto Ready;
	
	AltFireGlow:
		FAXE N 4 Offset (15, 32);
		FAXE O 3 Offset (15, 32);
		FAXE P 2 Offset (15, 32);
		FAXE P 1 Offset (-5, 70);
		FAXE P 2 Offset (-25, 90);
		TNT1 A 1 Offset (15, 32) A_FireWindAxe(1);
		TNT1 A 2 Offset (10, 54);
		Goto WindAxeWait;
	}
	
	override State GetUpState ()
	{
		return Ammo1.Amount ? FindState ("SelectGlow") : Super.GetUpState();
	}

	override State GetDownState ()
	{
		return Ammo1.Amount ? FindState ("DeselectGlow") : Super.GetDownState();
	}

	override State GetReadyState ()
	{
		return Ammo1.Amount ? FindState ("ReadyGlow") : Super.GetReadyState();
	}

	override State GetAtkState (bool hold)
	{
		return Ammo1.Amount ? FindState ("FireGlow") :  Super.GetAtkState(hold);
	}

	
	
	//============================================================================
	//
	// A_FAxeCheckReady
	//
	//============================================================================

	action void A_FAxeCheckReady()
	{
		if (player == null)
		{
			return;
		}
		Weapon w = player.ReadyWeapon;
		if (w.Ammo1 && w.Ammo1.Amount > 0)
		{
			player.SetPsprite(PSP_WEAPON, w.FindState("ReadyGlow"));
		}
		else
		{
			A_WeaponReady();
		}
	}

	//============================================================================
	//
	// A_FAxeCheckReadyG
	//
	//============================================================================

	action void A_FAxeCheckReadyG()
	{
		if (player == null)
		{
			return;
		}
		Weapon w = player.ReadyWeapon;
		if (!w.Ammo1 || w.Ammo1.Amount <= 0)
		{
			player.SetPsprite(PSP_WEAPON, w.FindState("Ready"));
		}
		else
		{
			A_WeaponReady();
		}
	}

	//============================================================================
	//
	// A_FAxeCheckUp
	//
	//============================================================================

	action void A_FAxeCheckUp()
	{
		if (player == null)
		{
			return;
		}
		Weapon w = player.ReadyWeapon;
		if (w.Ammo1 && w.Ammo1.Amount > 0)
		{
			player.SetPsprite(PSP_WEAPON, w.FindState("SelectGlow"));
		}
		else
		{
			A_Raise();
		}
	}

	//============================================================================
	//
	// A_FAxeCheckUpG
	//
	//============================================================================

	action void A_FAxeCheckUpG()
	{
		if (player == null)
		{
			return;
		}
		Weapon w = player.ReadyWeapon;
		if (!w.Ammo1 || w.Ammo1.Amount <= 0)
		{
			player.SetPsprite(PSP_WEAPON, w.FindState("Select"));
		}
		else
		{
			A_Raise();
		}
	}

	//============================================================================
	//
	// A_FAxeCheckAtk
	//
	//============================================================================

	action void A_FAxeCheckAtk(int throwing)
	{
		if (player == null)
		{
			return;
		}
		Weapon w = player.ReadyWeapon;
		if (w.Ammo1 && w.Ammo1.Amount > 0)
		{
			if (throwing)
				A_SetWeapState("AltFireGlow");
			else
				A_SetWeapState("FireGlow");
		}
	}

	//============================================================================
	//
	// A_FAxeAttack
	//
	//============================================================================

	action void A_FAxeAttack()
	{
		FTranslatedLineTarget t;

		if (player == null)
		{
			return;
		}

		int damage = random[AxeAtk](1, 55);
		damage += random[AxeAtk](0, 7);
		int power = 0;
		Weapon weapon = player.ReadyWeapon;
		class<Actor> pufftype;
		int usemana;
		if ((usemana = (weapon.Ammo1 && weapon.Ammo1.Amount > 0)))
		{
			damage <<= 1;
			power = 6;
			pufftype = "AxePuffGlow";
		}
		else
		{
			pufftype = "AxePuff";
		}

		let xrpgPlayer = XRpgPlayer(player.mo);
		if (xrpgPlayer != null)
			damage += xrpgPlayer.Strength;

		for (int i = 0; i < 16; i++)
		{
			for (int j = 1; j >= -1; j -= 2)
			{
				double ang = angle + j*i*(45. / 16);
				double slope = AimLineAttack(ang, AXERANGE, t, 0., ALF_CHECK3D);
				if (t.linetarget)
				{
					LineAttack(ang, AXERANGE, slope, damage, 'Melee', pufftype, true, t);
					if (t.linetarget != null)
					{
						if (t.linetarget.bIsMonster || t.linetarget.player)
						{
							t.linetarget.Thrust(power, t.attackAngleFromSource);
						}
						AdjustPlayerAngle(t);
						
						weapon.DepleteAmmo (weapon.bAltFire, false);

						if ((weapon.Ammo1 == null || weapon.Ammo1.Amount == 0) &&
							(!(weapon.bPrimary_Uses_Both) ||
							  weapon.Ammo2 == null || weapon.Ammo2.Amount == 0))
						{
							player.SetPsprite(PSP_WEAPON, weapon.FindState("EndAttack"));
						}
						return;
					}
				}
			}
		}
		// didn't find any creatures, so try to strike any walls
		self.weaponspecial = 0;

		double slope = AimLineAttack (angle, DEFMELEERANGE, null, 0., ALF_CHECK3D);
		LineAttack (angle, DEFMELEERANGE, slope, damage, 'Melee', pufftype, true);
	}

	action void A_FireWindAxe(int powered)
	{
		if (player == null)
		{
			return;
		}
		
		Weapon weapon = player.ReadyWeapon;
		if (weapon != null && powered)
		{
			//Costs extra mana
			int blueManaCost = 3;
			if (A_CheckAllMana(blueManaCost, 0))
				A_DepleteAllMana(blueManaCost, 0);
			weapon.DepleteAmmo(false, false);
		}
		
		let tracker = WindAxeTracker(FindInventory("WindAxeTracker"));
		if (tracker && tracker.WindAxe1)
			return;

		Actor windAxe;
		if (powered)
			windAxe = Actor(SpawnPlayerMissile ("WindAxeMissilePower", angle));
		else
			windAxe = Actor(SpawnPlayerMissile ("WindAxeMissile", angle));
			
		if (tracker == null)
			tracker = WindAxeTracker(GiveInventoryType("WindAxeTracker"));
		
		tracker.WindAxe1 = windAxe;

		A_StartSound("SerpentAttack", CHAN_BODY);
	}

	action void A_WindAxeFinish()
	{
		if (player == null)
		{
			return;
		}
		
		let tracker = WindAxeTracker(FindInventory("WindAxeTracker"));
		if (!tracker)
			return;

		if (!tracker.WindAxe1)
		{
			A_SetWeapState("WindAxeFinish");
		}
	}
}

const WINDAXE_HEALTH_MAX = 12;
const WINDAXE_HEALTH_STOP = 10;
const WINDAXE_HEALTH_RETURN = 2;
const WINDAXE_VEL_PERCENT = 0.33;
const WINDAXE_TARGETZ_OFFSET = 15;
const WINDAXE_SPEED = 40;

class WindAxeMissile : Actor
{
	Default
	{
		Radius 10;
		Height 6;
		Speed WINDAXE_SPEED;
		Damage 1;
		Health WINDAXE_HEALTH_MAX;
		Projectile;
		+RIPPER
		+ZDOOMTRANS
		Obituary "$OB_MPFWEAPAXE";
		Scale 1.5;
		+BOUNCEONFLOORS
		+BOUNCEONCEILINGS
		+USEBOUNCESTATE
		+BOUNCEONWALLS
		+CANBOUNCEWATER
	}

	States
	{
	Spawn:
		THAX AB 4 A_MoveWindAxe(0);
		Loop;
	Bounce:
		THAX A 1 A_WindAxeImpact;
		Goto Spawn;
	Death:
		THAX A 1;
		Goto Spawn;
	}
	
	//Bounce
	void A_WindAxeImpact()
	{
		//A_StartSound ("weapons/macebounce", CHAN_BODY);
		A_SetSpeed(0);
		A_ChangeVelocity(0,0,0, CVF_REPLACE);
	}
	
	override void Die(Actor source, Actor inflictor, int dmgflags, Name MeansOfDeath)
	{
		A_WindAxeImpact();
	}
	
	action void A_MoveWindAxe(int powered)
	{
		if (target == null || target.health <= 0)
		{ // Shooter is dead or nonexistent
			A_RemoveWindAxe();
			return;
		}
		
		Health--;
		if (Health < 1)
		{
			A_RemoveWindAxe();
			return;
		}
		
		let targetZ = target.Pos.Z + WINDAXE_TARGETZ_OFFSET;

		if (Health <= WINDAXE_HEALTH_RETURN)
		{
			let vecOffset = (target.Pos.X - Pos.X, target.Pos.Y - Pos.Y);
			let ang = Vectorangle(vecOffset.x, vecOffset.y);
			A_SetAngle(ang);
			
			let dist = Distance2D(target);
			let vel = dist * WINDAXE_VEL_PERCENT;
			let aPitch = Vectorangle(dist, Pos.Z - targetZ);
			
			Vel3DFromAngle(vel, angle, aPitch);
		}
		else if (Health <= WINDAXE_HEALTH_STOP)
		{
			A_SetSpeed(0);
			A_ChangeVelocity(0,0,0, CVF_REPLACE);
		}
	}
	
	action void A_RemoveWindAxe()
	{
		WindAxeTracker tracker;
		
		if (target != null && target.health > 0)
			tracker = WindAxeTracker(target.FindInventory("WindAxeTracker"));
			
		if (tracker)
			tracker.WindAxe1 = null;

		Destroy();
	}
}

class WindAxeTracker : Inventory
{
	Actor WindAxe1;
	
	Default
	{
		+INVENTORY.UNDROPPABLE
	}
}
class WindAxeMissilePower : WindAxeMissile
{
	Default
	{
		Damage 3;
	}

	States
	{
	Spawn:
		THAX CD 4 A_MoveWindAxe(0);
		Loop;
	Bounce:
		THAX C 1 A_WindAxeImpact;
		Goto Spawn;
	Death:
		THAX C 1;
		Goto Spawn;
	}
}