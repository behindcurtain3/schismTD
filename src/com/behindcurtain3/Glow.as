package com.behindcurtain3 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Glow extends Entity 
	{
		private var img:Image;		
		
		public function Glow() 
		{
			img = new Image(Assets.GFX_GLOW);
			
			graphic = img;
			layer = 3;
			
			height = img.height;
			width = img.width;
		}
		
	}

}