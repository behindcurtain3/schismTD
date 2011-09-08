package com.behindcurtain3 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class SiteLockWorld extends World 
	{
		private var message:Text;
		
		public function SiteLockWorld() 
		{
			message = new Text("SchismTD is not available to play on the current site. Please visit schismtd.com", 0, 275);
			message.font = "Domo";
			message.size = 18;
			message.width = FP.screen.width;
			message.align = "center";
			message.color = 0x111111;
			
			addGraphic(message);
		}
		
	}

}