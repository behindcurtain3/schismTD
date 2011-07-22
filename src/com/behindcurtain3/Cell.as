package com.behindcurtain3 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Cell extends Entity
	{
		private var index:int;
		
		public function Cell(i:int, _x:int, _y:int, w:int, h:int) 
		{
			index = i;
			
			super.x = _x;
			super.y = _y;
			super.width = w;
			super.height = h;
		}
		
		public function assignGfx(asset:Class):void
		{			
			graphic = new Image(asset);
		}
		
		public function getIndex():int
		{
			return index;
		}
		
	}

}