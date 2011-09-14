package schism 
{
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Assets 
	{		
		public static const VERSION:String = "v0.2-rc2";
		public static const GAME_ID:String = "schismtd-3r3otmhvkki9ixublwca";
		
		// Menus
		[Embed(source = '../../assets/Menus/title-left.png')] public static const GFX_TITLE_LEFT:Class;
		[Embed(source = '../../assets/Menus/title-right.png')] public static const GFX_TITLE_RIGHT:Class;
		[Embed(source = '../../assets/Menus/loginbackground.png')] public static const GFX_LOGIN_BACKGROUND:Class;
		[Embed(source = '../../assets/Menus/background.png')] public static const GFX_BACKGROUND:Class;
		
		// Board
		[Embed(source = '../../assets/board/Board-back.png')] public static const GFX_BOARD:Class;
		[Embed(source = '../../assets/board/Board-front.png')] public static const GFX_BOARD_OVERLAY:Class;
		[Embed(source = '../../assets/board/playerwindow-white.png')] public static const GFX_BOARD_WHITE:Class;
		[Embed(source = '../../assets/board/playerwindow-black.png')] public static const GFX_BOARD_BLACK:Class;		
		
		//Icons
		[Embed(source = '../../assets/board/creep icons/miniarmor.png')] public static const GFX_ICONS_ARMOR:Class;
		[Embed(source = '../../assets/board/creep icons/minichigen.png')] public static const GFX_ICONS_CHIGEN:Class;
		[Embed(source = '../../assets/board/creep icons/minimagic.png')] public static const GFX_ICONS_MAGIC:Class;
		[Embed(source = '../../assets/board/creep icons/miniquick.png')] public static const GFX_ICONS_QUICK:Class;
		[Embed(source = '../../assets/board/creep icons/miniregen.png')] public static const GFX_ICONS_REGEN:Class;
		[Embed(source = '../../assets/board/creep icons/miniswarm.png')] public static const GFX_ICONS_SWARM:Class;
		
		// Towers
		[Embed(source = '../../assets/towers/basic.png')] public static const GFX_TOWER_BASIC:Class;
		[Embed(source = '../../assets/towers/rapidfire.png')] public static const GFX_TOWER_RAPIDFIRE:Class;
		[Embed(source = '../../assets/towers/slow.png')] public static const GFX_TOWER_SLOW:Class;
		[Embed(source = '../../assets/towers/pulse.png')] public static const GFX_TOWER_PULSE:Class;
		[Embed(source = '../../assets/towers/sniper.png')] public static const GFX_TOWER_SNIPER:Class;
		[Embed(source = '../../assets/towers/spell.png')] public static const GFX_TOWER_SPELL:Class;
		[Embed(source = '../../assets/towers/damageboost.png')] public static const GFX_TOWER_DAMAGEBOOST:Class;
		[Embed(source = '../../assets/towers/rangeboost.png')] public static const GFX_TOWER_RANGEBOOST:Class;
		[Embed(source = '../../assets/towers/speedboost.png')] public static const GFX_TOWER_RATEBOOST:Class;
		[Embed(source = '../../assets/towers/towerrange.png')] public static const GFX_TOWER_RANGE:Class;
		
		
		// Creeps
		[Embed(source = '../../assets/creeps/Chigen.png')] public static const GFX_CREEP_CHIGEN:Class;
		[Embed(source = '../../assets/creeps/Regen.png')] public static const GFX_CREEP_REGEN:Class;
		[Embed(source = '../../assets/creeps/Quick.png')] public static const GFX_CREEP_QUICK:Class;
		[Embed(source = '../../assets/creeps/Magic.png')] public static const GFX_CREEP_MAGIC:Class;
		[Embed(source = '../../assets/creeps/Armor.png')] public static const GFX_CREEP_ARMOR:Class;
		[Embed(source = '../../assets/creeps/Swarm.png')] public static const GFX_CREEP_SWARM:Class;
		
		// Projectiles
		[Embed(source = '../../assets/towers/Bullets/basicbullet.png')] public static const GFX_BULLET_BASIC:Class;
		[Embed(source = '../../assets/towers/Bullets/rapidfirebullet.png')] public static const GFX_BULLET_RAPIDFIRE:Class;
		[Embed(source = '../../assets/towers/Bullets/sniperbullet.png')] public static const GFX_BULLET_SNIPER:Class;
		[Embed(source = '../../assets/towers/Bullets/slowbullet.png')] public static const GFX_BULLET_SLOW:Class;
		[Embed(source = '../../assets/towers/Bullets/spellbullet.png')] public static const GFX_BULLET_SPELL:Class;
		[Embed(source = '../../assets/towers/Bullets/pulsering.png')] public static const GFX_BULLET_PULSE:Class;
		
		// Shadows
		[Embed(source = '../../assets/towers/Bullets/basicbullet-shadow.png')] public static const GFX_SHADOW_BASIC:Class;
		[Embed(source = '../../assets/towers/Bullets/rapidfirebullet-shadow.png')] public static const GFX_SHADOW_RAPIDFIRE:Class;
		[Embed(source = '../../assets/towers/Bullets/sniperbullet-shadow.png')] public static const GFX_SHADOW_SNIPER:Class;
		[Embed(source = '../../assets/towers/Bullets/slowbullet-shadow.png')] public static const GFX_SHADOW_SLOW:Class;
		[Embed(source = '../../assets/towers/Bullets/spellbullet-shadow.png')] public static const GFX_SHADOW_SPELL:Class;
		
		// Sounds
		[Embed(source = '../../assets/sfx/invalid.mp3')] public static const SFX_INVALID:Class;
		[Embed(source = '../../assets/sfx/BuildTower.mp3')] public static const SFX_BUILD_TOWER:Class;
		[Embed(source = '../../assets/sfx/GameStartHighlightSound.mp3')] public static const SFX_START_HIGHLIGHT:Class;
		[Embed(source = '../../assets/sfx/PlayerHurt.mp3')] public static const SFX_PLAYER_HURT:Class;
		[Embed(source = '../../assets/sfx/SwarmCreepDeath.mp3')] public static const SFX_SWARM_CREEP_DEATH:Class;
		
		// Misc
		[Embed(source = '../../assets/Board/glow.png')] public static const GFX_GLOW:Class;
		
		// Fonts
		[Embed(source = '../../assets/DOMOAN__.ttf', embedAsCFF="false", fontFamily = 'Domo')] public static const FONT_DOMO:Class
		
	}

}