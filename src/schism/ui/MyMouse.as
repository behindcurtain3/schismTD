package schism.ui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import schism.Assets;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class MyMouse extends Entity 
	{
		protected var _map:Spritemap;
		
		public function MyMouse() 
		{
			this.x = Input.mouseX;
			this.y = Input.mouseY;
			
			_map = new Spritemap(Assets.MOUSE_MAIN, 40, 40);
			_map.add("main", [0]);
			_map.add("build", [1]);
			_map.add("sniper", [3]);
			_map.add("spell", [2]);
			_map.play("main");
			
			graphic = _map;
			
			layer = 0;
		}
		
		override public function update():void 
		{
			this.x = Input.mouseX;
			this.y = Input.mouseY;
			
			super.update();
		}
		
		public function setMap(s:String):void
		{
			_map.play(s);
		}
		
	}

}