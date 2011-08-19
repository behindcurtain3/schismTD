package com.behindcurtain3 
{
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Messages 
	{
		public static const CHAT:String = "cm";
		public static const PLAYER_JOINED:String = "pj";
		public static const PLAYER_LEFT:String = "pl";
		public static const PLAYER_MANA:String = "pm";
        public static const PLAYER_LIFE:String = "pli";
		
		// match
		public static const MATCH_READY:String = "mr"; // Called when 2 players have joined
		public static const MATCH_STARTED:String = "ms"; //Called when match actually starts
		public static const MATCH_FINISHED:String = "mf";
		
		// game
		public static const GAME_COUNTDOWN:String = "gc"; // Countdown status at start of each game
		public static const GAME_ACTIVATE:String = "ga";
        public static const GAME_START:String = "gs";
        public static const GAME_FINISHED:String = "gf";
		
		public static const GAME_CELL_ADD:String = "gca";

		public static const GAME_TOWER_PLACE:String = "gtp";
        public static const GAME_TOWER_REMOVE:String = "gtr";
        public static const GAME_TOWER_INVALID:String = "gti";
		public static const GAME_TOWER_UPGRADE:String = "gtu";
		public static const GAME_TOWER_SELL:String = "gts";
		
		public static const GAME_CREEP_ADD:String = "gcra";
        public static const GAME_CREEP_REMOVE:String = "gcrr";
		public static const GAME_CREEP_PATH:String = "gcrp";
		public static const GAME_ALL_CREEPS_PATH:String = "gacrp";
		public static const GAME_CREEP_UPDATE_LIFE:String = "gcrul";
		public static const GAME_CREEP_EFFECT:String = "gcre";
		
		public static const GAME_PROJECTILE_ADD:String = "gpa";
        public static const GAME_PROJECTILE_REMOVE:String = "gpr";
        public static const GAME_PROJECTILE_UPDATE:String = "gpu";
	}

}