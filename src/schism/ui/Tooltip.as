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
		protected var scale:int = 0;
		
		public function Tooltip(str:String, x:Number, y:Number) 
		{
			super(x, y);
			layer = 0;
			text = new Text(str, 0, 0, { color: 0xFFFFFF, font: "Domo", size: "16", outlineColor: 0x000000, outlineStrength: 2 } );
			addGraphic(text);
			
			width = text.textWidth + 10;
			height = text.textHeight + 10;
			text.x = 5;
			text.y = 5;
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		override public function render():void 
		{
			Draw.rectPlus(x - scale, y - scale, width + scale * 2, height + scale * 2, bgColor, 1, true, 1, 15);
			Draw.rectPlus(x - scale, y - scale, width + scale * 2, height + scale * 2, 0xFFFFFF, 1, false, 1, 15);
			
			super.render();
		}
		
	}

}