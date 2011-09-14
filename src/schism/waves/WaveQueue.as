package schism.waves 
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
			
			var offset:int = 40;
			zeroPosition = new Point(offset, 25);
			onePosition = new Point(offset, 55);
			twoPosition = new Point(offset, 85);
			
			activePosition = new Point(620, 77);
			
			this.visible = false;
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
						
					zeroWave = new Wave(zeroPosition.x, zeroPosition.y, id, types, 0.75, rightOriented);
					world.add(zeroWave);
					if(visible) zeroWave.fadeIn();
					
					if(oneWave != null)
						if (oneWave.Id == id)
							oneWave.fadeOut(0.25, oneWave.destroy);
					if(twoWave != null)
						if (twoWave.Id == id)
							twoWave.fadeOut(0.25, twoWave.destroy);
					break;
				case 1:
					if(oneWave != null)
						oneWave.fadeOut(0.25, oneWave.destroy);
						
					oneWave = new Wave(onePosition.x, onePosition.y, id, types, 0.75, rightOriented);
					world.add(oneWave);
					if(visible) oneWave.fadeIn();
					
					if(zeroWave != null)
						if (zeroWave.Id == id)
							zeroWave.fadeOut(0.25, zeroWave.destroy);
					if(twoWave != null)
						if (twoWave.Id == id)
							twoWave.fadeOut(0.25, twoWave.destroy);
					break;
				case 2:
					if(twoWave != null)
						twoWave.fadeOut(0.25, twoWave.destroy);
						
					twoWave = new Wave(twoPosition.x, twoPosition.y, id, types, 0.75, rightOriented);
					world.add(twoWave);
					if(visible) twoWave.fadeIn();
					
					if(oneWave != null)
						if (oneWave.Id == id)
							oneWave.fadeOut(0.25, oneWave.destroy);
					if(zeroWave != null)
						if (zeroWave.Id == id)
						zeroWave.fadeOut(0.25, zeroWave.destroy);
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
				
			activeWave = new Wave(activePosition.x, activePosition.y, id, types, 1, rightOriented);
			
			world.add(activeWave);
			if(visible) activeWave.fadeIn();

			if(zeroWave != null)
				if (zeroWave.Id == id)
					zeroWave.fadeOut(0.25, zeroWave.destroy);
			if(oneWave != null)
				if (oneWave.Id == id)
					oneWave.fadeOut(0.25, oneWave.destroy);
			if(twoWave != null)
				if (twoWave.Id == id)
					twoWave.fadeOut(0.25, twoWave.destroy);
		}
		
		public function removeWave(id:String):void
		{
			if (world == null)
				return;
				
			if (activeWave != null)
			{
				if (activeWave.Id == id)
				{
					activeWave.fadeOut(0.25, activeWave.destroy);
					return;
				}
			}
			if (zeroWave != null)
			{
				if (zeroWave.Id == id)
				{
					zeroWave.fadeOut(0.25, zeroWave.destroy);
					return;
				}
			}
			if (oneWave != null)
			{
				if (oneWave.Id == id)
				{
					oneWave.fadeOut(0.25, oneWave.destroy);
					return;
				}
			}
			if (twoWave != null)
			{
				if (twoWave.Id == id)
				{
					twoWave.fadeOut(0.25, twoWave.destroy);
					return;
				}
			}
			
		}
		
		public function showWaves():void
		{
			this.visible = true;
			
			if (oneWave != null) oneWave.fadeIn();
			if (twoWave != null) twoWave.fadeIn();
			if (zeroWave != null) zeroWave.fadeIn();
			if (activeWave != null) activeWave.fadeIn();
		}
		
	}

}