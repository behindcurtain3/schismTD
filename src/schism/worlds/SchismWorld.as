package schism.worlds 
{
	import net.flashpunk.World;
	import schism.ui.MessageDisplay;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class SchismWorld extends World 
	{
		// Messages
		protected var messageDisplay:MessageDisplay;
		
		public function SchismWorld() 
		{
			
		}
		
		override public function end():void 
		{
			removeAll();
			super.end();
		}
		
		public function showMessage(str:String, time:Number = 5):void
		{
			if (messageDisplay != null)
				remove(messageDisplay);
				
			messageDisplay = new MessageDisplay(str, time);
			add(messageDisplay);
		}
		
		
	}

}