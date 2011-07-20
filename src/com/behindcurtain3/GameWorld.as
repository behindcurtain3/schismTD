package com.behindcurtain3
{
	import flash.display.ActionScriptVersion;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Draw;
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
		
		private var consoleDisplayTime:Number = 5;
		
		// Gfx
		protected var board:Image;
		
		// Networking
		protected var client:Client;
		protected var connection:Connection;
		
		// Game
		private var gameActive:Boolean = false;
		private var gameCountdown:int = 0;
		private var dragStart:Point = null;
		private var dragEnd:Point = null;
	 
		public function GameWorld ()
		{
			// Setup gfx
			board = new Image(Assets.GFX_BOARD);
			board.alpha = 0;
			addGraphic(board, 10, 0, 43);
			
			chatbox = new PunkTextField("", 10, FP.screen.height - 30, FP.screen.width - 20);
			chatbox.visible = false;
			add(chatbox);
			
			addToChat("Connecting...");
			
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

			if (gameActive)
			{
			
				if (Input.mousePressed)
				{
					dragStart = new Point(Input.mouseX, Input.mouseY);
				}
				
				if (Input.mouseReleased)
				{
					dragEnd = new Point(Input.mouseX, Input.mouseY);
					
					if (connection != null)
					{
						//connection.send(Messages.GAME_PLACE_WALL, dragStart.x, dragStart.y, dragEnd.x, dragEnd.y);
						connection.send(Messages.GAME_PLACE_TOWER, dragEnd.x, dragEnd.y);
					}
					
					dragStart = null;
					dragEnd = null;
				}
			}
			
			if (Input.pressed(Key.ESCAPE))
			{
				disconnect();
			}
			/*
			var walls:Array = new Array();
			this.getClass(Wall, walls);
			for each(var w:Wall in walls)
			{
				Draw.linePlus(w.Start.x, w.Start.y, w.End.x, w.End.y, 0xFFFFFF, 1, 3);
			}
			*/
			
			super.update();
		}
		
		private function disconnect(message:String = ""):void
		{
			addToChat("Disconnected");
			
			if(connection != null)
				connection.disconnect();
				
			FP.world = new MenuWorld(message);
		}
		
		private function handleConnect(c:Client):void
		{
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
			
			connection.addMessageHandler(Messages.GAME_COUNTDOWN, function(m:Message, i:Number):void {
				i = Math.ceil(i / 1000);
				if (i != gameCountdown)
				{
					addToChat("Starting in ... " + i, 1.5);
					gameCountdown = i;
				}
			});
			
			connection.addMessageHandler(Messages.GAME_START, function(m:Message):void {
				addToChat("Game started!");				
				gameActive = true;
			});
			
			connection.addMessageHandler(Messages.GAME_FINISHED, function(m:Message):void {
				gameActive = false;
			});
			
			connection.addMessageHandler(Messages.GAME_PLACE_WALL, function(m:Message, x1:int, y1:int, x2:int, y2:int):void {
				addToChat("Place wall at (" + x1 + "," + y1 + ") to (" + x2 + "," + y2 + ")");
				add(new Wall(new Point(x1, y1), new Point(x2, y2)));
			});
			
			connection.addMessageHandler(Messages.GAME_INVALID_WALL, function(m:Message, x1:int, y1:int, x2:int, y2:int):void {
				addToChat("Invalid wall placement!");
			});
			
			connection.addDisconnectHandler(function():void {
				disconnect("Connection to server lost");
			});
		}
		
		private function handleError(error:PlayerIOError):void
		{
			addToChat(error.message);		
			disconnect(error.message);
		}
		
		public function addToChat(s:String, time:Number = 4):void
		{
			var t:Text = new Text(s, 10, FP.screen.height - 60, FP.screen.width - 20, 20);
			var vt:VarTween = new VarTween();
			vt.tween(t, "alpha", 0, time, Ease.quadIn);
			
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