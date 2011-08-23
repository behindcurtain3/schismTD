package com.behindcurtain3 
{
	import playerio.Client;
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class GameSettings 
	{
		public var client:Client;
		public var name:String;
		public var password:String;
		public var gameId:String;
			
		public function GameSettings(c:Client, n:String, pw:String, id:String)
		{
			client = c;
			name = n;
			password = pw;
			gameId = id;
		}		
	}
}