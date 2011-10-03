package schism.ui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class ScrollPanel extends Entity 
	{
		// Child items
		private var _children:Array;
		private var _childrenToAdd:Array;
		
		// Properties
		
		// Values
		private var _childWidth:int = 48;
		private var _childHeight:int = 48;
		private var _childSpacer:int = 10;
		
		private var _leftPadding:int = 32;
		private var _rightPadding:int = 32;
		private var _fadeZoneWidth:int = 64;
		private var _useableWidth:int = 0;
		
		private var _widthBeyondVisible:Boolean = false;
		
		public function ScrollPanel() 
		{
			centerOrigin();
			layer = 5;
			x = 0;
			y = FP.screen.height - 100;
			
			width = FP.screen.width;
			height = 58;
			
			_useableWidth = width - _leftPadding - _rightPadding - (_fadeZoneWidth * 2);
			
			_children = new Array();
			_childrenToAdd = new Array();
		}
		
		public function addChild(child:ScrollPanelItem):void
		{
			// Make sure the child is sized correctly
			if (child.width != _childWidth)
				child.width = _childWidth;
			if (child.height != _childHeight)
				child.height = _childHeight;
							
			// Position child
			if (_children.length == 0)
			{
				child.x = _leftPadding + _fadeZoneWidth;
			}
			else
			{
				child.x = _children[_children.length - 1].x + _childWidth + _childSpacer;
			}
			child.y = y;
			_children.push(child);
			
			if(world != null)
				world.add(child);
			else
				_childrenToAdd.push(child);
				
			updatePanel();
		}	
		
		override public function update():void 
		{			
			if (_childrenToAdd.length > 0)
			{
				for each(var item:ScrollPanelItem in _childrenToAdd)
				{
					if (world != null)
						world.add(item);
				}
				_childrenToAdd = [];
			}
			
			if (_widthBeyondVisible)
			{
				var velocity:Number = FP.elapsed * (_childWidth * 5);
				
				if (Input.check(Key.RIGHT))
				{
					for each(var item:ScrollPanelItem in _children)
					{
						item.x -= velocity;
					}
					
					if (_children[_children.length - 1].x < FP.screen.width - _rightPadding - _childWidth - _fadeZoneWidth)
					{
						repositionChildrenOffRight(FP.screen.width - _rightPadding - _childWidth - _fadeZoneWidth);
					}
					checkChildrenAlphaValues();
				}
				else if (Input.check(Key.LEFT))
				{
					for each(var item:ScrollPanelItem in _children)
					{
						item.x += velocity;
					}
					
					if (_children[0].x > _leftPadding + _fadeZoneWidth)
					{
						repositionChildrenOffLeft(_leftPadding + _fadeZoneWidth);
					}
					checkChildrenAlphaValues();
				}
			}
			
			super.update();
		}
		
		override public function render():void 
		{
			Draw.rectPlus(x, y - 10, width, height + 10, 0x000000, 0.75);
			Draw.line(x, y - 10, FP.screen.width, y - 10);
			Draw.line(x, y + height, FP.screen.width, y + height);
			
			super.render();
		}
		
		public function updatePanel():void
		{
			if (_children.length * (_childWidth + _childSpacer) > _useableWidth)
			{
				_widthBeyondVisible = true;
				checkChildrenAlphaValues();
			}
			else
			{
				_widthBeyondVisible = false;
				centerChildren();
			}
		}
		
		private function repositionChildrenOffLeft(left:int):void
		{			
			for (var i:int = 0; i < _children.length; i++)
			{
				_children[i].x = left + (i * (_childWidth + _childSpacer));
			}
		}
		
		private function repositionChildrenOffRight(right:int):void
		{			
			for (var i:int = 1; i <= _children.length; i++)
			{
				_children[_children.length - i].x = right - ((i - 1) * (_childWidth + _childSpacer));
			}
		}
		
		private function centerChildren():void
		{
			var totalLength:int = _children.length * (_childWidth + _childSpacer) - _childSpacer;
			var left:int = (FP.screen.width / 2) - (totalLength / 2);
			
			repositionChildrenOffLeft(left);
		}
		
		private function checkChildrenAlphaValues():void
		{
			for each(var item:ScrollPanelItem in _children)
			{
				if (item.x < _leftPadding)
				{
					item.alpha = 0;
				}
				else if (item.x < _leftPadding + _fadeZoneWidth)
				{
					item.alpha = FP.lerp(0, 1, (item.x - _leftPadding) / _fadeZoneWidth);
				}
				else if (item.x > FP.screen.width - _rightPadding - _childWidth)
				{
					item.alpha = 0;
				}
				else if (item.x > FP.screen.width - _rightPadding - _fadeZoneWidth - _childWidth)
				{
					item.alpha = FP.lerp(0, 1, 1 - (item.x - (FP.screen.width - _rightPadding - _fadeZoneWidth - _childWidth)) / _fadeZoneWidth);
				}
				else
					item.alpha = 1;
			}
		}
		
	}

}