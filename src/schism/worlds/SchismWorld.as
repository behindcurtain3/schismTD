package schism.worlds 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.World;
	import schism.Assets;
	import schism.ui.MessageDisplay;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class SchismWorld extends World 
	{
		// Messages
		protected var messageDisplay:MessageDisplay;
		
		protected var titleImg:Image;
		protected var bottomImg:Image;
		
		public function SchismWorld(addHeader:Boolean = true) 
		{
			addGraphic(new Image(Assets.GFX_MENUBG), 100);
			
			if (addHeader)
			{			
				titleImg = new Image(Assets.GFX_TITLE);
				titleImg.y = -titleImg.height - 50;
				addGraphic(titleImg, 99, FP.screen.width / 2 - 190, 50);
				
				bottomImg = new Image(Assets.GFX_MENU_BOTTOM);
				bottomImg.y = bottomImg.height;
				addGraphic(bottomImg, 99, 0, FP.screen.height - bottomImg.height);
			}
		}
		
		override public function begin():void 
		{
			if (titleImg != null && bottomImg != null)
			{			
				var t:VarTween = new VarTween();
				t.tween(titleImg, "y", 0, 0.75, Ease.bounceOut);
				addTween(t, true);
				
				t = new VarTween();
				t.tween(bottomImg, "y", 0, 0.75, Ease.bounceIn);
				addTween(t, true);
			}
			
			super.begin();
		}
		
		override public function end():void 
		{
			removeAll();
			super.end();
		}
		
		public function showMessage(str:String, time:Number = 5):void
		{
			if (messageDisplay != null)
				remove(messageDisplay);
				
			messageDisplay = new MessageDisplay(str, time);
			add(messageDisplay);
		}
		
		
	}

}