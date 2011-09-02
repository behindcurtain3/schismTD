package com.behindcurtain3 
{
	import flash.accessibility.ISearchableText;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Wave extends Entity 
	{
		public var Id:String;
		public var images:Array = new Array();
		public var gfxList:Graphiclist = new Graphiclist();
		public var targetY:int;
		public var moveToY:int;
		public var waveTimer:Number;
		
		public var selection:Image;
		
		public function Wave(x:int, y:int, id:String, types:Array, rightJustified:Boolean = false) 
		{
			Id = id;
			this.x = x;
			this.y = y;
			targetY = y;
			
			layer = 4;
			
			for each(var str:String in types)
			{
				var img:Image;
				
				switch(str)
				{
					case "Armor":
						img = new Image(Assets.GFX_ICONS_ARMOR);
						break;
					case "Chigen":
						img = new Image(Assets.GFX_ICONS_CHIGEN);
						break;
					case "Magic":
						img = new Image(Assets.GFX_ICONS_MAGIC);
						break;
					case "Quick":
						img = new Image(Assets.GFX_ICONS_QUICK);
						break;
					case "Regen":
						img = new Image(Assets.GFX_ICONS_REGEN);
						break;
					case "Swarm":
						img = new Image(Assets.GFX_ICONS_SWARM);
						break;
				}				
				img.scale = 0.75;
				if (rightJustified)
					img.x = (gfxList.count + 1) * -img.scaledWidth;
				else
					img.x = gfxList.count * img.scaledWidth;
				img.alpha = 0;
				gfxList.add(img);
				images.push(img);
			}
			
			graphic = gfxList;
		}
		
		override public function update():void 
		{
			if (targetY != y)
			{
				if(Math.abs(targetY - y) > 60 * FP.elapsed)
					moveTowards(x, targetY, 60 * FP.elapsed);
				else
					moveTo(x, targetY);
			}
			
			super.update();
		}
		
		public function fadeOut(time:Number = 0.25, followOnFunction:Function = null):void
		{
			var alphaTween:VarTween;
			
			if (followOnFunction != null)
				alphaTween = new VarTween(followOnFunction);
			else
				alphaTween = new VarTween();
			
			for each(var img:Image in images)
			{
				alphaTween.tween(img, "alpha", 0, time);
				addTween(alphaTween, true);
				alphaTween = new VarTween();
			}
		}
		
		public function fadeIn(time:Number = 1.0, followOnFunction:Function = null):void
		{
			var alphaTween:VarTween;
			
			if (followOnFunction != null)
				alphaTween = new VarTween(followOnFunction);
			else
				alphaTween = new VarTween();
			
			for each(var img:Image in images)
			{
				alphaTween.tween(img, "alpha", 1, time);
				addTween(alphaTween, true);
				alphaTween = new VarTween();
			}
		}
		
		public function moveUp():void
		{
			targetY -= 30;
		}
		
		public function moveDown():void
		{
			targetY += 30;
		}
		
		public function moveToActive(y:Number, time:Number):void
		{
			waveTimer = time / 1000;
			fadeOut(0.25, fadeOutComplete);
			moveToY = y;
		}
		
		public function fadeOutComplete():void
		{
			y = moveToY;
			targetY = y;
			fadeIn(0.5, fadeInComplete);
		}
		
		public function fadeInComplete():void
		{
			fadeOut(waveTimer);
		}
		
	}

}