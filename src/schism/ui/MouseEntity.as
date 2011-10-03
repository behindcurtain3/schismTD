package schism.ui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class MouseEntity extends Entity 
	{
		private var _backLayer:int = 3;
		public function get backLayer():int { return _backLayer; }
		public function set backLayer(value:int):void { _backLayer = value; }
		
		private var _frontLayer:int = 2;
		public function get frontLayer():int { return _frontLayer; }
		public function set frontLayer(value:int):void { _frontLayer = value; }
		
		private var _isMouseOver:Boolean = false;
		public function get mouseOver():Boolean { return _isMouseOver; }
		
		private var _isDraggable:Boolean = true;
		public function get draggable():Boolean { return _isDraggable; }
		public function set draggable(value:Boolean):void { _isDraggable = value; }
		
		private var _isBeingDragged:Boolean = false;
		public function get isDragging():Boolean { return _isBeingDragged; }
		private var _dragXOffset:int;
		private var _dragYOffset:int;
		
		private var _lastMouseX:int = 0;
		private var _lastMouseY:int = 0;
		
		public function MouseEntity(x:Number = 0, y:Number = 0, graphic:Graphic = null, mask:Mask = null) 
		{
			super(x, y, graphic, mask);
			
			layer = _backLayer;
		}
		
		override public function update():void 
		{
			if (Input.mouseX >= x && Input.mouseX <= x + width && Input.mouseY >= y && Input.mouseY <= y + height)
			{
				if (!_isMouseOver)
					onMouseOver();
				else
				{
					if (_lastMouseX != Input.mouseX && _lastMouseY != Input.mouseY)
					{
						onMouseMove();
					}
				}
				
				if (Input.mousePressed)
					onMouseDown();
				else if (Input.mouseReleased)
					onMouseUp();				
			}
			else
			{
				if (_isBeingDragged)
				{
					if (_lastMouseX != Input.mouseX && _lastMouseY != Input.mouseY)
					{
						onMouseMove();
					}
				}
				else if (_isMouseOver)
					onMouseOut();
			}
			
			super.update();
		}
		
		public function onMouseOver():void
		{
			_isMouseOver = true;
		}
		
		public function onMouseOut():void
		{
			_isMouseOver = false;
		}
		
		public function onMouseMove():void
		{
			_lastMouseX = Input.mouseX;
			_lastMouseY = Input.mouseY;
			
			if (_isDraggable && Input.mousePressed)
			{
				if (!_isBeingDragged)
				{
					_isBeingDragged = true;
					_dragXOffset = Input.mouseX - x;
					_dragYOffset = Input.mouseY - y;
				}
				layer = _frontLayer;
			}
			
			if (Input.mouseReleased)
			{
				_isBeingDragged = false;
				layer = _backLayer;
			}
			
			if (_isBeingDragged)
			{
				x = Input.mouseX - _dragXOffset;
				y = Input.mouseY - _dragYOffset;
			}			
		}
		
		public function onMouseDown():void
		{
			
		}
		
		public function onMouseUp():void
		{
			
		}
	}

}