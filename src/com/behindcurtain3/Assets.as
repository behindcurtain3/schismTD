package com.behindcurtain3 
{
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Assets 
	{		
		public static const VERSION:String = "v0.02";
		
		[Embed(source = '../../../assets/title-left.png')] public static const GFX_TITLE_LEFT:Class;
		[Embed(source = '../../../assets/title-right.png')] public static const GFX_TITLE_RIGHT:Class;
		
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
		[Embed(source = '../../../assets/creeps/Chigen.png')] public static const GFX_CREEP_CHIGEN:Class;
		[Embed(source = '../../../assets/creeps/Regen.png')] public static const GFX_CREEP_REGEN:Class;
		[Embed(source = '../../../assets/creeps/Quick.png')] public static const GFX_CREEP_QUICK:Class;
		[Embed(source = '../../../assets/creeps/Magic.png')] public static const GFX_CREEP_MAGIC:Class;
		[Embed(source = '../../../assets/creeps/Armor.png')] public static const GFX_CREEP_ARMOR:Class;
		[Embed(source = '../../../assets/creeps/Swarm.png')] public static const GFX_CREEP_SWARM:Class;
		
		// Sounds
		[Embed(source = '../../../assets/sfx/invalid.mp3')] public static const SFX_INVALID:Class;
		
		// Misc
		[Embed(source = '../../../assets/glow.png')] public static const GFX_GLOW:Class;
		
	}

}