package com.behindcurtain3 
{
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class ChigenCreep extends Creep 
	{
		
		public function ChigenCreep(s:String, pId:int, _x:int, _y:int, sp:int, _path:Array) 
		{
			super(s, pId, _x, _y, sp, _path);
			
			collidable = true;
			
			x = _x;
			y = _y;
			width = 32;
			height = 36;
			setHitbox(width, height);
			centerOrigin();

			spriteMap = new Spritemap(Assets.GFX_CREEP_CHIGEN, width, height);
			spriteMap.centerOrigin();
			spriteMap.add("walk", [0, 1], 4, true);
			spriteMap.play("walk");			
			
			graphic = spriteMap;
			
			updateAngle();
		}
		
	}

}