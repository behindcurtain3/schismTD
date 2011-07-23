package com.behindcurtain3 
{
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Messages 
	{
		public static const CHAT:String = "chat_message";
		public static const PLAYER_JOINED:String = "player_joined";
		public static const PLAYER_LEFT:String = "player_left";
		
		// match
		public static const MATCH_READY:String = "match_ready"; // Called when 2 players have joined
		public static const MATCH_STARTED:String = "match_start"; //Called when match actually starts
		public static const MATCH_FINISHED:String = "match_finish";
		
		// game
		public static const GAME_COUNTDOWN:String = "game_countdown"; // Countdown status at start of each game
        public static const GAME_START:String = "game_start";
        public static const GAME_FINISHED:String = "game_finish";
		public static const GAME_MANA:String = "game_mana";
        public static const GAME_LIFE:String = "game_life";
		
		public static const GAME_ADD_CELL:String = "game_add_cell";

        public static const GAME_PLACE_WALL:String = "game_place_wall";
        public static const GAME_REMOVE_WALL:String = "game_remove_wall";
        public static const GAME_INVALID_WALL:String = "game_invalid_wall";
		
		public static const GAME_PLACE_TOWER:String = "game_place_tower";
        public static const GAME_REMOVE_TOWER:String = "game_remove_tower";
        public static const GAME_INVALID_TOWER:String = "game_invalid_tower";
		
		public static const GAME_CREEP_ADD:String = "game_creep_add";
        public static const GAME_CREEP_REMOVE:String = "game_creep_remove";
        public static const GAME_CREEP_UPDATE:String = "game_creep_update";
	}

}