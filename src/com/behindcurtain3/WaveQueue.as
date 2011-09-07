package com.behindcurtain3 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class WaveQueue extends Entity 
	{
		protected var activeWave:Wave = null;
		protected var zeroWave:Wave;
		public var oneWave:Wave;
		public var twoWave:Wave;
		
		protected var activePosition:Point;
		protected var zeroPosition:Point;
		protected var onePosition:Point;
		protected var twoPosition:Point;
		
		protected var rightOriented:Boolean = false;
		
		public function WaveQueue() 
		{
			super();
			
			width = 168;
			height = 160;
			
			layer = 5;
			
			var offset:int = 5;
			zeroPosition = new Point(offset, 30);
			onePosition = new Point(offset, 70);
			twoPosition = new Point(offset, 110);
			
			activePosition = new Point(585, 25);
		}
		
		public function addWave(id:String, position:int, types:Array):void
		{
			if (world == null)
				return;
				
			switch(position)
			{
				case 0:
					if (zeroWave != null)
						zeroWave.fadeOut(0.25, zeroWave.destroy);
						
					zeroWave = new Wave(zeroPosition.x, zeroPosition.y, id, types, 1.0, rightOriented);
					world.add(zeroWave);
					zeroWave.fadeIn();
					break;
				case 1:
					if(oneWave != null)
						oneWave.fadeOut(0.25, oneWave.destroy);
						
					oneWave = new Wave(onePosition.x, onePosition.y, id, types, 0.75, rightOriented);
					world.add(oneWave);
					oneWave.fadeIn();
					break;
				case 2:
					if(twoWave != null)
						twoWave.fadeOut(0.25, twoWave.destroy);
						
					twoWave = new Wave(twoPosition.x, twoPosition.y, id, types, 0.6, rightOriented);
					world.add(twoWave);
					twoWave.fadeIn();
					break;
				default:
					trace("Invalid wave position: " + position);
					break;
			}
		}
		
		public function setActiveWave(id:String, types:Array):void
		{
			if (world == null)
				return;
				
			if (activeWave != null)
				activeWave.fadeOut(0.25, activeWave.destroy);
				
			activeWave = new Wave(activePosition.x, activePosition.y, id, types, 0.75, rightOriented);
			
			world.add(activeWave);
			activeWave.fadeIn();
		}
		
	}

}