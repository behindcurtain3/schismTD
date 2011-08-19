package com.behindcurtain3
{
	import flash.display.ActionScriptVersion;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import playerio.*;
	
	import punk.ui.PunkTextArea;
	import punk.ui.PunkTextField;

	import punk.ui.PunkLabel;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class GameWorld extends World 
	{
		public var Mode:int = BuildMode.NONE;
		
		// UI
		protected var chatbox:PunkTextField;
		private var console:Array = new Array();
		protected var whiteHealthUI:Text;
		protected var whiteManaUI:Text;
		protected var blackHealthUI:Text;
		protected var blackManaUI:Text;
		
		private var consoleDisplayTime:Number = 5;
		
		// Gfx
		protected var board:Image;
		
		// Sfx
		protected var sfx_invalid:Sfx = new Sfx(Assets.SFX_INVALID);
		
		// Networking
		protected var client:Client;
		protected var connection:Connection;
		
		// Game
		private var gameActive:Boolean = false;
		private var gameCountdown:int = 0;
		private var dragStart:Point = null;
		private var dragEnd:Point = null;
		private var glow:Glow = null;
		private var blackId:int;
		private var whiteId:int;
		
		public var buildMode:int = BuildMode.NONE;
		public var objectSelected:Entity = null;
		public var fauxTower:FauxTower = new FauxTower();
		
		private var blackHealth:int = 0;
		private var blackMana:int = 0;
		private var whiteHealth:int = 0;
		private var whiteMana:int = 0;
		
		private var blackPath:Array;
		private var whitePath:Array;
	 
		public function GameWorld ()
		{
			FP.volume = 0.1;
			
			add(fauxTower);
			
			// Setup gfx
			board = new Image(Assets.GFX_BOARD);
			board.alpha = 0;
			addGraphic(board, 100, 0, 0);
			
			chatbox = new PunkTextField("", 10, FP.screen.height - 30, 200);
			chatbox.visible = false;
			add(chatbox);
			
			addToChat("Connecting...");
			
			PlayerIO.connect(
				FP.stage,								//Referance to stage
				"schismtd-3r3otmhvkki9ixublwca",		//Game id (Get your own at playerio.com. 1: Create user, 2:Goto admin pannel, 3:Create game, 4: Copy game id inside the "")
				"public",							//Connection id, default is public
				"GuestUser",						//Username
				"",									//User auth. Can be left blank if authentication is disabled on connection
				null,								//Current PartnerPay partner.
				handleConnect,						//Function executed on successful connect
				handleError							//Function executed if we recive an error
			); 
			
			
			Input.define("Chat", Key.T);
			Input.define("Send", Key.ENTER);
			
			Input.define("Build", Key.W, Key.UP);
			Input.define("Upgrade1", Key.A, Key.LEFT);
			Input.define("Upgrade2", Key.D, Key.RIGHT);
			Input.define("Sell", Key.S, Key.DOWN);
		}
		
		override public function end():void
		{
			if (connection != null)
			{
				connection.disconnect();
			}
			removeAll();
			super.end();
		}
		
		override public function update():void
		{
			if (chatbox.visible)
			{
				if (Input.pressed("Send"))
				{
					if (chatbox.text != "")
					{
						connection.send(Messages.CHAT, chatbox.text);
						chatbox.text = "";
					}
					chatbox.visible = false;
				}
			}
			else
			{
				if (Input.pressed("Chat"))
				{
					chatbox.visible = true;
				}
			}

			// Update UI
			if (connection != null)
			{
				whiteHealthUI.text = "Health: " + whiteHealth;
				whiteManaUI.text = "Chi: " + whiteMana;
				blackHealthUI.text = "Health: " + blackHealth;
				blackManaUI.text = "Chi: " + blackMana;
			}
				
			if (gameActive)
			{
				// Default is not visible
				fauxTower.visible = false;
				
				switch(buildMode)
				{
					case BuildMode.NONE:
						if (Input.pressed("Build"))
							buildMode = BuildMode.TOWER;
						
						// Glow is visible in this mode
						glow.visible = true;
						
						if (objectSelected != null)
						{
							if (Input.pressed("Upgrade1"))
							{
								connection.send(Messages.GAME_UPGRADE_TOWER, objectSelected.centerX, objectSelected.centerY, 1);
							}
							else if (Input.pressed("Upgrade2"))
							{
								connection.send(Messages.GAME_UPGRADE_TOWER, objectSelected.centerX, objectSelected.centerY, 2);
							}
							else if (Input.pressed("Sell"))
							{
								connection.send(Messages.GAME_SELL_TOWER, objectSelected.centerX, objectSelected.centerY);
							}
						}
						
						break;
					case BuildMode.TOWER:					
						if (Input.pressed("Build") || objectSelected != null)
							buildMode = BuildMode.NONE;
						
						// Glow is not visible in this mode
						glow.visible = false;
							
						// Draw the faux tower over the cell the mouse is over
						var cell:Cell = collidePoint("cell", Input.mouseX, Input.mouseY) as Cell;
						
						if (cell != null)
						{
							if (!cell.hasTower)
							{
								fauxTower.visible = true;
								fauxTower.x = cell.x;
								fauxTower.y = cell.y;
								
								// build here
								if (Input.mouseReleased)
								{
									if (connection != null)
									{
										connection.send(Messages.GAME_PLACE_TOWER, Input.mouseX, Input.mouseY);
									}
								}
							}
						}
						break;
				}

				if (Input.mousePressed)
				{
					dragStart = new Point(Input.mouseX, Input.mouseY);
				}
				
				if (Input.mouseReleased)
				{
					dragEnd = new Point(Input.mouseX, Input.mouseY);
					
					// Check if something exists
					var cell:Cell = collidePoint("cell", dragEnd.x, dragEnd.y) as Cell;
						
					if (cell != null)
					{
						if (!cell.hasTower)
						{
							objectSelected = null;
						}
						else
						{
							if (cell.isOurs())
							{
								objectSelected = cell;
							}
						}
					}

					dragStart = null;
					dragEnd = null;
				}
			}
			
			if (Input.pressed(Key.ESCAPE))
			{
				disconnect();
			}
			
			super.update();
		}
		
		private function disconnect(message:String = ""):void
		{
			addToChat("Disconnected");
			
			if(connection != null)
				connection.disconnect();
				
			FP.world = new MenuWorld(message);
		}
		
		private function handleConnect(c:Client):void
		{
			client = c;
			
			//Set developmentsever (Comment out to connect to your server online)
			client.multiplayer.developmentServer = "127.0.0.1:8184";
			
			//Create pr join the room test
			client.multiplayer.createJoinRoom(
				"schismTD",							//Room id. If set to null a random roomid is used
				"schismTD",							//The game type started on the server
				true,								//Should the room be visible in the lobby?
				{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
				{},									//User join data
				handleJoin,							//Function executed on successful joining of the room
				handleError							//Function executed if we got a join error
			);
			
		}
		
		private function handleJoin(c:Connection):void
		{
			addToChat("Connected");
			connection = c;
			
			// Setup UI
			chatbox.visible = false;
			
			whiteHealthUI = new Text("Life:", 5, 5, 100, 25);
			whiteManaUI = new Text("Mana:", 105, 5, 100, 25);
			addGraphic(whiteHealthUI);
			addGraphic(whiteManaUI);
			
			blackHealthUI = new Text("Life:", FP.screen.width - 200, FP.screen.height - 30, 100, 25);
			blackManaUI = new Text("Mana:", FP.screen.width - 95, FP.screen.height - 30, 100, 25);
			addGraphic(blackHealthUI);
			addGraphic(blackManaUI);
			
			
			connection.addMessageHandler(Messages.CHAT, function(m:Message, s:String):void {
				addToChat(s);
			});
			
			connection.addMessageHandler(Messages.PLAYER_JOINED, function(m:Message, i:int):void {
				addToChat("Player #" + i + " has joined");
			});
			
			connection.addMessageHandler(Messages.PLAYER_LEFT, function(m:Message, i:int):void {
				addToChat("Player #" + i + " has left");
			});
			
			connection.addMessageHandler(Messages.MATCH_READY, function(m:Message):void {
				addToChat("Match ready to begin!");
			});
			
			connection.addMessageHandler(Messages.MATCH_STARTED, function(m:Message, id1:int, id2:int):void {
				blackId = id1;
				whiteId = id2;
				addToChat("Matched started!");
				
				var vt:VarTween = new VarTween();
				vt.tween(board, "alpha", 1, 2.5, Ease.expoOut);
				addTween(vt, true);
			});
			
			connection.addMessageHandler(Messages.MATCH_FINISHED, function(m:Message):void {
				addToChat("Matched finished!");
				var vt:VarTween = new VarTween();
				vt.tween(board, "alpha", 0, 1.5, Ease.expoOut);
				addTween(vt, true);
			});
			
			connection.addMessageHandler(Messages.GAME_COUNTDOWN, function(m:Message, i:Number):void {
				i = Math.ceil(i / 1000);
				if (i != gameCountdown)
				{
					addToChat("Starting in ... " + i, 1.5);
					gameCountdown = i;
				}
			});
			
			connection.addMessageHandler(Messages.GAME_ACTIVATE, function(m:Message):void {
				gameActive = true;
				glow = new Glow();
				add(glow);
			});
			
			connection.addMessageHandler(Messages.GAME_START, function(m:Message):void {
				addToChat("Game started!");				
			});
			
			connection.addMessageHandler(Messages.GAME_FINISHED, function(m:Message, id:int):void {
				gameActive = false;
				
				removeList(getCells());
				removeList(getCreeps());
				removeList(getProjectiles());
				
				if (glow != null)
				{
					remove(glow);
					glow = null;
				}
				
				if (id == -1)
				{
					// Draw
					addToChat("Game is drawn!", 10);
				}
				else if (id == blackId)
				{
					addToChat("Black wins!", 10);
				}
				else if (id == whiteId)
				{
					addToChat("White wins!", 10);
				}
				
			});
			
			connection.addMessageHandler(Messages.GAME_ADD_CELL, function(m:Message, i:int, x:int, y:int, w:int, h:int, mine:Boolean):void {
				var c:Cell = new Cell(i, x, y, w, h, mine);
				add(c);
			});
			
			connection.addMessageHandler(Messages.GAME_PLACE_TOWER, function(m:Message, i:int, type:String):void {				
				for each(var tc:Cell in getCells())
				{
					if (tc.getIndex() == i)
					{
						tc.assignGfx(Assets.GFX_TOWER_BASIC);
					}
				}
			});
			
			connection.addMessageHandler(Messages.GAME_REMOVE_TOWER, function(m:Message, index:int):void {
				for each(var tc:Cell in getCells())
				{
					if (tc.getIndex() == index)
					{
						if (objectSelected == tc)
							objectSelected = null;
						tc.graphic = null;
						tc.hasTower = false;
					}
				}
			});
			
			connection.addMessageHandler(Messages.GAME_INVALID_TOWER, function(m:Message, x:int, y:int):void {
				addToChat("Invalid tower placement!");
				sfx_invalid.play();
			});
			
			connection.addMessageHandler(Messages.GAME_CREEP_ADD, function(m:Message, id:String, pId:int, x:int, y:int, sp:int):void {
				if(pId == blackId)
					add(new Creep(id, pId, x, y, sp, whitePath));
				else if (pId == whiteId)
					add(new Creep(id, pId, x, y, sp, blackPath));
			});
			
			connection.addMessageHandler(Messages.GAME_CREEP_REMOVE, function(m:Message, id:String):void {
				for each(var cr:Creep in getCreeps())
				{
					if (cr.ID == id)
					{
						remove(cr);
						
						for each(var p:Projectile in getProjectiles())
						{
							if (p.target == cr)
							{
								remove(p);
							}
						}						
						break;
					}
				}
			});
			
			connection.addMessageHandler(Messages.GAME_CREEP_UPDATE_LIFE, function(m:Message, id:String, value:int):void {
				for each(var cr:Creep in getCreeps())
				{
					if (cr.ID == id)
					{
						cr.updateLife(value);
						break;
					}
				}
			});
			
			connection.addMessageHandler(Messages.GAME_LIFE, function(m:Message, id:int, value:int):void {
				if (id == blackId)
					blackHealth = value;
				else
					whiteHealth = value;
			});
			
			connection.addMessageHandler(Messages.GAME_MANA, function(m:Message, id:int, value:int):void {
				if (id == blackId)
					blackMana = value;
				else
					whiteMana = value;
			});
			
			connection.addMessageHandler(Messages.GAME_PROJECTILE_ADD, function(m:Message, id:String, x:Number, y:Number, v:Number, crID:String):void {
				var creep:Creep = null;
				for each(var cr:Creep in getCreeps())
				{
					if (cr.ID == crID)
					{
						creep = cr;
						break;
					}					
				}
				
				if (creep != null)
				{
					add(new Projectile(id, x, y, v, creep));					
				}				
			});
			
			connection.addMessageHandler(Messages.GAME_PROJECTILE_REMOVE, function(m:Message, id:String):void {				
				for each(var p:Projectile in getProjectiles())
				{
					if (p.id == id)
					{
						p.destroy();
					}
				}
				
			});
			
			connection.addMessageHandler(Messages.GAME_CREEP_EFFECT, function(m:Message, id:String, type:String, duration:int):void {
				for each(var creep:Creep in getCreeps())
				{
					if (creep.ID == id)
					{
						switch(type)
						{
							case "slow":
								creep.addEffect(new SlowEffect(creep, duration / 1000));
								break;
						}
					}
				}
			});
			
			connection.addMessageHandler(Messages.GAME_ALL_CREEPS_PATH, updatePaths);
			connection.addMessageHandler(Messages.GAME_CREEP_PATH, updateSinglePath);
			
			connection.addDisconnectHandler(function():void {
				disconnect("Connection to server lost");
			});
		}
		
		private function updatePaths(m:Message):void
		{
			var newPath:Array = new Array();
			
			for (var i:int = 1; i < m.length; i++)
			{
				var cell:Cell = getCell(m.getInt(i));
				
				if (cell != null)
					newPath.push(cell);
			}
			
			if (blackId == m.getInt(0))
			{
				blackPath = newPath;
			}
			else if (whiteId == m.getInt(0))
			{
				whitePath = newPath;
			}
		}
		
		private function updateSinglePath(m:Message):void
		{
			var newPath:Array = new Array();
			
			for (var i:int = 1; i < m.length; i++)
			{
				var cell:Cell = getCell(m.getInt(i));
				
				if (cell != null)
				{
					newPath.push(cell);
				}
			}
			
			for each(var c:Creep in getCreeps())
			{
				if (c.ID == m.getString(0))
				{
					c.updatePath(newPath);
				}
			}
		}
		
		private function handleError(error:PlayerIOError):void
		{
			addToChat(error.message);		
			disconnect(error.message);
		}
		
		public function addToChat(s:String, time:Number = 4):void
		{
			var t:Text = new Text(s, 10, FP.screen.height - 60, FP.screen.width - 20, 20);
			var vt:VarTween = new VarTween();
			vt.tween(t, "alpha", 0, time, Ease.quadIn);
			
			addGraphic(t);
			addTween(vt);
			
			for each(var text:Text in console)
			{
				text.y -= 20;
			}
			
			console.push(t);
		}
		
		public function getCell(index:int):Cell
		{
			var cells:Array = getCells();
			
			for each(var cell:Cell in cells)
			{
				if (cell.getIndex() == index)
					return cell;
			}
			
			return null;
		}
		
		public function getCells():Array
		{
			var cells:Array = new Array();
			getClass(Cell, cells);
				
			return cells;
		}
		
		public function getCreeps():Array
		{
			var c:Array = new Array();
			getClass(Creep, c);
				
			return c;
		}
		
		public function getProjectiles():Array
		{
			var p:Array = new Array();
			getClass(Projectile, p);
			return p;
		}
		
	}
}