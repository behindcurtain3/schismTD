package schism.ui 
{
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Draw;
	import schism.creeps.Creep;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class WavePanel extends MouseEntity 
	{
		private var _children:Array;
		public function get children():Array { return _children; }
		
		private var _typesUsed:Array;
		private var _errorListeners:Array;
		
		private var _isActivePanel:Boolean;
		public function get activePanel():Boolean { return _isActivePanel; }
		public function set activePanel(value:Boolean):void { _isActivePanel = value; }
		
		private var _pointsRemaining:int = 24;
		public function get pointsRemaining():int { return _pointsRemaining; }
		public function set pointsRemaining(value:int):void { _pointsRemaining = value; }
		
		private var _position:int;
		public function get position():int { return _position; }
		public function set position(value:int):void { _position = value; }
		
		private var _positionDisplay:Text;
		private var _alpha:Number = 1;
		
		private var _childWidth:int = 24;
		private var _childHeight:int = 32;
		private var _childSpacer:int = 5;
		private var _leftPadding:int = 100;
		
		public function WavePanel(x:Number = 0, y:Number = 0, num:int = 0) 
		{
			super(x, y);
			draggable = false;
			layer = 5;
			position = num + 1;
			
			height = 42;
			width = FP.screen.width;
			
			_children = new Array();
			_typesUsed = new Array();

			_positionDisplay = new Text(position.toString());
			_positionDisplay.width = _leftPadding;
			_positionDisplay.align = "center";
			_positionDisplay.font = "Domo";
			_positionDisplay.size = 18;
			_positionDisplay.color = 0x888888;
			_positionDisplay.y = height / 2 - _positionDisplay.height / 2;
			_positionDisplay.outlineColor = 0x000000;
			_positionDisplay.outlineStrength = 2;
			_positionDisplay.updateTextBuffer();
		
			addGraphic(_positionDisplay);
			
			_errorListeners = new Array();
			
			deactivate();
		}
		
		public function addErrorListener(callback:Function):void
		{
			_errorListeners.push(callback);
		}
		
		public function addChild(child:DraggableCreepIcon):void
		{
			// Check to make sure there are no more than 3 different types of creeps
			if (_typesUsed.indexOf(child.type) == -1)
			{
				if (_typesUsed.length >= 3)
				{
					raiseError("Unable to add " + child.type + " creep because there are already 3 types of creep in this wave.");
					return;
				}
				else
					_typesUsed.push(child.type);
			}
			
			// Make sure there are points left before adding
			var cost:int = Creep.getCost(child.type);
			if (cost > pointsRemaining)
			{
				raiseError("Unable to add a new " + child.type + " creep because there are not enough points left.");
				return;
			}
			else
				pointsRemaining -= cost;
			
			// Position child
			if (_children.length == 0)
				child.x = x + _leftPadding;
			else 
				child.x = _children[_children.length - 1].x + _childWidth + _childSpacer;

			child.y = y + (height / 2) - (_childHeight / 2);
			child.lockY = child.y;
			child.draggable = activePanel;
			child.alpha = _alpha;
			
			// Add drag handler
			child.addDragHandler(onChildDragDrop);
			
			// Add to array
			_children.push(child);
			
			// Add to world
			if (world != null)
				world.add(child);
		}
		
		override public function render():void 
		{
			if (_isActivePanel)
			{
				Draw.rectPlus(x, y, width, height, 0xd8dfea, _alpha);
				Draw.linePlus(x, y, FP.screen.width, y, 0x222222, _alpha);
				Draw.linePlus(x, y + height, FP.screen.width, y + height, 0x111111, _alpha);
				Draw.linePlus(_leftPadding - 5, y, _leftPadding - 5, y + height, 0x222222, _alpha - 0.25);
			}
			else
			{
				Draw.rectPlus(x, y, width, height, 0x000000, _alpha);
				Draw.linePlus(x, y, FP.screen.width, y, 0xFFFFFF, _alpha);
				Draw.linePlus(x, y + height, FP.screen.width, y + height, 0xFFFFFF, _alpha);
				Draw.linePlus(_leftPadding - 7, y, _leftPadding - 7, y + height, 0xBBBBBB, _alpha - 0.25);
			}
			super.render();
		}
		
		override public function onMouseUp():void 
		{
			super.onMouseUp();
		}
		
		public function onChildDragDrop(child:DraggableCreepIcon):void
		{
			_children.sortOn("x", Array.NUMERIC);
			
			for (var i:int = 0; i < _children.length; i++)
			{
				_children[i].x = _leftPadding + (i * (_childWidth + _childSpacer));
			}
		}
		
		public function activate():void
		{
			_alpha = 1;
			for (var i:int = 0; i < _children.length; i++)
			{
				_children[i].draggable = true;
				_children[i].alpha = _alpha;
			}
			activePanel = true;
			
			_positionDisplay.size = 24;
			_positionDisplay.alpha = _alpha;
			_positionDisplay.color = 0x555555;
			
		}
		
		public function deactivate():void
		{
			_alpha = 0.85;
			for (var i:int = 0; i < _children.length; i++)
			{
				_children[i].draggable = false;
				_children[i].alpha = _alpha;
			}
			activePanel = false;
			
			_positionDisplay.size = 18;
			_positionDisplay.alpha = _alpha;
			_positionDisplay.color = 0x888888;
		}
		
		public function clear():void
		{
			if (world != null)
				world.removeList(_children);
				
			_children = [];
			_typesUsed = [];
			pointsRemaining = 24;
		}
		
		public function moveUp(amount:Number):void
		{
			y -= amount;
			
			for (var i:int = 0; i < _children.length; i++)
			{
				_children[i].y -= amount;
				_children[i].lockY = _children[i].y;
			}
		}
		
		public function moveDown(amount:Number):void
		{
			y += amount;
			
			for (var i:int = 0; i < _children.length; i++)
			{
				_children[i].y += amount;
				_children[i].lockY = _children[i].y;
			}
		}
		
		public function setAlpha(value:Number):void
		{
			_alpha = value;
			_positionDisplay.alpha = _alpha;
			for (var i:int = 0; i < _children.length; i++)
			{
				_children[i].alpha = _alpha;
			}
		}
		
		public function show():void
		{
			if (_isActivePanel)
				setAlpha(1);
			else
				setAlpha(0.85);
		}
		
		public function isVisible():Boolean
		{
			return _alpha > 0;
		}
		
		public function removeLast():void
		{
			if (_children.length > 0)
			{
				var object:DraggableCreepIcon = _children.pop();
				pointsRemaining += Creep.getCost(object.type);
				
				// Update types in array
				var found:Boolean = false;
				for (var i:int = 0; i < _children.length; i++)
				{
					if (_children[i].type == object.type)
						found = true;
				}
				
				if (!found)
				{
					_typesUsed.splice(_typesUsed.indexOf(object.type), 1);
				}
				
				world.remove(object);
			}
		}
		
		private function raiseError(e:String):void
		{
			for (var i:int = 0; i < _errorListeners.length; i++)
			{
				_errorListeners[i](e);
			}
		}
		
	}

}