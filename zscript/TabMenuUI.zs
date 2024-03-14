class TabMenuUIElement
{
    Vector2 displayPos;
    Vector2 displaySize;
    Vector2 renderPos;

    bool selectable;
    bool stopPropagation;

    string image;

    virtual void Init(string imageStr, vector2 size, bool selectableVal, bool stopPropagationVal)
    {
        image = imageStr;
        displaySize = size;
        selectable = selectableVal;
        stopPropagation = stopPropagationVal;
    }

    virtual bool Clicked()
    {
        return stopPropagation;
    }

    bool IsInBounds(Vector2 pos)
    {
        //console.printf(string.format("mx: %d my:%d x:%d y:%d w:%d h:%d", pos.X, -pos.Y, renderPos.X, renderPos.Y, renderPos.X + displaySize.X, renderPos.Y + displaySize.Y));

        return (pos.X >= renderPos.X && pos.X <= (renderPos.X + displaySize.X) &&
                -pos.Y >= renderPos.Y && -pos.Y <= (renderPos.Y + displaySize.Y));
    }

    void SetRenderPosition(Vector2 pos)
    {
        renderPos = (pos.X - (displaySize.X / 2), pos.Y);
        displayPos = pos;
    }
}

class PlayerUIElement : TabMenuUIElement
{
	PlayerPawn player;

    void Init(string imageStr, vector2 size, bool selectableVal, bool stopPropagationVal, Vector2 newPos, PlayerPawn playerObj)
    {
        super.Init(imageStr, size, selectableVal, stopPropagation);

        player = playerObj;
        displayPos = newPos;
        renderPos = (newPos.X - (size.X / 2), newPos.Y - (size.Y / 2));
    }

    override bool Clicked()
    {
        return super.Clicked();
    }
}

class ItemSlotElement : PlayerUIElement
{
	Inventory nextSlotItem;
}