package com.behindcurtain3 
{
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Assets 
	{		
		public static const VERSION:String = "v0.01";
		
		// Board
		[Embed(source = '../../../assets/Board/Board.png')] public static const GFX_BOARD:Class;
		
		// Towers
		[Embed(source = '../../../assets/Tower Tiles/Basic-Tower.png')] public static const GFX_TOWER_BASIC:Class;
		
		// Creeps
		[Embed(source = '../../../assets/Creeps/Pig.png')] public static const GFX_CREEP_PIG:Class;
		
		// Sounds
		[Embed(source = '../../../assets/sfx/invalid.mp3')] public static const SFX_INVALID:Class;
		
		// Misc
		[Embed(source = '../../../assets/glow.png')] public static const GFX_GLOW:Class;
		
	}

}