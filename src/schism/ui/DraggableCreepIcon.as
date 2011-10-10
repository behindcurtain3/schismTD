package schism.ui 
{
	import flash.display.InterpolationMethod;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Input;
	import schism.creeps.Creep;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class DraggableCreepIcon extends MouseEntity 
	{		
		private var _gfx:Image;
		public function get alpha():Number { return _gfx.alpha; }
		public function set alpha(value:Number):void { _gfx.alpha = value; }
		
		private var _lockedY:Number;
		public function get lockY():Number { return _lockedY; }
		public function set lockY(value:Number):void { _lockedY = value; }		
		
		public function DraggableCreepIcon(creepType:String, x:Number = 0, y:Number = 0) 
		{
			super(x, y);

			_lockedY = y;
			draggable = true;
			type = creepType;
			
			height = 32;
			width = 24;
			
			_gfx = new Image(Creep.getIcon(type));			
			_gfx.centerOrigin();
			_gfx.x = width / 2;
			_gfx.y = height / 2;
			
			
			graphic = _gfx;
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		override public function onMouseDown():void 
		{
			super.onMouseDown();
			
			if(draggable)
				_gfx.scale = 1.15;
		}
		
		override public function onMouseUp():void 
		{	
			super.onMouseUp();
			
			_gfx.scale = 1;
		}
		
		override public function onMouseMove():void 
		{			
			super.onMouseMove();
			
			if (isDragging)
			{
				y = _lockedY;
			}
		}
		
	}

}