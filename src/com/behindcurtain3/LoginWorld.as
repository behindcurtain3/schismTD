package com.behindcurtain3
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
		protected var username:PunkTextField;
		protected var password:PunkPasswordField;
		
		// Register
		protected var regUsername:PunkTextField;
		protected var regPassword:PunkPasswordField;
		protected var regEmail:PunkTextField;
		
		// Messages
		protected var messageDisplay:MessageDisplay;

		// Kongregate API reference
		protected var kongregate:*;
		
		public function LoginWorld (error:String = "")
		{
			var uiX:int = 100;
			var uiY:int = 200;
			var width:int = 250;
			var spacer:int = 25;
			
			// Background
			addGraphic(new Image(Assets.GFX_LOGIN_BACKGROUND), 100);
			
			// Login
			add(new PunkLabel("Username:", uiX, uiY, width, 50));
			username = new PunkTextField("", uiX, uiY + spacer, width);
			add(new PunkLabel("Password:", uiX, uiY + spacer * 2, width, 50));
			password = new PunkPasswordField(uiX, uiY + spacer * 3, width);
			
			add(username);
			add(password);
			add(new PunkButton(uiX, uiY + spacer * 5, width, 50, "Play Now", onPlayNow, Key.ENTER));
			add(new PunkButton(uiX, uiY + spacer * 5 + 75, width, 50, "Test Game", onPlayTest));
			
			// Register
			uiX = 450;
			
			add(new PunkLabel("Username:", uiX, uiY, width, 50));
			regUsername = new PunkTextField("", uiX, uiY + spacer, width);
			add(new PunkLabel("Password:", uiX, uiY + spacer * 2, width, 50));
			regPassword = new PunkPasswordField(uiX, uiY + spacer * 3, width);
			add(new PunkLabel("Email: (optional)", uiX, uiY + spacer * 4, width, 50));
			regEmail = new PunkTextField("", uiX, uiY + spacer * 5, width);
			
			add(regUsername);
			add(regPassword);
			add(regEmail);
			add(new PunkButton(uiX, uiY + spacer * 7, width, 50, "Register", onRegister));
			
			addGraphic(new Text(Assets.VERSION, 0, FP.screen.height - 15, 50, 15));
			
			if (error != "")
			{
				messageDisplay = new MessageDisplay(error, 5);
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
			//Register a user with QuickConnect for Simple Users
			PlayerIO.quickConnect.simpleRegister(
				FP.stage, 
				Assets.GAME_ID,
				regUsername.text, 
				regPassword.text, 
				regEmail.text, 
				null, // captcha key, if captcha is used
				null, // captcha value, if captcha is used
				{}, // any additional data you want
				"",
				onRegisterSuccess,
				onRegisterError
			);
		}
		
		private function onRegisterSuccess(client:Client):void
		{
			FP.world = new MatchFinderWorld(client);
		}
		
		private function onRegisterError(e:PlayerIORegistrationError):void
		{
			if (messageDisplay != null)
				remove(messageDisplay);
				
			var msg:String;	
				
			if (e.usernameError != null)
				msg = e.usernameError;
			else if (e.passwordError != null)
				msg = e.passwordError;
			else if (e.emailError != null)
				msg = e.emailError;
			else
				msg = e.message;
			
			messageDisplay = new MessageDisplay(msg, 5);
			add(messageDisplay);

		}
		
		public function kongLoadComplete(event:Event):void
		{
			kongregate = event.target.content;
			
			//trace(kongregate.services.getUserId());
			trace(kongregate.services.getGameAuthToken());
		}
		
	}
}