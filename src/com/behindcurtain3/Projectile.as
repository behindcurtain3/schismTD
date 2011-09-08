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
		public var target:Creep;
		public var id:String;
		private var img:Image;
		
		public function Projectile(_id:String, _x:Number, _y:Number, _v:Number, _t:Creep, _type:String) 
		{
			super();
			
			id = _id;
			x = _x;
			y = _y;
			switch(_type)
			{
				case "Basic":
					img = new Image(Assets.GFX_BULLET_BASIC);
					break;
				case "RapidFire":
					img = new Image(Assets.GFX_BULLET_RAPIDFIRE);
					break;
				case "Sniper":
					img = new Image(Assets.GFX_BULLET_SNIPER);
					break;
				case "Slow":
					img = new Image(Assets.GFX_BULLET_SLOW);
					break;
				case "Spell":
					img = new Image(Assets.GFX_BULLET_SPELL);
					break;
			}
			img.centerOrigin();
			//img.x = -img.width / 2;
			//img.y = -img.height / 2;
			
			graphic = img;
			layer = 2;
			setHitbox(img.width, img.height);
			type = "bullet"
			
			speed = _v;
			target = _t;
		}
		
		override public function update():void
		{
			var velocity:Number = speed * FP.elapsed;			
			moveTowards(target.centerX, target.centerY, velocity);
			
			img.angle = FP.angle(centerX, centerY, target.centerX, target.centerY) - 90;
			
			if (collideRect(x, y, target.x, target.y, target.width, target.height))
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
	}

}
