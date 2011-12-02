package schism 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
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
		public var towerDamage:int = 0;
		public var towerFireRate:int = 0;
		
		private var doSetupIndicator:Boolean = false;
		private var setupIndicatorTimer:Number;
		private var setupIndicatorLength:Number;
		private var isSetup:Boolean;
		private var setupImage:Image;
		private var stunImg:Spritemap;
		private var stunDuration:Number;
		private var stunPosition:Number;
		
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
			
			towerImage = new Image(Assets.GFX_TOWER_BASIC);
			towerRange = 0;
			
			stunImg = new Spritemap(Assets.GFX_TOWER_STUNNED, 30, 30);
			stunImg.add("stun", [0, 1, 2, 3, 4, 5], 10);
			stunImg.visible = false;
			graphic = new Graphiclist(setupImage, stunImg);
		}
		
		override public function update():void 
		{
			if (!isSetup && isOurs() && doSetupIndicator)
			{
				setupIndicatorTimer += FP.elapsed;
				
				if (setupIndicatorTimer >= setupIndicatorLength)
				{
					isSetup = true;
					setupImage.visible = false;
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
					alphaTween = new VarTween();
					alphaTween.tween(setupImage, "alpha", 0, 0.75);
					addTween(alphaTween, true);
				}
			}	
			
			stunPosition += FP.elapsed;
			if (stunPosition >= stunDuration)
			{
				stunImg.visible = false;
			}
			super.update();
		}
		
		public function assignGfx(asset:Class):void
		{			
			towerImage = new Image(asset);
			towerAsset = asset;
			graphic = new Graphiclist(towerImage, stunImg);
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
		
		public function stopFlash():void
		{
			setupIndicatorTimer = setupIndicatorLength;
			setupImage.visible = false;
		}
		
		public function stun(duration:Number):void
		{
			stunImg.visible = true;
			stunImg.play("stun");
			
			stunPosition = 0;
			stunDuration = duration / 1000;
		}
		
		public function getTowerName():String
		{
			if (!hasTower)
				return "";
					
			switch(towerAsset)
			{
				case Assets.GFX_TOWER_BASIC:
					return "Basic";
					break;
				case Assets.GFX_TOWER_DAMAGEBOOST:
					return "Damage Boost";
					break;
				case Assets.GFX_TOWER_PULSE:
					return "Pulse";
					break;
				case Assets.GFX_TOWER_RANGEBOOST:
					return "Range Boost";
					break;
				case Assets.GFX_TOWER_RAPIDFIRE:
					return "Rapid Fire";
					break;
				case Assets.GFX_TOWER_RATEBOOST:
					return "Fire Rate Boost";
					break;
				case Assets.GFX_TOWER_SLOW:
					return "Slow";
					break;
				case Assets.GFX_TOWER_SNIPER:
					return "Sniper";
					break;
				case Assets.GFX_TOWER_SPELL:
					return "Spell";
					break;
			}
			return "";
		}
		
	}

}