package com.behindcurtain3 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class GameWorld extends World 
	{
		// Level
		private var level:Level;
		private var _ground:Layer;
		private var _scenery:Layer;
		
		// Display
		private var flash:Text;
		
		// Game state variables
		public var gameOver:Boolean = false;
		private var player:Player;
		
		public function GameWorld() 
		{
			level = new Level(Assets.LEVEL_WELCOME);
			var element:XML;
			
			// Add ground layer
			_ground = new Layer(level.LevelData.ground.tile, 9);
			_ground.type = "ground";
			_ground.collidable = false;
			add(_ground);
			
			_scenery = new Layer(level.LevelData.scenery.tile, 7);
			_scenery.setGrid(level.LevelData.collisions.rect);
			_scenery.type = "scenery";
			add(_scenery);
			
			
			// Add our objects
			for each(element in level.LevelData.objects.spawn)
			{
				add(new Spawner(int(element.@x), int(element.@y), Number(element.@spawn_rate), Boolean(element.@spawn_skeletons), Boolean(element.@spawn_zombies), Boolean(element.@spawn_bats)));
			}
			
			// Add our player
			for each(element in level.LevelData.objects.player_start)
			{
				player = new Player(int(element.@x), int(element.@y));
				add(player);
			}
			
			flash = new Text(level.Name);
			flash.font = "ZombieFont";
			flash.alpha = 1;
			flash.size = 16;
			flash.x = FP.screen.width / 2 - flash.width / 2;
			flash.y = FP.screen.height / 2 - flash.height / 2;
			
			addGraphic(flash);
						
			// Tween for text
			var flashTween:VarTween = new VarTween();
			flashTween.tween(flash, "alpha", 0, 3, Ease.expoIn);
			addTween(flashTween, true);	
			
			gameOver = false;
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}