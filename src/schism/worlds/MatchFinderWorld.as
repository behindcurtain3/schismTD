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
		private var connStatus:MessageDisplay;
		private var totalTimeWaiting:Number = 0;
		private var waitHelper:Boolean = false;
		private var fanpageLink:Boolean = false;
		
		public function MatchFinderWorld(c:Client, guest:Boolean = false) 
		{
			super(c, guest);
			
			connStatus = new MessageDisplay("Connecting to lobby...", 0, 36, 0, FP.screen.height / 2);
			add(connStatus);
			
			//Create or join the room test
			client.multiplayer.createJoinRoom(
				"match-maker",						//Room id. If set to null a random roomid is used
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
			
			if (connection != null)
				totalTimeWaiting += FP.elapsed;
				
			if (totalTimeWaiting > 10 && !waitHelper)
			{
				if (connStatus != null)
					remove(connStatus);
					
				connStatus = new MessageDisplay("Waiting for a challenger...\n\nIt looks you've been waiting a little bit.\nInvite a friend to join you to play!", 0, 24, 0, FP.screen.height / 2);
				add(connStatus);
				waitHelper = true;
			}
			if (totalTimeWaiting > 25 && !fanpageLink)
			{
				if (connStatus != null)
					remove(connStatus);
					
				connStatus = new MessageDisplay("Waiting for a challenger...\n\nYou can also check out our website\nschismtd.com\n\nIt contains a strategy guide and forums\n", 0, 24, 0, FP.screen.height / 2);
				add(connStatus);
				fanpageLink = true;
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
			
			if (connStatus != null)
				remove(connStatus);
				
			connStatus = new MessageDisplay("Waiting for a challenger...", 0, 36, 0, FP.screen.height / 2);
			add(connStatus);
		
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
					e = error.message;
					break;
			}			
			
			if (_isGuest)
				FP.world = new TitleWorld(e);
			else
				FP.world = new HomeWorld(client, e);
		}
		
	}

}