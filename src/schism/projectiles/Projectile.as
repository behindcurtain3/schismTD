package schism.projectiles 
{
	/**
	 * ...
	 * @author Justin Brown
	 */
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import schism.Assets;
	import schism.creeps.Creep;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Projectile extends Entity 
	{
		protected var speed:Number;
		public var target:Creep;
		public var id:String;
		private var spm:Spritemap;
		private var shadow:Image;
		private var graphicList:Graphiclist;
		
		public function Projectile(_id:String, _x:Number, _y:Number, _v:Number, _t:Creep, _type:String) 
		{
			super();
			
			id = _id;
			x = _x;
			y = _y;
			
			switch(_type)
			{
				case "Basic":
					spm = new Spritemap(Assets.GFX_BULLET_BASIC);
					spm.add("fire", [0]);
					
					shadow = new Image(Assets.GFX_SHADOW_BASIC);
					break;
				case "RapidFire":
					spm = new Spritemap(Assets.GFX_BULLET_RAPIDFIRE);
					spm.add("fire", [0]);
					
					shadow = new Image(Assets.GFX_SHADOW_RAPIDFIRE);
					break;
				case "Sniper":
					spm = new Spritemap(Assets.GFX_BULLET_SNIPER, 8, 15);
					spm.add("fire", [0, 1, 2], 100, true);
					
					shadow = new Image(Assets.GFX_SHADOW_SNIPER);
					break;
				case "Slow":
					spm = new Spritemap(Assets.GFX_BULLET_SLOW, 12, 10);
					spm.add("fire", [0, 1, 2], 100, true);
					
					shadow = new Image(Assets.GFX_SHADOW_SLOW);
					break;
				case "Spell":
					spm = new Spritemap(Assets.GFX_BULLET_SPELL, 8, 8);
					spm.add("fire", [0, 1, 2, 3], 100, true);
					
					shadow = new Image(Assets.GFX_SHADOW_SPELL);
					break;
			}
			spm.smooth = true;
			spm.centerOrigin();
			spm.play("fire");
			
			shadow.centerOrigin();
			shadow.x = 2;
			shadow.y = 2;
			width = shadow.width;
			height = shadow.height;
			centerOrigin();
			
			graphic = new Graphiclist(shadow, spm);
			layer = 2;
			setHitbox(width, height);
			type = "bullet"
			
			speed = _v;
			target = _t;
		}
		
		override public function update():void
		{
			spm.angle = FP.angle(centerX, centerY, target.centerX, target.centerY) - 90;
			shadow.angle = spm.angle;
			
			var velocity:Number = speed * FP.elapsed;			
			moveTowards(target.centerX, target.centerY, velocity);
			if(collideRect(x, y, target.centerX - 2, target.centerY - 2, 4, 4))
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
