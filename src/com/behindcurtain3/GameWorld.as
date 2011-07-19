package com.behindcurtain3
{
	import flash.display.ActionScriptVersion;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import playerio.*;
	
	import punk.ui.PunkTextArea;
	import punk.ui.PunkTextField;

	import punk.ui.PunkLabel;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class GameWorld extends World 
	{
		// UI
		protected var chatbox:PunkTextField;
		private var console:Array = new Array();
		protected var statusText:Text;
		
		private var consoleDisplayTime:Number = 5;
		
		// Gfx
		protected var board:Image;
		
		// Networking
		protected var client:Client;
		protected var connection:Connection;
	 
		public function GameWorld ()
		{
			// Setup gfx
			board = new Image(Assets.GFX_BOARD);
			board.x = 0;
			board.y = 0;
			board.scale = 0.2;
			board.alpha = 0;
			addGraphic(board);
			
			chatbox = new PunkTextField("", 10, FP.screen.height - 30, FP.screen.width - 20);
			chatbox.visible = false;
			add(chatbox);
			
			statusText = new Text("Connecting to server...", 10, 10, FP.screen.width - 20, 50);
			addGraphic(statusText);
			
			PlayerIO.connect(
				FP.stage,								//Referance to stage
				"schismtd-3r3otmhvkki9ixublwca",		//Game id (Get your own at playerio.com. 1: Create user, 2:Goto admin pannel, 3:Create game, 4: Copy game id inside the "")
				"public",							//Connection id, default is public
				"GuestUser",						//Username
				"",									//User auth. Can be left blank if authentication is disabled on connection
				null,								//Current PartnerPay partner.
				handleConnect,						//Function executed on successful connect
				handleError							//Function executed if we recive an error
			); 
			
		}
		
		override public function end():void
		{
			if (connection != null)
			{
				connection.disconnect();
			}
			removeAll();
			super.end();
		}
		
		override public function update():void
		{
			if (Input.pressed(Key.ENTER))
			{
				if (chatbox.text != "")
				{
					connection.send(Messages.CHAT, chatbox.text);
					chatbox.text = "";
				}
			}
			
			if (Input.pressed(Key.ESCAPE))
			{
				disconnect();
			}
			super.update();
		}
		
		private function disconnect():void
		{
			addToChat("Disconnected");
			
			if(connection != null)
				connection.disconnect();
				
			FP.world = new MenuWorld();
		}
		
		private function handleConnect(c:Client):void
		{
			trace("Sucessfully connected to player.io");
			
			client = c;
			
			//Set developmentsever (Comment out to connect to your server online)
			client.multiplayer.developmentServer = "127.0.0.1:8184";
			
			//Create pr join the room test
			client.multiplayer.createJoinRoom(
				"schismTD",							//Room id. If set to null a random roomid is used
				"schismTD",							//The game type started on the server
				true,								//Should the room be visible in the lobby?
				{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
				{},									//User join data
				handleJoin,							//Function executed on successful joining of the room
				handleError							//Function executed if we got a join error
			);
		}
		
		private function handleJoin(c:Connection):void
		{
			addToChat("Connected");
			connection = c;
			
			chatbox.visible = true;
			statusText.text = "";
			
			connection.addMessageHandler(Messages.CHAT, function(m:Message, s:String):void {
				addToChat(s);
			});
			
			connection.addMessageHandler(Messages.PLAYER_JOINED, function(m:Message, i:int):void {
				addToChat("Player #" + i + " has joined");
			});
			
			connection.addMessageHandler(Messages.PLAYER_LEFT, function(m:Message, i:int):void {
				addToChat("Player #" + i + " has left");
			});
			
			connection.addMessageHandler(Messages.MATCH_READY, function(m:Message):void {
				addToChat("Match ready to begin!");
			});
			
			connection.addMessageHandler(Messages.MATCH_STARTED, function(m:Message):void {
				addToChat("Matched started!");
				
				var vt:VarTween = new VarTween();
				vt.tween(board, "alpha", 1, 2.5, Ease.expoOut);
				addTween(vt, true);
			});
			
			connection.addMessageHandler(Messages.MATCH_FINISHED, function(m:Message):void {
				addToChat("Matched finished!");
				var vt:VarTween = new VarTween();
				vt.tween(board, "alpha", 0, 1.5, Ease.expoOut);
				addTween(vt, true);
			});
			
			connection.addMessageHandler(Messages.GAME_COUNTDOWN, function(m:Message, i:int):void {
				statusText.alpha = 1;
				statusText.text = "Starting in ... " + Math.ceil(i / 1000);
			});
			
			connection.addMessageHandler(Messages.GAME_START, function(m:Message):void {
				addToChat("Game started!");
				statusText.text = "Begin!";
				var ft:VarTween = new VarTween();
				ft.tween(statusText, "alpha", 0, 2.5, Ease.expoIn);
				addTween(ft, true);
			});
			
			connection.addDisconnectHandler(function():void {
				disconnect();
			});
		}
		
		private function handleError(error:PlayerIOError):void
		{
			addToChat(error.message);		
			disconnect();
		}
		
		public function addToChat(s:String):void
		{
			var t:Text = new Text(s, 10, FP.screen.height - 100, FP.screen.width - 20, 20);
			var vt:VarTween = new VarTween();
			vt.tween(t, "alpha", 0, consoleDisplayTime, Ease.quadIn);
			
			addGraphic(t);
			addTween(vt);
			
			for each(var text:Text in console)
			{
				text.y -= 20;
			}
			
			console.push(t);
		}
		
	}
}