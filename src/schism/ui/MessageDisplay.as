package schism.ui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Draw;
	import schism.Assets;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class MessageDisplay extends Entity 
	{
		public var message:Text;
		private var timeDisplayed:Number;
		private var displayTime:Number;
		private var backgroundAlpha:Number;
		private var doesMsgFade:Boolean = true;
		private var callBack:Function = null;
		
		protected var _bgColor:uint = 0x111111;
		protected var _borderColor:uint = 0xFFFFFF;
		
		public function MessageDisplay(msg:String, time:Number, fontSize:int = 18, x:int = 0, y:int = 0, w:int = 400, h:int = 50, callBack:Function = null) 
		{
			layer = 1;
			
			if (time == 0)
				doesMsgFade = false;
				
			if (callBack != null)
				this.callBack = callBack;
			
			displayTime = time;
			timeDisplayed = 0;
			
			var alignCenter:Boolean = true;
			
			if (x != 0)
				this.x = x;
			else
				this.x = FP.screen.width / 2;
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
			message.outlineColor = 0x000000;
			message.outlineStrength = 2;
			message.updateTextBuffer();
			
			var edited:Boolean = false;
			while (message.textWidth + message.size > FP.screen.width)
			{
				message.text = message.text.substr(0, message.text.length - 1);
				edited = true;
			}
			
			if (edited)
			{
				message.text = message.text + "...";
			}
			
			if (message.textWidth + message.size > width)
			{
				width =  message.textWidth + message.size;
			}
			
			if (message.textHeight + message.size > height)
				height = message.textHeight + message.size;
				
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
			Draw.rectPlus(this.x + 5, this.y + 5, width, height, 0x000000, backgroundAlpha - 0.35, true, 1, 15);
			Draw.rectPlus(this.x, this.y, width, height, _bgColor, backgroundAlpha, true, 1, 15);
			Draw.rectPlus(this.x + 3, this.y + 3, width - 6, height - 6, _borderColor, backgroundAlpha, false, 2, 15);
			
			super.render();
		}
		
		override public function update():void 
		{
			if (doesMsgFade)
			{
				timeDisplayed += FP.elapsed;
				
				if (timeDisplayed >= displayTime)
				{
					fadeOut(0.25, destroy);
				}
			}
			
			backgroundAlpha = message.alpha;
			//if (backgroundAlpha > 0.9)
			//	backgroundAlpha = 0.9;
			
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
			if(callBack != null)
				callBack.call();
			
			if (world != null)
				world.remove(this);
		}
		
		public function sound():void
		{
			//var s:Sfx = new Sfx(Assets.SFX_POPUP);
			//s.play();
		}
		
	}

}