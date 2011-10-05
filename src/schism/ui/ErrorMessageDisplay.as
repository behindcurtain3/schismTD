package schism.ui 
{
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class ErrorMessageDisplay extends MessageDisplay 
	{
		
		public function ErrorMessageDisplay(msg:String, time:Number, fontSize:int = 18, x:int = 0, y:int = 0, w:int = 400, h:int = 50, callBack:Function = null) 
		{
			super(msg, time, fontSize, x, y, w, h, callBack);
			
			message.color = 0x000000;
			_borderColor = 0xdd3c10;
			_bgColor = 0xffebe8;
		}
		
		
		
	}

}