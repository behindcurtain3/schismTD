package schism.worlds
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import playerio.*;
	import schism.Assets;
	import schism.DidYouKnow;
	import schism.Messages;
	import schism.ui.MessageDisplay;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class MatchFinderWorld extends AuthWorld
	{		
		private var previousDidYouKnow:int = -1;
		
		private var messageDisplay:MessageDisplay;
		
		public function MatchFinderWorld(c:Client, guest:Boolean = false) 
		{
			super(c, guest);
			
			// Title
			addGraphic(new Image(Assets.GFX_BACKGROUND), 100);
			addGraphic(new Image(Assets.GFX_TITLE), 99, FP.screen.width / 2 - 275, 50);
			messageDisplay = new MessageDisplay("Connecting to lobby...", 0, 36, 0, FP.screen.height / 2);
			add(messageDisplay);
			
			//Create pr join the room test
			client.multiplayer.createJoinRoom(
				"match-maker2",						//Room id. If set to null a random roomid is used
				"$service-room$",					//The game type started on the server
				true,								//Should the room be visible in the lobby?
				{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
				{},									//User join data
				handleJoin,							//Function executed on successful joining of the room
				handleClientError					//Function executed if we got a join error
			);			
			
			newDidYouKnow();			
		}
		
		override public function update():void 
		{
			if (Input.pressed(Key.ESCAPE))
			{
				if (connection != null && connection.connected)
					connection.disconnect();
				
				if (_isGuest)
					FP.world = new TitleWorld();
				else
					FP.world = new HomeWorld(client);
			}
			
			super.update();
		}
		
		private function handleDisconnect():void
		{
			var e:String = "Connection to the lobby was lost, please try again.";
			if (_isGuest)
				FP.world = new TitleWorld(e);
			else
				FP.world = new HomeWorld(client, e);
		}
		
		private function newDidYouKnow():void
		{
			var i:int;
			
			do
			{
				i = Math.round(Math.random() * DidYouKnow.strings.length) - 1;
				if (i < 0)
					i = DidYouKnow.strings.length - 1;
			} while (i == previousDidYouKnow);
			
			previousDidYouKnow = i;
			add(new MessageDisplay("Pro Tip:\n" + DidYouKnow.strings[i], 10, 14, FP.screen.width / 2, 0, 400, 50, newDidYouKnow));
		}
		
		private function handleJoin(c:Connection):void
		{
			if (messageDisplay != null)
				remove(messageDisplay);
				
			messageDisplay = new MessageDisplay("Waiting for a challenger...", 0, 36, 0, FP.screen.height / 2);
			add(messageDisplay);
		
			connection = c;
			connection.addDisconnectHandler(handleDisconnect);		
			
			connection.addMessageHandler(Messages.MATCH_CREATE, function(m:Message, gameId:String):void {
				connection.disconnect();
				FP.world = new GameWorld(client, _isGuest, gameId, true);
			});
			
			connection.addMessageHandler(Messages.MATCH_ID, function(m:Message, gameId:String):void {
				connection.disconnect();
				FP.world = new GameWorld(client, _isGuest, gameId);
			});
		}
		
		private function handleConnectionError(error:PlayerIOError):void
		{
			FP.world = new TitleWorld("Connection: " + error.message);
		}
		
		
		private function handleClientError(error:PlayerIOError):void
		{			
			var e:String;
			switch(error.type)
			{
				case PlayerIOError.NoServersAvailable:
					e = "There are no game servers currently available.";
					break;
				default:
					e = "There was an error connecting to the servers.";
					break;
			}			
			
			if (_isGuest)
				FP.world = new TitleWorld(e);
			else
				FP.world = new HomeWorld(client, e);
		}
		
	}

}