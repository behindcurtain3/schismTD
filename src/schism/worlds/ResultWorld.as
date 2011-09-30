package schism.worlds 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import playerio.Client;
	import playerio.Connection;
	import punk.ui.PunkButton;
	import punk.ui.PunkPanel;
	import punk.ui.PunkText;
	import schism.Assets;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class ResultWorld extends World 
	{
		private var mClient:Client;
		private var mConnection:Connection;
		
		private var result:Text;
		private var black:Text;
		private var blackLife:Text;
		private var blackDamage:Text;
		private var white:Text; 
		private var whiteLife:Text;
		private var whiteDamage:Text;
		
		public function ResultWorld(client:Client, connection:Connection, resultStr:String, blackLifeNum:int, whiteLifeNum:int, blackDamageNum:uint, whiteDamageNum:uint)
		{
			mClient = client;
			mConnection = connection;

			addGraphic(new Image(Assets.GFX_BACKGROUND), 5);
			
			var b:PunkButton = new PunkButton(FP.screen.width / 2 - 250, FP.screen.height / 2 + 100, 200, 100, "Play Again", onPlayAgain);
			b.label.font = "Domo";
			add(b); 
			b = new PunkButton(FP.screen.width / 2 + 50, FP.screen.height / 2 + 100, 200, 100, "Exit", onExit);
			b.label.font = "Domo";
			add(b);
			
			result = new Text(resultStr, 0, 100);
			result.font = "Domo";
			result.size = 48;
			result.width = FP.screen.width;
			result.height = 100;
			result.align = "center";
			if (result.text.indexOf("Black") != -1)
				result.color = 0x000000;

			addGraphic(result);
			
			var centerx:int = 550;
			
			black = new Text("Black", FP.screen.width / 2 - 100, 175);
			black.font = "Domo";
			black.size = 24;
			black.width = 500;
			black.align = "center";
			black.color = 0x000000;
			addGraphic(black);
			
			blackLife = new Text("Life: " + blackLifeNum, FP.screen.width / 2 - 100, 225);
			blackLife.font = "Domo";
			blackLife.size = 18;
			blackLife.width = black.width;
			blackLife.align = "center";
			blackLife.color = 0x000000;
			addGraphic(blackLife);
			
			blackDamage = new Text("Damage: " + blackDamageNum, FP.screen.width / 2 - 100, 255);
			blackDamage.font = "Domo";
			blackDamage.size = 18;
			blackDamage.width = black.width;
			blackDamage.align = "center";
			blackDamage.color = 0x000000;
			addGraphic(blackDamage);
			
			centerx = 250;
			
			white = new Text("White", 0, 175);
			white.font = "Domo";
			white.size = 24;
			white.width = 500;
			white.align = "center";
			addGraphic(white);
			
			whiteLife = new Text("Life: " + whiteLifeNum, 0, 225);
			whiteLife.font = "Domo";
			whiteLife.size = 18;
			whiteLife.width = white.width;
			whiteLife.align = "center";
			addGraphic(whiteLife);
			
			whiteDamage = new Text("Damage: " + whiteDamageNum, 0, 255);
			whiteDamage.font = "Domo";
			whiteDamage.size = 18;
			whiteDamage.width = white.width;
			whiteDamage.align = "center";
			addGraphic(whiteDamage);

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
		
		public function onPlayAgain():void
		{
			FP.world = new MatchFinderWorld(mClient, mConnection);
		}
		
		public function onExit():void
		{
			mConnection.disconnect();
			FP.world = new LoginWorld();
		}
		
	}

}