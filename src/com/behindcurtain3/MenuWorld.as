package com.behindcurtain3
{
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	
	import punk.ui.PunkButton;
	import punk.ui.PunkLabel;
	import punk.ui.PunkPasswordField;
	import punk.ui.PunkTextArea;
	import punk.ui.PunkTextField;
	import punk.ui.PunkToggleButton;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class MenuWorld extends World 
	{
		
		public function MenuWorld ()
		{
			add(new PunkButton(FP.screen.width / 2 - 100, FP.screen.height / 2 - 25, 200, 100, "Play Now", onPlayNow)); 
		}
		
		override public function end():void
		{
			removeAll();
			super.end();
		}
		
		override public function update():void
		{
			
			super.update();
		}
		
		public function playNow():void
		{
			FP.world = new GameWorld();
		}
		
		public function onPlayNow():void
		{
			playNow();
		}
		
	}
}