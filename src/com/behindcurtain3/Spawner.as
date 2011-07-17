package com.behindcurtain3 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Spawner extends Entity 
	{
		private var skeletons:Boolean;
		private var zombies:Boolean;
		private var bats:Boolean;
		
		private var spawnRate:Number;
		private var timeElapsed:Number = 0;
		
		public function Spawner(_x:int, _y:int, rate:Number, s:Boolean, z:Boolean, b:Boolean) 
		{
			x = _x;
			y = _y;
			type = "Spawner";
			
			spawnRate = rate;
			skeletons = s;
			zombies = z;
			bats = b;
		}
		
		public override function update():void 
		{
			timeElapsed += FP.elapsed;
			
			if (timeElapsed >= spawnRate)
			{
				timeElapsed = 0;
				// TODO spawn mob
			}
			
			super.update();
		}
		
	}

}