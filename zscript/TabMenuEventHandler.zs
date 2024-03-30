class TabMenuEventHandler : EventHandler
{
    override void NetworkProcess (ConsoleEvent e)
	{
		if (e.IsManual || e.Player < 0 || !PlayerInGame[e.Player] || !(players[e.Player].mo))
			return;

		let player = players [e.Player].mo;
		
		if (e.Name ~== "GameMouseMoved")
		{
			let xrpgPlayer = XRpgPlayer(player);
            if (xrpgPlayer && xrpgPlayer.hud)
            {
                let sV = Screen.GetTextScreenSize();
                xrpgPlayer.hud.AdjustMouse(e.Args[0], e.Args[1], sv);
            }
		}
        else if (e.Name ~== "GameMouseReset")
        {
            let xrpgPlayer = XRpgPlayer(player);
            if (xrpgPlayer && xrpgPlayer.hud)
                xrpgPlayer.hud.ResetMouse();
        }
        else if (e.Name ~== "GameMouseClicked")
        {
            let xrpgPlayer = XRpgPlayer(player);
            if (xrpgPlayer && xrpgPlayer.hud)
                xrpgPlayer.hud.MouseClicked();
        }
	}

    const EGenericEvent_Type_None = 0;
    const EGenericEvent_Type_KeyDown = 1;
    const EGenericEvent_Type_KeyUp = 2;
    const EGenericEvent_Type_Mouse = 3;
    const EGenericEvent_Type_GUI = 4;
    const EGenericEvent_Type_DeviceChange = 5;

    const INPUTEVENT_KEYSCAN_LEFTMOUSE = 256;
    const INPUTEVENT_KEYSCAN_RIGHTMOUSE = 257;

    override bool InputProcess (InputEvent e)
    {
        let currentPlayer = players[consoleplayer];
        if (!currentPlayer.mo)
            return false;

        let playerObj = XRpgPlayer(currentPlayer.mo);
        if (!playerObj)
            return false;
        
        //Get mouse position and ignore inputs while automap is active
        if (automapactive)
        {
            //Automap resets cursor position and does not not block inputs so map can close
            if (Bindings.GetBinding(e.KeyScan) ~== "togglemap")
            {
                EventHandler.SendNetworkEvent("GameMouseReset");
                return false;
            }
            //Handle mouse clicks, blocking input
            else if (e.KeyScan == INPUTEVENT_KEYSCAN_LEFTMOUSE && e.Type == EGenericEvent_Type_KeyUp)
            {
                EventHandler.SendNetworkEvent("GameMouseClicked", 1);
                return true;
            }
            //Allow console, keyup (move releases), and automap commands to work without blocking input
            else if (Bindings.GetBinding(e.KeyScan) ~== "toggleconsole" || e.Type == EGenericEvent_Type_KeyUp || !(AutomapBindings.GetBinding(e.KeyScan) ~== ""))
            {
                return false;
            }

            //UI events have to be forwared to game events
            EventHandler.SendNetworkEvent("GameMouseMoved", e.MouseX, e.MouseY);
            
            return true;
        }

        return false; 
    }
}