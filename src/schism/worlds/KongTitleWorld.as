package schism.worlds 
{
	import flash.events.Event;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import playerio.Client;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	import punk.ui.PunkButton;
	import schism.Assets;
	import schism.ui.MessageDisplay;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class KongTitleWorld extends SchismWorld 
	{
		public function KongTitleWorld(error:String = "") 
		{
			if (error != "")
				showMessage(error);
				
			addGraphic(new Image(Assets.GFX_MENUBG), 100);
			addGraphic(new Image(Assets.GFX_TITLE), 99, FP.screen.width / 2 - 275, 50);
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
				// Background				
				var b:PunkButton = new PunkButton(FP.screen.width / 2 - 125, FP.screen.height / 2, 250, 50, "Play as Guest", onPlayTest)
				add(b);
				
				b = new PunkButton(FP.screen.width / 2 - 125, FP.screen.height / 2 - 75, 250, 50, "Login with Kongregate", QuickKong.services.showSignInBox)
				add(b);
				
				// Listen for a guest->user conversion, which can happen without a refresh
				QuickKong.services.addEventListener("login", onKongregateInPageLogin);
			}
			else
			{
				doKongQuickConnect();
			}
		}
		
		private function onKongregateInPageLogin(event:Event):void{
			// Log in with new credentials here
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
		
	}

}