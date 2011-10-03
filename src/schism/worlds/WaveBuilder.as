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
	import schism.ui.MessageDisplay;
	import schism.ui.ScrollPanel;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class WaveBuilder extends World 
	{
		// UI
		private var pointsRemainingMessage:MessageDisplay;
		private var creepScrollPanel:ScrollPanel;
		
		// Values
		private var pointsRemaining:int = 24;
		
		public function WaveBuilder() 
		{
			super();
			
			FP.console.enable();
			FP.console.visible = true;

			addGraphic(new Image(Assets.GFX_BACKGROUND), 100);

			pointsRemainingMessage = new MessageDisplay("Points Remaining\n" + pointsRemaining, 0, 24, FP.screen.width - 110, 45, 200, 50);
			pointsRemainingMessage.message.color = 0xFFFF00;
			
			add(pointsRemainingMessage);
			
			creepScrollPanel = new ScrollPanel();
			add(creepScrollPanel);
			
			creepScrollPanel.addChild(new CreepPanelItem("Armor", 3, onAddCreep));
			creepScrollPanel.addChild(new CreepPanelItem("Regen", 2, onAddCreep));
			creepScrollPanel.addChild(new CreepPanelItem("Swarm", 1, onAddCreep));
			creepScrollPanel.addChild(new CreepPanelItem("Chigen", 2, onAddCreep));
			creepScrollPanel.addChild(new CreepPanelItem("Quick", 2, onAddCreep));
			creepScrollPanel.addChild(new CreepPanelItem("Magic", 1, onAddCreep));
		}
		
		override public function end():void 
		{
			FP.console.visible = false;
			
			super.end();
		}
		
		override public function update():void
		{
			if (Input.pressed(Key.BACKSPACE))
			{
				FP.world = new LoginWorld();
			}			
			
			if (Input.pressed(Key.NUMPAD_ADD) && pointsRemaining < 24)
			{
				pointsRemaining++;
			}
			else if (Input.pressed(Key.NUMPAD_SUBTRACT) && pointsRemaining > 0)
			{
				pointsRemaining--;
			}
			
			pointsRemainingMessage.message.text = "Points Remaining\n" + pointsRemaining;
			if (pointsRemaining <= 5 )
				pointsRemainingMessage.message.color = 0xFF0000;
			else
				pointsRemainingMessage.message.color = 0xFFFF00;
			
			if (Input.pressed(Key.ENTER))
				creepScrollPanel.addChild(new CreepPanelItem("Quick", 2, onAddCreep));
				
			super.update();
		}
		
		public function onAddCreep(type:String):void
		{
			FP.log("Added " + type + " to wave.");
		}
		
	}

}