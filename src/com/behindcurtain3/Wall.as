package com.behindcurtain3 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.utils.Draw;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Wall extends Entity 
	{
		public var Start:Point;
		public var End:Point;
		
		public function Wall(s:Point, e:Point) 
		{
			layer = 1;
			
			Start = s;
			End = e;
		}
		
		override public function update():void 
		{			
			super.update();
		}
		
	}

}