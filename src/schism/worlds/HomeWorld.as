package schism.worlds 
{
	import flash.net.SharedObject;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import playerio.Client;
	import punk.ui.PunkButton;
	import schism.Assets;
	import schism.ui.MessageDisplay;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class HomeWorld extends AuthWorld 
	{
		private var messageDisplay:MessageDisplay;
		private var startSfx:Sfx;
		
		public function HomeWorld(c:Client, error:String = "") 
		{
			super(c);
			
			var width:int = 250;
			var uiX:int = FP.screen.width / 2 - width / 2;
			var uiY:int = 225;
			var spacer:int = 25;
			
			var b:PunkButton = new PunkButton(uiX, FP.screen.height / 2 - 25, width, 50, "Play", onPlay)
			b.label.font = "Domo";
			add(b);
			
			b = new PunkButton(uiX, FP.screen.height / 2 - 25 + 60, width, 50, "Wave Builder", onWaveBuilderClick)
			b.label.font = "Domo";
			add(b);
			
			add(new MessageDisplay("", 0, 36, FP.screen.width / 2, FP.screen.height / 2 + 30, width + 35, 135));
			
			if (error != "")
			{
				messageDisplay = new MessageDisplay(error, 5, 18, FP.screen.width / 2);
				messageDisplay.sound();
				add(messageDisplay);
			}
			
			startSfx = new Sfx(Assets.SFX_BUTTON_START);
		}
			
		override public function end():void
		{
			removeAll();
			super.end();
		}
		
		public function onPlay():void
		{
			startSfx.play();
			FP.world = new MatchFinderWorld(client);
		}
		
		public function onWaveBuilderClick():void
		{
			FP.world = new WaveBuilder(client);
		}
	}

}