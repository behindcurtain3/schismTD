package schism 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.Font;
	import flash.utils.getDefinitionByName;
	import flash.display.Sprite;
	import flash.text.TextField;
	import net.flashpunk.graphics.Image;
	import schism.Main;
	
	[SWF(width = "800", height = "600")]
	/**
	 * ...
	 * @author Noel Berry
	 */
	public class Preloader extends MovieClip 
	{
		//[Embed(source = 'data/loading.png')] static private var imgLoading:Class;
		private var loading:Bitmap = new Bitmap(new BitmapData(5, 5));
		
		private var square:Sprite = new Sprite();
		private var border:Sprite = new Sprite();
		private var wd:Number = (loaderInfo.bytesLoaded / loaderInfo.bytesTotal) * 240;
		private var text:TextField = new TextField();
		
		private var dummyMain:Main;
		
		public function Preloader() 
		{
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			// show loader
			addChild(square);
			square.x = 200;
			square.y = stage.stageHeight / 2;
			
			addChild(border);
			border.x = 200-4;
			border.y = stage.stageHeight / 2 - 4;
		
			addChild(text);
			text.x = 194;
			text.y = stage.stageHeight / 2 - 30;
			
			addChild(loading);
			loading.x = 0;
			loading.y = 48;
			
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// update loader
			square.graphics.beginFill(0xF2F2F2);
			square.graphics.drawRect(0,0,(loaderInfo.bytesLoaded / loaderInfo.bytesTotal) * 240,20);
			square.graphics.endFill();
			
			border.graphics.lineStyle(2,0xFFFFFF);
			border.graphics.drawRect(0, 0, 248, 28);
			
			text.textColor = 0xFFFFFF;
			text.text = "Loading: " + Math.ceil((loaderInfo.bytesLoaded/loaderInfo.bytesTotal)*100) + "%";
			
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				startup();
			}
		}
		
		private function startup():void 
		{
			// hide loader
			stop();
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			
			var mainClass:Class = getDefinitionByName("schism.Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}

}