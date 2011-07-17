package com.behindcurtain3 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Grass extends Entity 
	{
		[Embed(source = '../../../assets/gfx/Tombstone.png')]
		private const GFX_GRASS:Class;
		
		protected var gfx:Image;
		
		public function Grass(_x:Number, _y:Number) 
		{
			x = _x;
			y = _y;
			gfx = new Image(GFX_GRASS);
			graphic = gfx;
			
			
			layer = 30;
		}
		
	}

}