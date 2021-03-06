package schism.worlds
{
	import flash.net.SharedObject;
	import flash.ui.Mouse;
	import net.flashpunk.graphics.Spritemap;
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
	import schism.projectiles.SpellProjectile;
	import schism.ui.BuildMenu;
	import schism.ui.Button;
	import schism.ui.ChiBlast;
	import schism.ui.CustomMouse;
	import schism.ui.FauxTower;
	import schism.ui.Glow;
	import schism.ui.MessageDisplay;
	import schism.ui.Tooltip;
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
	public class GameWorld extends AuthWorld 
	{
		private var Mode:int = BuildMode.NONE;
		
		private var whiteName:String;
		private var blackName:String;
		private var rated:Boolean;
		
		// Settings
		private var gameId:String;
		private var connectionAttempts:int = 0;
		private var createServerRoom:Boolean;
		
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
		protected var whiteHeart:Spritemap;
		protected var blackHeart:Spritemap;
		protected var whiteChi:Spritemap;
		protected var blackChi:Spritemap;
		protected var buildButton:Button;
		protected var spellButton:Button;
		protected var spellButtonCost:Text;
		protected var spellButtonToken:Image;
		protected var black1:Button;
		protected var black2:Button;
		protected var black3:Button;
		protected var white1:Button;
		protected var white2:Button;
		protected var white3:Button;
		protected var incomingArrow:Image;
		
		protected var blackIntro:Text;
		protected var whiteIntro:Text;
		protected var vsIntro:Text;
		
		// Gfx
		protected var board:Image;
		protected var boardOverlay:Image;
		protected var boardWhite:Image;
		protected var boardBlack:Image;
		protected var boardWaveHighlight:WaveHighlight;
		protected var newBg:Image;
		
		protected var mute:Spritemap;
		
		// Sfx
		protected var sfx_invalid:Sfx = new Sfx(Assets.SFX_ERROR);
		protected var sfx_tower_build:Sfx = new Sfx(Assets.SFX_BUILD_TOWER);
		protected var sfx_player_hurt:Sfx = new Sfx(Assets.SFX_PLAYER_HURT1);
		protected var sfx_music:Sfx = new Sfx(Assets.SFX_MUSIC_GAME);
		protected var sfx_start:Sfx = new Sfx(Assets.SFX_GAME_START, sfx_music.loop);
		
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
		
		private var connectionStatusDisplay:MessageDisplay;
		
		private var sharedObject:SharedObject;
		
		// Help mode
		protected var helpModeOn:Boolean = true;
		protected var buildTip:Tooltip;
		protected var buildPlacementTip:Tooltip;
		protected var upgradeTip:Tooltip;
		protected var upgradedATower:Boolean = false;
		
		public function GameWorld (c:Client, guest:Boolean, gameId:String, createServer:Boolean = false, rate:Boolean = true)
		{
			super(c, guest, false);

			this.gameId = gameId;
			createServerRoom = createServer;
			rated = rate;
			
			// UI elements
			add(fauxTower);
			whiteWaveQueue = new WhiteWaveQueue();
			add(whiteWaveQueue);
			blackWaveQueue = new BlackWaveQueue();
			add(blackWaveQueue);
			
			// Board
			board = new Image(Assets.GFX_BOARD);
			board.alpha = 0;
			board.angle = 90;
			board.smooth = true;
			board.centerOrigin();
			addGraphic(board, 99, FP.screen.width / 2, FP.screen.height / 2);
			
			boardOverlay = new Image(Assets.GFX_BOARD_OVERLAY);
			boardOverlay.centerOrigin();
			boardOverlay.alpha = 0;
			boardOverlay.smooth = true;
			boardOverlay.angle = 90;
			addGraphic(boardOverlay, 5, FP.screen.width / 2, FP.screen.height / 2);
			
			boardWhite = new Image(Assets.GFX_BOARD_WHITE);
			boardWhite.alpha = 0;
			boardWhite.x = -boardWhite.width;
			addGraphic(boardWhite, 6);
			boardBlack = new Image(Assets.GFX_BOARD_BLACK);
			boardBlack.alpha = 0;
			boardBlack.x = boardBlack.width;
			addGraphic(boardBlack, 6, FP.screen.width - boardBlack.width, FP.screen.height - boardBlack.height);
			
			whiteHeart = new Spritemap(Assets.GFX_UI_LIFE, 32, 32, endWhiteHeartAnimation);
			whiteHeart.add("normal", [0]);
			whiteHeart.add("hit", [1, 0, 1, 0, 1, 0], 50, false);
			whiteHeart.play("normal");
			whiteHeart.alpha = 0;
			whiteHeart.x = -boardWhite.width;
			addGraphic(whiteHeart, 2, 83, 21);
			
			blackHeart = new Spritemap(Assets.GFX_UI_LIFE, 32, 32, endBlackHeartAnimation);
			blackHeart.add("normal", [0]);
			blackHeart.add("hit", [1, 0, 1, 0, 1, 0], 50, false);
			blackHeart.play("normal");
			blackHeart.alpha = 0;
			blackHeart.x = boardBlack.width;
			addGraphic(blackHeart, 2, FP.screen.width - 114, FP.screen.height - 53);
			
			whiteChi = new Spritemap(Assets.GFX_UI_CHI, 32, 32, endWhiteChiAnimation);
			whiteChi.add("normal", [0]);
			whiteChi.add("highlight", [1, 0, 1, 0, 1, 0], 50, false);
			whiteChi.play("normal");
			whiteChi.alpha = 0;
			whiteChi.x = -boardWhite.width;
			addGraphic(whiteChi, 2, 90, 8);
			
			blackChi = new Spritemap(Assets.GFX_UI_CHI, 32, 32, endBlackChiAnimation);
			blackChi.add("normal", [0]);
			blackChi.add("highlight", [1, 0, 1, 0, 1, 0], 50, false);
			blackChi.play("normal");
			blackChi.alpha = 0;
			blackChi.x = boardBlack.width;
			addGraphic(blackChi, 2,  FP.screen.width - 106, FP.screen.height - 22);
			
			// Add mute button
			mute = new Spritemap(Assets.GFX_MUTE, 22, 23);
			mute.x = 0;
			mute.y = FP.screen.height - mute.height;
			mute.add("on", [0]);
			mute.add("off", [1]);
			addGraphic(mute, 1);
			
			sharedObject = SharedObject.getLocal("schismTDdata");
			if (sharedObject.data.sound != null)
			{
				if (sharedObject.data.sound == "on")
					mute.play("on");
				else
					mute.play("off");					
			}
			else
			{
				mute.play("on");
			}
			mute.alpha = 0;
			
			if (guest || sharedObject.data.help == null)
			{
				helpModeOn = true;
				sharedObject.data.help = "done";
			}
			else
				helpModeOn = false;
			
						
			// Connect to game
			connectionStatusDisplay = new MessageDisplay("Connecting to game...", 0, 24);
			add(connectionStatusDisplay);
			connect();
			
			// Define our inputs			
			Input.define("Chat", Key.T);
			Input.define("Send", Key.ENTER);
			
			Input.define("Build", Key.W, Key.UP);
			Input.define("Upgrade1", Key.A, Key.LEFT);
			Input.define("Upgrade2", Key.D, Key.RIGHT);
			Input.define("Sell", Key.S, Key.DOWN);
			Input.define("Spell", Key.SPACE);
			
			Input.define("Wave1", Key.DIGIT_1, Key.NUMPAD_1);
			Input.define("Wave2", Key.DIGIT_2, Key.NUMPAD_2);
			Input.define("Wave3", Key.DIGIT_3, Key.NUMPAD_3);
		}
		
		public function connect():void
		{
			var userid:String = QuickKong.userId == "" ? "" : QuickKong.userId;

			client.multiplayer.createJoinRoom(
				gameId, "schismTD", false, {rated: rated }, 								//Room id. If set to null a random roomid is used
				{guest:_isGuest, name: AuthWorld.playerName, id: userid, auth_token: AuthWorld.accessToken },	//User join data
				handleNewGame,						//Function executed on successful joining of the room
				handleError							//Function executed if we got a join error
			);
			/*
			if (createServerRoom)
			{
				client.multiplayer.createRoom(
					gameId,								//Room id. If set to null a random roomid is used
					"schismTD",							//The game type started on the server
					false,								//Should the room be visible in the lobby?
					{rated: rated},						//Room data. This data is returned to lobby list. Variabels can be modifed on the server
					joinRoom,							//Function executed on successful joining of the room
					onRoomCreateError
				);
			}
			else
			{
				joinRoom(gameId);
			}
			connectionAttempts++;
			*/
		}
		
		public function joinRoom(roomId:String):void
		{
			var userid:String = QuickKong.userId == "" ? "" : QuickKong.userId;

			client.multiplayer.joinRoom(
				roomId,								//Room id. If set to null a random roomid is used
				{guest:_isGuest, name: AuthWorld.playerName, id: userid, auth_token: AuthWorld.accessToken },	//User join data
				handleNewGame,						//Function executed on successful joining of the room
				handleError							//Function executed if we got a join error
			);
		}
		
		override public function end():void
		{
			if (connection != null)
			{
				connection.disconnect();
			}
			sfx_music.stop();
			removeAll();
			(FP.stage.getChildByName("CustomMouse") as CustomMouse).setCursor(Assets.MOUSE_NORMAL);
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
				
				if (Input.mousePressed)
				{
					dragStart = new Point(Input.mouseX, Input.mouseY);
					
					if (Input.mouseX > mute.x && Input.mouseX < mute.x + mute.width && Input.mouseY > mute.y && Input.mouseY < mute.y + mute.height)
					{
						toggleMute();
					}
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
						if (buildMenu.isMouseOverSell())
						{
							connection.send(Messages.GAME_TOWER_SELL, objectSelected.centerX, objectSelected.centerY);
							trace("Selling...");
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
								if (cell.isOurs() && buildMode != BuildMode.SPELL)
								{
									objectSelected = cell;
									buildMenu.displayAt(cell);
									
									if(buildMode == BuildMode.TOWER)									
										toggleBuildMode();
										
									if (upgradeTip != null)
									{
										remove(upgradeTip);
										upgradeTip = null;							
									}
									
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
				
				switch(buildMode)
				{
					case BuildMode.NONE:
						if (spellButton.isDown())
							spellButton.toggle();
						if (buildButton.isDown())
							buildButton.toggle();
						if (Input.pressed("Build"))
						{
							objectSelected = null;
							buildMenu.visible = false;
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
						if (spellButton.isDown())
							spellButton.toggle();
						if (!buildButton.isDown())
							buildButton.toggle();
						
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
					case BuildMode.SPELL:
						if (!spellButton.isDown())
							spellButton.toggle();
						if (buildButton.isDown())
							buildButton.toggle();
							
						objectSelected = null;
						buildMenu.visible = false;
							
						var cell:Cell = collidePoint("cell", Input.mouseX, Input.mouseY) as Cell;
							
						if (cell != null)
						{
							(FP.stage.getChildByName("CustomMouse") as CustomMouse).setCursor(Assets.MOUSE_SPELL);
							
							if (cell.hasTower && !cell.isOurs())
							{								
								if (Input.mouseReleased && connection != null)
								{
									connection.send(Messages.GAME_SPELL_TOWER, cell.getIndex());
									toggleSpellMode();
								}
							}
							else if (!cell.hasTower)
							{
								if (Input.mouseReleased && connection != null)
								{
									connection.send(Messages.GAME_SPELL_CREEP, Input.mouseX, Input.mouseY);
									toggleSpellMode();	
								}
							}
						}
						else
						{
							(FP.stage.getChildByName("CustomMouse") as CustomMouse).setCursor(Assets.MOUSE_NORMAL);
						}
						
						break;
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
				
				if (Input.pressed("Spell"))
				{
					toggleSpellMode();
				}
				else if (Input.pressed("Build"))
				{
					toggleBuildMode();
				}
				
			}
			
			super.update();
		}
		
		private function disconnect(message:String = ""):void
		{			
			if(connection != null)
				connection.disconnect();
				
			FP.world = new TitleWorld(message);
		}
		
		private function handleNewGame(c:Connection):void
		{
			connection = c;
			connection.addDisconnectHandler(handleDisconnect);
			
			if(connectionStatusDisplay != null)
				remove(connectionStatusDisplay);
			
			// Setup UI			
			whiteHealthUI = new Text("20", 110, 27);
			whiteHealthUI.visible = false;
			whiteHealthUI.font = "Domo";
			whiteHealthUI.size = 16;
			whiteHealthUI.color = 0xFF0000;
			whiteHealthUI.outlineColor = 0x000000;
			whiteHealthUI.outlineStrength = 2;
			whiteHealthUI.updateTextBuffer();
			
			whiteManaUI = new Text("100", 110, 5);
			whiteManaUI.visible = false;
			whiteManaUI.font = "Domo";
			whiteManaUI.size = 16;
			whiteManaUI.color = 0x0000FF;
			whiteManaUI.outlineColor = 0x000000;
			whiteManaUI.outlineStrength = 2;
			whiteManaUI.updateTextBuffer();
			addGraphic(whiteHealthUI);
			addGraphic(whiteManaUI);
			
			blackHealthUI = new Text("20", FP.screen.width - 208, FP.screen.height - 45);
			blackHealthUI.visible = false;
			blackHealthUI.font = "Domo";
			blackHealthUI.size = 16;
			blackHealthUI.width = 100;
			blackHealthUI.align = "right";
			blackHealthUI.outlineColor = 0xFF0000;
			blackHealthUI.outlineStrength = 2;
			blackHealthUI.updateTextBuffer();
			
			blackManaUI = new Text("100", FP.screen.width - 208, FP.screen.height - 22);
			blackManaUI.visible = false;
			blackManaUI.font = "Domo";
			blackManaUI.size = 16;
			blackManaUI.width = 100;
			blackManaUI.align = "right";
			blackManaUI.outlineColor = 0x0000FF;
			blackManaUI.outlineStrength = 2;
			blackManaUI.updateTextBuffer();
			
			addGraphic(blackHealthUI);
			addGraphic(blackManaUI);
			
			connection.addMessageHandler(Messages.CHAT, function(m:Message):void {
				//trace(m.getString(0));
			});
			
			connection.addMessageHandler(Messages.GAME_JOINED, function(m:Message):void {
				if (connectionStatusDisplay != null)
					remove(connectionStatusDisplay);
					
				connectionStatusDisplay = new MessageDisplay("Waiting for other player...", 0, 24);
				add(connectionStatusDisplay);
			});
			
			connection.addMessageHandler(Messages.GAME_SET_SPAWN, function(m:Message):void {
				incomingArrow = new Image(Assets.GFX_INCOMING);
				incomingArrow.x = m.getNumber(0);
				incomingArrow.y = m.getNumber(1);
				incomingArrow.centerOrigin();
				if(incomingArrow.y < FP.screen.height / 2)
					incomingArrow.angle = 180;
				incomingArrow.alpha = 0;

				addGraphic(incomingArrow, 2);
			});
			
			connection.addMessageHandler(Messages.GAME_INFO, function(m:Message):void {				
				if (m.getString(0) == "black")
				{					
					color = m.getString(0);
					blackId = m.getInt(1);
					whiteId = m.getInt(2);
					
					buildMenu = new BuildMenu(color);
					add(buildMenu);
					
					boardWhite = new Image(Assets.GFX_OTHER_WHITE);
					boardWhite.alpha = 0;
					boardWhite.x = -boardWhite.width;
					addGraphic(boardWhite, 6);
					
					boardWaveHighlight = new WaveHighlight(color, FP.screen.width, blackWaveQueue.zeroPosition.y);
					add(boardWaveHighlight);
					
					buildButton = new Button(toggleBuildMode, null, FP.screen.width - 50, FP.screen.height - boardBlack.height + 65);
					buildButton.setSpritemap(Assets.GFX_BUTTON_BUILD, 40, 40);
					buildButton._map.alpha = 0;
					buildButton._map.x = boardBlack.width;
					add(buildButton);
					
					spellButton = new Button(toggleSpellMode, null, FP.screen.width - 50, FP.screen.height - boardBlack.height + 117);
					spellButton.setSpritemap(Assets.GFX_BUTTON_SPELL, 40, 40);
					spellButton._map.alpha = 0;
					spellButton._map.x = boardBlack.width;
					add(spellButton);
					
					spellButtonCost = new Text("50", 0, 0, { color: 0xFFFFFF, font: "Domo", size: "16", outlineColor: 0x0000FF, outlineStrength: 2 } );
					spellButtonCost.x = spellButton.x + spellButton.width / 2 - spellButtonCost.textWidth / 2 + 5;
					spellButtonCost.y = spellButton.y + spellButton.height;
					spellButtonCost.visible = false;
					addGraphic(spellButtonCost);
					
					spellButtonToken = new Image(Assets.GFX_GEM);
					spellButtonToken.x = spellButtonCost.x - spellButtonToken.width + 2;
					spellButtonToken.y = spellButtonCost.y;
					spellButtonToken.visible = false;
					addGraphic(spellButtonToken);
			
					black1 = new Button(setWave, 0, FP.screen.width - 42.5, FP.screen.height - 85);
					black1.setSpritemap(Assets.GFX_UI_B1, 85, 32);
					black1._map.centerOrigin();
					black1.centerOrigin();
					black1._map.x = boardBlack.width;
					black2 = new Button(setWave, 1, FP.screen.width - 42.5, FP.screen.height - 55);
					black2.setSpritemap(Assets.GFX_UI_B2, 85, 32);
					black2._map.centerOrigin();
					black2.centerOrigin();
					black2._map.x = boardBlack.width;
					black3 = new Button(setWave, 2, FP.screen.width - 42.5, FP.screen.height - 25);
					black3.setSpritemap(Assets.GFX_UI_B3, 85, 32);
					black3._map.centerOrigin();
					black3.centerOrigin();
					black3._map.x = boardBlack.width;
					
					addList(black1, black2, black3);
					
					white1 = new Button(null, null, 42.5, 16);
					white1.setSpritemap(Assets.GFX_UI_W1, 85, 32);
					white1._map.centerOrigin();
					white1.centerOrigin();
					white1.enabled = false;
					white1._map.x = -boardWhite.width;
					white2 = new Button(null, null, 42.5, 46);
					white2.setSpritemap(Assets.GFX_UI_W2, 85, 32);
					white2._map.centerOrigin();
					white2.centerOrigin();
					white2.enabled = false;
					white2._map.x = -boardWhite.width;
					white3 = new Button(null, null, 42.5, 76);
					white3.setSpritemap(Assets.GFX_UI_W3, 85, 32);
					white3._map.centerOrigin();
					white3.centerOrigin();
					white3.enabled = false;
					white3._map.x = -boardWhite.width;
					
					addList(white1, white2, white3);
				} 
				else if (m.getString(0) == "white")
				{
					color = m.getString(0);
					whiteId = m.getInt(1);
					blackId = m.getInt(2);
					
					buildMenu = new BuildMenu(color);
					add(buildMenu);
					
					boardBlack = new Image(Assets.GFX_OTHER_BLACK);
					boardBlack.alpha = 0;
					boardBlack.x = boardBlack.width;
					addGraphic(boardBlack, 6, FP.screen.width - boardBlack.width, FP.screen.height - boardBlack.height);
					
					boardWaveHighlight = new WaveHighlight(color, 0, whiteWaveQueue.zeroPosition.y);
					add(boardWaveHighlight);
					
					buildButton = new Button(toggleBuildMode, null, 10, boardWhite.height - 105);
					buildButton.setSpritemap(Assets.GFX_BUTTON_BUILD, 40, 40);
					buildButton._map.alpha = 0;
					buildButton._map.x = -boardWhite.width;
					add(buildButton);
					
					spellButton = new Button(toggleSpellMode, null, 10, boardWhite.height - 178);
					spellButton.setSpritemap(Assets.GFX_BUTTON_SPELL, 40, 40);
					spellButton._map.alpha = 0;
					spellButton._map.x = -boardWhite.width;
					add(spellButton);
					
					spellButtonCost = new Text("50", 0, 0, { color: 0xFFFFFF, font: "Domo", size: "16", outlineColor: 0x000000, outlineStrength: 2 } );
					spellButtonCost.color = 0x0000FF;
					spellButtonCost.x = spellButton.x + spellButton.width / 2 - spellButtonCost.textWidth / 2 + 5;
					spellButtonCost.y = spellButton.y + spellButton.height;
					spellButtonCost.visible = false;
					addGraphic(spellButtonCost);
					
					spellButtonToken = new Image(Assets.GFX_GEM);
					spellButtonToken.x = spellButtonCost.x - spellButtonToken.width + 2;
					spellButtonToken.y = spellButtonCost.y;
					spellButtonToken.visible = false;
					addGraphic(spellButtonToken);
					
					black1 = new Button(null, null, FP.screen.width - 42.5, FP.screen.height - 85);
					black1.setSpritemap(Assets.GFX_UI_B1, 85, 32);
					black1._map.centerOrigin();
					black1.centerOrigin();
					black1.enabled = false;
					black1._map.x = boardBlack.width;
					black2 = new Button(null, null, FP.screen.width - 42.5, FP.screen.height - 55);
					black2.setSpritemap(Assets.GFX_UI_B2, 85, 32);
					black2._map.centerOrigin();
					black2.centerOrigin();
					black2.enabled = false;
					black2._map.x = boardBlack.width;
					black3 = new Button(null, null, FP.screen.width - 42.5, FP.screen.height - 25);
					black3.setSpritemap(Assets.GFX_UI_B3, 85, 32);
					black3._map.centerOrigin();
					black3.centerOrigin();
					black3.enabled = false;
					black3._map.x = boardBlack.width;
					
					addList(black1, black2, black3);
					
					white1 = new Button(setWave, 0, 42.5, 16);
					white1.setSpritemap(Assets.GFX_UI_W1, 85, 32);
					white1._map.centerOrigin();
					white1.centerOrigin();
					white1._map.x = -boardWhite.width;
					white2 = new Button(setWave, 1, 42.5, 46);
					white2.setSpritemap(Assets.GFX_UI_W2, 85, 32);
					white2._map.centerOrigin();
					white2.centerOrigin();
					white2._map.x = -boardWhite.width;
					white3 = new Button(setWave, 2, 42.5, 76);
					white3.setSpritemap(Assets.GFX_UI_W3, 85, 32);
					white3._map.centerOrigin();
					white3.centerOrigin();
					white3._map.x = -boardWhite.width;
					
					addList(white1, white2, white3);
				}				
			});
			
			connection.addMessageHandler(Messages.GAME_USER_INFO, function(m:Message):void {
				if (connectionStatusDisplay != null)
					remove(connectionStatusDisplay);
				
				blackName = m.getString(0);
				whiteName = m.getString(1);
				
				var pinkOptions:Object = { font: "Domo", size: 72, color: 0xF660AB, outlineColor: 0x000000, outlineStrength: 4 };
				var devOptions:Object = { font: "Domo", size: 72, color: 0xD4A017, outlineColor: 0x000000, outlineStrength: 4 };
				
				var whiteOptions:Object = Assets.devNames.indexOf(whiteName) == -1 ? { font: "Domo", size: 72, outlineColor: 0x000000, outlineStrength: 4 } : devOptions;
				var blackOptions:Object = Assets.devNames.indexOf(blackName) == -1 ? { color: 0x000000, font: "Domo", size: 72 } : devOptions;
				
				if (Assets.friendNames.indexOf(whiteName) != -1)
					whiteOptions = pinkOptions;
				if (Assets.friendNames.indexOf(blackName) != -1)
					blackOptions = pinkOptions;
				
				whiteIntro = new Text(m.getString(1), 0, 100, whiteOptions);
				whiteIntro.x = -whiteIntro.textWidth;
				
				blackIntro = new Text(m.getString(0), FP.screen.width, FP.screen.height - 200, blackOptions );
				
				addGraphic(whiteIntro);
				addGraphic(blackIntro);
				
				var t:VarTween = new VarTween(whiteIntroComplete);
				t.tween(whiteIntro, "x", FP.screen.width / 2 - whiteIntro.textWidth * 0.66, 0.3);
				addTween(t, true);
			});
			
			connection.addMessageHandler(Messages.GAME_START, function(m:Message):void {
				incomingArrow.visible = false;
				add(new MessageDisplay("Go!", 2, 96, FP.screen.width / 2, FP.screen.height / 2, 250));
				sfx_start.play();
			});
			
			connection.addMessageHandler(Messages.GAME_FINISHED, function(m:Message):void {
				whiteIntro.visible = false;
				blackIntro.visible = false;
				vsIntro.visible = false;
				sfx_music.stop();
				gameActive = false;
				objectSelected = null;
				buildMenu.visible = false;
				
				var submitStats:Boolean = QuickKong.stats == null ? false : true;
				
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
					
					
					if (color == "black")
					{
						result = "You win!";
						new Sfx(Assets.SFX_GAME_WIN).play();
					}
					else
					{
						result = "You lose!";
						new Sfx(Assets.SFX_GAME_LOSE).play();
					}
					
					if(color == "black" && !_isGuest && submitStats)
						QuickKong.stats.submit("MatchesWon", 1);
				}
				else if (m.getInt(0) == whiteId)
				{
					result = "White wins!";
					
					if (color == "white")
					{
						result = "You win!";
						new Sfx(Assets.SFX_GAME_WIN).play();
					}
					else
					{
						result = "You lose!";
						new Sfx(Assets.SFX_GAME_LOSE).play();
					}
					
					if(color == "white" && !_isGuest && submitStats)
						QuickKong.stats.submit("MatchesWon", 1);
				}
				
				if (color == "black" && !_isGuest)
				{
					if (submitStats)
					{
						var rating:Number = m.getUInt(3);
						QuickKong.stats.submit("MaxDamageDealt", rating);
						QuickKong.stats.submit("Rating", m.getNumber(5));
					}
					
					if (playerObject != null)
						playerObject["rating"] = m.getNumber(5);
				}
				if (color == "white" && !_isGuest)
				{
					if (submitStats)
					{
						var rating:Number = m.getUInt(4);
						QuickKong.stats.submit("MaxDamageDealt", rating);
						QuickKong.stats.submit("Rating", m.getNumber(6));
					}
					
					if (playerObject != null)
						playerObject["rating"] = m.getNumber(6);
				}
				
				gameFinished = true;
				resultWorld = new ResultWorld(client, _isGuest, connection, blackName, whiteName, result, m.getInt(1), m.getInt(2), m.getUInt(3), m.getUInt(4), m.getNumber(5), m.getNumber(6));
				if(m.getString(7) != "")
					add(new MessageDisplay(m.getString(7), 5, 24));
					
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
						if (tc.isOurs() && helpModeOn)
						{
							if (buildPlacementTip != null)
							{
								remove(buildPlacementTip);
								buildPlacementTip = null;
								
								if (color == "black")
									upgradeTip = new Tooltip("Select the tower to view upgrade menu", tc.centerX - 410, tc.y, false);
								else
									upgradeTip = new Tooltip("Select the tower to view upgrade menu", tc.centerX + 25, tc.y);
								add(upgradeTip);
								
								for each(var c:Cell in getCells())
								{
									c.stopFlash();
								}
							}
							
							if (tc.hasTower && !upgradedATower)
							{
								showMessage("Keep building and upgrading towers to defeat your opponents creeps!");
								upgradedATower = true;
							}
							
						}
						
						switch(type)
						{
							case "basic":
								tc.assignGfx(Assets.GFX_TOWER_BASIC);
								if(tc.isOurs())
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
			
			connection.addMessageHandler(Messages.GAME_CREEP_REMOVE, function(m:Message, id:String, type:String):void {
				for each(var cr:Creep in getCreeps())
				{
					if (cr.ID == id)
					{
						if (type == "Death")
							cr.die();
						else
							remove(cr);
						
						for each(var p:Projectile in getProjectiles())
						{
							if (p.target == cr && !p is SpellProjectile)
							{
								remove(p);
							}
						}						
						break;
					}
				}
			});
			
			connection.addMessageHandler(Messages.GAME_CREEP_UPDATE_LIFE, function(m:Message, id:String, value:int, x:Number, y:Number, length:int):void {
				for each(var cr:Creep in getCreeps())
				{
					if (cr.ID == id)
					{
						if (cr.getDistanceFromXY(x, y) > 60)
						{
							// request updated path from server
						}
						cr.updateLife(value);
						break;
					}
				}
			});
			
			connection.addMessageHandler(Messages.PLAYER_LIFE, function(m:Message, id:int, value:int):void {
				if (id == blackId)
				{
					if (value < blackHealth)
					{
						// Play sound effect
						if (color == "black")
							playSelfHurt();
						else
							playOpponentHurt();
					}
						
					blackHealth = value;
					blackHeart.play("hit");
				}
				else
				{
					if (value < whiteHealth)
					{
						// Play sound effect
						if (color == "white")
							playSelfHurt();
						else
							playOpponentHurt();
					}
						
					whiteHealth = value;
					whiteHeart.play("hit");
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
					case "Spell":
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
							add(new SpellProjectile(id, x, y, v, creep, type));
						}
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
			
			connection.addMessageHandler(Messages.GAME_FIRE_REMOVE, function(m:Message, id:String):void {
				for each(var cr:Creep in getCreeps())
				{
					if (cr.ID == id)
					{
						cr.removeTarget();
						break;
					}
				}
			});
			
			connection.addMessageHandler(Messages.GAME_TOWER_EFFECT, function(m:Message):void {
				var cell:Cell = getCell(m.getInt(0));
				
				if (cell != null)
				{
					switch(m.getString(1))
					{
						case "stun":
							cell.stun(m.getNumber(2));
							break;
					}
				}				
			});
			
			connection.addMessageHandler(Messages.GAME_TOWER_RANGE, function(m:Message):void {
				var cell:Cell = getCell(m.getInt(0));
				
				if (cell != null)
				{
					cell.towerRange = m.getNumber(1);
					
					if (buildMenu.index == cell.getIndex())
					{
						buildMenu.setRange(m.getNumber(1));
					}
				}
			});
			
			connection.addMessageHandler(Messages.GAME_TOWER_RATE, function(m:Message):void {
				var cell:Cell = getCell(m.getInt(0));
				
				if (cell != null)
				{
					cell.towerFireRate = m.getInt(1);
					if (buildMenu.index == cell.getIndex())
					{
						buildMenu.towerRate.text = "Rate: " + m.getInt(1) / 1000;
					}
				}
			});
			
			connection.addMessageHandler(Messages.GAME_TOWER_DAMAGE, function(m:Message):void {
				var cell:Cell = getCell(m.getInt(0));
				
				if (cell != null)
				{
					cell.towerDamage = m.getInt(1);
					if (buildMenu.index == cell.getIndex())
					{
						buildMenu.towerDmg.text = "Dmg: " + m.getInt(1);
					}
				}
			});
			
			connection.addMessageHandler(Messages.PLAYER_CHIBLAST_COST, function(m:Message, value:Number):void {
				spellButtonCost.text = value.toString();
			});
			
			connection.addMessageHandler(Messages.GAME_ACTIVATE, activateGame);
			connection.addMessageHandler(Messages.GAME_ALL_CREEPS_PATH, updatePaths);
			connection.addMessageHandler(Messages.GAME_CREEP_PATH, updateSinglePath);
			connection.addMessageHandler(Messages.GAME_WAVE_ACTIVATE, activateWave);
			connection.addMessageHandler(Messages.GAME_WAVE_QUEUE, queueWave);
			connection.addMessageHandler(Messages.GAME_WAVE_REMOVE, removeWave);
			connection.addMessageHandler(Messages.GAME_WAVE_POSITION, positionWave);
			connection.addMessageHandler(Messages.GAME_SPELL_TOWER, spellTower);
			connection.addMessageHandler(Messages.GAME_SPELL_CREEP, spellCreep);
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
			var t:VarTween = new VarTween();
			t.tween(whiteIntro, "x", 0, 0.3);
			addTween(t);
			t = new VarTween();			
			t.tween(whiteIntro, "alpha", 0, 0.3);
			addTween(t);
			t = new VarTween();
			t.tween(blackIntro, "x", FP.screen.width, 0.3);
			addTween(t);
			t = new VarTween();
			t.tween(blackIntro, "alpha", 0, 0.3);
			addTween(t);
			t = new VarTween();
			t.tween(vsIntro, "scale", 5, 0.3);
			addTween(t);
			t = new VarTween();
			t.tween(vsIntro, "alpha", 0, 0.3);
			addTween(t);

			t = new VarTween();
			t.tween(bg, "alpha", 0, 0.3);
			addTween(t);
			
			newBg = new Image(Assets.GFX_BACKGROUND);
			newBg.alpha = 0;
			addGraphic(newBg, 100);
			
			t = new VarTween();
			t.tween(newBg, "alpha", 1, 0.3);
			addTween(t);			
			
			var vt:VarTween = new VarTween(activateCells);
			vt.tween(board, "alpha", 1, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(boardOverlay, "alpha", 1, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(board, "angle", 0, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(boardOverlay, "angle", 0, 2.5, Ease.expoOut);
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
			
			vt = new VarTween();
			vt.tween(whiteHeart, "alpha", 1, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(blackHeart, "alpha", 1, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(whiteChi, "alpha", 1, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(blackChi, "alpha", 1, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(whiteHeart, "x", 0, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(blackHeart, "x", 0, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(whiteChi, "x", 0, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(blackChi, "x", 0, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(buildButton._map , "alpha", 1, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(buildButton._map, "x", 0, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(spellButton._map , "alpha", 1, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(spellButton._map, "x", 0, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(black1._map, "x", 0, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(black2._map, "x", 0, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(black3._map, "x", 0, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(white1._map, "x", 0, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(white2._map, "x", 0, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(white3._map, "x", 0, 2.5, Ease.expoOut);
			addTween(vt, true);
			
			vt = new VarTween();
			vt.tween(mute, "alpha", 1, 2.5, Ease.expoOut);
			addTween(vt, true);
		};
		
		private function spellCreep(m:Message):void
		{
			var cell:Cell = collidePoint("cell", m.getInt(0), m.getInt(1)) as Cell;
			
			if (cell != null)
			{
				if (cell.isOurs() && color == "white")
					add(new ChiBlast(m.getInt(0), m.getInt(1), null, "black"));
				else if (cell.isOurs() && color == "black")
					add(new ChiBlast(m.getInt(0), m.getInt(1)));
				else
					add(new ChiBlast(m.getInt(0), m.getInt(1)));
			}
		}
		
		private function spellTower(m:Message):void
		{
			var cell:Cell = getCell(m.getInt(0));
			
			if (cell != null)
			{
				if(color == "white" && cell.isOurs())
					add(new ChiBlast(cell.centerX, cell.centerY));
				else if (color == "white" && !cell.isOurs())
					add(new ChiBlast(cell.centerX, cell.centerY, null, "black"));
				else if (color == "black" && !cell.isOurs())
					add(new ChiBlast(cell.centerX, cell.centerY));
				else
					add(new ChiBlast(cell.centerX, cell.centerY, null, "black"));
			}
		}
		
		private function activateCells():void
		{
			gameActive = true;
			glow = new Glow();
			add(glow);
			
			fadeInText();
			
			if (helpModeOn)
			{
				if (color == "black")
				{
					buildTip = new Tooltip("Press W or click here to build towers", buildButton.x - 375, buildButton.y + 2, false);
				}
				else
				{
					buildTip = new Tooltip("Press W or click here to build towers", buildButton.x + 40, buildButton.y + 2);
				}
				
				add(buildTip);
			}
			
			//buildInstructions = new MessageDisplay("Press W to build", 5, 24, 0, FP.screen.height / 2);
			//add(buildInstructions);			
			
			blackWaveQueue.showWaves();
			whiteWaveQueue.showWaves();
			
			var vt:VarTween = new VarTween();
			vt.tween(boardWaveHighlight.image, "alpha", 1, 1, Ease.expoOut);
			addTween(vt, true);			
						
			toggleIncomingArrow();
		}
		
		private function fadeInText():void
		{
			whiteHealthUI.visible = true;
			whiteManaUI.visible = true;
			blackHealthUI.visible = true;
			blackManaUI.visible = true;
			
			spellButtonCost.visible = true;
			spellButtonToken.visible = true;
		}
		
		private function fadeOutText():void
		{
			whiteHealthUI.visible = false;
			whiteManaUI.visible = false;
			blackHealthUI.visible = false;
			blackManaUI.visible = false;
		}
		
		private function onRoomCreateError(e:PlayerIOError):void
		{
			if (connectionAttempts < 3)
			{
				if (e.type == PlayerIOError.RoomAlreadyExists)
					createServerRoom = false;
					
				connect();
			}
			else
			{
				FP.world = new TitleWorld("Unable to start a game on the server.");
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
			if(sfx_music.playing)
				sfx_music.stop();
			if(_isGuest)
				FP.world = new TitleWorld("Connection to the server was lost, please try again.");
			else
				FP.world = new HomeWorld(client, "Connection to the server was lost, please try again.");
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
		
		public function getCreep(id:String):Creep
		{
			var creeps:Array = getCreeps();
			
			for each(var creep:Creep in creeps)
			{
				if(creep.ID == id)
					return creep;
			}
			
			return null;
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
			if (buildMode == BuildMode.TOWER)
				buildMode = BuildMode.NONE;
			else
				buildMode = BuildMode.TOWER;
			
			buildButton.toggle();
			
			if (buildButton.isDown())
				(FP.stage.getChildByName("CustomMouse") as CustomMouse).setCursor(Assets.MOUSE_BUILD);
			else
				(FP.stage.getChildByName("CustomMouse") as CustomMouse).setCursor(Assets.MOUSE_NORMAL);
				
			if (helpModeOn)
			{
				if (buildTip != null)
				{
					remove(buildTip);
					
					for each(var c:Cell in getCells())
					{
						c.flash();
					}

					if (color == "black")
						buildPlacementTip = new Tooltip("Build a tower on the flashing squares", FP.screen.width / 2 - 50, FP.screen.height / 2 + 150, false, false);
					else
						buildPlacementTip = new Tooltip("Build a tower on the flashing squares", FP.screen.width / 2 - 250, FP.screen.height / 2 - 150, false, false);
					
					add(buildPlacementTip);
					buildTip = null;
				}
			}
		}
		
		public function toggleSpellMode():void
		{
			if (buildMode == BuildMode.SPELL)
				buildMode = BuildMode.NONE;
			else
				buildMode = BuildMode.SPELL;
				
			spellButton.toggle();
			
			if (spellButton.isDown())
				(FP.stage.getChildByName("CustomMouse") as CustomMouse).setCursor(Assets.MOUSE_SPELL);
			else
				(FP.stage.getChildByName("CustomMouse") as CustomMouse).setCursor(Assets.MOUSE_NORMAL);
		}
		
		public function endWhiteHeartAnimation():void
		{
			whiteHeart.play("normal");			
		}
		
		public function endBlackHeartAnimation():void
		{
			blackHeart.play("normal");			
		}
		
		public function endWhiteChiAnimation():void
		{
			whiteChi.play("normal");			
		}
		
		public function endBlackChiAnimation():void
		{
			blackChi.play("normal");			
		}
		
		public function setWave(i:int):void
		{
			connection.send(Messages.GAME_WAVE_NEXT, i);
		}
	
		
		public function whiteIntroComplete():void
		{
			vsIntro = new Text("VS", FP.screen.width / 2, FP.screen.height / 2, { color: 0x888888, font: "Domo", size: 72, outlineColor: 0x000000, outlineStrength: 4 } );
			vsIntro.centerOrigin();
			vsIntro.scale = 5;
			vsIntro.alpha = 0;
			addGraphic(vsIntro);
			
			var t:VarTween = new VarTween(vsIntroComplete);
			t.tween(vsIntro, "scale", 1, 0.3);
			addTween(t, true);
			
			t = new VarTween();
			t.tween(vsIntro, "alpha", 1, 0.3);
			addTween(t, true);
		}
		
		public function vsIntroComplete():void
		{
			var t:VarTween = new VarTween();
			t.tween(blackIntro, "x", FP.screen.width / 2 - blackIntro.textWidth * 0.33, 0.3);
			addTween(t, true);
		}
	
		
		public function toggleIncomingArrow():void
		{
			if (incomingArrow.visible == false)
				return;
				
			var t:VarTween = new VarTween(toggleIncomingArrow);
			if (incomingArrow.alpha == 1)
			{
				t.tween(incomingArrow, "alpha", 0, 0.5);
			}
			else
			{
				t.tween(incomingArrow, "alpha", 1, 0.5);
				new Sfx(Assets.SFX_START_HIGHLIGHT).play();
			}
			addTween(t);
		}
	
		public function toggleMute():void
		{
			if (muted)
			{
				mute.play("on");
				muted = false;
				FP.volume = 1;
				sharedObject.data.sound = "on";
			}
			else
			{
				mute.play("off");
				muted = true;
				FP.volume = 0;
				sharedObject.data.sound = "off";
			}
		}
	
		public function playSelfHurt():void
		{
			var num:Number = randomNumber(1, 5);
			
			switch(num)
			{
				case 1:
					new Sfx(Assets.SFX_PLAYER_HURT1).play();
					break;
				case 2:
					new Sfx(Assets.SFX_PLAYER_HURT2).play();
					break;
				case 3:
					new Sfx(Assets.SFX_PLAYER_HURT3).play();
					break;
				case 4:
					new Sfx(Assets.SFX_PLAYER_HURT4).play();
					break;
				case 5:
					new Sfx(Assets.SFX_PLAYER_HURT5).play();
					break;
			}
		}
		
		public function playOpponentHurt():void
		{
			var num:Number = randomNumber(1, 5);
			
			switch(num)
			{
				case 1:
					new Sfx(Assets.SFX_OPPONENT_HURT1).play();
					break;
				case 2:
					new Sfx(Assets.SFX_OPPONENT_HURT2).play();
					break;
				case 3:
					new Sfx(Assets.SFX_OPPONENT_HURT3).play();
					break;
				case 4:
					new Sfx(Assets.SFX_OPPONENT_HURT4).play();
					break;
				case 5:
					new Sfx(Assets.SFX_OPPONENT_HURT5).play();
					break;
			}
		}
		
		private function randomNumber(low:Number=0, high:Number=1):Number
		{
			return Math.floor(Math.random() * (1+high-low)) + low;
		}
		
	}
}