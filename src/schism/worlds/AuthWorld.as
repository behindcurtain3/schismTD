package schism.worlds 
{
	import flash.net.SharedObject;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import playerio.Client;
	import playerio.Connection;
	import playerio.DatabaseObject;
	import playerio.PlayerIOError;
	import schism.Assets;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class AuthWorld extends SchismWorld
	{
		// Static vars useable across worlds
		protected static var playerObject:DatabaseObject;
		public static var playerName:String = "Guest";
		public static var accessToken:String = "";
		public static var isKongUser:Boolean = false;
		
		protected var client:Client;
		protected var connection:Connection;
		protected var _isGuest:Boolean;
		protected var checkClient:Boolean = true;
		
		protected var bg:Image;
		protected var muted:Boolean = false;
		
		public function AuthWorld(c:Client, isGuest:Boolean = false, addTitle:Boolean = true) 
		{
			super(addTitle);
			
			client = c;
			_isGuest = isGuest;
			
			if (client != null)
				client.multiplayer.developmentServer = "72.220.227.32:8184";
				
			bg = new Image(Assets.GFX_MENUBG);
			addGraphic(bg, 100);
			
			// Load sound settings
			var sharedObject:SharedObject = SharedObject.getLocal("schismTDdata");
			if (sharedObject.data.sound != null)
			{
				if (sharedObject.data.sound == "on")
					muted = false;
				else
					muted = true;
			}
			else
			{
				muted = false;
			}
			
			if (muted)
				FP.volume = 0;
			else
				FP.volume = 1;
		}
		
		override public function update():void 
		{
			if (client == null && checkClient)
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
		
		public function objectLoadError(e:PlayerIOError):void
		{
			trace(e.message);
			playerObject = null;
		}
		
	}

}