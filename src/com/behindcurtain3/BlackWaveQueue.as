package com.behindcurtain3 
{
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class BlackWaveQueue extends Entity 
	{
		private var counter:int = 1;
		
		private var waves:Array = new Array();
		private var activeWave:Wave = null;
		private var fadeTimer:Number;
		private var fading:Boolean = false;
		
		public function BlackWaveQueue() 
		{
			super();
			
			width = 168;
			height = 160;
			
			x = FP.screen.width - 5;
			y = FP.screen.height - 60;			
			
			layer = 5;
		}
		
		override public function update():void 
		{			
			super.update();
		}
		
		public function addWave(id:String, types:Array):void
		{
			var w:Wave = new Wave(x, y - counter * 30, id, types, true);
			
			if (this.world != null)
			{
				this.world.add(w);
				waves.push(w);
				w.fadeIn();
			}
			
			if(counter < 3)
				counter++;
		}
		
		public function activateWave(id:String, time:Number):void
		{
			if (activeWave != null)
			{
				if (this.world != null)
					this.world.remove(activeWave);
			}
			
			var counter:int = 0;
			for each(var w:Wave in waves)
			{
				if (w.Id == id)
				{
					activeWave = w;
					activeWave.moveToActive(this.y, time);
					waves.splice(counter, 1);
					
					for (var i:int = 0; i < waves.length; i++)
					{
						if (w.Id == waves[i].Id || w.y > waves[i].Id)
							continue;
							
						waves[i].moveDown();						
					}
					return;
				}
				counter++;
			}
		}
		
	}

}