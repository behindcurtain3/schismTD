package com.behindcurtain3
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Main extends Engine
	{
		protected var world:World;
		public function Main():void
		{
			super(640, 480, 60, false);
			
			world = new MenuWorld();
			FP.world = world;
		}
		
		override public function update():void
		{	
			super.update();
		}
		
	}
	
}