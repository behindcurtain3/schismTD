package schism.worlds 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Key;
	import playerio.Client;
	import punk.ui.PunkButton;
	import schism.Assets;
	import schism.ui.MessageDisplay;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class HowToPlayWorld extends AuthWorld 
	{
		private var txt:MessageDisplay;
		
		public function HowToPlayWorld(c:Client) 
		{
			super(c);

			var str:String;
			
			str = "\n";
			str += "Objective\n\n";
			str += "Defend your side of the board by building towers to kill\nyour opponents creeps.\n";
			str += "Kill your opponent by getting your creeps into their base!\n\n";
			add(new MessageDisplay(str, 0, 18, 0, FP.screen.height / 2 - 75));
			
			str = "\n";
			str += "				     Controls\n\n";
			str += "	W:			Toggles build mode\n";
			str += "	A:			Upgrade 1 on selected tower\n";
			str += "	S:			Sell selected tower\n";
			str += "	D:			Upgrade 2 on selected tower\n\n";
			str += "	Space:		Toggle Chi Blast mode\n\n";
			str += "	1-3:			Select your next wave of creeps\n\n";
			
			txt = new MessageDisplay(str, 0, 18, 0, FP.screen.height / 2 + 125);
			txt.message.align = "left";
			add(txt);
			
			var b:PunkButton = new PunkButton(FP.screen.width / 2 - 100, FP.screen.height / 2 + 250, 180, 40, "Back", onBack, Key.ESCAPE);
			add(b);
			
			checkClient = false;
		}
		
		public function onBack():void
		{
			if (client == null)
				FP.world = new TitleWorld();
			else
				FP.world = new HomeWorld(client);
		}
		
	}

}