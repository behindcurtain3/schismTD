package schism.ui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import schism.Assets;
	import schism.creeps.Creep;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class ChiBlast extends Entity 
	{
		private var _map:Spritemap;
		private var _target:Creep;
		private var _sfx:Sfx;
		
		public function ChiBlast(_x:int, _y:int, target:Creep = null, color:String = "white") 
		{
			super();
			
			x = _x;
			y = _y;
			
			_target = target;
			
			if (color == "white")
			{
				_map = new Spritemap(Assets.GFX_SPELL_WHITE, 220, 420, destroy);
				
			}
			else
			{
				_map = new Spritemap(Assets.GFX_SPELL_BLACK, 220, 420, destroy);
			}
			
			_map.centerOrigin();
			
			// We need to adjust the y-axis off center
			_map.y = -_map.height / 2 + 103;
			
			_map.add("shoot", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 20, false);
			_map.play("shoot");
			centerOrigin();
			
			graphic = _map;
			layer = 2;
			
			_sfx = new Sfx(Assets.SFX_CHIBLAST);
			_sfx.play();
		}
		
		override public function update():void 
		{
			if (_target != null)
			{
				x = _target.centerX;
				y = _target.centerY;
			}
			
			super.update();
		}
		
		public function destroy():void
		{
			if (world != null)
				world.remove(this);
		}
		
	}

}