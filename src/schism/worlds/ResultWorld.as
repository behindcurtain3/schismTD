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
	import schism.ui.MessageDisplay;
	
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
			
			add(new MessageDisplay(resultStr, 0, 48, 0, 100, 600, 100));
			add(new MessageDisplay("Black\n\nLife: " + blackLifeNum + "\nDamage: " + blackDamageNum, 0, 18, 550, 250, 225));
			add(new MessageDisplay("White\n\nLife: " + whiteLifeNum + "\nDamage: " + whiteDamageNum, 0, 18, 250, 250, 225));
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
			FP.world = new MatchFinderWorld(mClient);
		}
		
		public function onExit():void
		{
			mConnection.disconnect();
			FP.world = new TitleWorld();
		}
		
	}

}