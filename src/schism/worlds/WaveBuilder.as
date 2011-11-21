package schism.worlds 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import playerio.Client;
	import playerio.Connection;
	import playerio.DatabaseObject;
	import playerio.Message;
	import playerio.PlayerIOError;
	import punk.ui.PunkButton;
	import schism.Assets;
	import schism.ui.CreepPanelItem;
	import schism.ui.CustomMouse;
	import schism.ui.DraggableCreepIcon;
	import schism.ui.MessageDisplay;
	import schism.ui.ScrollPanel;
	import schism.ui.WavePanel;
	import schism.ui.WavePanelHeader;
	import schism.WaveBuilderMessages;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class WaveBuilder extends AuthWorld 
	{
		// UI
		private var pointsRemainingMessage:Text;
		private var creepScrollPanel:ScrollPanel;
		
		// Values
		private var pointsRemaining:int = 24;
		private var _pointsAllowedRemaining:int = 0;
		private var _waves:Array;
		private var _activeWave:int = 0;
		
		private var _vertPadding:int = 50;
		private var _panelSpacing:int = 46;
		private var _yCutoff:int = FP.screen.height - 88;
		
		private var _repeatDelayTimer:Number = 0.5;
		private var _repeatFireTimer:Number = 0.25;
		private var _repeatPosition:Number = 0;
		private var _repeatIsFiring:Boolean = false;
		
		public function WaveBuilder(c:Client) 
		{
			super(c, false, false);

			pointsRemainingMessage = new Text("Points Remaining: 24");
			pointsRemainingMessage.size = 24;
			pointsRemainingMessage.font = "Domo";
			pointsRemainingMessage.x = FP.screen.width - pointsRemainingMessage.textWidth - 5;
			pointsRemainingMessage.y = (_panelSpacing / 2) - (pointsRemainingMessage.height / 2);
			pointsRemainingMessage.color = 0x555555;
			pointsRemainingMessage.outlineColor = 0x000000;
			pointsRemainingMessage.outlineStrength = 2;
			pointsRemainingMessage.updateTextBuffer();
			
			addGraphic(pointsRemainingMessage);
			
			creepScrollPanel = new ScrollPanel();
			add(creepScrollPanel);
			
			creepScrollPanel.addChild(new CreepPanelItem("Armor", onAddCreep));
			creepScrollPanel.addChild(new CreepPanelItem("Regen", onAddCreep));
			creepScrollPanel.addChild(new CreepPanelItem("Swarm", onAddCreep));
			creepScrollPanel.addChild(new CreepPanelItem("Chigen", onAddCreep));
			creepScrollPanel.addChild(new CreepPanelItem("Quick", onAddCreep));
			creepScrollPanel.addChild(new CreepPanelItem("Magic", onAddCreep));
			
			_waves = new Array();
			
			for (var i:int = 0; i < 10; i++)
			{
				var w:WavePanel = new WavePanel(0, _vertPadding + (i * _panelSpacing), i);
				if (i == 0)
					w.activate();
				w.addMouseDownListener(onWavePanelClicked);
				w.addErrorListener(showMessage);
				_waves.push(w);
			}
			updateAlpha();
			addList(_waves);
			
			add(new WavePanelHeader(0, 0));
			
			var b:PunkButton = new PunkButton(45, FP.screen.height - 68, 150, 50, "Save", onSave)
			add(b);
			
			b = new PunkButton(FP.screen.width - 150 - 45, FP.screen.height - 68, 150, 50, "Exit", onExit)
			add(b);
		}
		
		override public function begin():void 
		{
			onLoad();
			super.begin();
		}
		
		override public function end():void
		{
			removeAll();
			super.end();
		}
		
		override public function update():void
		{
			if (Input.pressed(Key.ESCAPE))
			{
				FP.world = new HomeWorld(client);
			}
			
			if (Input.pressed(Key.BACKSPACE))
			{
				_waves[_activeWave].removeLast();
			}
			
			pointsRemainingMessage.text = "Points Remaining: " + _waves[_activeWave].pointsRemaining;
			if (_waves[_activeWave].pointsRemaining > _pointsAllowedRemaining)
				pointsRemainingMessage.color = 0xFF0000;
			else
				pointsRemainingMessage.color = 0xAAAAAA;
			
			if (Input.pressed(Key.DELETE))
				_waves[_activeWave].clear();
				
			if (Input.mouseWheel)
			{
				if (Input.mouseWheelDelta > 0)
				{
					if (_activeWave > 0)
					{
						_waves[_activeWave].deactivate();
						_activeWave--;
						_waves[_activeWave].activate();
						
						if (_waves[_activeWave].y < _vertPadding)
							moveListDown();
					}
				}
				else
				{
					if (_activeWave + 1 < _waves.length)
					{
						_waves[_activeWave].deactivate();
						_activeWave++;
						_waves[_activeWave].activate();
						
						if (_waves[_activeWave].y + _waves[_activeWave].height > _yCutoff)
							moveListUp();
					}	
				}
			}
				
			if (Input.released(Key.DOWN) || Input.released(Key.UP))
			{
				_repeatPosition = 0;
				_repeatIsFiring = false;
			}
			
			if (Input.pressed(Key.DOWN))
			{
				if (_activeWave + 1 < _waves.length)
				{
					moveListUp();
				}
			}
			
			if (Input.check(Key.DOWN))
			{
				if (_activeWave + 1 < _waves.length)
				{
					_repeatPosition += FP.elapsed;
				
					if (_repeatIsFiring)
					{
						if (_repeatPosition >= _repeatFireTimer)
						{
							moveListUp();
							_repeatPosition = 0;
						}
					}
					else
					{
						if (_repeatPosition >= _repeatDelayTimer)
						{
							moveListUp();
							_repeatPosition = 0;
							_repeatIsFiring = true;
						}
					}
				}
			}
			
			if (Input.pressed(Key.UP))
			{
				if (_activeWave > 0)
				{
					moveListDown();
				}
			}
			if (Input.check(Key.UP))
			{
				if (_activeWave > 0)
				{
					_repeatPosition += FP.elapsed;
				
					if (_repeatIsFiring)
					{
						if (_repeatPosition >= _repeatFireTimer)
						{
							moveListDown();
							_repeatPosition = 0;
						}
					}
					else
					{
						if (_repeatPosition >= _repeatDelayTimer)
						{
							moveListDown();
							_repeatPosition = 0;
							_repeatIsFiring = true;
						}
					}
				}
			}
			
			if (Input.pressed(Key.NUMPAD_ADD) || Input.pressed(Key.PAGE_DOWN))
			{
				if (_activeWave < _waves.length - 1)
				{
					_waves[_activeWave].position += 1;
					_waves[_activeWave].moveDown(_panelSpacing);
					_waves[_activeWave+1].position -= 1;
					_waves[_activeWave+1].moveUp(_panelSpacing);
					_waves[_activeWave].deactivate();
					_waves.sortOn("position", Array.NUMERIC);
					_activeWave++;
					_waves[_activeWave].activate();
				}
			}
			
			if (Input.pressed(Key.NUMPAD_SUBTRACT) || Input.pressed(Key.PAGE_UP))
			{
				if (_activeWave > 0)
				{
					_waves[_activeWave].position -= 1;
					_waves[_activeWave].moveUp(_panelSpacing);
					_waves[_activeWave-1].position += 1;
					_waves[_activeWave-1].moveDown(_panelSpacing);
					_waves[_activeWave].deactivate();
					_waves.sortOn("position", Array.NUMERIC);
					_activeWave--;
					_waves[_activeWave].activate();
				}
			}
				
			super.update();
		}
		
		public function onAddCreep(type:String):void
		{
			_waves[_activeWave].addChild(new DraggableCreepIcon(type, 50, 50));
		}
		
		public function moveListUp():void
		{
			_waves[_activeWave].deactivate();
			_activeWave++;
			_waves[_activeWave].activate();
					
			if (_waves[_activeWave].y + _waves[_activeWave].height > _yCutoff)
			{
				for (var i:int = 0; i < _waves.length; i++)
					_waves[i].moveUp(_panelSpacing);
			}
				
			updateAlpha();
		}
		
		public function moveListDown():void
		{
			_waves[_activeWave].deactivate();
			_activeWave--;
			_waves[_activeWave].activate();
					
			if (_waves[_activeWave].y < _vertPadding)
			{
				for (var i:int = 0; i < _waves.length; i++)
					_waves[i].moveDown(_panelSpacing);
			}
				
			updateAlpha();
		}
		
		public function updateAlpha():void
		{
			for (var i:int = 0; i < _waves.length; i++)
			{
				if (_waves[i].y < _vertPadding || _waves[i].y + _waves[i].height > _yCutoff)
					_waves[i].setAlpha(0);
				else
					_waves[i].show();
			}
		}
		
		public function onWavePanelClicked(panel:WavePanel):void
		{
			if (panel.isVisible())
			{			
				_waves[_activeWave].deactivate();
				_activeWave = panel.position - 1;
				_waves[_activeWave].activate();
			}
		}
		
		public function onLoad():void
		{
			if (client == null)
			{
				showMessage("Invalid authentication, please login again.");
				return;				
			}
			showMessage("Loading creeps from server...", 0);
			
			if (playerObject != null)
				onRoomLoad(playerObject);
			else
				client.bigDB.loadMyPlayerObject(onRoomLoad, onRoomError);
		}
		
		public function onSave():void
		{	
			// Check client side data
			if (!validateWaves())
				return;
			
			if (client == null)
			{
				showMessage("Invalid authentication, please login again.");
				return;				
			}
			if (connection == null || !connection.connected)
			{
				showMessage("Connecting to server...", 0);
				//Create pr join the room test
				client.multiplayer.createJoinRoom(
					"wavebuilder",						//Room id. If set to null a random roomid is used
					"WaveBuilder",						//The game type started on the server
					false,								//Should the room be visible in the lobby?
					{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
					{},									//User join data
					onRoomSave,							//Function executed on successful joining of the room
					onRoomError					//Function executed if we got a join error
				);
			}
			else
			{
				saveAllWaves();
			}
		}
		
		public function onExit():void
		{
			FP.world = new HomeWorld(client);
		}
		
		public function onRoomSave(c:Connection):void
		{
			connection = c;
			connection.addMessageHandler(WaveBuilderMessages.INVALID_WAVE, function(m:Message):void {
				showMessage(m.getString(0));
				connection.disconnect();
			});
			connection.addMessageHandler(WaveBuilderMessages.WAVES_SAVED, function(m:Message):void {
				showMessage("Saved", 3);
				connection.disconnect();
				
				// reload the player object
				loadPlayerObject();
			});
			saveAllWaves();
		}
		
		public function onRoomLoad(dbObject:DatabaseObject):void
		{
			if (dbObject["Waves"] == undefined)
			{
				showMessage("There were no waves found.");
				return;
			}
			
			for (var i:int = 0; i < dbObject["Waves"].length; i++)
			{
				for (var j:int = 0; j < dbObject["Waves"][i].length; j++)
				{
					_waves[i].addChild(new DraggableCreepIcon(dbObject["Waves"][i][j], 0, 0));
				}
			}
			showMessage("Creeps loaded.", 1.5);
		}
		
		public function onRoomError(e:PlayerIOError):void
		{
			showMessage(e.message);
		}
		
		private function saveAllWaves():void
		{		
			var msg:Message = connection.createMessage(WaveBuilderMessages.SAVE_ALL_WAVES);
			
			for (var i:int = 0; i < _waves.length; i++)
			{				
				for (var j:int = 0; j < _waves[i].children.length; j++)
				{
					msg.add(_waves[i].children[j].type);
				}
				msg.add("--ENDOFWAVE--");
			}
			
			connection.sendMessage(msg);
		}
		
		private function validateWaves():Boolean
		{
			for (var i:int = 0; i < _waves.length; i++)
			{
				if (_waves[i].pointsRemaining > _pointsAllowedRemaining)
				{
					showMessage("Wave " + _waves[i].position + " has too many points unspent");
					return false;
				}
			}
			
			return true;
		}
		/*
		private function showMessage(msg:String, time:Number = 5):void 
		{
			if (messageDisplay != null)
				remove(messageDisplay);
				
			messageDisplay = new MessageDisplay(msg, time, 20, 0, FP.screen.height / 2);
			add(messageDisplay);
		}*/
		
	}

}