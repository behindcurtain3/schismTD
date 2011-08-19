package com.behindcurtain3 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class FauxTower extends Entity 
	{
		private var img:Image = new Image(Assets.GFX_TOWER_BASIC);
		public function FauxTower() 
		{
			img.alpha = 0.6;
			graphic = img;
			layer = 15;
			
			visible = false;
		}
		
	}

}