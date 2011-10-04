package schism.ui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import schism.Assets;
	import schism.creeps.Creep;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class CreepPanelItem extends ScrollPanelItem
	{
		// useability
		private var _callback:Function;
		
		// ui
		private var _creepImg:Image; 	// Creep icon
		private var _pointsText:Text; 	// Cost
		private var _bgColor:uint;
		
		// values
		private var _pointsDisplayOffset:int = 5;
		
		private var _cost:int = 1;
		public function get cost():int { return _cost; }
		public function set cost(value:int):void { _cost = value; }
		
		public function CreepPanelItem(creepType:String, callback:Function)
		{			
			super();
			
			_callback = callback;
			
			alpha = 0; // always start at zero to prevent weird things
			
			layer = 2;
			width = 48;
			height = 48;
			type = creepType;
			_cost = Creep.getCost(type);
			
			_creepImg = new Image(Creep.getIcon(type));
			_creepImg.centerOrigin();
			_creepImg.x = width / 2;
			_creepImg.y = height / 2;
			_creepImg.alpha = alpha;
			
			_pointsText = new Text(cost.toString());
			_pointsText.size = 14;
			_pointsText.y = -2;
			if (cost != 1)
				_pointsText.x = -1;
			_pointsText.align = "center";
			_pointsText.font = "Domo";
			_pointsText.alpha = alpha;
			
			graphic = new Graphiclist(_creepImg, _pointsText);
			
			_bgColor = 0x000000;
		}
		
		override public function update():void 
		{
			_creepImg.alpha = alpha;
			_pointsText.alpha = alpha;
			super.update();
		}
		
		override public function render():void 
		{	
			Draw.rectPlus(x, y, width, height, _bgColor, alpha);
			Draw.rectPlus(x, y, width, height, 0xFFFFFF, alpha, false);
			if(alpha == 0)
				Draw.circlePlus(x + _pointsDisplayOffset, y + _pointsDisplayOffset, 10, 0x000000, 0);
			else
				Draw.circlePlus(x + _pointsDisplayOffset, y + _pointsDisplayOffset, 10, 0x000000, 1);
			Draw.circlePlus(x + _pointsDisplayOffset, y + _pointsDisplayOffset, 10, 0xFFFFFF, alpha, false);
			super.render();			
		}
		
		override public function onMouseOver():void 
		{
			super.onMouseOver();
			
			_bgColor = 0x999999;
		}
		
		override public function onMouseOut():void 
		{
			super.onMouseOut();
			
			_bgColor = 0x000000;
		}
		
		override public function onMouseDown():void 
		{
			_bgColor = 0xCCCCCC;
			super.onMouseDown();
		}
		
		override public function onMouseUp():void 
		{
			_callback(type);
			_bgColor = 0x999999;
			super.onMouseUp();
		}
		
	}

}