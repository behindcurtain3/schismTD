package com.behindcurtain3 
{
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import net.user1.reactor.IClient;
	import net.user1.reactor.Reactor;
	import net.user1.reactor.ReactorEvent;
	import net.user1.reactor.Room;

	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class MenuWorld extends World 
	{
		
		protected var reactor:Reactor;
		protected var chatRoom:Room;
	 
		public function MenuWorld ()
		{
			reactor = new Reactor();
			reactor.addEventListener(ReactorEvent.READY, readyListener);
			reactor.connect("tryunion.com", 80);
		}
		
		override public function update():void
		{
			if (Input.pressed(Key.ENTER))
			{
				chatRoom.sendMessage("CHAT_MESSAGE", true, null, "Hello world!");
			}
			super.update();
		}
	 
		protected function readyListener (e:ReactorEvent):void {
			trace("Connected to Union");
			chatRoom = reactor.getRoomManager().createRoom("chatRoom");
			chatRoom.addMessageListener("CHAT_MESSAGE", chatMessageListener);
			chatRoom.join();
		}
	 
		protected function chatMessageListener (fromClient:IClient,	messageText:String):void {
			trace(fromClient.getClientID()
									  + " says: "
									  + messageText + "\n");
		}
		
	}
}