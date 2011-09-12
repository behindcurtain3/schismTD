package com.behindcurtain3 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Draw;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class MessageDisplay extends Entity 
	{
		private var message:Text;
		private var timeDisplayed:Number;
		private var displayTime:Number;
		private var backgroundAlpha:Number;
		
		public function MessageDisplay(msg:String, time:Number, fontSize:int = 18, x:int = 0, y:int = 0, w:int = 400, h:int = 50) 
		{
			layer = 1;
			displayTime = time;
			timeDisplayed = 0;
			
			var alignCenter:Boolean = false;
			
			if (x != 0)
			{
				this.x = x;
				alignCenter = true;
			}
			else
				this.x = 200;
			if (y != 0)
				this.y = y;
			else
				this.y = 500;
					
			height = h;
			width = w;

			message = new Text(msg);
			message.font = "Domo";
			message.size = fontSize;
			message.color = 0xFFFFFF;
			
			var edited:Boolean = false;
			while (message.textWidth + 100 > FP.screen.width)
			{
				message.text = message.text.substr(0, message.text.length - 1);
				edited = true;
			}
			
			if (edited)
			{
				message.text = message.text + "...";
			}
			
			if (message.textWidth > width)
			{
				width =  message.textWidth + 30;
				this.x = (FP.screen.width - width) / 2;
			}
			
			if (message.textHeight + 10 > height)
				height = message.textHeight + 10;
				
			if (alignCenter)
			{
				this.x = this.x - width / 2;
				this.y = this.y - height / 2;
			}
			
			message.width = this.width;
			message.height = this.height;
			message.align = "center";
			message.y = (height - message.textHeight) / 2;
			message.alpha = 0;

			backgroundAlpha = 0;
			addGraphic(message);
			
			fadeIn(0.25);
		}
		
		public function setMessage(msg:String):void
		{
			message.text = msg;
			message.x = (this.width / 2) - ((msg.length / 2) * 8);
		}
		
		public function resetTimeTo(time:Number):void
		{
			displayTime = time;
			timeDisplayed = 0;
		}
		
		override public function render():void 
		{
			Draw.rectPlus(this.x, this.y, width, height, 0x000000, backgroundAlpha, true, 1, 15);
			
			super.render();
		}
		
		override public function update():void 
		{
			timeDisplayed += FP.elapsed;
			
			if (timeDisplayed >= displayTime)
			{
				fadeOut(0.25, destroy);
			}
			
			backgroundAlpha = message.alpha;
			if (backgroundAlpha > 0.9)
				backgroundAlpha = 0.9;
			
			super.update();
		}
		
		public function fadeOut(time:Number = 0.25, followOnFunction:Function = null):void
		{
			var alphaTween:VarTween;
			
			if (followOnFunction != null)
				alphaTween = new VarTween(followOnFunction);
			else
				alphaTween = new VarTween();
			
			
			alphaTween.tween(message, "alpha", 0, time);
			addTween(alphaTween, true);
		}
		
		public function fadeIn(time:Number = 1.0, followOnFunction:Function = null):void
		{
			var alphaTween:VarTween;
			
			if (followOnFunction != null)
				alphaTween = new VarTween(followOnFunction);
			else
				alphaTween = new VarTween();
			
			alphaTween.tween(message, "alpha", 1, time);
			addTween(alphaTween, true);
			alphaTween = new VarTween();
		}
		
		public function destroy():void
		{
			if (world != null)
				world.remove(this);
		}
		
	}

}