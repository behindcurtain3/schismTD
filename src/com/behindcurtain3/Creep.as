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
	public class Creep extends EffectEntity
	{
		protected var img:Image;
		
		public var MovingTo:Cell = null;
		
		public var ID:String;
		public var player:int;
		public var path:Array;
		
		public var Speed:int;
		public var effectedSpeed:int;
		
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
			
			graphic = img;
			layer = 10;
			
			updatePath(_path);
		}
		
		override public function update():void 
		{
			if (path.length > 0)
			{
				// Reset values
				effectedSpeed = Speed;
				
				// Apply effects
				applyEffects();
				
				
				if (MovingTo == null)
				{
					MovingTo = path[0];
				}
				
				var d:Number = getDistance(MovingTo);
				
				if (d <= 3)
				{
					path.reverse();
					path.pop();
					path.reverse();
					
					if (path.length == 0)
					{
						// Creep has arrived
					}
					else
					{
						MovingTo = path[0];
					}
				}
				
				// Move the creep
				var velocity:Number = effectedSpeed * FP.elapsed;
				
				var movement:Vector2 = new Vector2(centerX, centerY);
				movement.minus(new Vector2(MovingTo.centerX, MovingTo.centerY));
				movement.normalize();
				movement.times(velocity);
				
				x -= movement.x;
				y -= movement.y;	
				
				if (life != -1)
				{
					img.alpha = (life / startingLife) + 0.25;
				}
			}
			
			super.update();
		}
		
		public function updateLife(value:int):void
		{
			if (life == -1)
			{
				startingLife = value;
			}
			life = value;
		}
		
		public function updatePath(_path:Array):void
		{
			this.path = _path.slice();
			this.MovingTo = path[0];			
		}
		
		public function getDistance(cell:Cell):Number
		{
			return Math.abs(cell.centerX - centerX) + Math.abs(cell.centerY - centerY);
		}
	}

}