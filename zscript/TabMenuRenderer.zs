const TAB_INV_START_X = 0;
const TAB_INV_START_Y = 100;
const TAB_INV_OFFSET_X = 30;
const TAB_INV_OFFSET_Y = -30;
const TAB_INV_ROWSIZE = 5;
class TabMenuRenderer ui
{
    static void DrawCursor(BaseStatusBar sbar, PlayerHudController hud)
    {
        string icon = hud.CursorIcon;
        if (hud.selectedItem)
            sbar.DrawTexture(hud.selectedItem.Icon, (hud.mousePos.X, -hud.mousePos.Y), 0);
        else
            sbar.DrawImage(hud.CursorIcon, (hud.mousePos.X, -hud.mousePos.Y), 0);
    }

    static void DrawInvetoryBar(BaseStatusBar sbar, int startY)
    {
        Vector2 invPosition = (TAB_INV_START_X, startY);
        for (let i = 0; i < TAB_INV_ROWSIZE; i++)
        {
            Vector2 newPos = (invPosition.X + (i * TAB_INV_OFFSET_X), invPosition.Y);
            sbar.DrawImage(TABMENU_SLOT_ICON_DEFAULT, newPos, BaseStatusBar.DI_ITEM_CENTER);
        }
    }
    static void DrawIventoryItems(BaseStatusBar sbar, PlayerPawn playerObj)
    {
        Vector2 invPosition = (TAB_INV_START_X, TAB_INV_START_Y);
        int colCount = 0;

        DrawInvetoryBar(sbar,  invPosition.Y);
        for(let i = playerObj.Inv; i != null; i = i.Inv)
        {
            let item = TabMenuItem(i);
            if (!item)
                continue;
            
            let element = item.element;
            if (element && item.Icon.IsValid() && item.Listable)
            {
                //check if item is allowed to render
                if (!item.CanRenderInventory())
                    continue;

                element.SetRenderPosition(invPosition);
                sbar.DrawTexture(item.Icon, element.displayPos, BaseStatusBar.DI_ITEM_CENTER);

                colCount++;
                if (colCount == TAB_INV_ROWSIZE)
                {
                    colCount = 0;
                    invPosition = (TAB_INV_START_X, invPosition.Y + TAB_INV_OFFSET_Y);
                    DrawInvetoryBar(sbar, invPosition.Y);
                }
                else
                {
                    invPosition.X += TAB_INV_OFFSET_X;
                }
            }
        }
         
    }

    static void Draw(BaseStatusBar sbar, PlayerInfo cplayer)
    {
        if (automapactive)
        {
            let xrpgPlayer = XRpgPlayer(cplayer.mo);
            if (!xrpgPlayer || !xrpgPlayer.hud)
                return;            

            DrawIventoryItems(sbar, xrpgPlayer);

            //Always draw cursor last so it appears on top
            DrawCursor(sbar, xrpgPlayer.hud);            
        }
    }
}

class PlayerHudController 
{
    Vector2 mousePos;
    string cursorIcon;

    TabMenuItem selectedItem;

    void AdjustMouse (int xval, int yval, Vector2 maxSize)
	{
		int newX = mousePos.X + xval;
		int newY = mousePos.Y + yval;

		mousePos.X = Math.Clamp(newX, -maxSize.X, maxSize.X);
		mousePos.Y = Math.Clamp(newY, -maxSize.Y, maxSize.Y);
	}

    void ResetMouse ()
	{
		mousePos = (0,0);
        selectedItem = null;
	}

    play void MouseClicked(bool rightClick = false)
    {
        //find if TabMenu UI item is clicked on
        let player = players[consoleplayer].mo;
        let playerObj = PlayerPawn(player);
        if (!playerObj)
            return;
        
        //let arrayItems = TabMenuItem.GetItems(playerObj);
        bool itemFound;

        for (let i = playerObj.inv; i != null; i = i.inv)
        {
            TabMenuItem item = TabMenuItem(i);

            if (!item)
                continue;

            let element = item.element;

            if (element && element.IsInBounds(mousePos) && item.selectable)
            {
                itemFound = true;

                if (element.Clicked() && item.CanRenderInventoryPlay())
                {
                    selectedItem = item;

                    if (selectedItem && selectedItem.StopPropagation)
                        break;
                }
            }
        }
        if (!itemFound)
        {
            let xrpgPlayer = XRpgPlayer(playerObj);

            for (int i = 0; i < PAPERDOLL_SLOTS; i++)
            {
                let slot = xrpgPlayer.accessorySlots[i];
                if (xrpgPlayer && slot)
                {
                    if (slot.IsInBounds(mousePos))
                    {
                        if (slot.Clicked())
                            selectedItem = null;
                    }
                }
            }

            selectedItem = null;
        }
    }
}