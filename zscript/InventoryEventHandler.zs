class InventoryEventHandler : EventHandler
{
    override void CheckReplacement(ReplaceEvent e)
	{
		if (e.Replacee is 'ArtiBoostArmor')
		{
            int magicItemNum = random[MagicItemSpawn](1,5);
            switch (magicItemNum)
            {
                case 1:
                    e.Replacement = 'DragonBracers';
                    break;
                case 2:
                    e.Replacement = 'FireRing';
                    break;
                case 3:
                    e.Replacement = 'IceRing';
                    break;
                case 4:
                    e.replacement = 'LightningRing';
                    break;
                case 5:
                    e.replacement = 'ShieldBracelet';
                    break;
            }
		}
        else if (e.replacee is 'ArtiSpeedBoots')
        {
            int magicItemNum = random[MagicItemSpawn](1,3);
            switch (magicItemNum)
            {
                case 1:
                    e.Replacement = 'BootsOfSpeed';
                    break;
                case 2:
                    e.Replacement = 'PhoenixBracers';
                    break;
                case 3:
                    e.Replacement = 'ShadowRing';
                    break;
            }
        }
        else if (e.replacee is 'AmuletOfWarding')
        {
            int magicItemNum = random[MagicItemSpawn](1,3);
            switch (magicItemNum)
            {
                case 1:
                    e.Replacement = 'WardingAmulet';
                    break;
                case 2:
                    e.Replacement = 'RegenAmulet';
                    break;
                case 3:
                    e.replacement = 'ManaAmulet';
                    break;
            }
        }
        else if (e.Replacee is 'FalconShield')
		{
            int magicItemNum = random[MagicItemSpawn](1,3);
            switch (magicItemNum)
            {
                case 1:
                    e.Replacement = 'FalconLargeShield';
                    break;
                case 2:
                    e.Replacement = 'RoundShield';
                    break;
                case 3:
                    e.Replacement = 'SilverSmallShield';
                    break;
            }
		}
        else if (e.Replacee is 'MeshArmor')
        {
            int magicItemNum = random[MagicItemSpawn](1,10);
            switch (magicItemNum)
            {
                case 1:
                case 2:
                    e.Replacement = 'MeshBodyArmor';
                    break;
                case 3:
                case 4:
                    e.Replacement = 'LeatherBodyArmor';
                    break;
                case 5:
                case 6:
                    e.Replacement = 'PlateMail';
                    break;
                case 7:
                case 8:
                    e.Replacement = 'HalfPlate';
                    break;
                //Small chance for magic robes or dragon scale
                case 9:
                    e.Replacement = 'MagicRobes';
                    break;
                case 10:
                    e.Replacement = 'DragonScaleArmor';
                    break;
            }
        }
        else if (e.Replacee is 'PlatinumHelm')
        {
            int magicItemNum = random[MagicItemSpawn](1,3);
            switch (magicItemNum)
            {
                case 1:
                    e.Replacement = 'PlatinumHelmet';
                    break;
                case 2:
                    e.Replacement = 'MetalCap';
                    break;
                case 3:
                    e.Replacement = 'WingedHelmet';
                    break;
            }
        } 
	}
}