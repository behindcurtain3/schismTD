package schism.waves 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class BlackWaveQueue extends WaveQueue
	{		
		public function BlackWaveQueue() 
		{
			super();
			
			x = FP.screen.width - 15;
			y = FP.screen.height - 70;
			
			var offset:int = x;
			zeroPosition = new Point(offset, FP.screen.height - 85);
			onePosition = new Point(offset, FP.screen.height - 55);
			twoPosition = new Point(offset, FP.screen.height - 25);
			
			activePosition = new Point(200, FP.screen.height - 75);
			
			rightOriented = true;
		}

	}

}