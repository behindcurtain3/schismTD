package schism.creeps 
{
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import schism.Assets;
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
			
			x = _x;
			y = _y;
			width = 24;
			height = 38;
			setHitbox(width, height);
			centerOrigin();

			spriteMap = new Spritemap(Assets.GFX_CREEP_REGEN, width, height);
			spriteMap.centerOrigin();
			spriteMap.add("walk", [0, 1], 4, true);
			spriteMap.play("walk");			
			
			updateAngle();
			
			deathSounds.push(new Sfx(Assets.SFX_DEATH_REGENCHIGEN1));
			deathSounds.push(new Sfx(Assets.SFX_DEATH_REGENCHIGEN2));
			deathSounds.push(new Sfx(Assets.SFX_DEATH_REGENCHIGEN3));
			deathSounds.push(new Sfx(Assets.SFX_DEATH_REGENCHIGEN4));
			deathSounds.push(new Sfx(Assets.SFX_DEATH_REGENCHIGEN5));
		}
		
	}

}