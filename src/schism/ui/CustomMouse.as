package schism.ui 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Mouse;
	import schism.Assets;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class CustomMouse extends Sprite
	{		
		private var _gfx:Bitmap = new Assets.MOUSE_NORMAL;
		private var _currentAsset:Class = Assets.MOUSE_NORMAL;
		
		public function CustomMouse() 
		{
			Mouse.hide();
			
			name = "CustomMouse";			
			addChild(_gfx);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		public function addedToStage(e:Event):void
		{
			addEventListener(Event.ENTER_FRAME, moveMouse);
		}
		
		public function moveMouse(e:Event):void
		{
			_gfx.x = mouseX;
			_gfx.y = mouseY;
		}
		
		public function setCursor(object:Class):void
		{
			if (object != _currentAsset)
			{
				var x:Number = _gfx.x;
				var y:Number = _gfx.y;
				
				removeChild(_gfx);
				
				_gfx = new object();
				_gfx.x = x;
				_gfx.y = y;
				addChild(_gfx);
				_currentAsset = object;
			}
		}
		
	}

}