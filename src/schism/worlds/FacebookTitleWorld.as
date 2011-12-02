package schism.worlds 
{
	import flash.net.SharedObject;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import playerio.Client;
	import playerio.Connection;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	import playerio.PlayerIORegistrationError;
	import schism.Assets;
	import schism.ui.CustomMouse;
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
		
		private var facebook:Image;
		
		public function FacebookTitleWorld (error:String = "")
		{	
			sharedObject = SharedObject.getLocal("schismTDdata");
			super(sharedObject.data.fbtoken == null);
			
			// Play menu music
			music.play();			
			
			if (error != "")
			{
				showMessage(error);
				messageDisplay.sound();
			}		
			
			// If no fbtoken, login the user
			if (sharedObject.data.fbtoken == null)
			{						
				var width:int = 250;
				var uiX:int = FP.screen.width / 2 - width / 2;
				var spacer:int = 25;
				
				// Background				
				var b:PunkButton = new PunkButton(uiX, FP.screen.height / 2 - 25, width, 50, "Play as Guest", onPlayTest)
				add(b);
				
				b = new PunkButton(uiX, FP.screen.height / 2 - 25 - 60, width, 50, "Login/Register", onLoginClick)
				add(b);
				
				b = new PunkButton(uiX, FP.screen.height / 2 - 25 + 60, width, 50, "How to Play", onHowToPlay)
				add(b);
				
				add(new MessageDisplay("", 0, 36, FP.screen.width / 2, FP.screen.height / 2, width + 35, 205));
				//addGraphic(new Text(Assets.VERSION, 0, FP.screen.height - 15, 50, 15));
				
				showMessage("\nSchismTD is a multiplayer tower defense game.\n\nBuild custom waves of creeps and play in a competive\nenvironment to prove you are the best tower defender!\n\n", 0);
				
			}
			// Use the token we have
			else
			{				
				showMessage("Logging in ...", 0);
				
				PlayerIO.quickConnect.facebookOAuthConnect(
					FP.stage, Assets.GAME_ID, sharedObject.data.fbtoken, "",
					function(c:Client, facebookUserId:String):void {
						AuthWorld.accessToken = sharedObject.data.fbtoken;
						FP.world = new HomeWorld(c);
					},
					function(e:PlayerIOError):void {
						showMessage(e.message);
						sharedObject.data.fbtoken = null;
						FP.world = new FacebookTitleWorld(e.message);
					});
			}			
			
			facebook = new Image(Assets.GFX_MISC_FB);
			facebook.x = FP.screen.width - facebook.width;
			facebook.y = FP.screen.height - facebook.height;
			addGraphic(facebook);
			
			var tmp:Text = new Text(Assets.VERSION);
			addGraphic(new Text(Assets.VERSION, FP.screen.width - tmp.textWidth - facebook.width - 3, FP.screen.height - 15, { outlineColor: 0x000000, outlineStrength: 2, font: "Domo" } ));
		}
		
		override public function end():void
		{
			removeAll();
			super.end();
		}
		
		override public function update():void 
		{
			if (Input.mouseX > facebook.x && Input.mouseX < facebook.x + facebook.width && Input.mouseY > facebook.y && Input.mouseY < facebook.y + facebook.height)
			{
				Mouse.show();
				Mouse.cursor = MouseCursor.BUTTON;
				(FP.stage.getChildByName("CustomMouse") as CustomMouse).visible = false;

				if (Input.mousePressed)
				{
					var goto:URLRequest = new URLRequest("https://www.facebook.com/pages/SchismTD/231809410207524");
					navigateToURL(goto, "_blank");
				}
			}
			else
			{
				Mouse.hide();
				Mouse.cursor = MouseCursor.ARROW;
				(FP.stage.getChildByName("CustomMouse") as CustomMouse).visible = true;
			}
			
			super.update();
		}
		
		public function onLoginClick():void
		{
			PlayerIO.quickConnect.facebookOAuthConnectPopup(
					FP.stage, Assets.GAME_ID, "_blank", ["publish_stream","offline_access"], "",
					function(c:Client, access_token:String, facebookUserId:String):void {
						AuthWorld.accessToken = access_token;
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
		
		public function onHowToPlay():void
		{			
			FP.world = new HowToPlayWorld(null);
		}
		
	}

}