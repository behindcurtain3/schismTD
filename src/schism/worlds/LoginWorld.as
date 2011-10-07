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
	public class LoginWorld extends World 
	{
		// Login
		protected var usernameL:PunkLabel;
		protected var username:PunkTextField;
		protected var passwordL:PunkLabel;
		protected var password:PunkPasswordField;
		
		// Messages
		protected var messageDisplay:MessageDisplay;
		
		// Client
		protected var _client:Client;
		
		public function LoginWorld ()
		{
			var width:int = 250;
			var uiX:int = FP.screen.width / 2 - width / 2;
			var uiY:int = 225;
			var spacer:int = 25;
			
			// Background
			addGraphic(new Image(Assets.GFX_BACKGROUND), 100);
			addGraphic(new Image(Assets.GFX_TITLE), 99, FP.screen.width / 2 - 275, 50);
			
			
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
		
			var b:PunkButton = new PunkButton(uiX, uiY + spacer * 4 + spacer / 2, width, 50, "Go", onPlayNow, Key.ENTER);
			b.label.size = 20;
			add(b);
			
			add(new MessageDisplay("", 0, 36, FP.screen.width / 2, FP.screen.height / 2 + 10, width + 15, 200));			
		}
		
		override public function end():void
		{
			removeAll();
			super.end();
		}
		
		override public function update():void
		{
			if (Input.pressed(Key.ESCAPE))
			{
				FP.world = new TitleWorld();
			}			
			
			super.update();
		}
		
		public function onPlayNow():void
		{		
			if (messageDisplay != null)
				remove(messageDisplay);
				
			messageDisplay = new MessageDisplay("Logging in...", 0);
			add(messageDisplay);
			
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
		
		private function onLoginSuccess(client:Client):void
		{
			_client = client;
			FP.world = new HomeWorld(_client, "Welcome back " + username.text);
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
		
	}
}