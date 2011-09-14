package schism.worlds
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.World;
	import playerio.*;
	import schism.Assets;
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
		
		public function MatchFinderWorld(client:Client) 
		{
			this.client = client;

			// Title
			addGraphic(new Image(Assets.GFX_BACKGROUND), 10);
			add(new MessageDisplay("Waiting for an opponent", 99999, 24));
			
			//Set developmentsever (Comment out to connect to your server online)
			client.multiplayer.developmentServer = "192.168.0.169:8184";
			
			//Create pr join the room test
			client.multiplayer.createJoinRoom(
				"match-maker2",							//Room id. If set to null a random roomid is used
				"$service-room$",					//The game type started on the server
				true,								//Should the room be visible in the lobby?
				{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
				{},									//User join data
				handleJoin,							//Function executed on successful joining of the room
				handleClientError					//Function executed if we got a join error
			);	
			
		}
		
		private function handleJoin(c:Connection):void
		{
			connection = c;

			connection.addMessageHandler(Messages.MATCH_ID, function(m:Message, gameId:String):void {
				connection.disconnect();
				FP.world = new GameWorld(client, gameId);
			});
		}
		
		private function handleConnectionError(error:PlayerIOError):void
		{
			FP.world = new LoginWorld("Connection: " + error.message);
		}
		
		private function handleClientError(error:PlayerIOError):void
		{			
			switch(error.type)
			{
				case PlayerIOError.NoServersAvailable:
					FP.world = new LoginWorld("There are no game servers currently available.");
					break;
				default:
					FP.world = new LoginWorld("Client Error: " + error.message);
					break;
			}
			
			
		}
		
		
	}

}