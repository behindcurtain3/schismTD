package schism.worlds 
{
	import flash.net.SharedObject;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import playerio.Client;
	import punk.ui.PunkButton;
	import schism.Assets;
	import schism.ui.MessageDisplay;
	import schism.ui.Tooltip;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class HomeWorld extends AuthWorld 
	{
		private var messageDisplay:MessageDisplay;
		private var startSfx:Sfx;
		private var ratingDisplay:Text;
		
		public function HomeWorld(c:Client, error:String = "") 
		{
			super(c);
			
			addGraphic(new Image(Assets.GFX_TITLE), 99, FP.screen.width / 2 - 275, 50);
			
			var width:int = 250;
			var uiX:int = FP.screen.width / 2 - width / 2;
			var uiY:int = 225;
			var spacer:int = 25;
			
			var b:PunkButton = new PunkButton(uiX, FP.screen.height / 2 - 25, width, 50, "Play", onPlay)
			add(b);
			
			b = new PunkButton(uiX, FP.screen.height / 2 - 25 + 60, width, 50, "Wave Builder", onWaveBuilderClick)
			add(b);
			//add(new Tooltip("Build your own custom waves!", b.x + b.width + 5, b.y));
			
			add(new MessageDisplay("", 0, 36, FP.screen.width / 2, FP.screen.height / 2 + 55, width + 35, 185));
			
			if (error != "")
			{
				messageDisplay = new MessageDisplay(error, 5, 18, FP.screen.width / 2);
				messageDisplay.sound();
				add(messageDisplay);
			}
			
			startSfx = new Sfx(Assets.SFX_BUTTON_START);
			
			if (QuickKong.api != null)
			{
				var loginName:String = QuickKong.userName;
				var t:Text = new Text("Logged in as: " + loginName, 0, 0, { font: "Domo", color: 0xFFFFFF, outlineColor: 0x000000, outlineStrength: 2 });
				t.x = FP.screen.width - t.textWidth;
				t.y = FP.screen.height - t.textHeight;
				addGraphic(t);
			}
			
			if(playerObject == null)
				loadPlayerObject();
			
			addGraphic(new Text(Assets.VERSION, 0, FP.screen.height - 15, { outlineColor: 0x000000, outlineStrength: 2, font: "Domo" } ));
		}
			
		override public function end():void
		{
			removeAll();
			super.end();
		}
		
		override public function update():void 
		{
			if (playerObject != null && ratingDisplay == null)
			{
				var rating:String = playerObject["rating"] == undefined ? "1500" : playerObject["rating"];
				
				ratingDisplay = new Text("Rating: " + rating, FP.screen.width / 2, FP.screen.height / 2 + 105, { font: "Domo", size: 24, outlineStrength: 2 } );
				ratingDisplay.x -= ratingDisplay.textWidth / 2;
				addGraphic(ratingDisplay);
			}
			
			super.update();
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