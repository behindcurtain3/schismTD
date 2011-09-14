package schism.projectiles 
{
	import flash.display.Bitmap;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import schism.Assets;
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
			
			width = radius * 2;
			height = radius * 2;
			centerOrigin();
		
			image = new Image(Assets.GFX_BULLET_PULSE);
			image.centerOrigin();
			image.scaleX = width / image.width;
			image.scaleY = height / image.height;
			graphic = image;
		}
		
		override public function update():void 
		{
			radius += FP.elapsed * velocity;
			
			width = radius * 2;
			height = radius * 2;
			
			image.scaleX = width / image.width;
			image.scaleY = height / image.height;
			
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