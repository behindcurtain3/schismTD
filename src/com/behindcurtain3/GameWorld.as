package com.behindcurtain3 
{
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import net.user1.reactor.IClient;
	import net.user1.reactor.Reactor;
	import net.user1.reactor.ReactorEvent;
	import net.user1.reactor.Room;
	import net.user1.reactor.RoomModules;
	import punk.ui.PunkTextArea;
	import punk.ui.PunkTextField;

	import punk.ui.PunkLabel;

	/**
	 * ...
	 * @author Justin Brown
	 */
	public class GameWorld extends World 
	{
		protected var chatbox:PunkTextField;
		protected var status:PunkTextArea;
		protected var statusLabel:PunkLabel;
		protected var reactor:Reactor;
		protected var chatRoom:Room;
	 
		public function GameWorld ()
		{
			// Setup UI
			status = new PunkTextArea("", 10, FP.screen.height / 2 + 35, FP.screen.width - 20, 200);
			status.visible = false;
			add(status);
			
			chatbox = new PunkTextField("", 10, FP.screen.height / 2 + 25, FP.screen.width - 20);
			chatbox.visible = false;
			add(chatbox);
			
			statusLabel = new PunkLabel("Connecting to server...", 10, FP.screen.height / 2 - 25, FP.screen.width - 20, 50);
			add(statusLabel);
			
			reactor = new Reactor();
			reactor.addEventListener(ReactorEvent.READY, readyListener);
			reactor.addEventListener(ReactorEvent.CLOSE, closeListener);
			reactor.connect("localhost", 9100);
		}
		
		override public function end():void
		{
			reactor.disconnect();
			removeAll();
			super.end();
		}
		
		override public function update():void
		{
			if (Input.pressed(Key.ENTER))
			{
				if (chatbox.text != "")
				{
					chatRoom.sendMessage(Messages.CHAT, true, null, chatbox.text);
					chatbox.text = "";
				}
			}
			
			if (Input.pressed(Key.ESCAPE))
			{
				FP.world = new MenuWorld();
			}
			super.update();
		}
	 
		protected function readyListener(e:ReactorEvent):void 
		{
			status.visible = true;
			chatbox.visible = true;
			statusLabel.text = "Connected to Union";
			trace("Connected to Union");
			
			var modules:RoomModules = new RoomModules();
			modules.addModule("com.behindcurtain3.schismTD.schismTDModule", "class");
			chatRoom = reactor.getRoomManager().createRoom("schismTD", null, null, modules);
			chatRoom.addMessageListener(Messages.CHAT, chatMessageListener);
			chatRoom.join();
			
		}
		
		protected function closeListener(e:ReactorEvent):void
		{
			statusLabel.text = "Disconnected";
			chatbox.visible = false;
			status.visible = false;
		}
	 
		protected function chatMessageListener (fromClient:IClient,	messageText:String):void {
			if (fromClient != null)
			{
				trace(fromClient.getClientID() + " says: " + messageText + "\n");
				status.text += "\n" + fromClient.getClientID() + " says: " + messageText;
			}
			else
			{
				trace(messageText);
				status.text += "\n" + messageText;
			}
		}
	}
}