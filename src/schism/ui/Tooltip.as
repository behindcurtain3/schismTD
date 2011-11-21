package schism.ui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Draw;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Tooltip extends Entity 
	{
		protected var text:Text;
		protected var bgColor:uint = 0x222222;
		
		protected var leftAligned:Boolean;
		protected var rightEdge:Number;
		
		public function Tooltip(str:String, x:Number, y:Number, leftAlign:Boolean = true, pointer:Boolean = true) 
		{
			super(x, y);
			layer = 0;
			
			leftAligned = leftAlign;
			
			if (pointer)
			{
				if (leftAlign)
					str = "< " + str;
				else
					str += " >";
			}
			
			text = new Text(str, 0, 0, { color: 0xFFFFFF, font: "Domo", size: "24", outlineColor: 0xFF0000, outlineStrength: 4 } );
			addGraphic(text);
			
			width = text.textWidth + 10;
			height = text.textHeight + 10;
			text.x = 5;
			text.y = 5;
			
			if(leftAlign)
				text.align = "center";
			else
			{
				text.align = "right";
				rightEdge = text.x + text.textWidth;
			}
			
			on();
		}
		
		override public function update():void 
		{
			if (!leftAligned)
			{
				text.x = rightEdge - text.scaledWidth;
			}
			
			super.update();			
		}
		
		public function on():void
		{
			var d:Number = 0.5;
			
			var t:VarTween = new VarTween(off);
			t.tween(text, "scale", 1.05, d);
			addTween(t);
		}
		
		public function off():void
		{
			var d:Number = 0.5;

			var t:VarTween = new VarTween(on);
			t.tween(text, "scale", 1, d);
			addTween(t);
		}
		
	}

}