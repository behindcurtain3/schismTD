package com.behindcurtain3 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class ArmorCreep extends Creep 
	{
		
		public function ArmorCreep(s:String, pId:int, _x:int, _y:int, sp:int, _path:Array) 
		{
			super(s, pId, _x, _y, sp, _path);
			
			doFacing = true;
			collidable = true;
			
			x = _x - 16;
			y = _y - 24 ;
			width = 32;
			height = 48;
			setHitbox(width, height);
			
			spriteMap = new Spritemap(Assets.GFX_CREEP_ARMOR, 32, 48);
			spriteMap.centerOrigin();
			spriteMap.add("walk", [0, 1], 4, true);
			spriteMap.play("walk");			
			
			graphic = spriteMap;
		}
				
	}

}