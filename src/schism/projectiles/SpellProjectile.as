package schism.projectiles 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.TiledImage;
	import net.flashpunk.graphics.TiledSpritemap;
	import schism.Assets;
	import schism.creeps.Creep;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class SpellProjectile extends Projectile 
	{		
		public var tile:TiledSpritemap;
		public var duration:Number;
		public var timeElapsed:Number;
		
		protected var beam:Number;
		protected var onWayOut:Boolean;
		protected var originalX:Number;
		protected var originalY:Number;
		
		public function SpellProjectile(_id:String, _x:Number, _y:Number, _v:Number, _t:Creep, _type:String) 
		{
			super(_id, _x, _y, _v, _t, _type);
			tile = new TiledSpritemap(Assets.GFX_BULLET_SPELL, 8, 8, 8, 100);
			tile.add("fire", [0, 1, 2, 3], 10);
			tile.play("fire");
			tile.visible = false;
			graphic = tile;
			
			duration = 0.75;
			timeElapsed = 0;
			beam = 0;
			onWayOut = true;
			
			originalX = x;
			originalY = y;
			
			width = 8;
		}
		
		public function setHeight(h:Number):void
		{
			
		}
		
		override public function update():void 
		{					
			var d:Number;
			var f:int;
			if (onWayOut)
			{
				beam += FP.elapsed * speed;
				d = FP.distance(centerX, centerY, target.centerX, target.centerY);
				if (beam < d)
				{
					if (d != height)
					{
						f = tile.frame;
						
						tile = new TiledSpritemap(Assets.GFX_BULLET_SPELL, 8, 8, 8, beam);
						tile.add("fire", [0, 1, 2, 3], 10);
						tile.setAnimFrame("fire", f);
						tile.play("fire");

						graphic = tile;
					}
				}
				else
				{
					onWayOut = false;
				}
				
				tile.angle = FP.angle(originalX, originalY, target.centerX, target.centerY) + 90;
			}
			else
			{
				beam -= FP.elapsed * speed;
				x = target.centerX;
				y = target.centerY;
				
				if (beam <= 0)
				{
					if (world != null)
						world.remove(this);
					return;
				}
				
				f = tile.frame;
						
				tile = new TiledSpritemap(Assets.GFX_BULLET_SPELL, 8, 8, 8, beam);
				tile.add("fire", [0, 1, 2, 3], 10);
				tile.setAnimFrame("fire", f);
				tile.play("fire");

				graphic = tile;
				
				tile.angle = FP.angle(x, y, originalX, originalY) + 90;				
				
			}
			tile.originX = 4;
		}
		
		override public function destroy():void 
		{
			return;
		}
	}

}