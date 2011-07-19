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
	}

}