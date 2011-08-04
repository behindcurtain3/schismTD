package com.behindcurtain3 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Creep extends Entity 
	{
		protected var img:Image;
		
		public var MovingTo:Point = null;
		public var Center:Point;
		
		public var ID:String;
		
		public var Speed:int;		
		
		public function Creep(s:String, _x:int, _y:int, sp:int) 
		{
			ID = s;			
			Speed = sp;
			
			img = new Image(Assets.GFX_CREEP_PIG);
			x = _x - img.width / 2;
			y = _y - img.height / 2 ;
			
			Center = new Point(_x, _y);
			
			graphic = img;
		}
		
		override public function update():void 
		{
			if (MovingTo != null)
			{
				var d:Number = Math.abs(Center.x - MovingTo.x) + Math.abs(Center.y - MovingTo.y);
				
				if (d > 2)
				{
					if (Math.abs(Center.x - MovingTo.x) >= 2)
					{
						if(Center.x < MovingTo.x)
							x += Speed * FP.elapsed;
						else
							x -= Speed * FP.elapsed;
							
						Center.x = x + img.width / 2;
					}
					if (Math.abs(Center.y - MovingTo.y) >= 2)
					{
						if(Center.y < MovingTo.y)
							y += Speed * FP.elapsed;
						else
							y -= Speed * FP.elapsed;
							
						Center.y = y + img.height / 2;
					}
					
					
				}
			}
			
			super.update();
		}
		
		public function updatePositionFromServer(_x:int, _y:int, mx:int, my:int):void
		{
			x = _x - img.width / 2;
			y = _y - img.height / 2 ;
			
			Center = new Point(_x, _y);			
			MovingTo = new Point(mx, my);
		}
	}

}