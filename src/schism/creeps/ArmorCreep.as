package schism.creeps 
{
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import schism.Assets;
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
			
			x = _x;
			y = _y;
			width = 32;
			height = 48;
			setHitbox(width, height, -width / 2, -height / 2);
			centerOrigin();
			
			spriteMap = new Spritemap(Assets.GFX_CREEP_ARMOR, 32, 48);
			spriteMap.centerOrigin();
			spriteMap.add("walk", [0, 1], 3, true);
			spriteMap.play("walk");			
						
			updateAngle();
			
			deathSounds.push(new Sfx(Assets.SFX_DEATH_ARMOR1));
			deathSounds.push(new Sfx(Assets.SFX_DEATH_ARMOR2));
			deathSounds.push(new Sfx(Assets.SFX_DEATH_ARMOR3));
			deathSounds.push(new Sfx(Assets.SFX_DEATH_ARMOR4));
			deathSounds.push(new Sfx(Assets.SFX_DEATH_ARMOR5));
		}
				
	}

}