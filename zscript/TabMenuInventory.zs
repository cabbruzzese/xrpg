const TABMENU_SLOT_ICON_DEFAULT = "ARTIBOX";

class TabMenuItem : PowerupGiver
{
    TabMenuUIelement element;

    int displayHeight;
    int displayWidth;
    property DisplayHeight:displayHeight;
    property DisplayWidth:displayWidth;

    string menuSlotIcon;
    property MenuSlotIcon:menuSlotIcon;

    bool selectable;
    property Selectable:selectable;
    bool stopPropagation;
    property StopPropagation:stopPropagation;

    bool listable;
    property Listable:listable;

    Default
    {
        -INVENTORY.INVBAR

        TabMenuItem.MenuSlotIcon TABMENU_SLOT_ICON_DEFAULT;
        TabMenuItem.StopPropagation true;

        TabMenuItem.DisplayHeight 30;
        TabMenuItem.DisplayWidth 30;
    }

    override void PostBeginPlay()
    {
        if (!element)
        {
            element = new("TabMenuUIElement");
            element.Init("", (DisplayHeight, DisplayWidth), Selectable, StopPropagation);
        }
    }

    ui virtual bool CanRenderInventory()
    {
        return true;
    }
}