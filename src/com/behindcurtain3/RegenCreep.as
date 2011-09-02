package com.behindcurtain3 
{
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class RegenCreep extends Creep 
	{
		
		public function RegenCreep(s:String, pId:int, _x:int, _y:int, sp:int, _path:Array) 
		{
			super(s, pId, _x, _y, sp, _path);
			
			doFacing = true;
			collidable = true;
			
			x = _x - 12;
			y = _y - 19 ;
			width = 24;
			height = 38;
			setHitbox(width, height);

			spriteMap = new Spritemap(Assets.GFX_CREEP_REGEN, width, height);
			spriteMap.centerOrigin();
			spriteMap.add("walk", [0, 1], 4, true);
			spriteMap.play("walk");			
			
			graphic = spriteMap;
			
			updateAngle();
		}
		
	}

}