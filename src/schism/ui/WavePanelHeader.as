package schism.ui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Draw;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class WavePanelHeader extends Entity 
	{
		private var _leftPadding:int = 95;
		private var _alpha:Number = 1;
		
		public function WavePanelHeader(x:Number = 0, y:Number = 0) 
		{
			super(x, y);
			layer = 5;
			height = 42;
			width = FP.screen.width;
			
			var text:Text = new Text("Wave");
			text.width = _leftPadding;
			text.y = height / 2 - text.height / 2;
			text.color = 0x555555;
			text.align = "center";
			text.font = "Domo";
			text.size = 24;
			text.outlineColor = 0x000000;
			text.outlineStrength = 2;
			text.updateTextBuffer();
			
			addGraphic(text);
			
			text = new Text("Creeps");
			text.x = _leftPadding + 5;
			text.y = height / 2 - text.height / 2;
			text.color = 0x555555;
			text.align = "center";
			text.font = "Domo";
			text.size = 24;
			text.outlineColor = 0x000000;
			text.outlineStrength = 2;
			text.updateTextBuffer();
			
			addGraphic(text);
		}
		
		override public function render():void 
		{
			Draw.rectPlus(x, y, width, height, 0xffebe8, _alpha);
			Draw.linePlus(x, y, FP.screen.width, y, 0x222222, _alpha);
			Draw.linePlus(x, y + height, x + FP.screen.width, y + height, 0x111111, _alpha);
			Draw.linePlus(_leftPadding, y, _leftPadding, y + height, 0x222222, _alpha - 0.25);
			
			super.render();
		}
		
	}

}