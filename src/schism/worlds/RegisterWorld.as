package schism.worlds 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import playerio.Client;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	import playerio.PlayerIORegistrationError;
	import punk.ui.PunkButton;
	import punk.ui.PunkLabel;
	import punk.ui.PunkPasswordField;
	import punk.ui.PunkTextField;
	import schism.Assets;
	import schism.ui.MessageDisplay;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class RegisterWorld extends World 
	{
		// Register
		protected var regUsername:PunkTextField;
		protected var regPassword:PunkPasswordField;
		protected var regEmail:PunkTextField;
		
		// Messages
		protected var messageDisplay:MessageDisplay;
		
		public function RegisterWorld() 
		{
			var width:int = 250;
			var uiX:int = FP.screen.width / 2 - width / 2;
			var uiY:int = 225;			
			var spacer:int = 25;
			
			// Background
			addGraphic(new Image(Assets.GFX_LOGIN_BACKGROUND), 100);
			
			add(new PunkLabel("Username:", uiX, uiY, width, 50));
			regUsername = new PunkTextField("", uiX, uiY + spacer, width);
			add(new PunkLabel("Password:", uiX, uiY + spacer * 2, width, 50));
			regPassword = new PunkPasswordField(uiX, uiY + spacer * 3, width);
			add(new PunkLabel("Email: (optional)", uiX, uiY + spacer * 4, width, 50));
			regEmail = new PunkTextField("", uiX, uiY + spacer * 5, width);

			add(regUsername);
			add(regPassword);
			add(regEmail);
			var b:PunkButton = new PunkButton(uiX, uiY + spacer * 7, width, 50, "Register", onRegister, Key.ENTER);
			b.label.font = "Domo";
			add(b);
			
			add(new MessageDisplay("", 0, 36, FP.screen.width / 2, FP.screen.height / 2 + 40, width + 15, 245));
		}
		
		override public function update():void 
		{
			if (Input.check(Key.ESCAPE))
				FP.world = new LoginWorld();
			
			super.update();
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
		
	}

}