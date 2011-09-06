package com.behindcurtain3
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.World;
	import playerio.*;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class LoginWorld extends World 
	{
		private var client:Client;
		private var connection:Connection;
		
		protected var titleLeft:Image;
		protected var titleRight:Image;
		protected var titleText:Text;
		
		public function LoginWorld(client:Client) 
		{
			this.client = client;
			
			// Title
			titleLeft = new Image(Assets.GFX_TITLE_LEFT);
			titleRight = new Image(Assets.GFX_TITLE_RIGHT);
			var str:String = "Waiting for an opponent";
			titleText = new Text(str, 0, FP.screen.height - 100, FP.screen.width, 200);
			titleText.font = "Domo";
			titleText.size = 24;
			titleText.x = FP.screen.width / 2 - (titleText.text.length / 2 * 10);
			
			addGraphic(titleLeft, 1, 0, 0);
			addGraphic(titleRight, 1, 400, 0);
			addGraphic(titleText);
			
			//Set developmentsever (Comment out to connect to your server online)
			client.multiplayer.developmentServer = "192.168.0.169:8184";
			
			//Create pr join the room test
			client.multiplayer.createJoinRoom(
				"match-maker2",							//Room id. If set to null a random roomid is used
				"$service-room$",					//The game type started on the server
				true,								//Should the room be visible in the lobby?
				{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
				{},									//User join data
				handleJoin,							//Function executed on successful joining of the room
				handleClientError					//Function executed if we got a join error
			);	
			
		}
		
		override public function update():void 
		{
			if (titleText.alpha == 0)
			{
				var alphaTween:VarTween = new VarTween();
				alphaTween.tween(titleText, "alpha", 1, 0.5);
				addTween(alphaTween, true);
			}
			else if (titleText.alpha == 1)
			{
				var alphaTween:VarTween = new VarTween();
				alphaTween.tween(titleText, "alpha", 0, 0.5);
				addTween(alphaTween, true);
			}
			
			super.update();
		}
		
		private function handleJoin(c:Connection):void
		{
			connection = c;
			
			connection.addMessageHandler(Messages.MATCH_ID, function(m:Message, gameId:String):void {
				connection.disconnect();
				FP.world = new GameWorld(client, gameId);
			});
		}
		
		private function handleConnectionError(error:PlayerIOError):void
		{
			trace(error.getStackTrace());
			FP.world = new MenuWorld("Connection: " + error.message);
		}
		
		private function handleClientError(error:PlayerIOError):void
		{
			trace(error.getStackTrace());
			FP.world = new MenuWorld("Client: " + error.message);
		}
		
		
	}

}