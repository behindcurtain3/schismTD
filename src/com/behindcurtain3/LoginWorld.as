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
		private var playerName:String;
		private var playerPassword:String;
		
		protected var titleLeft:Image;
		protected var titleRight:Image;
		protected var titleText:Text;
		
		public function LoginWorld(userName:String, password:String) 
		{
			// Title
			titleLeft = new Image(Assets.GFX_TITLE_LEFT);
			titleRight = new Image(Assets.GFX_TITLE_RIGHT);
			var str:String = "Authenticating";
			titleText = new Text(str, FP.screen.width / 2 - (str.length / 2 * 10), FP.screen.height - 100, FP.screen.width);
			
			addGraphic(titleLeft, 1, 0, 0);
			addGraphic(titleRight, 1, 400, 0);
			addGraphic(titleText);
			
			playerName = userName;
			playerPassword = password;
			
			PlayerIO.connect(
				FP.stage,								//Referance to stage
				"schismtd-3r3otmhvkki9ixublwca",		//Game id (Get your own at playerio.com. 1: Create user, 2:Goto admin pannel, 3:Create game, 4: Copy game id inside the "")
				"public",							//Connection id, default is public
				userName,							//Username
				"",									//User auth. Can be left blank if authentication is disabled on connection
				null,								//Current PartnerPay partner.
				handleConnect,						//Function executed on successful connect
				handleError							//Function executed if we recive an error
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
		
		private function handleConnect(c:Client):void
		{
			client = c;
			
			//Set developmentsever (Comment out to connect to your server online)
			client.multiplayer.developmentServer = "127.0.0.1:8184";
			
			var userSettings:Object = {name:playerName, password:playerPassword};
			
			//Create pr join the room test
			client.multiplayer.createJoinRoom(
				"lobby",							//Room id. If set to null a random roomid is used
				"$service-room$",					//The game type started on the server
				true,								//Should the room be visible in the lobby?
				{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
				userSettings,						//User join data
				handleJoin,							//Function executed on successful joining of the room
				handleError							//Function executed if we got a join error
			);	
		}
		
		private function handleJoin(c:Connection):void
		{
			connection = c;
			
			titleText.text = "Waiting for an opponent";
			titleText.x = FP.screen.width / 2 - (titleText.text.length / 2 * 10);
			
			connection.addMessageHandler(Messages.MATCH_ID, function(m:Message, gameId:String):void {
				connection.disconnect();
				FP.world = new GameWorld(new GameSettings(client, playerName, playerPassword, gameId));
			});
		}
		
		private function handleError(error:PlayerIOError):void
		{
			FP.world = new MenuWorld(error.message);
		}
		
	}

}