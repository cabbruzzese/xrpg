class XRpgStatusBar : HexenStatusBar
{
	DynamicValueInterpolator mHealthInterpolator;
	DynamicValueInterpolator mHealthInterpolator2;
	HUDFont mHUDFont;
	HUDFont mIndexFont;
	HUDFont mBigFont;
	HUDFont mSmallFont;
	InventoryBarState diparms;
	InventoryBarState diparms_sbar;
	

	override void Init()
	{
		Super.Init();
		SetSize(38, 320, 200);

		// Create the font used for the fullscreen HUD
		Font fnt = "HUDFONT_RAVEN";
		mHUDFont = HUDFont.Create(fnt, fnt.GetCharWidth("0") + 1, Mono_CellLeft, 1, 1);
		fnt = "INDEXFONT_RAVEN";
		mIndexFont = HUDFont.Create(fnt, fnt.GetCharWidth("0"), Mono_CellLeft);
		fnt = "BIGFONT";
		mBigFont = HUDFont.Create(fnt, fnt.GetCharWidth("0"), Mono_CellLeft, 2, 2);
		fnt = "SMALLFONT";
		mSmallFont = HUDFont.Create(fnt, 0, Mono_Off);
		diparms = InventoryBarState.Create(mIndexFont);
		diparms_sbar = InventoryBarState.CreateNoBox(mIndexFont, boxsize:(31, 31), arrowoffs:(0,-10));
		mHealthInterpolator = DynamicValueInterpolator.Create(0, 0.25, 1, 8);
		mHealthInterpolator2 = DynamicValueInterpolator.Create(0, 0.25, 1, 6);	// the chain uses a maximum of 6, not 8.
	}
	
	override void NewGame ()
	{
		Super.NewGame();
		mHealthInterpolator.Reset (0);
		mHealthInterpolator2.Reset (0);
	}

	override int GetProtrusion(double scaleratio) const
	{
		return scaleratio > 0.85? 28 : 12;	// need to get past the gargoyle's wings
	}

	override void Tick()
	{
		Super.Tick();
		mHealthInterpolator.Update(CPlayer.health);
		mHealthInterpolator2.Update(CPlayer.health);
	}

	override void Draw (int state, double TicFrac)
	{
		Super.Draw (state, TicFrac);

		//draw visor under everything
		//DrawVisor(state == HUD_Fullscreen);

		if (state == HUD_StatusBar)
		{
			BeginStatusBar();
			DrawMainBar (TicFrac);
            DrawExpStuff(0);
		}
		else if (state == HUD_Fullscreen)
		{
			BeginHUD();
			DrawFullScreenStuff ();
            DrawExpStuff(1);
		}

		DrawPaperdoll();

		DrawSkillStuff();
		DrawMagicItemStuff(state == HUD_Fullscreen);

		TabMenuRenderer.Draw(self, CPlayer, mSmallFont);
	}

	protected void DrawFullScreenStuff ()
	{
		//health
		DrawImage("PTN1A0", (60, -3));
		DrawString(mBigFont, FormatNumber(mHealthInterpolator.GetValue()), (41, -21), DI_TEXT_ALIGN_RIGHT);

		//armor
		DrawImage("AR_1A0", (60, -23));
		DrawString(mBigFont, FormatNumber(GetArmorSavePercent() / 5, 2), (41, -41), DI_TEXT_ALIGN_RIGHT);

		//frags/keys
		if (deathmatch)
		{
			DrawString(mHUDFont, FormatNumber(CPlayer.FragCount, 3), (70, -16));
		}
		
		if (!isInventoryBarVisible() && !Level.NoInventoryBar && CPlayer.mo.InvSel != null)
		{
			// This code was changed to always fit the item into the box, regardless of alignment or sprite size.
			// Heretic's ARTIBOX is 30x30 pixels. 
			DrawImage("ARTIBOX", (-66, -1), 0, HX_SHADOW);
			DrawInventoryIcon(CPlayer.mo.InvSel, (-66, -15), DI_ARTIFLASH|DI_ITEM_CENTER, boxsize:(28, 28));
			if (CPlayer.mo.InvSel.Amount > 1)
			{
				DrawString(mIndexFont, FormatNumber(CPlayer.mo.InvSel.Amount, 3), (-52, -2 - mIndexFont.mFont.GetHeight()), DI_TEXT_ALIGN_RIGHT);
			}
		}
		
		Ammo ammo1, ammo2;
		[ammo1, ammo2] = GetCurrentAmmo();
		if ((ammo1 is "Mana1") || (ammo2 is "Mana1")) DrawImage("MANABRT1", (-17, -30), DI_ITEM_OFFSETS);
		else DrawImage("MANADIM1", (-17, -30), DI_ITEM_OFFSETS);
		if ((ammo1 is "Mana2") || (ammo2 is "Mana2")) DrawImage("MANABRT2", (-17, -15), DI_ITEM_OFFSETS);
		else DrawImage("MANADIM2", (-17, -15), DI_ITEM_OFFSETS);
		DrawString(mHUDFont, FormatNumber(GetAmount("Mana1"), 3), (-21, -30), DI_TEXT_ALIGN_RIGHT);
		DrawString(mHUDFont, FormatNumber(GetAmount("Mana2"), 3), (-21, -15), DI_TEXT_ALIGN_RIGHT);
		
		if (isInventoryBarVisible())
		{
			DrawInventoryBar(diparms, (0, 0), 7, DI_SCREEN_CENTER_BOTTOM, HX_SHADOW);
		}
	}

	protected void DrawMainBar (double TicFrac)
	{
		DrawImage("H2BAR", (0, 134), DI_ITEM_OFFSETS);
		
		String Gem, Chain;
		if (CPlayer.mo is "ClericPlayer")
			{
				Gem = "LIFEGMC2";
				Chain = "CHAIN2";
			}
		else if (CPlayer.mo is "MagePlayer")
			{
				Gem = "LIFEGMM2";
				Chain = "CHAIN3";
			}
		else
			{
				Gem = "LIFEGMF2";
				Chain = "CHAIN";
			}

		int inthealth =  mHealthInterpolator2.GetValue();
		DrawGem(Chain, Gem, inthealth, CPlayer.mo.GetMaxHealth(true), (30, 193), -23, 49, 15, (multiplayer? DI_TRANSLATABLE : 0) | DI_ITEM_LEFT_TOP); 
		
		DrawImage("LFEDGE", (0, 192), DI_ITEM_OFFSETS);
		DrawImage("RTEDGE", (277, 192), DI_ITEM_OFFSETS);
		
		if (!automapactive)
		{
			if (isInventoryBarVisible())
			{
				DrawImage("INVBAR", (38, 162), DI_ITEM_OFFSETS);
				DrawInventoryBar(diparms_sbar, (52, 163), 7, DI_ITEM_LEFT_TOP, HX_SHADOW);
			}
			else
			{
				DrawImage("STATBAR", (38, 162), DI_ITEM_OFFSETS);

				//inventory box
				if (CPlayer.mo.InvSel != null)
				{
					DrawInventoryIcon(CPlayer.mo.InvSel, (159.5, 177), DI_ARTIFLASH|DI_ITEM_CENTER, boxsize:(28, 28));
					if (CPlayer.mo.InvSel.Amount > 1)
					{
						DrawString(mIndexFont, FormatNumber(CPlayer.mo.InvSel.Amount, 3), (174, 184), DI_TEXT_ALIGN_RIGHT);
					}
				}
				
				if (deathmatch || teamplay)
				{
					DrawImage("KILLS", (38, 163), DI_ITEM_OFFSETS);
					DrawString(mHUDFont, FormatNumber(CPlayer.FragCount, 3), (66, 176), DI_TEXT_ALIGN_RIGHT);
				}
				else
				{
					DrawImage("ARMCLS", (41, 178), DI_ITEM_OFFSETS);
					// Note that this has been changed to use red only if the REAL health is below 25, not when an interpolated value is below 25!
					DrawString(mHUDFont, FormatNumber(mHealthInterpolator.GetValue(), 3), (66, 176), DI_TEXT_ALIGN_RIGHT, CPlayer.Health < 25? Font.CR_RED : Font.CR_UNTRANSLATED);
				}
				
				//armor
				DrawImage("ARMCLS", (255, 178), DI_ITEM_OFFSETS);
				DrawString(mHUDFont, FormatNumber(GetArmorSavePercent() / 5, 2), (276, 176), DI_TEXT_ALIGN_RIGHT);
				
				Ammo ammo1, ammo2;
				[ammo1, ammo2] = GetCurrentAmmo();
				
				if (ammo1 != null && !(ammo1 is "Mana1") && !(ammo1 is "Mana2"))
				{
					DrawImage("HAMOBACK", (77, 164), DI_ITEM_OFFSETS);
					if (ammo2 != null)
					{
						DrawTexture(ammo1.icon, (89, 172), DI_ITEM_CENTER);
						DrawTexture(ammo2.icon, (113, 172), DI_ITEM_CENTER);
						DrawString(mIndexFont, FormatNumber(ammo1.amount, 3), ( 98, 182), DI_TEXT_ALIGN_RIGHT);
						DrawString(mIndexFont, FormatNumber(ammo2.amount, 3), (122, 182), DI_TEXT_ALIGN_RIGHT);
					}
					else
					{
						DrawTexture(ammo1.icon, (100, 172), DI_ITEM_CENTER);
						DrawString(mIndexFont, FormatNumber(ammo1.amount, 3), (109, 182), DI_TEXT_ALIGN_RIGHT);
					}
				}
				else
				{
					int amt1, maxamt1, amt2, maxamt2;
					[amt1, maxamt1] = GetAmount("Mana1");
					[amt2, maxamt2] = GetAmount("Mana2");
					if ((ammo1 is "Mana1") || (ammo2 is "Mana1")) 
					{
						DrawImage("MANABRT1", (77, 164), DI_ITEM_OFFSETS);
						DrawBar("MANAVL1", "", amt1, maxamt1, (94, 164), 1, SHADER_VERT, DI_ITEM_OFFSETS);
					}
					else 
					{
						DrawImage("MANADIM1", (77, 164), DI_ITEM_OFFSETS);
						DrawBar("MANAVL1D", "", amt1, maxamt1, (94, 164), 1, SHADER_VERT, DI_ITEM_OFFSETS);
					}
					if ((ammo1 is "Mana2") || (ammo2 is "Mana2")) 
					{
						DrawImage("MANABRT2", (110, 164), DI_ITEM_OFFSETS);
						DrawBar("MANAVL2", "", amt2, maxamt2, (102, 164), 1, SHADER_VERT, DI_ITEM_OFFSETS);
					}
					else 
					{
						DrawImage("MANADIM2", (110, 164), DI_ITEM_OFFSETS);
						DrawBar("MANAVL2D", "", amt2, maxamt2, (102, 164), 1, SHADER_VERT, DI_ITEM_OFFSETS);
					}
					DrawString(mIndexFont, FormatNumber(amt1, 3), ( 92, 181), DI_TEXT_ALIGN_RIGHT);
					DrawString(mIndexFont, FormatNumber(amt2, 3), (124, 181), DI_TEXT_ALIGN_RIGHT);
				}
				if (CPlayer.mo is "XRpgClericPlayer")
				{
					DrawImage("WPSLOT1", (190, 162), DI_ITEM_OFFSETS);
					if (CheckInventory("XRpgCWeapWraithverge")) DrawImage("WPFULL1", (190, 162), DI_ITEM_OFFSETS);
					else
					{
						int pieces = GetWeaponPieceMask("XRpgCWeapWraithverge");
						if (pieces & 1) DrawImage("WPIECEC1", (190, 162), DI_ITEM_OFFSETS);
						if (pieces & 2) DrawImage("WPIECEC2", (212, 162), DI_ITEM_OFFSETS);
						if (pieces & 4) DrawImage("WPIECEC3", (225, 162), DI_ITEM_OFFSETS);
					}
				}
				else if (CPlayer.mo is "XRpgMagePlayer")
				{
					DrawImage("WPSLOT2", (190, 162), DI_ITEM_OFFSETS);
					if (CheckInventory("XRpgMWeapBloodscourge")) DrawImage("WPFULL2", (190, 162), DI_ITEM_OFFSETS);
					else
					{
						int pieces = GetWeaponPieceMask("XRpgMWeapBloodscourge");
						if (pieces & 1) DrawImage("WPIECEM1", (190, 162), DI_ITEM_OFFSETS);
						if (pieces & 2) DrawImage("WPIECEM2", (205, 162), DI_ITEM_OFFSETS);
						if (pieces & 4) DrawImage("WPIECEM3", (224, 162), DI_ITEM_OFFSETS);
					}
				}
				else
				{
					DrawImage("WPSLOT0", (190, 162), DI_ITEM_OFFSETS);
					if (CheckInventory("XRpgFWeapQuietus")) DrawImage("WPFULL0", (190, 162), DI_ITEM_OFFSETS);
					else
					{
						int pieces = GetWeaponPieceMask("XRpgFWeapQuietus");
						if (pieces & 1) DrawImage("WPIECEF1", (190, 162), DI_ITEM_OFFSETS);
						if (pieces & 2) DrawImage("WPIECEF2", (225, 162), DI_ITEM_OFFSETS);
						if (pieces & 4) DrawImage("WPIECEF3", (234, 162), DI_ITEM_OFFSETS);
					}
				}
			}
		}
		else // automap
		{
			DrawImage("KEYBAR", (38, 162), DI_ITEM_OFFSETS);
			int cnt = 0;
			Vector2 keypos = (46, 164);
			for(let i = CPlayer.mo.Inv; i != null; i = i.Inv)
			{
				if (i is "Key" && i.Icon.IsValid())
				{
					DrawTexture(i.Icon, keypos, DI_ITEM_OFFSETS);
					keypos.X += 20;
					if (++cnt >= 5) break;
				}
			}
			// DrawHexenArmor(HEXENARMOR_ARMOR, "ARMSLOT1", (150, 164), DI_ITEM_OFFSETS);
			// DrawHexenArmor(HEXENARMOR_SHIELD, "ARMSLOT2", (181, 164), DI_ITEM_OFFSETS);
			// DrawHexenArmor(HEXENARMOR_HELM, "ARMSLOT3", (212, 164), DI_ITEM_OFFSETS);
			// DrawHexenArmor(HEXENARMOR_AMULET, "ARMSLOT4", (243, 164), DI_ITEM_OFFSETS);
		}
	}

	protected void DrawExpStuff (int isFullscreen)
	{
		//don't render on automap
		if (automapactive)
			return;

        let xPos = 0;
		let yPos = 126;
		let yStep = 8;
		
		let xPosStats = 320;
		
		if (isFullscreen)
		{
			xPos = 8;
			yPos = 346;
			xPosStats = 740;
		}

		let xrpgPlayer = XRpgPlayer(CPlayer.mo);
		if (!xrpgPlayer)
			return;

		let statItem = xrpgPlayer.GetUIStats();
		if (!statItem)
			return;

		let text1 = String.Format("XP: %s / %s", FormatNumber(statItem.Exp, 0), FormatNumber(statItem.ExpNext, 0));
		let text2 = String.Format("Level: %s", FormatNumber(statItem.ExpLevel, 0));
				
		//Exp
		DrawString(mSmallFont, text1, (xPos, yPos), DI_TEXT_ALIGN_LEFT);
		DrawString(mSmallFont, text2, (xPos, yPos + yStep), DI_TEXT_ALIGN_LEFT);
		
		let statText1 = String.Format("Strength: %s", FormatNumber(statItem.Strength, 0));
		let statText2 = String.Format("Armor: %s", FormatNumber(statItem.Dexterity, 0));
		let statText3 = String.Format("Magic: %s", FormatNumber(statItem.Magic, 0));

		//Stats
		DrawString(mSmallFont, statText1, (xPosStats, yPos - yStep), DI_TEXT_ALIGN_RIGHT);
		DrawString(mSmallFont, statText2, (xPosStats, yPos), DI_TEXT_ALIGN_RIGHT);
		DrawString(mSmallFont, statText3, (xPosStats, yPos + yStep), DI_TEXT_ALIGN_RIGHT);
	}

	protected void DrawMultiSlotSpell(XRpgSpellItem spellItem, int yOffset, string gemIcon, bool alwaysDrawBox = true)
	{
		if (automapactive)
			return;

		if (alwaysDrawBox || spellItem)
			DrawImage("ARTIBOX", (14, 124 + yOffset), 0, HX_SHADOW);

		if (spellItem)
		{
			DrawInventoryIcon(spellItem, (13, 109 + yOffset), DI_ITEM_CENTER, boxsize:(28, 28));

			if (spellItem.TimerVal > 0 || spellItem.DrawInactive)
			{
				double percentTimer = 0.0;
				int timerGems = 0;

				if (spellItem.TimerVal > 0)
				{
					percentTimer = double(spellItem.TimerVal) / double(spellItem.MaxTimer);
					timerGems = 10 * percentTimer;
				}

				//draw at least one
				if (spellItem.TimerVal > 0 && timerGems < 1)
					timerGems = 1;

				for (int i = 0; i < timerGems; i++)
				{
					DrawImage(gemIcon, (45 + (TIMERGEM_OFFSET_X * i), 124 + yOffset), 0, HX_SHADOW);
				}

				if (spellItem.UseCrystals)
				{
					for (int i = 0; i < spellItem.HitCount; i++)
					{
						DrawImage("AGMGA0", (45 + (TIMERGEM_OFFSET_X * i), 110 + yOffset), 0, HX_SHADOW);
					}
				}
			}
		}
	}
	const TIMERGEM_OFFSET_X = 13;
	const ICON_BOX_OFFSET_Y = 15;
	protected void DrawSkillStuff()
	{
		if (automapactive)
			return;

		let magePlayer = XRpgMagePlayer(CPlayer.mo);
		if (magePlayer)
		{
			int msXPos = 14;
			int msYPos = 117;

			DrawImage("ARTIBOX", (msXPos, msYPos), 0, HX_SHADOW);
			DrawInventoryIcon(magePlayer.ActiveSpell, (msXPos, msYPos - ICON_BOX_OFFSET_Y), DI_ITEM_CENTER, boxsize:(28, 28));
		}

		let clericPlayer = XRpgClericPlayer(CPlayer.mo);
		if (clericPlayer)
		{
			DrawMultiSlotSpell(clericPlayer.ActiveSpell, 0, "INVGEMR2");
			DrawMultiSlotSpell(clericPlayer.ActiveSpell2, -30, "INVGEMR2");
		}

		let fighterPlayer = XRpgFighterPlayer(CPlayer.mo);
		if (fighterPlayer)
		{
			DrawMultiSlotSpell(fighterPlayer.ActiveSpell, 0, "INVGEMR2", false);
			DrawMultiSlotSpell(fighterPlayer.ActiveSpell2, -30, "INVGEMR2", false);
		}
	}

	protected void DrawMagicItemStuff(bool fullScreen)
	{	
		if (automapactive)
			return;
		
		int miXPos = 305;
		int miYPos = 117;

		if (fullScreen)
		{
			miXPos = 14;
			miYPos = 164;
		}

		let xrpgPlayer = XRpgPlayer(CPlayer.mo);
		if (!xrpgPlayer)
			return;

		let item = xrpgPlayer.activeMagicItems[PAPERDOLL_SLOT_ACCESSORY];
		if (item)
		{
			DrawImage("ARTIBOX", (miXPos, miYPos), 0, HX_SHADOW);
			DrawInventoryIcon(item, (miXPos, miYPos - ICON_BOX_OFFSET_Y), DI_ITEM_CENTER, boxsize:(28, 28));
		}
	}

	protected void DrawPaperdoll()
	{
		if (!automapactive)
			return;
		
		int miXPos = 240;
		int miYPos = 130;

		let xrpgPlayer = XRpgPlayer(CPlayer.mo);
		if (!xrpgPlayer)
			return;

		DrawImage(xrpgPlayer.PaperdollIcon, (miXPos, miYPos), 0);

		for (int i = 0; i < PAPERDOLL_SLOTS; i++)
		{
			let slot = xrpgPlayer.accessorySlots[i];
			let item = xrpgPlayer.ActiveMagicItems[i];

			if (slot)
			{
				//Always render accessory slot, only render armor if item is active
				if (i == PAPERDOLL_SLOT_ACCESSORY || item)
					DrawImage(slot.image, slot.displayPos, 0);

				if (item)
					DrawInventoryIcon(item, (slot.displayPos.X, slot.displayPos.Y - ICON_BOX_OFFSET_Y), DI_ITEM_CENTER, boxsize:(28, 28));
			}
		}

		let trash = xrpgPlayer.trashSlot;
		if (trash)
		{
			DrawImage(trash.image, trash.displayPos, 0);
		}

		if (xrpgPlayer.isArmorSlowed)
		{
			DrawImage("SLOWA0", (miXPos + 50, trash.displayPos.y), 0);
		}
		else if (xrpgPlayer.isArmorHeavy)
		{
			DrawImage("SLOWB0", (miXPos + 50, trash.displayPos.y), 0);
		}
	}

	protected void DrawVisor(bool fullscreen)
	{		
		if (automapactive)
			return;
		
		let xrpgPlayer = XRpgPlayer(CPlayer.mo);
		if (!xrpgPlayer)
			return;

		let helm = XRpgHelmetItem(xrpgPlayer.ActiveMagicItems[PAPERDOLL_SLOT_HELMET]);
		if (helm && helm.VisorImage)
		{
			int mX = 160;
			int mY = 0;
			if (fullscreen)
			{
				mx = 320;
				mY = 240;
			}
			DrawImage(helm.VisorImage, (mX,mY), DI_ITEM_CENTER, 1, (-1,-1), (3,3));
		}
	}
}

