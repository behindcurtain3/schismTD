package com.behindcurtain3 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Bullet extends Entity 
	{
		private var speed:Number;
		private var dmg:Number;
		private var target:Point;
		
		public function Bullet(_x:Number, _y:Number, _t:Point, damage:Number = 50) 
		{
			x = _x;
			y = _y;
			
			target = _t;
			
			graphic = new Image(new BitmapData(1, 1));
			setHitbox(1,1);
			type = "bullet"
			
			speed = 250;
			dmg = damage;
		}
		
		override public function update():void
		{
			var v:Number = speed * FP.elapsed;
			moveTowards(target.x, target.y, v);
			
			if (y < 0 || y > FP.height || x < 0 || x > FP.width)
			{
				destroy();
			}
			
			if (collide("scenery", x, y))
			{
				destroy();
			}
			
			super.update();
		}
		
		public function destroy():void
		{
			if(this.world != null)
				this.world.remove(this);
		}
		
		public function Damage():Number
		{
			return dmg;
		}
	}

}