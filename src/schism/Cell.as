package schism 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Cell extends Entity
	{
		private var index:int;
		private var isPlayers:Boolean = false;
		public var hasTower:Boolean = false;
		public var towerImage:Image;
		public var towerAsset:Class;
		public var towerRange:Number;
		
		private var doSetupIndicator:Boolean = false;
		private var setupIndicatorTimer:Number;
		private var setupIndicatorLength:Number;
		private var isSetup:Boolean;
		private var setupImage:Image;
		
		private var sfx_highlight:Sfx = new Sfx(Assets.SFX_START_HIGHLIGHT);
		
		public function Cell(i:int, _x:int, _y:int, w:int, h:int, mine:Boolean) 
		{
			index = i;
			isPlayers = mine;
			
			super.x = _x;
			super.y = _y;
			super.width = w;
			super.height = h;
			setHitbox(width, height);
			type = "cell";
			layer = 20;
			
			setupIndicatorLength = 6;
			setupIndicatorTimer = 0;
			isSetup = false;
			
			setupImage = new Image(Assets.GFX_GLOW);
			setupImage.alpha = 0;
			setupImage.x = -1;
			setupImage.y = -1;
			graphic = setupImage;
			
			towerImage = new Image(Assets.GFX_TOWER_BASIC);
			towerRange = 0;
		}
		
		override public function update():void 
		{
			if (!isSetup && isOurs() && doSetupIndicator)
			{
				setupIndicatorTimer += FP.elapsed;
				
				if (setupIndicatorTimer >= setupIndicatorLength)
				{
					isSetup = true;
					if (graphic == setupImage)
						graphic = null;
				}
				
				var alphaTween:VarTween;
				if (setupImage.alpha == 0)
				{
					alphaTween = new VarTween();
					alphaTween.tween(setupImage, "alpha", 1, 0.75);
					addTween(alphaTween, true);
				}
				else if (setupImage.alpha == 1)
				{
					sfx_highlight.play();
					alphaTween = new VarTween();
					alphaTween.tween(setupImage, "alpha", 0, 0.75);
					addTween(alphaTween, true);
				}
			}			
			super.update();
		}
		
		public function assignGfx(asset:Class):void
		{			
			towerImage = new Image(asset);
			towerAsset = asset;
			graphic = towerImage;
			hasTower = true;
		}
		
		public function getIndex():int
		{
			return index;
		}
		
		public function isOurs():Boolean
		{
			return isPlayers;
		}
		
		override public function toString():String 
		{
			return getIndex().toString();
		}
		
		public function flash():void
		{
			doSetupIndicator = true;
		}
		
	}

}