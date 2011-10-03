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
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class ScrollPanelItem extends MouseEntity 
	{
		// Spritemap
		protected var _map:Spritemap;
		
		// Alpha value
		private var _alpha:Number = 1;
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void {
			if (value >= 1)
				value = 1;
			if (value <= 0)
				value = 0;
			
			_alpha = value;	
				
			if (_map != null)
				_map.alpha = value;
		}
		
		// Positioning
		private var _needsPositioning:Boolean = true;
		public function get updatePosition():Boolean { return _needsPositioning; }
		public function set updatePosition(value:Boolean):void { _needsPositioning = value; }
		
		public function ScrollPanelItem()
		{
			draggable = false;
		}
		
		
		
	}

}