package com.behindcurtain3 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Heart extends Entity 
	{
		[Embed(source = '../../../assets/gfx/heart.png')]
		private const GFX_HEART:Class;
		
		private var gfx:Image;
		
		public function Heart(_x:Number = 0, _y:Number = 0) 
		{
			gfx = new Image(GFX_HEART);
			gfx.scale = 0.2;
			graphic = gfx;
			
			layer = 20;
			
			x = _x;
			y = _y;
		}
		
	}

}