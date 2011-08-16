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
		
		public var MovingTo:Cell = null;
		public var Center:Point;
		
		public var ID:String;
		public var player:int;
		public var path:Array;
		
		public var Speed:int;
		public var life:int = -1;
		public var startingLife:int;
		
		public function Creep(s:String, pId:int, _x:int, _y:int, sp:int, _path:Array) 
		{
			ID = s;		
			player = pId;
			Speed = sp;
			
			img = new Image(Assets.GFX_CREEP_PIG);
			x = _x - img.width / 2;
			y = _y - img.height / 2 ;
			width = img.width;
			height = img.height;
			setHitbox(width, height);
			type = "creep";
			
			Center = new Point(_x, _y);
			
			graphic = img;
			layer = 10;
			
			updatePath(_path);
		}
		
		override public function update():void 
		{
			if (MovingTo == null)
			{
				//
			}
			else
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
				
				if (life != -1)
				{
					img.alpha = (life / startingLife) + 0.25;
				}
			}
			
			super.update();
		}
		
		// x & y sent from server are the center of the creep
		/*
		public function updatePositionFromServer(_x:int, _y:int, mx:int, my:int):void
		{
			x = _x - img.width / 2;
			y = _y - img.height / 2 ;
			
			Center = new Point(_x, _y);			
			MovingTo = new Point(mx, my);
		}*/
		
		public function updateLife(value:int):void
		{
			if (life == -1)
			{
				startingLife = value;
			}
			life = value;
		}
		
		public function updatePath(path:Array):void
		{
			
			
		}
	}

}