package schism.worlds
{
	import schism.Assets;
	import schism.BuildMode;
	import schism.Cell;
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
	import schism.creeps.ArmorCreep;
	import schism.creeps.ChigenCreep;
	import schism.creeps.Creep;
	import schism.creeps.MagicCreep;
	import schism.creeps.QuickCreep;
	import schism.creeps.RegenCreep;
	import schism.creeps.SwarmCreep;
	import schism.effects.SlowEffect;
	import schism.Messages;
	import schism.projectiles.Projectile;
	import schism.projectiles.PulseProjectile;
	import schism.ui.BuildMenu;
	import schism.ui.Button;
	import schism.ui.FauxTower;
	import schism.ui.Glow;
	import schism.ui.MessageDisplay;
	import schism.waves.BlackWaveQueue;
	import schism.waves.WaveHighlight;
	import schism.waves.WhiteWaveQueue;
	
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
		
		// Result
		private var resultWorld:ResultWorld;		
		
		// UI
		protected var whiteHealthUI:Text;
		protected var whiteManaUI:Text;
		protected var blackHealthUI:Text;
		protected var blackManaUI:Text;
		protected var whiteWaveQueue:WhiteWaveQueue;
		protected var blackWaveQueue:BlackWaveQueue;
		protected var buildMenu:BuildMenu;
		protected var buildInstructions:MessageDisplay;
		protected var countdownText:Text;
		
		// Gfx
		protected var board:Image;
		protected var boardOverlay:Image;
		protected var boardWhite:Image;
		protected var boardBlack:Image;
		protected var boardWaveHighlight:WaveHighlight;
		
		// Sfx
		protected var sfx_invalid:Sfx = new Sfx(Assets.SFX_INVALID);
		protected var sfx_tower_build:Sfx = new Sfx(Assets.SFX_BUILD_TOWER);
		protected var sfx_player_hurt:Sfx = new Sfx(Assets.SFX_PLAYER_HURT);
		
		// Networking
		protected var client:Client;
		protected var connection:Connection;
		
		//Players
		private var color:String = "";
		private var blackId:int;
		private var whiteId:int;
		
		// Game
		private var gameActive:Boolean = false;
		private var gameFinished:Boolean = false;
		private var gameCountdown:int = 0;
		private var gameFinishCountdown:Number = 8;
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
			
			// UI elements
			add(fauxTower);
			buildMenu = new BuildMenu();
			add(buildMenu);
			whiteWaveQueue = new WhiteWaveQueue();
			add(whiteWaveQueue);
			blackWaveQueue = new BlackWaveQueue();
			add(blackWaveQueue);
			
			// Board
			addGraphic(new Image(Assets.GFX_BACKGROUND), 200);
			board = new Image(Assets.GFX_BOARD);
			board.alpha = 0;
			addGraphic(board, 100, 0, 0);
			
			boardOverlay = new Image(Assets.GFX_BOARD_OVERLAY);
			boardOverlay.alpha = 0;
			boardOverlay.smooth = true;
			addGraphic(boardOverlay, 5);
			
			boardWhite = new Image(Assets.GFX_BOARD_WHITE);
			boardWhite.alpha = 0;
			boardWhite.x = -boardWhite.width;
			addGraphic(boardWhite, 6);
			boardBlack = new Image(Assets.GFX_BOARD_BLACK);
			boardBlack.alpha = 0;
			boardBlack.x = boardBlack.width;
			addGraphic(boardBlack, 6, FP.screen.width - 304, FP.screen.height - 160);
						
			// Connect to game
			connect();
			
			// Define our inputs			
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
			// Update UI
			if (connection != null)
			{
				whiteHealthUI.text = whiteHealth.toString();
				whiteManaUI.text = whiteMana.toString();
				blackHealthUI.text = blackHealth.toString();
				blackManaUI.text = blackMana.toString();
			}
			
			if (gameFinished)
			{
				gameFinishCountdown -= FP.elapsed;
				
				if (gameFinishCountdown <= 0)
					FP.world = resultWorld;
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
							
							if (creep != null && !buildMenu.isMouseOver())
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
					case BuildMode.UPGRADE:
						break;
				}

				if (Input.mousePressed)
				{
					dragStart = new Point(Input.mouseX, Input.mouseY);
				}
				
				if (Input.mouseReleased)
				{
					if (buildMenu.isMouseOver())
					{
						// Check to see if any buttons were pressed
						if (buildMenu.isMouseOverLeft())
						{
							connection.send(Messages.GAME_TOWER_UPGRADE, objectSelected.centerX, objectSelected.centerY, 1);
						}
						if (buildMenu.isMouseOverRight())
						{
							connection.send(Messages.GAME_TOWER_UPGRADE, objectSelected.centerX, objectSelected.centerY, 2);
						}
						
					}
					else
					{					
						dragEnd = new Point(Input.mouseX, Input.mouseY);
						
						// Check if something exists
						cell = collidePoint("cell", dragEnd.x, dragEnd.y) as Cell;
							
						if (cell != null)
						{
							if (!cell.hasTower && !buildMenu.isMouseOver())
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

					}
					dragStart = null;
					dragEnd = null;
				}
				
				if (Input.released("Wave1"))
					connection.send(Messages.GAME_WAVE_NEXT, 0);

				if (Input.released("Wave2"))
					connection.send(Messages.GAME_WAVE_NEXT, 1);
				
				if (Input.released("Wave3"))
					connection.send(Messages.GAME_WAVE_NEXT, 2);
					
				if (Input.released(Key.ESCAPE))
				{
					if (buildMode == BuildMode.TOWER)
						buildMode = BuildMode.NONE;
					if (objectSelected != null)
					{
						objectSelected = null;
						buildMenu.visible = false;
					}
				}
			}
			
			super.update();
		}
		
		private function disconnect(message:String = ""):void
		{			
			if(connection != null)
				connection.disconnect();
				
			FP.world = new LoginWorld(message);
		}
		
		private function handleNewGame(c:Connection):void
		{
			connection = c;
			connection.addDisconnectHandler(handleDisconnect);
			
			// Setup UI			
			whiteHealthUI = new Text("20", 180, 27);
			whiteHealthUI.visible = false;
			whiteHealthUI.font = "Domo";
			whiteHealthUI.size = 16;
			whiteHealthUI.color = 0x000000;
			
			whiteManaUI = new Text("100", 180, 5);
			whiteManaUI.visible = false;
			whiteManaUI.font = "Domo";
			whiteManaUI.size = 16;
			whiteManaUI.color = 0x000000;
			addGraphic(whiteHealthUI);
			addGraphic(whiteManaUI);
			
			blackHealthUI = new Text("20", FP.screen.width - 280, FP.screen.height - 44);
			blackHealthUI.visible = false;
			blackHealthUI.font = "Domo";
			blackHealthUI.size = 16;
			blackHealthUI.width = 100;
			blackHealthUI.align = "right";
			
			blackManaUI = new Text("100", FP.screen.width - 280, FP.screen.height - 22);
			blackManaUI.visible = false;
			blackManaUI.font = "Domo";
			blackManaUI.size = 16;
			blackManaUI.width = 100;
			blackManaUI.align = "right";
			
			addGraphic(blackHealthUI);
			addGraphic(blackManaUI);
			
			connection.addMessageHandler(Messages.GAME_JOINED, function(m:Message):void {
				add(new MessageDisplay("Game joined!", 1.5, 24));
			});
			
			connection.addMessageHandler(Messages.GAME_INFO, function(m:Message):void {				
				if (m.getString(0) == "black")
				{
					color = m.getString(0);
					blackId = m.getInt(1);
					whiteId = m.getInt(2);
					
					boardWaveHighlight = new WaveHighlight(color, blackWaveQueue.zeroPosition.x, blackWaveQueue.zeroPosition.y);
					add(boardWaveHighlight);
					
					var button:Button = new Button(toggleBuildMode, null, FP.screen.width - 40, FP.screen.height - boardBlack.height - 40);
					button.setSpritemap(Assets.GFX_BUTTON_BUILD, 40, 40);
					add(button);
				} 
				else if (m.getString(0) == "white")
				{
					color = m.getString(0);
					whiteId = m.getInt(1);
					blackId = m.getInt(2);
					
					boardWaveHighlight = new WaveHighlight(color, whiteWaveQueue.zeroPosition.x, whiteWaveQueue.zeroPosition.y);
					add(boardWaveHighlight);
					
					var button:Button = new Button(toggleBuildMode, null, 0, boardWhite.height);
					button.setSpritemap(Assets.GFX_BUTTON_BUILD, 40, 40);
					add(button);
				}				
			});
			
			connection.addMessageHandler(Messages.GAME_START, function(m:Message):void {
				add(new MessageDisplay("Go!", 2, 96, FP.screen.width / 2, FP.screen.height / 2, 250));
			});
			
			connection.addMessageHandler(Messages.GAME_FINISHED, function(m:Message):void {
				gameActive = false;
				objectSelected = null;
				buildMenu.visible = false;
				
				for each(var p:Projectile in getProjectiles())
					p.active = false;
				
				for each(var cr:Creep in getCreeps())
				{
					cr.active = false;
					cr.spriteMap.active = false;
				}
				
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
				
				gameFinished = true;
				resultWorld = new ResultWorld(client, connection, result, m.getInt(1), m.getInt(2), m.getUInt(3), m.getUInt(4));
				add(new MessageDisplay(result, gameFinishCountdown, 48, FP.screen.width / 2, FP.screen.height / 2));
			});
			
			connection.addMessageHandler(Messages.GAME_CELL_ADD, function(m:Message, i:int, x:int, y:int, w:int, h:int, mine:Boolean):void {				
				var c:Cell = new Cell(i, x, y, w, h, mine);
				add(c);
			});
			
			connection.addMessageHandler(Messages.GAME_TOWER_PLACE, function(m:Message, i:int, type:String, range:Number):void {				
				for each(var tc:Cell in getCells())
				{
					if (tc.getIndex() == i)
					{
						switch(type)
						{
							case "basic":
								tc.assignGfx(Assets.GFX_TOWER_BASIC);
								sfx_tower_build.play();
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
						tc.towerRange = range;
						
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
				add(new MessageDisplay("Invalid tower!", 1.5, 18, FP.screen.width / 2, FP.screen.height - 20, 200, 25));
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
				{
					if (value < blackHealth)
						sfx_player_hurt.play();
						
					blackHealth = value;
				}
				else
				{
					if (value < whiteHealth)
						sfx_player_hurt.play();
						
					whiteHealth = value;
				}
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
			
			connection.addMessageHandler(Messages.GAME_ACTIVATE, activateGame);
			connection.addMessageHandler(Messages.GAME_ALL_CREEPS_PATH, updatePaths);
			connection.addMessageHandler(Messages.GAME_CREEP_PATH, updateSinglePath);
			connection.addMessageHandler(Messages.GAME_WAVE_ACTIVATE, activateWave);
			connection.addMessageHandler(Messages.GAME_WAVE_QUEUE, queueWave);
			connection.addMessageHandler(Messages.GAME_WAVE_REMOVE, removeWave);
			connection.addMessageHandler(Messages.GAME_WAVE_POSITION, positionWave);
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
		
		private function positionWave(m:Message):void
		{
			if (color == "black")
			{
				switch(m.getInt(0))
				{
					case 0:
						boardWaveHighlight.setPosition(blackWaveQueue.zeroPosition.y);
						break;
					case 1:
						boardWaveHighlight.setPosition(blackWaveQueue.onePosition.y);
						break;
					case 2:
						boardWaveHighlight.setPosition(blackWaveQueue.twoPosition.y);
						break;
				}				
			}
			else if(color == "white")
			{
				switch(m.getInt(0))
				{
					case 0:
						boardWaveHighlight.setPosition(whiteWaveQueue.zeroPosition.y);
						break;
					case 1:
						boardWaveHighlight.setPosition(whiteWaveQueue.onePosition.y);
						break;
					case 2:
						boardWaveHighlight.setPosition(whiteWaveQueue.twoPosition.y);
						break;
				}
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
			var vt:VarTween = new VarTween(activateCells);
			vt.tween(board, "alpha", 1, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(boardOverlay, "alpha", 1, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(boardWhite, "x", 0, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(boardBlack, "x", 0, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(boardWhite, "alpha", 1, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(boardBlack, "alpha", 1, 2.5, Ease.expoOut);
			addTween(vt, true);
		};
		
		private function activateCells():void
		{
			gameActive = true;
			glow = new Glow();
			add(glow);
			
			fadeInText();
			buildInstructions = new MessageDisplay("Press W to build", 5, 24);
			add(buildInstructions);			
			
			blackWaveQueue.showWaves();
			whiteWaveQueue.showWaves();
			
			var vt:VarTween = new VarTween();
			vt.tween(boardWaveHighlight.image, "alpha", 1, 1, Ease.expoOut);
			addTween(vt, true);			
			
			for each(var c:Cell in getCells())
			{
				c.flash();
			}
		}
		
		private function fadeInText():void
		{
			whiteHealthUI.visible = true;
			whiteManaUI.visible = true;
			blackHealthUI.visible = true;
			blackManaUI.visible = true;
		}
		
		private function fadeOutText():void
		{
			whiteHealthUI.visible = false;
			whiteManaUI.visible = false;
			blackHealthUI.visible = false;
			blackManaUI.visible = false;
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
		
		public function toggleBuildMode():void
		{
			switch(buildMode)
			{
				case BuildMode.NONE:
					buildMode = BuildMode.TOWER;
					break;
				case BuildMode.TOWER:
					buildMode = BuildMode.NONE;
					break;
			}
		}
		
	}
}