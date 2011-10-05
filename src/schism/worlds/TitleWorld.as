package schism.worlds
{
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.system.Security;
	import net.flashpunk.utils.Draw;
	import playerio.Client;
	import playerio.Connection;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	import playerio.PlayerIORegistrationError;
	import schism.Assets;
	import schism.ui.MessageDisplay;
	
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	
	import punk.ui.PunkButton;
	import punk.ui.PunkLabel;
	import punk.ui.PunkPasswordField;
	import punk.ui.PunkTextArea;
	import punk.ui.PunkTextField;
	import punk.ui.PunkToggleButton;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class TitleWorld extends World 
	{		
		// Messages
		protected var messageDisplay:MessageDisplay;

		// Kongregate API reference
		protected var kongregate:*;
		
		// Client
		protected var _client:Client;
		
		public function TitleWorld (error:String = "")
		{
			var width:int = 250;
			var uiX:int = FP.screen.width / 2 - width / 2;
			var uiY:int = 225;
			var spacer:int = 25;
			
			// Background
			addGraphic(new Image(Assets.GFX_BACKGROUND), 100);
			addGraphic(new Image(Assets.GFX_TITLE), 99, FP.screen.width / 2 - 275, 50);
			
			var b:PunkButton = new PunkButton(uiX, FP.screen.height / 2 - 25, width, 50, "Play as Guest", onPlayTest)
			b.label.font = "Domo";
			add(b);
			
			b = new PunkButton(uiX, FP.screen.height / 2 - 25 + 60, width, 50, "Login", onLoginClick)
			b.label.font = "Domo";
			add(b);
			
			b = new PunkButton(uiX, FP.screen.height / 2 - 25 + 120, width, 50, "Register", onRegister)
			b.label.font = "Domo";
			add(b);
			
			add(new MessageDisplay("", 0, 36, FP.screen.width / 2, FP.screen.height / 2 + 60, width + 35, 205));
			
			addGraphic(new Text(Assets.VERSION, 0, FP.screen.height - 15, 50, 15));
			
			if (error != "")
			{
				messageDisplay = new MessageDisplay(error, 5, 18, FP.screen.width / 2);
				messageDisplay.sound();
				add(messageDisplay);
			}
			
		}
		
		override public function end():void
		{
			removeAll();
			super.end();
		}
		
		override public function begin():void 
		{
			super.begin();
			/*
			// Pull the API path from the FlashVars
			var paramObj:Object = LoaderInfo(FP.stage.loaderInfo).parameters;

			// The API path. The "shadow" API will load if testing locally. 
			var apiPath:String = paramObj.kongregate_api_path || "http://www.kongregate.com/flash/API_AS3_Local.swf";

			// Allow the API access to this SWF
			Security.allowDomain(apiPath);

			// Load the API
			var request:URLRequest = new URLRequest(apiPath);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, kongLoadComplete);
			loader.load(request);
			FP.stage.addChild(loader);
			*/
		}
		
		public function onLoginClick():void
		{
			FP.world = new LoginWorld();
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
			if (messageDisplay != null)
				remove(messageDisplay);

			switch(e.type)
			{
				case PlayerIOError.NoServersAvailable:
					messageDisplay = new MessageDisplay("There are no game servers currently available.", 5);
					break;
				default:
					messageDisplay = new MessageDisplay(e.message, 5);
					break;
			}				
			messageDisplay.sound();
			add(messageDisplay);
		}
		
		public function onRegister():void
		{			
			FP.world = new RegisterWorld();
		}
		
		public function kongLoadComplete(event:Event):void
		{
			trace("Kong loaded.");
			kongregate = event.target.content;
			
			//trace(kongregate.services.getUserId());
			trace(kongregate.services.getGameAuthToken());
		}
		
	}
}