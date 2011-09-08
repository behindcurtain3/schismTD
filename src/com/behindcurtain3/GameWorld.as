package com.behindcurtain3
{
	import flash.display.ActionScriptVersion;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.Font;
	import flash.text.TextSnapshot;
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
		
		// Settings
		private var gameId:String;
		private var connectionAttempts:int = 0;
		
		
		// UI
		private var console:Array = new Array();
		protected var whiteHealthUI:Text;
		protected var whiteManaUI:Text;
		protected var blackHealthUI:Text;
		protected var blackManaUI:Text;
		protected var whiteWaveQueue:WhiteWaveQueue;
		protected var blackWaveQueue:BlackWaveQueue;
		protected var buildMenu:BuildMenu;
		protected var buildInstructions:Text;
		protected var countdownText:Text;
		
		private var consoleDisplayTime:Number = 5;
		
		// Gfx
		protected var titleLeft:Image;
		protected var titleRight:Image;
		protected var board:Image;
		
		// Sfx
		protected var sfx_invalid:Sfx = new Sfx(Assets.SFX_INVALID);
		
		// Networking
		protected var client:Client;
		protected var connection:Connection;
		
		//Players
		private var color:String = "";
		private var blackId:int;
		private var whiteId:int;
		
		// Game
		private var gameActive:Boolean = false;
		private var gameCountdown:int = 0;
		private var dragStart:Point = null;
		private var dragEnd:Point = null;
		private var glow:Glow = null;	
		
		public var buildMode:int = BuildMode.NONE;
		public var objectSelected:Entity = null;
		public var fauxTower:FauxTower = new FauxTower();
		
		private var blackHealth:int = 0;
		private var blackMana:int = 0;
		private var whiteHealth:int = 0;
		private var whiteMana:int = 0;
		
		private var blackPath:Array;
		private var whitePath:Array;
	 
		public function GameWorld (client:Client, gameId:String)
		{
			this.client = client;
			this.gameId = gameId;
			
			FP.volume = 0.1;
			
			add(fauxTower);
			
			// Title
			titleLeft = new Image(Assets.GFX_TITLE_LEFT);
			titleRight = new Image(Assets.GFX_TITLE_RIGHT);
			
			addGraphic(titleLeft, 1, 0, 0);
			addGraphic(titleRight, 0, 400, 0);			
			
			// Setup gfx
			board = new Image(Assets.GFX_BOARD);
			board.alpha = 0;
			addGraphic(board, 100, 0, 0);
			addGraphic(new Image(Assets.GFX_BOARD_OVERLAY), 5);
						
			whiteWaveQueue = new WhiteWaveQueue();
			add(whiteWaveQueue);
			blackWaveQueue = new BlackWaveQueue();
			add(blackWaveQueue);
			
			buildMenu = new BuildMenu();
			add(buildMenu);
			
			buildInstructions = new Text("Press W to build", 5, FP.screen.height - 25);
			buildInstructions.font = "Domo";
			buildInstructions.size = 18;
			
			addGraphic(buildInstructions, 2);
			
			var str:String = "Go!";
			countdownText = new Text(str, (FP.screen.width / 2) - (str.length / 2 * 48), (FP.screen.height / 2) - 48, 250, 250);
			countdownText.font = "Domo";
			countdownText.size = 96;
			countdownText.visible = false;
			addGraphic(countdownText, 2);
			
			connect();
			
			Input.define("Chat", Key.T);
			Input.define("Send", Key.ENTER);
			
			Input.define("Build", Key.W, Key.UP);
			Input.define("Upgrade1", Key.A, Key.LEFT);
			Input.define("Upgrade2", Key.D, Key.RIGHT);
			Input.define("Sell", Key.S, Key.DOWN);
			
			Input.define("Wave1", Key.DIGIT_1, Key.NUMPAD_1);
			Input.define("Wave2", Key.DIGIT_2, Key.NUMPAD_2);
			Input.define("Wave3", Key.DIGIT_3, Key.NUMPAD_3);
		}
		
		public function connect():void
		{
			client.multiplayer.createJoinRoom(
				gameId,								//Room id. If set to null a random roomid is used
				"schismTD",							//The game type started on the server
				false,								//Should the room be visible in the lobby?
				{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
				{},									//User join data
				handleNewGame,						//Function executed on successful joining of the room
				handleError							//Function executed if we got a join error
			);
			
			connectionAttempts++;
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
			if (buildInstructions.visible)
			{
				if (buildInstructions.alpha == 0)
				{
					var alphaTween:VarTween = new VarTween();
					alphaTween.tween(buildInstructions, "alpha", 1, 0.5);
					addTween(alphaTween, true);
				}
				else if (buildInstructions.alpha == 1)
				{
					var alphaTween:VarTween = new VarTween();
					alphaTween.tween(buildInstructions, "alpha", 0, 0.5);
					addTween(alphaTween, true);
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
						{
							buildMode = BuildMode.TOWER;
							objectSelected = null;
							buildMenu.visible = false;
							buildInstructions.visible = false;
						}
						
						// Update if glow is visible
						var hoverCell:Cell = collidePoint("cell", Input.mouseX, Input.mouseY) as Cell;
						
						if (hoverCell == null)
						{
							glow.visible = false;	
						}
						else
						{
							glow.visible = hoverCell.hasTower && hoverCell.isOurs();
							glow.x = hoverCell.x - 1;
							glow.y = hoverCell.y - 1;
						}
						
						if (objectSelected != null)
						{
							glow.visible = true;
							glow.x = objectSelected.x - 1;
							glow.y = objectSelected.y - 1;
							
							if (Input.released("Upgrade1"))
							{
								connection.send(Messages.GAME_TOWER_UPGRADE, objectSelected.centerX, objectSelected.centerY, 1);
							}
							else if (Input.released("Upgrade2"))
							{
								connection.send(Messages.GAME_TOWER_UPGRADE, objectSelected.centerX, objectSelected.centerY, 2);
							}
							else if (Input.released("Sell"))
							{
								connection.send(Messages.GAME_TOWER_SELL, objectSelected.centerX, objectSelected.centerY);
							}
						}
						
						if (Input.mouseReleased)
						{
							var creep:Creep = collidePoint("creep", Input.mouseX, Input.mouseY) as Creep;
							
							if (creep != null)
							{
								if ((color == "black" && creep.player == whiteId) || (color == "white" && creep.player == blackId))
								{
									creep.flash();
									connection.send(Messages.GAME_FIRE_AT, creep.ID);
								}
							}
						}
						
						break;
					case BuildMode.TOWER:					
						if (Input.pressed("Build") || objectSelected != null)
						{
							buildMode = BuildMode.NONE;
						}
						
						// Glow is not visible in this mode
						glow.visible = false;
							
						// Draw the faux tower over the cell the mouse is over
						var cell:Cell = collidePoint("cell", Input.mouseX, Input.mouseY) as Cell;
						
						if (cell != null)
						{
							if (!cell.hasTower && cell.isOurs())
							{
								fauxTower.visible = true;
								fauxTower.x = cell.x;
								fauxTower.y = cell.y;
								
								// build here
								if (Input.mouseReleased)
								{
									if (connection != null)
									{
										connection.send(Messages.GAME_TOWER_PLACE, Input.mouseX, Input.mouseY);
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
					cell = collidePoint("cell", dragEnd.x, dragEnd.y) as Cell;
						
					if (cell != null)
					{
						if (!cell.hasTower)
						{
							objectSelected = null;
							buildMenu.visible = false;
						}
						else
						{
							if (cell.isOurs())
							{
								objectSelected = cell;
								buildMenu.displayAt(cell);
							}
						}
					}
					else
					{
						objectSelected = null;
						buildMenu.visible = false;
					}

					dragStart = null;
					dragEnd = null;
				}
				
				if (Input.released("Wave1"))
				{
					if (color == "black")
						connection.send(Messages.GAME_WAVE_NEXT, blackWaveQueue.oneWave.Id);
					else
						connection.send(Messages.GAME_WAVE_NEXT, whiteWaveQueue.oneWave.Id);
				}

				if (Input.released("Wave2"))
				{
					if (color == "black")
						connection.send(Messages.GAME_WAVE_NEXT, blackWaveQueue.twoWave.Id);
					else
						connection.send(Messages.GAME_WAVE_NEXT, whiteWaveQueue.twoWave.Id);
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
				
			FP.world = new LoginWorld(message);
		}
		
		private function handleNewGame(c:Connection):void
		{
			connection = c;
			connection.addDisconnectHandler(handleDisconnect);
			
			// Setup UI			
			whiteHealthUI = new Text("Life:", 5, 5, 100, 25);
			whiteHealthUI.visible = false;
			whiteHealthUI.font = "Domo";
			whiteHealthUI.size = 18;
			
			whiteManaUI = new Text("Mana:", 105, 5, 100, 25);
			whiteManaUI.visible = false;
			whiteManaUI.font = "Domo";
			whiteManaUI.size = 18;
			addGraphic(whiteHealthUI);
			addGraphic(whiteManaUI);
			
			blackHealthUI = new Text("Life:", FP.screen.width - 200, FP.screen.height - 30, 100, 25);
			blackHealthUI.visible = false;
			blackHealthUI.font = "Domo";
			blackHealthUI.size = 18;
			
			blackManaUI = new Text("Mana:", FP.screen.width - 95, FP.screen.height - 30, 100, 25);
			blackManaUI.visible = false;
			blackManaUI.font = "Domo";
			blackManaUI.size = 18;
			
			addGraphic(blackHealthUI);
			addGraphic(blackManaUI);
			
			
			connection.addMessageHandler(Messages.CHAT, function(m:Message, s:String):void {
				addToChat(s);
			});
			
			connection.addMessageHandler(Messages.GAME_JOINED, function(m:Message):void {
				addToChat("Joined game.");
			});
			
			connection.addMessageHandler(Messages.GAME_INFO, function(m:Message):void {
				var vt:VarTween = new VarTween();
				vt.tween(board, "alpha", 1, 2.5, Ease.expoOut);
				addTween(vt, true);
				
				if (m.getString(0) == "black")
				{
					color = m.getString(0);
					blackId = m.getInt(1);
					whiteId = m.getInt(2);
				} 
				else if (m.getString(0) == "white")
				{
					color = m.getString(0);
					whiteId = m.getInt(1);
					blackId = m.getInt(2);
				}
				
			});
			
			connection.addMessageHandler(Messages.GAME_ACTIVATE, activateGame); 
			
			connection.addMessageHandler(Messages.GAME_START, function(m:Message):void {
				countdownText.visible = true;
				
				var alphaTween:VarTween = new VarTween();
				alphaTween.tween(countdownText, "alpha", 0, 2);
				addTween(alphaTween, true);
			});
			
			connection.addMessageHandler(Messages.GAME_FINISHED, function(m:Message):void {
				gameActive = false;
				
				removeList(getCells());
				removeList(getCreeps());
				removeList(getProjectiles());
				
				if (glow != null)
				{
					remove(glow);
					glow = null;
				}
				
				var result:String = "";
				if (m.getInt(0) == -1)
				{
					// Draw
					result = "Draw";
				}
				else if (m.getInt(0) == blackId)
				{
					result = "Black wins!";
				}
				else if (m.getInt(0) == whiteId)
				{
					result = "White wins!";
				}
				
				FP.world = new ResultWorld(client, connection, result, m.getInt(1), m.getInt(2), m.getUInt(3), m.getUInt(4));
			});
			
			connection.addMessageHandler(Messages.GAME_CELL_ADD, function(m:Message, i:int, x:int, y:int, w:int, h:int, mine:Boolean):void {				
				var c:Cell = new Cell(i, x, y, w, h, mine);
				add(c);
			});
			
			connection.addMessageHandler(Messages.GAME_TOWER_PLACE, function(m:Message, i:int, type:String):void {				
				for each(var tc:Cell in getCells())
				{
					if (tc.getIndex() == i)
					{
						switch(type)
						{
							case "basic":
								tc.assignGfx(Assets.GFX_TOWER_BASIC);
								break;
							case "rapidfire":
								tc.assignGfx(Assets.GFX_TOWER_RAPIDFIRE);
								break;
							case "slow":
								tc.assignGfx(Assets.GFX_TOWER_SLOW);
								break;
							case "pulse":
								tc.assignGfx(Assets.GFX_TOWER_PULSE);
								break;
							case "sniper":
								tc.assignGfx(Assets.GFX_TOWER_SNIPER);
								break;
							case "spell":
								tc.assignGfx(Assets.GFX_TOWER_SPELL);
								break;
							case "damageboost":
								tc.assignGfx(Assets.GFX_TOWER_DAMAGEBOOST);
								break;	
							case "rangeboost":
								tc.assignGfx(Assets.GFX_TOWER_RANGEBOOST);
								break;
							case "rateboost":
								tc.assignGfx(Assets.GFX_TOWER_RATEBOOST);
								break;
						}
						
						if (tc == objectSelected)
						{
							buildMenu.displayAt(tc);
						}
						
					}
				}
			});
			
			connection.addMessageHandler(Messages.GAME_TOWER_REMOVE, function(m:Message, index:int):void {
				for each(var tc:Cell in getCells())
				{
					if (tc.getIndex() == index)
					{
						if (objectSelected == tc)
						{
							objectSelected = null;
							buildMenu.visible = false;
						}
						tc.graphic = null;
						tc.hasTower = false;
					}
				}
			});
			
			connection.addMessageHandler(Messages.GAME_TOWER_INVALID, function(m:Message, x:int, y:int):void {
				addToChat("Invalid tower placement!");
				sfx_invalid.play();
			});
			
			connection.addMessageHandler(Messages.GAME_CREEP_ADD, function(m:Message, id:String, type:String, pId:int, x:int, y:int, sp:int):void {
				var path:Array;
				
				if (whitePath == null || blackPath == null)
				{
					trace("Error: no path has been set.");
					return;
				}
				
				if (pId == blackId)
					path = whitePath;
				else
					path = blackPath;
				
				switch(type)
				{
					case "Chigen":
						add(new ChigenCreep(id, pId, x, y, sp, path));
						break;			
					case "Regen":
						add(new RegenCreep(id, pId, x, y, sp, path));
						break;
					case "Quick":
						add(new QuickCreep(id, pId, x, y, sp, path));
						break;
					case "Magic":
						add(new MagicCreep(id, pId, x, y, sp, path));
						break;
					case "Armor":
						add(new ArmorCreep(id, pId, x, y, sp, path));
						break;
					case "Swarm":
						add(new SwarmCreep(id, pId, x, y, sp, path));
						break;
				}

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
			
			connection.addMessageHandler(Messages.PLAYER_LIFE, function(m:Message, id:int, value:int):void {
				if (id == blackId)
					blackHealth = value;
				else
					whiteHealth = value;
			});
			
			connection.addMessageHandler(Messages.PLAYER_MANA, function(m:Message, id:int, value:int):void {
				if (id == blackId)
					blackMana = value;
				else
					whiteMana = value;
			});
			
			connection.addMessageHandler(Messages.GAME_PROJECTILE_ADD, function(m:Message, id:String, type:String, x:Number, y:Number, v:Number, crID:String):void {
				var creep:Creep = null;
				
				switch(type)
				{
					case "Pulse":
						add(new PulseProjectile(id, x, y, v));
						break;
					default:
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
							add(new Projectile(id, x, y, v, creep, type));
						}
						break;
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
			connection.addMessageHandler(Messages.GAME_WAVE_ACTIVATE, activateWave);
			connection.addMessageHandler(Messages.GAME_WAVE_QUEUE, queueWave);
			connection.addMessageHandler(Messages.GAME_WAVE_REMOVE, removeWave);
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
			else
			{
				trace("Error! Paths sent do not match player!");
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
		
		private function activateWave(m:Message):void
		{
			var types:Array = new Array();
			
			for (var i:int = 4; i < m.length; i++)
			{
				types.push(m.getString(i));				
			}
			
			if (m.getInt(0) == whiteId)
			{
				whiteWaveQueue.setActiveWave(m.getString(1), types);
			}
			else if (m.getInt(0) == blackId)
			{
				blackWaveQueue.setActiveWave(m.getString(1), types);
			}
		}
		
		private function queueWave(m:Message):void
		{
			var types:Array = new Array();
			
			for (var i:int = 3; i < m.length; i++)
			{
				types.push(m.getString(i));				
			}
			
			if (m.getInt(0) == whiteId)
			{
				whiteWaveQueue.addWave(m.getString(1), m.getInt(2), types);
			}
			else if (m.getInt(0) == blackId)
			{
				blackWaveQueue.addWave(m.getString(1), m.getInt(2), types);
			}
		}
		
		private function removeWave(m:Message):void
		{
			if (m.getInt(0) == whiteId)
			{
				whiteWaveQueue.removeWave(m.getString(1));
			}
			else if (m.getInt(0) == blackId)
			{
				blackWaveQueue.removeWave(m.getString(1));
			}
		}
		
		private function activateGame(m:Message):void 
		{					
			// tween out the title
			var tweenLeft:VarTween = new VarTween();
			tweenLeft.tween(titleLeft, "x", -400, 0.5, Ease.quintOut);
			
			var tweenRight:VarTween = new VarTween();
			tweenRight.tween(titleRight, "x", 400, 0.5, Ease.quintOut);
			
			addTween(tweenLeft, true);
			addTween(tweenRight, true);
			
			gameActive = true;
			glow = new Glow();
			add(glow);
			
			fadeInText();
		};
		
		private function fadeInText():void
		{
			whiteHealthUI.visible = true;
			whiteManaUI.visible = true;
			blackHealthUI.visible = true;
			blackManaUI.visible = true;
			/*
			for each(var t:Text in console)
			{
				t.visible = true;				
			}
			*/
		}
		
		private function fadeOutText():void
		{
			whiteHealthUI.visible = false;
			whiteManaUI.visible = false;
			blackHealthUI.visible = false;
			blackManaUI.visible = false;
			
			for each(var t:Text in console)
			{
				t.visible = false;				
			}		
		}
		
		private function handleError(error:PlayerIOError):void
		{
			if (connectionAttempts < 3)
				connect();
			else
			{		
				disconnect(error.errorID + ": " + error.message);
			}
		}
		
		private function handleDisconnect():void
		{
			FP.world = new LoginWorld("Connection to the server was lost, please try again.");
		}
		
		public function addToChat(s:String, time:Number = 4):void
		{
			var t:Text = new Text(s, 10, FP.screen.height - 60, FP.screen.width - 20, 20);
			if (titleLeft.x == 0)
				t.visible = false;
				
			t.font = "Domo";
			t.size = 14;
				
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