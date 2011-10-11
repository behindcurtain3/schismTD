package schism.worlds 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import playerio.Client;
	import playerio.Connection;
	import playerio.DatabaseObject;
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
		protected var playerObject:DatabaseObject;
		
		public function AuthWorld(c:Client, isGuest:Boolean = false) 
		{
			client = c;
			_isGuest = isGuest;
			
			//if (client != null)
			//	client.multiplayer.developmentServer = "72.220.227.32:8184";
				
			addGraphic(new Image(Assets.GFX_BACKGROUND), 100);
		}
		
		override public function update():void 
		{
			if (client == null)
				FP.world = new TitleWorld("Invalid authentication.");
			super.update();
		}
		
		public function loadPlayerObject():void
		{
			client.bigDB.loadMyPlayerObject(objectLoaded, objectLoadError);
		}
		
		public function objectLoaded(obj:DatabaseObject):void
		{
			playerObject = obj;
		}
		
		public function objectLoadError():void
		{
			playerObject = null;
		}
		
	}

}