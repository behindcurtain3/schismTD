package schism.worlds 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import playerio.Client;
	import punk.ui.PunkButton;
	import punk.ui.PunkLabel;
	import punk.ui.PunkTextField;
	import schism.Assets;
	import schism.ui.MessageDisplay;
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class ChallengeWorld extends AuthWorld 
	{
		protected var friendName:PunkTextField;
		
		public function ChallengeWorld(c:Client) 
		{
			super(c);
			
			var width:int = 250;
			var uiX:int = FP.screen.width / 2 - width / 2;
			var uiY:int = 215;
			var spacer:int = 25;
			
			add(new PunkLabel("Friend Name:", uiX, uiY, width, 50));
			friendName = new PunkTextField("", uiX, uiY + spacer, width);
			add(friendName);
			
			var b:PunkButton = new PunkButton(uiX, uiY + spacer * 3 - 5, width, 50, "Play", onPlay, Key.ENTER);
			add(b);
			b = new PunkButton(uiX + 50, uiY + spacer * 5 + 5, width - 100, 35, "Back", onReturn, Key.ESCAPE);
			add(b);
			
			add(new MessageDisplay("", 0, 36, FP.screen.width / 2, FP.screen.height / 2, width + 30, 190));
			
			add(new MessageDisplay("Type your friends user name into the box above.\nHave them type your name in on their game.", 0, 18, 0, FP.screen.height / 2 + 150));
		}
		
		override public function update():void 
		{
			if (Input.pressed(Key.ESCAPE))
				FP.world = new HomeWorld(client);
			
			super.update();
		}
		
		public function onPlay():void
		{
			if (friendName.text == "")
				showMessage("Please enter the name of a player you wish to challenge.");
			else
			{
				var gameName:String;
				
				if (playerName < friendName.text)
					gameName = playerName + friendName.text;
				else
					gameName = friendName.text + playerName;
				
				FP.world = new GameWorld(client, false, gameName, true, false);
			}
		}
		
		public function onReturn():void
		{
			FP.world = new HomeWorld(client);
		}
	}

}