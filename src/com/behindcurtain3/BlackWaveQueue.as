package com.behindcurtain3 
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
			
			x = FP.screen.width - 5;
			y = FP.screen.height - 70;
			
			var offset:int = x;
			zeroPosition = new Point(offset, y);
			onePosition = new Point(offset, y - 30);
			twoPosition = new Point(offset, y - 60);
			
			activePosition = new Point(210, FP.screen.height - 55);
			
			rightOriented = true;
		}

	}

}