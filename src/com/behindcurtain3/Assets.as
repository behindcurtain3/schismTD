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
		[Embed(source = '../../../assets/board/board.png')] public static const GFX_BOARD:Class;
		
		// Towers
		[Embed(source = '../../../assets/towers/basic.png')] public static const GFX_TOWER_BASIC:Class;
		[Embed(source = '../../../assets/towers/rapidfire.png')] public static const GFX_TOWER_RAPIDFIRE:Class;
		[Embed(source = '../../../assets/towers/slow.png')] public static const GFX_TOWER_SLOW:Class;
		[Embed(source = '../../../assets/towers/pulse.png')] public static const GFX_TOWER_PULSE:Class;
		[Embed(source = '../../../assets/towers/sniper.png')] public static const GFX_TOWER_SNIPER:Class;
		[Embed(source = '../../../assets/towers/spell.png')] public static const GFX_TOWER_SPELL:Class;
		[Embed(source = '../../../assets/towers/seed.png')] public static const GFX_TOWER_SEED:Class;
		
		// Creeps
		[Embed(source = '../../../assets/creeps/Pig.png')] public static const GFX_CREEP_BASIC:Class;
		[Embed(source = '../../../assets/creeps/Monkey.png')] public static const GFX_CREEP_CHIGEN:Class;
		
		// Sounds
		[Embed(source = '../../../assets/sfx/invalid.mp3')] public static const SFX_INVALID:Class;
		
		// Misc
		[Embed(source = '../../../assets/glow.png')] public static const GFX_GLOW:Class;
		
	}

}