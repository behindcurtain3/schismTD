package schism 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class MoveableEntity extends Entity 
	{
		// GFX
		protected const PARTICLE_COUNT:Number = 100;
		protected var spriteMap:Spritemap;
		protected var particleEmitter:Emitter;
		protected var direction:int;
		
		// Stats
		protected var speed:Number;
		protected var velocity:Point;
		protected var health:Number;
		
		public function MoveableEntity(sx:int, sy:int) 
		{
			x = sx;
			y = sy;
			
			velocity = new Point();
		}
		
	}

}