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
		
		override public function update():void 
		{			
			if (world == null)
				return;
			
			var gw:GameWorld = world as GameWorld;
			if (gw.objectSelected == null)
			{
				var mx:int = Input.mouseX;
				var my:int = Input.mouseY;
				
				var cells:Array = new Array();
				if(world != null)
					world.getClass(Cell, cells);
				
				var hit:Boolean = false;
				for each(var c:Cell in cells)
				{
					if (!c.isOurs())
						continue;
					
					if (mx >= c.x && mx <= c.x + width && my >= c.y && my <= c.y + height)
					{
						hit = true;
						x = c.x - 1;
						y = c.y - 1;
					}
				}
				
				graphic.visible = hit;
			}
			else
			{
				x = gw.objectSelected.x - 1;
				y = gw.objectSelected.y - 1;
			}
			super.update();
		}
	}

}