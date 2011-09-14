package schism.waves 
{
	import flash.accessibility.ISearchableText;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import schism.Assets;
	
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
		
		public function Wave(x:int, y:int, id:String, types:Array, imgScale:Number, rightJustified:Boolean = false) 
		{
			Id = id;
			this.x = x;
			this.y = y;
			centerOrigin();
			
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
				img.scale = imgScale;
				if (rightJustified)
					img.x = (gfxList.count + 1) * -img.scaledWidth;
				else
					img.x = gfxList.count * img.scaledWidth;
				img.alpha = 0;
				img.centerOrigin();
				gfxList.add(img);
				images.push(img);
			}
			
			graphic = gfxList;
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
		
		public function destroy():void
		{
			if (world != null)
				world.remove(this);			
		}
		
	}

}