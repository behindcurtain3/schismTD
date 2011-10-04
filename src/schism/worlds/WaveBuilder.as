package schism.worlds 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import schism.Assets;
	import schism.ui.CreepPanelItem;
	import schism.ui.CustomMouse;
	import schism.ui.DraggableCreepIcon;
	import schism.ui.MessageDisplay;
	import schism.ui.ScrollPanel;
	import schism.ui.WavePanel;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class WaveBuilder extends World 
	{
		// UI
		private var pointsRemainingMessage:MessageDisplay;
		private var creepScrollPanel:ScrollPanel;
		private var wave1:WavePanel;
		
		// Values
		private var pointsRemaining:int = 24;
		private var _waves:Array;
		private var _activeWave:int = 0;
		
		private var _vertPadding:int = 150;
		private var _panelSpacing:int = 50;
		private var _yCutoff:int = 150 + (50 * 7);
		
		public function WaveBuilder() 
		{
			super();

			addGraphic(new Image(Assets.GFX_BACKGROUND), 100);

			pointsRemainingMessage = new MessageDisplay("Points Remaining\n" + pointsRemaining, 0, 24, FP.screen.width - 110, 45, 200, 50);
			pointsRemainingMessage.message.color = 0xFFFF00;
			
			add(pointsRemainingMessage);
			
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
				var w:WavePanel = new WavePanel(0, _vertPadding + (i * 50), i);
				if (i == 0)
					w.activate();
				w.addMouseDownListener(onWavePanelClicked);
				_waves.push(w);
			}
			updateAlpha();
			addList(_waves);
		}
		
		override public function update():void
		{
			if (Input.pressed(Key.BACKSPACE))
			{
				FP.world = new TitleWorld();
			}			
			
			pointsRemainingMessage.message.text = "Points Remaining\n" + _waves[_activeWave].pointsRemaining;
			if (_waves[_activeWave].pointsRemaining <= 5 )
				pointsRemainingMessage.message.color = 0xFF0000;
			else
				pointsRemainingMessage.message.color = 0xFFFF00;
			
			if (Input.pressed(Key.ENTER))
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
				
			if (Input.pressed(Key.DOWN))
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
			
			if (Input.pressed(Key.UP))
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
				
			super.update();
		}
		
		public function onAddCreep(type:String):void
		{
			_waves[_activeWave].addChild(new DraggableCreepIcon(type, 50, 50));
		}
		
		public function moveListUp():void
		{
			for (var i:int = 0; i < _waves.length; i++)
				_waves[i].moveUp(_panelSpacing);
				
			updateAlpha();
		}
		
		public function moveListDown():void
		{
			for (var i:int = 0; i < _waves.length; i++)
				_waves[i].moveDown(_panelSpacing);
				
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
		
	}

}