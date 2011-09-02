package com.behindcurtain3 
{
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class SwarmCreep extends Creep 
	{
		
		public function SwarmCreep(s:String, pId:int, _x:int, _y:int, sp:int, _path:Array) 
		{
			super(s, pId, _x, _y, sp, _path);
			
			doFacing = true;
			collidable = true;
			
			x = _x - 7;
			y = _y - 7;
			width = 14;
			height = 15;
			setHitbox(width, height);

			spriteMap = new Spritemap(Assets.GFX_CREEP_SWARM, width, height);
			spriteMap.centerOrigin();
			spriteMap.add("walk", [0, 1], 3, true);
			spriteMap.play("walk");			
			
			graphic = spriteMap;
			
			updateAngle();
		}
		
		override public function render():void 
		{
			// TODO: Add offsets to x & y
			super.render();
		}
		
	}

}