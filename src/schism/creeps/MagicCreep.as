package schism.creeps 
{
	import net.flashpunk.graphics.Spritemap;
	import schism.Assets;
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class MagicCreep extends Creep 
	{
		
		public function MagicCreep(s:String, pId:int, _x:int, _y:int, sp:int, _path:Array) 
		{
			super(s, pId, _x, _y, sp, _path);
			
			doFacing = true;
			collidable = true;
			
			x = _x;
			y = _y;
			width = 27;
			height = 39;
			setHitbox(width, height);
			centerOrigin();

			spriteMap = new Spritemap(Assets.GFX_CREEP_MAGIC, width, height);
			spriteMap.centerOrigin();
			spriteMap.add("walk", [0, 1], 4, true);
			spriteMap.play("walk");			
			
			graphic = spriteMap;
			
			updateAngle();
		}
		
	}

}