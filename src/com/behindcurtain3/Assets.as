package com.behindcurtain3 
{
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Assets 
	{
		private static const assetPath:String = "../../../assests/";
		
		// Character Sprites
		[Embed(source = '../../../assets/gfx/Sprite_Skeleton.png')]	public static const SKELETON_GFX:Class;

		// Tile sets
		[Embed(source = '../../../assets/gfx/Tilesheet.png')] public static const TILES:Class;
		
		// Levels
		[Embed(source = '../../../assets/levels/welcome.oel', mimeType = "application/octet-stream")] public static const LEVEL_WELCOME:Class;
		[Embed(source = '../../../assets/levels/mortuary.oel', mimeType = "application/octet-stream")] public static const LEVEL_MORTUARY:Class;
		
		// Fonts
		[Embed(source = '../../../assets/ZOMBIE.ttf', embedAsCFF="false", fontFamily = 'ZombieFont')] public static const FONT_ZOMBIE:Class
		
	}

}