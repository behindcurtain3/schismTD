package com.behindcurtain3 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import playerio.Client;
	import playerio.Connection;
	import punk.ui.PunkButton;
	import punk.ui.PunkPanel;
	import punk.ui.PunkText;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class ResultWorld extends World 
	{
		private var mClient:Client;
		private var mConnection:Connection;
		
		public function ResultWorld(client:Client, connection:Connection, blackLife:int, whiteLife:int, blackDamage:uint, whiteDamage:uint)
		{
			mClient = client;
			mConnection = connection;

			add(new PunkButton(FP.screen.width / 2 - 250, FP.screen.height / 2 + 100, 200, 100, "Play Again", onPlayAgain)); 
			add(new PunkButton(FP.screen.width / 2 + 50, FP.screen.height / 2 + 100, 200, 100, "Exit", onExit));
			
			var fontSize:int = 10;
			var result:String;
			
			if (blackLife == whiteLife)
				result = "Match was drawn";
			else if (blackLife > whiteLife)
				result = "Black wins!";
			else
				result = "White wins!";
			
			addGraphic(new Text(result, FP.screen.width / 2 - (result.length / 2 * fontSize), 100));
			
			var centerx:int = 550;
			var str:String = "Black";
			addGraphic(new Text(str, centerx - (str.length / 2 * fontSize), 175));			

			str = "Life: " + blackLife;
			addGraphic(new Text(str, centerx - (str.length / 2 * fontSize), 225));
			
			str = "Damage: " + blackDamage;
			addGraphic(new Text(str, centerx - (str.length / 2 * fontSize), 255));
			
			centerx = 250;
			str = "White";
			addGraphic(new Text(str, centerx - (str.length / 2 * fontSize), 175));	
			
			str = "Life: " + whiteLife;
			addGraphic(new Text(str, centerx - (str.length / 2 * fontSize), 225));
			
			str = "Damage: " + whiteDamage;
			addGraphic(new Text(str, centerx - (str.length / 2 * fontSize), 255));			
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
			FP.world = new GameWorld();
		}
		
		public function onExit():void
		{
			mConnection.disconnect();
			FP.world = new MenuWorld();
		}
		
	}

}