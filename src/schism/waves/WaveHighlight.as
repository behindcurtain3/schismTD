package schism.waves 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import schism.Assets;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class WaveHighlight extends Entity 
	{
		public var image:Image;
		protected var color:String;
		
		private var targetY:Number;
		
		public function WaveHighlight(color:String, x:Number, y:Number) 
		{
			this.color = color;
			this.x = x - 10;
			this.y = y;
			this.targetY = this.y;
			centerOrigin();

			if (this.color == "black")
			{
				this.image = new Image(Assets.GFX_WAVE_BLACK);
				this.image.centerOrigin();
				this.x = this.x - this.image.width / 2;
			}
			else
			{
				this.image = new Image(Assets.GFX_WAVE_WHITE);
				this.image.centerOrigin();
				this.x = this.x + this.image.width / 2;
			}			
			
			this.layer = 5;
			this.image.alpha = 0;
			this.graphic = this.image;
		}
		
		override public function update():void 
		{
			if (this.targetY != this.y)
			{
				var velocity:Number = 20;
				var distance:Number = velocity * FP.elapsed;
				
				if (distance <= Math.abs(this.targetY - this.y))
					moveTo(this.x, this.targetY);
				else
					moveTowards(this.x, this.targetY, distance);
			}
			
			super.update();
		}
		
		public function setPosition(y:Number):void
		{
			this.targetY = y;
		}
		
	}

}