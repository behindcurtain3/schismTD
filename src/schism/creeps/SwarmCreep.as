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
	public class SwarmCreep extends Creep 
	{
		
		public function SwarmCreep(s:String, pId:int, _x:int, _y:int, sp:int, _path:Array) 
		{
			super(s, pId, _x, _y, sp, _path);
			
			doFacing = true;
			collidable = true;
			
			x = _x;
			y = _y;
			width = 14;
			height = 15;
			setHitbox(width, height);
			centerOrigin();

			spriteMap = new Spritemap(Assets.GFX_CREEP_SWARM, width, height);
			spriteMap.centerOrigin();
			spriteMap.add("walk", [0, 1], 3, true);
			spriteMap.play("walk");			
			
			updateAngle();
			
			deathSounds.push(new Sfx(Assets.SFX_CREEP_DEATH_SMALL1));
			deathSounds.push(new Sfx(Assets.SFX_CREEP_DEATH_SMALL3));
			deathSounds.push(new Sfx(Assets.SFX_CREEP_DEATH_SMALL4));
			deathSounds.push(new Sfx(Assets.SFX_CREEP_DEATH_SMALL6));
			deathSounds.push(new Sfx(Assets.SFX_CREEP_DEATH_SMALL7));
		}
		
	}

}