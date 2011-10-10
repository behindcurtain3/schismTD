package schism.worlds 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import playerio.Client;
	import playerio.Connection;
	import schism.Assets;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class AuthWorld extends World 
	{
		protected var client:Client;
		protected var connection:Connection;
		protected var _isGuest:Boolean;
		
		public function AuthWorld(c:Client, isGuest:Boolean = false) 
		{
			client = c;
			_isGuest = isGuest;
			
			if (client != null)
				client.multiplayer.developmentServer = "72.220.227.32:8184";
				
			addGraphic(new Image(Assets.GFX_BACKGROUND), 100);
		}
		
		override public function update():void 
		{
			if (client == null)
				FP.world = new TitleWorld("Invalid authentication.");
			super.update();
		}
		
	}

}