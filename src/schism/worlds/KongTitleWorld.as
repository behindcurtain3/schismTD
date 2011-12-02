package schism.worlds 
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import playerio.Client;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	import punk.ui.PunkButton;
	import schism.Assets;
	import schism.ui.CustomMouse;
	import schism.ui.MessageDisplay;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class KongTitleWorld extends SchismWorld 
	{
		private var facebook:Image;
		
		public function KongTitleWorld(error:String = "") 
		{
			if (error != "")
				showMessage(error);
			
			AuthWorld.isKongUser = true;				
			super();
		}
		
		override public function begin():void 
		{
			super.begin();
			
			QuickKong.connectToKong(FP.stage, onKongConnect);
		}
		
		public function onKongConnect():void
		{
			if (QuickKong.services.isGuest())
			{
				// Play menu music
				music.play();	
				
				// Background				
				var b:PunkButton = new PunkButton(FP.screen.width / 2 - 125, FP.screen.height / 2 - 25, 250, 50, "Play as Guest", onPlayTest)
				add(b);
				
				b = new PunkButton(FP.screen.width / 2 - 125, FP.screen.height / 2 - 85, 250, 50, "Login with Kongregate", QuickKong.services.showSignInBox)
				add(b);
				
				b = new PunkButton(FP.screen.width / 2 - 125, FP.screen.height / 2 + 35, 250, 50, "How to Play", onHowToPlay)
				add(b);
				
				add(new MessageDisplay("", 0, 36, FP.screen.width / 2, FP.screen.height / 2, 285, 205));
				
				// Listen for a guest->user conversion, which can happen without a refresh
				QuickKong.services.addEventListener("login", onKongregateInPageLogin);
				
				showMessage("\nSchismTD is a multiplayer tower defense game.\n\nBuild custom waves of creeps and play in a competive\nenvironment to prove you are the best tower defender!\n\n", 0);
				
				facebook = new Image(Assets.GFX_MISC_FB);
				facebook.x = FP.screen.width - facebook.width;
				facebook.y = FP.screen.height - facebook.height;
				addGraphic(facebook);

				var tmp:Text = new Text(Assets.VERSION);
				addGraphic(new Text(Assets.VERSION, FP.screen.width - tmp.textWidth - facebook.width - 3, FP.screen.height - 15, { outlineColor: 0x000000, outlineStrength: 2, font: "Domo" } ));
			}
			else
			{
				doKongQuickConnect();
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if (facebook == null)
				return;
				
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
		}
		
		private function onKongregateInPageLogin(event:Event):void{
			// Log in with new credentials here
			AuthWorld.playerName = QuickKong.api.services.getUsername();
			doKongQuickConnect();
		}
		
		private function doKongQuickConnect():void
		{
			showMessage("Logging in...", 0);
			
			//Connect to Player.IO
			PlayerIO.quickConnect.kongregateConnect(
				FP.stage, 
				Assets.GAME_ID, 
				QuickKong.api.services.getUserId(), 
				QuickKong.api.services.getGameAuthToken(), 
				function(client:Client):void {
					AuthWorld.isKongUser = true;
					AuthWorld.accessToken = QuickKong.api.services.getGameAuthToken();
					FP.world = new HomeWorld(client);
				}, function(e:PlayerIOError):void{
					showMessage(e.message);
				}
			);
		}
		
		public function onPlayTest():void
		{			
			showMessage("Logging in...", 0);
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
			FP.world = new MatchFinderWorld(client, true);
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