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
		
		private var _mouseDownListeners:Array;
		private var _clickListeners:Array;
		private var _dragListeners:Array;
		
		public function MouseEntity(x:Number = 0, y:Number = 0, graphic:Graphic = null, mask:Mask = null) 
		{
			super(x, y, graphic, mask);
			
			layer = _backLayer;
			
			_mouseDownListeners = new Array();
			_clickListeners = new Array();
			_dragListeners = new Array();
		}
		
		override public function update():void 
		{
			if (Input.mouseX >= x && Input.mouseX <= x + width && Input.mouseY >= y && Input.mouseY <= y + height)
			{
				if (!_isMouseOver)
					onMouseOver();
				else
				{
					if (_lastMouseX != Input.mouseX || _lastMouseY != Input.mouseY)
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
					if (_lastMouseX != Input.mouseX || _lastMouseY != Input.mouseY)
						onMouseMove();
					
					// This is necessary to catch cases where the mouse is let go on a frame its not over the entity but while its being dragged.
					if (Input.mouseReleased)
						onMouseUp();
				}
				else if (_isMouseOver)
					onMouseOut();
			}
			
			super.update();
		}
		
		public function addClickListener(callback:Function):void
		{
			_clickListeners.push(callback);
		}
		
		public function addDragHandler(callback:Function):void
		{
			_dragListeners.push(callback);
		}
		
		public function addMouseDownListener(callback:Function):void
		{
			_mouseDownListeners.push(callback);
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
			
			if (_isBeingDragged)
			{
				x = Input.mouseX - _dragXOffset;
				y = Input.mouseY - _dragYOffset;
			}			
		}
		
		public function onMouseDown():void
		{
			if (_isDraggable)
			{
				_isBeingDragged = true;
				_dragXOffset = Input.mouseX - x;
				_dragYOffset = Input.mouseY - y;

				world.bringToFront(this);
			}
			
			for (var i:int = 0; i < _mouseDownListeners.length; i++)
			{
				_mouseDownListeners[i](this);
			}
		}
		
		public function onMouseUp():void
		{
			var i:int;
			if (_isBeingDragged)
			{
				for (i = 0; i < _dragListeners.length; i++)
				{
					_dragListeners[i](this);
				}
			}
			
			_isBeingDragged = false;
			
			for (i = 0; i < _clickListeners.length; i++)
			{
				_clickListeners[i](this);
			}
		}
	}

}