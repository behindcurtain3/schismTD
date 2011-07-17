package com.behindcurtain3
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Main extends Engine
	{
		protected var world:GameWorld;
		public function Main():void //epic comment 
		{
			super(640, 480, 60, false);
			
			world = new GameWorld();
			FP.world = world;
		}
		
		override public function update():void
		{
			if (Input.pressed(Key.M))
			{
				FP.volume = 0;
			}
			
			if (world.gameOver)
			{
				if (Input.mousePressed)
				{
					world = new GameWorld();
					FP.world = world;
				}
			}
			
			
			super.update();
		}
		
	}
	
}