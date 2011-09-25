package schism.worlds
{
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.system.Security;
	import net.flashpunk.utils.Draw;
	import playerio.Client;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	import playerio.PlayerIORegistrationError;
	import schism.Assets;
	import schism.ui.MessageDisplay;
	import schism.ui.MyMouse;
	
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
	public class LoginWorld extends World 
	{
		// Login
		protected var usernameL:PunkLabel;
		protected var username:PunkTextField;
		protected var passwordL:PunkLabel;
		protected var password:PunkPasswordField;
		
		// Messages
		protected var messageDisplay:MessageDisplay;

		// Kongregate API reference
		protected var kongregate:*;
		
		public function LoginWorld (error:String = "")
		{
			var width:int = 250;
			var uiX:int = FP.screen.width / 2 - width / 2;
			var uiY:int = 225;
			var spacer:int = 25;
			
			// Background
			addGraphic(new Image(Assets.GFX_BACKGROUND), 100);
			addGraphic(new Image(Assets.GFX_TITLE), 99, FP.screen.width / 2 - 275, 50);
			
			/*
			// Login
			usernameL = new PunkLabel("Login Name", uiX, uiY, width, 50);
			usernameL.font = "Domo";
			username = new PunkTextField("", uiX, uiY + spacer, width);
			username.font = "Domo";
			passwordL = new PunkLabel("Password", uiX, uiY + spacer * 2, width, 50);
			passwordL.font = "Domo";
			password = new PunkPasswordField(uiX, uiY + spacer * 3, width);
			password.font = "Domo";
			
			add(usernameL);
			add(username);
			add(passwordL);
			add(password);
			*/
			var b:PunkButton = new PunkButton(uiX, FP.screen.height / 2 - 25, width, 50, "Play", onPlayTest)
			b.label.font = "Domo";
			add(b);
			add(new MessageDisplay("", 0, 36, FP.screen.width / 2, FP.screen.height / 2, width + 15, 65));
			/*
			
			var b:PunkButton = new PunkButton(uiX, uiY + spacer * 4 + spacer / 2, width, 50, "Play Now", onPlayNow, Key.ENTER);
			b.label.font = "Domo";
			b.label.size = 20;
			add(b);
			
			b = new PunkButton(uiX, uiY + spacer * 7, width, 50, "Register", onRegister);
			b.label.font = "Domo";
			add(b);
			
			add(new MessageDisplay("", 0, 36, FP.screen.width / 2, FP.screen.height / 2 + 40, width + 15, 245));
			*/
			
			
			addGraphic(new Text(Assets.VERSION, 0, FP.screen.height - 15, 50, 15));
			
			if (error != "")
			{
				messageDisplay = new MessageDisplay(error, 5, 18, FP.screen.width / 2);
				add(messageDisplay);
			}
			
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
		
		override public function end():void
		{
			removeAll();
			super.end();
		}
		
		override public function update():void
		{
			
			super.update();
		}
		
		public function onPlayNow():void
		{			
			//Login for a user with QuickConnect for Simple Users
			PlayerIO.quickConnect.simpleConnect(
				FP.stage, 
				Assets.GAME_ID,
				username.text, 
				password.text, 
				onLoginSuccess,
				onLoginError
			);
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
			FP.world = new MatchFinderWorld(client);
		}
		
		private function onLoginError(e:PlayerIOError):void
		{
			if (messageDisplay != null)
				remove(messageDisplay);

			messageDisplay = new MessageDisplay(e.message, 5);
			add(messageDisplay);
		}
		
		public function onRegister():void
		{			
			FP.world = new RegisterWorld();
		}
		
		public function kongLoadComplete(event:Event):void
		{
			kongregate = event.target.content;
			
			//trace(kongregate.services.getUserId());
			trace(kongregate.services.getGameAuthToken());
		}
		
	}
}