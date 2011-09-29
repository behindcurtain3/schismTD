package schism.ui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
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
		
		public function ChiBlast(_x:int, _y:int, target:Creep = null, color:String = "white") 
		{
			super();
			
			x = _x;
			y = _y;
			
			_target = target;
			
			if (color == "white")
			{
				_map = new Spritemap(Assets.GFX_SPELL_WHITE, 90, 200, destroy);
				
			}
			else
			{
				_map = new Spritemap(Assets.GFX_SPELL_BLACK, 90, 200, destroy);
			}
			
			_map.centerOrigin();
			_map.y = -_map.height / 2 + 35;
			_map.add("shoot", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13], 20, false);
			_map.play("shoot");
			centerOrigin();
			
			graphic = _map;
			layer = 2;
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