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
				var velocity:Number = Speed * FP.elapsed;
				
				var movement:Vector2 = new Vector2(Center.x, Center.y);
				movement.minus(new Vector2(MovingTo.x, MovingTo.y));
				movement.normalize();
				movement.times(velocity);
				
				x -= movement.x;
				y -= movement.y;	
				Center.x = x + img.width / 2;
				Center.y = y + img.height / 2;
			}
			
			super.update();
		}
		
		// x & y sent from server are the center of the creep
		public function updatePositionFromServer(_x:int, _y:int, mx:int, my:int):void
		{
			x = _x - img.width / 2;
			y = _y - img.height / 2 ;
			
			Center = new Point(_x, _y);			
			MovingTo = new Point(mx, my);
		}
	}

}