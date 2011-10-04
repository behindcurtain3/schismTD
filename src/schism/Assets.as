package schism 
{
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Assets 
	{		
		public static const VERSION:String = "v0.3.2";
		public static const GAME_ID:String = "schismtd-3r3otmhvkki9ixublwca";
		
		[Embed(source = '../../assets/board/punkuimenus.png')] public static const SKIN:Class;
		[Embed(source = '../../assets/board/pointer-normal.png')] public static const MOUSE_NORMAL:Class;
		[Embed(source = '../../assets/board/pointer-build.png')] public static const MOUSE_BUILD:Class;
		[Embed(source = '../../assets/board/pointer-spell.png')] public static const MOUSE_SPELL:Class;
		
		// Menus
		[Embed(source = '../../assets/board/Title.png')] public static const GFX_TITLE:Class;
		[Embed(source = '../../assets/board/background.png')] public static const GFX_BACKGROUND:Class;
		
		// Board
		[Embed(source = '../../assets/board/Board-back.png')] public static const GFX_BOARD:Class;
		[Embed(source = '../../assets/board/Board-front.png')] public static const GFX_BOARD_OVERLAY:Class;
		[Embed(source = '../../assets/board/Player HUDS/playerwindow-white.png')] public static const GFX_BOARD_WHITE:Class;
		[Embed(source = '../../assets/board/Player HUDS/playerwindow-black.png')] public static const GFX_BOARD_BLACK:Class;
		[Embed(source = '../../assets/board/Player HUDS/wavehighlight-black.png')] public static const GFX_WAVE_BLACK:Class;
		[Embed(source = '../../assets/board/Player HUDS/wavehighlight-white.png')] public static const GFX_WAVE_WHITE:Class;
		[Embed(source = '../../assets/towers/chigem.png')] public static const GFX_GEM:Class;
		[Embed(source = '../../assets/board/buildtowerbutton.png')] public static const GFX_BUTTON_BUILD:Class;
		[Embed(source = '../../assets/board/chiblastbutton.png')] public static const GFX_BUTTON_SPELL:Class;
		[Embed(source = '../../assets/board/Player HUDS/lifecrystal.png')] public static const GFX_UI_LIFE:Class;
		[Embed(source = '../../assets/board/Player HUDS/chicrystal.png')] public static const GFX_UI_CHI:Class;
		[Embed(source = '../../assets/board/Player HUDS/black-1.png')] public static const GFX_UI_B1:Class;
		[Embed(source = '../../assets/board/Player HUDS/black-2.png')] public static const GFX_UI_B2:Class;
		[Embed(source = '../../assets/board/Player HUDS/black-3.png')] public static const GFX_UI_B3:Class;
		[Embed(source = '../../assets/board/Player HUDS/white-1.png')] public static const GFX_UI_W1:Class;
		[Embed(source = '../../assets/board/Player HUDS/white-2.png')] public static const GFX_UI_W2:Class;
		[Embed(source = '../../assets/board/Player HUDS/white-3.png')] public static const GFX_UI_W3:Class;
		
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
		
		// Spells
		[Embed(source = '../../assets/Board/spell-black.png')] public static const GFX_SPELL_BLACK:Class;
		[Embed(source = '../../assets/Board/spell-white.png')] public static const GFX_SPELL_WHITE:Class;
		
		// Sounds
		[Embed(source = '../../assets/sfx/invalid.mp3')] public static const SFX_INVALID:Class;
		[Embed(source = '../../assets/sfx/BuildTower.mp3')] public static const SFX_BUILD_TOWER:Class;
		[Embed(source = '../../assets/sfx/GameStartHighlightSound.mp3')] public static const SFX_START_HIGHLIGHT:Class;
		[Embed(source = '../../assets/sfx/PlayerHurt.mp3')] public static const SFX_PLAYER_HURT:Class;
		[Embed(source = '../../assets/sfx/PopupSound.mp3')] public static const SFX_POPUP:Class;
		[Embed(source = '../../assets/sfx/SwarmCreepDeath.mp3')] public static const SFX_SWARM_CREEP_DEATH:Class;
		
		// Misc
		[Embed(source = '../../assets/Board/glow.png')] public static const GFX_GLOW:Class;
		
		// Fonts
		[Embed(source = '../../assets/DOMOAN__.ttf', embedAsCFF="false", fontFamily = 'Domo')] public static const FONT_DOMO:Class
		
	}

}