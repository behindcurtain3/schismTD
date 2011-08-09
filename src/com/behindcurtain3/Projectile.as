package com.behindcurtain3 
{
	/**
	 * ...
	 * @author Justin Brown
	 */
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Projectile extends Entity 
	{
		private var speed:Number;
		private var target:Creep;
		public var id:String;
		
		public function Projectile(_id:String, _x:Number, _y:Number, _v:Number, _t:Creep) 
		{
			id = _id;
			x = _x;
			y = _y;
			
			graphic = new Image(new BitmapData(5, 5));
			layer = 2;
			setHitbox(5,5);
			type = "bullet"
			
			speed = _v;
			target = _t;
		}
		
		override public function update():void
		{
			var velocity:Number = speed * FP.elapsed;			
			moveTowards(target.Center.x, target.Center.y, velocity);
			super.update();
		}
		
		public function destroy():void
		{
			if(this.world != null)
				this.world.remove(this);
		}
	}

}
