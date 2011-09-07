package com.behindcurtain3 
{
	import flash.display.Bitmap;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class PulseProjectile extends Entity
	{
		private var Id:String;	
		private var range:Number;
		private var radius:Number;
		private var velocity:Number;
		private var image:Image;
		
		public function PulseProjectile(_id:String, _x:Number, _y:Number, _range:Number) 
		{
			Id = _id;
			
			super.x = _x;
			super.y = _y;
			
			range = _range;
			radius = 1;
			velocity = 150;
			
			type = "bullet";
			layer = 21;
			
			image = Image.createCircle(radius, 0x333333);
			image.alpha = 0.6;
			image.x = -radius;
			image.y = -radius;
			graphic = image;
		}
		
		override public function update():void 
		{
			radius += FP.elapsed * velocity;
			
			image = Image.createCircle(radius, 0x333333);
			image.alpha = 0.6;
			image.x = -radius;
			image.y = -radius;
			graphic = image;
			
			if (radius > range)
			{
				if (world != null)
					world.remove(this);				
			}
			
			super.update();
		}
		
		override public function render():void 
		{			
			super.render();
		}
		
	}

}