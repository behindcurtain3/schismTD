package schism.worlds
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
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
	public class MatchFinderWorld extends World 
	{
		private var client:Client;
		private var connection:Connection;
		
		private var previousDidYouKnow:int = -1;
		
		private var messageDisplay:MessageDisplay;
		
		public function MatchFinderWorld(client:Client) 
		{
			this.client = client;
			
			// Title
			addGraphic(new Image(Assets.GFX_BACKGROUND), 100);
			addGraphic(new Image(Assets.GFX_TITLE), 99, FP.screen.width / 2 - 275, 50);
			messageDisplay = new MessageDisplay("Connecting to lobby...", 0, 36, 0, FP.screen.height / 2);
			add(messageDisplay);
			
			//Set developmentsever (Comment out to connect to your server online)
			this.client.multiplayer.developmentServer = "72.220.227.32:8184";
			//client.multiplayer.developmentServer = "192.168.0.169:8184";
			
			//Create pr join the room test
			this.client.multiplayer.createJoinRoom(
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
		
		private function handleDisconnect():void
		{
			FP.world = new TitleWorld("Connection to the lobby was lost, please try again.");
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
		
			this.connection = c;
			this.connection.addDisconnectHandler(handleDisconnect);		
			
			this.connection.addMessageHandler(Messages.MATCH_CREATE, function(m:Message, gameId:String):void {
				connection.disconnect();
				FP.world = new GameWorld(client, gameId, true);
			});
			
			this.connection.addMessageHandler(Messages.MATCH_ID, function(m:Message, gameId:String):void {
				connection.disconnect();
				FP.world = new GameWorld(client, gameId);
			});
		}
		
		private function handleConnectionError(error:PlayerIOError):void
		{
			FP.world = new TitleWorld("Connection: " + error.message);
		}
		
		
		private function handleClientError(error:PlayerIOError):void
		{			
			switch(error.type)
			{
				case PlayerIOError.NoServersAvailable:
					FP.world = new TitleWorld("There are no game servers currently available.");
					break;
				default:
					FP.world = new TitleWorld("There was an error connecting to the servers.");
					break;
			}						
		}
		
	}

}