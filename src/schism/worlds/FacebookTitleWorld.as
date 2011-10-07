package schism.worlds 
{
	import flash.net.SharedObject;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import playerio.Client;
	import playerio.Connection;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	import playerio.PlayerIORegistrationError;
	import schism.Assets;
	import schism.ui.MessageDisplay;
	import net.flashpunk.FP;
	import punk.ui.PunkButton;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class FacebookTitleWorld extends SchismWorld 
	{
		protected var sharedObject:SharedObject;

		// Kongregate API reference
		protected var kongregate:*;
		
		// Client
		protected var _client:Client;
		
		public function FacebookTitleWorld (error:String = "")
		{
			addGraphic(new Image(Assets.GFX_BACKGROUND), 100);
			addGraphic(new Image(Assets.GFX_TITLE), 99, FP.screen.width / 2 - 275, 50);
			
			if (error != "")
			{
				showMessage(error);
				messageDisplay.sound();
			}
			
			sharedObject = SharedObject.getLocal("schismTDdata");
			
			// If no fbtoken, login the user
			if (sharedObject.data.fbtoken == null)
			{		
				var width:int = 250;
				var uiX:int = FP.screen.width / 2 - width / 2;
				var uiY:int = 225;
				var spacer:int = 25;
				
				// Background				
				var b:PunkButton = new PunkButton(uiX, FP.screen.height / 2 - 25, width, 50, "Play as Guest", onPlayTest)
				add(b);
				
				b = new PunkButton(uiX, FP.screen.height / 2 - 25 + 60, width, 50, "Login", onLoginClick)
				add(b);
				
				b = new PunkButton(uiX, FP.screen.height / 2 - 25 + 120, width, 50, "Register", onRegister)
				add(b);
				
				add(new MessageDisplay("", 0, 36, FP.screen.width / 2, FP.screen.height / 2 + 60, width + 35, 205));
				
				addGraphic(new Text(Assets.VERSION, 0, FP.screen.height - 15, 50, 15));
				
			}
			// Use the token we have
			else
			{
				showMessage("Logging in ...");
				
				PlayerIO.quickConnect.facebookOAuthConnect(
					FP.stage, Assets.GAME_ID, sharedObject.data.fbtoken, "",
					function(c:Client, facebookUserId:String):void {
						FP.world = new HomeWorld(c);
					},
					function(e:PlayerIOError):void {
						showMessage(e.message);
					});
			}
		}
		
		override public function end():void
		{
			removeAll();
			super.end();
		}
		
		public function onLoginClick():void
		{
			PlayerIO.quickConnect.facebookOAuthConnectPopup(
					FP.stage, Assets.GAME_ID, "_blank", ["publish_stream","offline_access"], "",
					function(c:Client, access_token:String, facebookUserId:String):void {
						sharedObject.data.fbtoken = access_token;
						sharedObject.flush();
						FP.world = new HomeWorld(c, "Welcome to SchismTD");
					},
					function(e:PlayerIOError):void {
						showMessage(e.message);
					});
			//FP.world = new LoginWorld();
		}
		
		public function onPlayTest():void
		{			
			//Login for a user with QuickConnect for Simple Users
			PlayerIO.quickConnect.simpleConnect(
				FP.stage, 
				Assets.GAME_ID,
				"Admin", 
				"password", 
				onLoginSuccess,
				onLoginError
			);
		}
		
		private function onLoginSuccess(client:Client):void
		{
			_client = client;
			FP.world = new MatchFinderWorld(_client, true);
		}
		
		private function onLoginError(e:PlayerIOError):void
		{
			switch(e.type)
			{
				case PlayerIOError.NoServersAvailable:
					showMessage("There are no game servers currently available.");
					break;
				default:
					showMessage(e.message);
					break;
			}				
			messageDisplay.sound();
		}
		
		public function onRegister():void
		{			
			FP.world = new RegisterWorld();
		}
		
	}

}