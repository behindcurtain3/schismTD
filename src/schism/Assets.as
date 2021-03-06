package schism 
{
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Assets 
	{		
		public static const VERSION:String = "v0.6.2";
		public static const GAME_ID:String = "schismtd-3r3otmhvkki9ixublwca";
		public static const FB_APPID:String = "256712624370689";
		
		[Embed(source = '../../assets/board/punkuimenus.png')] public static const SKIN:Class;
		[Embed(source = '../../assets/board/pointer-normal.png')] public static const MOUSE_NORMAL:Class;
		[Embed(source = '../../assets/board/pointer-build.png')] public static const MOUSE_BUILD:Class;
		[Embed(source = '../../assets/board/pointer-spell.png')] public static const MOUSE_SPELL:Class;
		
		// Menus
		[Embed(source = '../../assets/board/Title.png')] public static const GFX_TITLE:Class;
		[Embed(source = '../../assets/board/background.png')] public static const GFX_BACKGROUND:Class;
		[Embed(source = '../../assets/board/MenuBack.png')] public static const GFX_MENUBG:Class;
		[Embed(source = '../../assets/board/MenuBottom.png')] public static const GFX_MENU_BOTTOM:Class;
		
		// Board
		[Embed(source = '../../assets/board/Board-back.png')] public static const GFX_BOARD:Class;
		[Embed(source = '../../assets/board/Board-front.png')] public static const GFX_BOARD_OVERLAY:Class;
		[Embed(source = '../../assets/board/Player HUDS/playerwindow-white.png')] public static const GFX_BOARD_WHITE:Class;
		[Embed(source = '../../assets/board/Player HUDS/playerwindow-black.png')] public static const GFX_BOARD_BLACK:Class;
		[Embed(source = '../../assets/board/Player HUDS/otherwindow-black.png')] public static const GFX_OTHER_BLACK:Class;
		[Embed(source = '../../assets/board/Player HUDS/otherwindow-white.png')] public static const GFX_OTHER_WHITE:Class;
		[Embed(source = '../../assets/board/Player HUDS/wavehighlight-black.png')] public static const GFX_WAVE_BLACK:Class;
		[Embed(source = '../../assets/board/Player HUDS/wavehighlight-white.png')] public static const GFX_WAVE_WHITE:Class;
		[Embed(source = '../../assets/towers/chigem.png')] public static const GFX_GEM:Class;
		[Embed(source = '../../assets/board/Player HUDS/buildtowerbutton.png')] public static const GFX_BUTTON_BUILD:Class;
		[Embed(source = '../../assets/board/Player HUDS/chiblastbutton.png')] public static const GFX_BUTTON_SPELL:Class;
		[Embed(source = '../../assets/board/Player HUDS/lifecrystal.png')] public static const GFX_UI_LIFE:Class;
		[Embed(source = '../../assets/board/Player HUDS/chicrystal.png')] public static const GFX_UI_CHI:Class;
		[Embed(source = '../../assets/board/Player HUDS/black-1.png')] public static const GFX_UI_B1:Class;
		[Embed(source = '../../assets/board/Player HUDS/black-2.png')] public static const GFX_UI_B2:Class;
		[Embed(source = '../../assets/board/Player HUDS/black-3.png')] public static const GFX_UI_B3:Class;
		[Embed(source = '../../assets/board/Player HUDS/white-1.png')] public static const GFX_UI_W1:Class;
		[Embed(source = '../../assets/board/Player HUDS/white-2.png')] public static const GFX_UI_W2:Class;
		[Embed(source = '../../assets/board/Player HUDS/white-3.png')] public static const GFX_UI_W3:Class;
		[Embed(source = '../../assets/board/incoming.png')] public static const GFX_INCOMING:Class;
		[Embed(source = '../../assets/board/build-menu-bg.png')] public static const GFX_BUILD_MENU:Class;
		//[Embed(source = '../../assets/board/Results.png')] public static const GFX_RESULTS:Class;
		
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
		[Embed(source = '../../assets/towers/stunned.png')] public static const GFX_TOWER_STUNNED:Class;
		[Embed(source = '../../assets/towers/sell icon.png')] public static const GFX_TOWER_SELL:Class;
		
		
		// Creeps
		[Embed(source = '../../assets/creeps/Chigen.png')] public static const GFX_CREEP_CHIGEN:Class;
		[Embed(source = '../../assets/creeps/Regen.png')] public static const GFX_CREEP_REGEN:Class;
		[Embed(source = '../../assets/creeps/Quick.png')] public static const GFX_CREEP_QUICK:Class;
		[Embed(source = '../../assets/creeps/Magic.png')] public static const GFX_CREEP_MAGIC:Class;
		[Embed(source = '../../assets/creeps/Armor.png')] public static const GFX_CREEP_ARMOR:Class;
		[Embed(source = '../../assets/creeps/Swarm.png')] public static const GFX_CREEP_SWARM:Class;
		[Embed(source = '../../assets/creeps/heal.png')] public static const GFX_CREEP_HEAL:Class;
		[Embed(source = '../../assets/creeps/death.png')] public static const GFX_CREEP_DEATH:Class;
		[Embed(source = '../../assets/creeps/target.png')] public static const GFX_CREEP_TARGET:Class;
		
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
		
		// Music
		[Embed(source = '../../assets/sfx/battlemusic.mp3')] public static const SFX_MUSIC_GAME:Class;
		[Embed(source = '../../assets/sfx/menumusic.mp3')] public static const SFX_MUSIC_MENU:Class;
		
		// Sounds		
		[Embed(source = '../../assets/sfx/ArmoredCreeps1-1.mp3')] public static const SFX_DEATH_ARMOR1:Class;
		[Embed(source = '../../assets/sfx/ArmoredCreeps2-2.mp3')] public static const SFX_DEATH_ARMOR2:Class;
		[Embed(source = '../../assets/sfx/ArmoredCreeps3-3.mp3')] public static const SFX_DEATH_ARMOR3:Class;
		[Embed(source = '../../assets/sfx/ArmoredCreeps4-4.mp3')] public static const SFX_DEATH_ARMOR4:Class;
		[Embed(source = '../../assets/sfx/ArmoredCreeps5-5.mp3')] public static const SFX_DEATH_ARMOR5:Class;
		
		[Embed(source = '../../assets/sfx/chiblast.mp3')] public static const SFX_CHIBLAST:Class;
		
		[Embed(source = '../../assets/sfx/enemyhurt1-1.mp3')] public static const SFX_OPPONENT_HURT1:Class;
		[Embed(source = '../../assets/sfx/enemyhurt2-2.mp3')] public static const SFX_OPPONENT_HURT2:Class;
		[Embed(source = '../../assets/sfx/enemyhurt3-3.mp3')] public static const SFX_OPPONENT_HURT3:Class;
		[Embed(source = '../../assets/sfx/enemyhurt4-4.mp3')] public static const SFX_OPPONENT_HURT4:Class;
		[Embed(source = '../../assets/sfx/enemyhurt5-5.mp3')] public static const SFX_OPPONENT_HURT5:Class;
		
		[Embed(source = '../../assets/sfx/error.mp3')] public static const SFX_ERROR:Class;
		
		[Embed(source = '../../assets/sfx/findgame.mp3')] public static const SFX_GAME_SEARCH_START:Class;
		[Embed(source = '../../assets/sfx/gamefound.mp3')] public static const SFX_GAME_SEARCH_END:Class;
		
		[Embed(source = '../../assets/sfx/gamestart.mp3')] public static const SFX_GAME_START:Class;
		[Embed(source = '../../assets/sfx/highlightsound.mp3')] public static const SFX_START_HIGHLIGHT:Class;
		
		[Embed(source = '../../assets/sfx/MedCreeps1-1.mp3')] public static const SFX_DEATH_REGENCHIGEN1:Class;
		[Embed(source = '../../assets/sfx/MedCreeps2-2.mp3')] public static const SFX_DEATH_REGENCHIGEN2:Class;
		[Embed(source = '../../assets/sfx/MedCreeps3-3.mp3')] public static const SFX_DEATH_REGENCHIGEN3:Class;
		[Embed(source = '../../assets/sfx/MedCreeps4-4.mp3')] public static const SFX_DEATH_REGENCHIGEN4:Class;
		[Embed(source = '../../assets/sfx/MedCreeps5-5.mp3')] public static const SFX_DEATH_REGENCHIGEN5:Class;
		
		[Embed(source = '../../assets/sfx/placetower.mp3')] public static const SFX_BUILD_TOWER:Class;
		
		[Embed(source = '../../assets/sfx/PlayerHurtArmored-1.mp3')] public static const SFX_PLAYER_HURT1:Class;
		[Embed(source = '../../assets/sfx/PlayerHurtMed1-5.mp3')] public static const SFX_PLAYER_HURT2:Class;
		[Embed(source = '../../assets/sfx/PlayerHurtMed2-4.mp3')] public static const SFX_PLAYER_HURT3:Class;
		[Embed(source = '../../assets/sfx/PlayerHurtSmall1-3.mp3')] public static const SFX_PLAYER_HURT4:Class;
		[Embed(source = '../../assets/sfx/PlayerHurtSmall2-2.mp3')] public static const SFX_PLAYER_HURT5:Class;
		
		[Embed(source = '../../assets/sfx/SmallCreeps1-1.mp3')] public static const SFX_DEATH_MAGICSPEED1:Class;
		[Embed(source = '../../assets/sfx/SmallCreeps2-2.mp3')] public static const SFX_DEATH_MAGICSPEED2:Class;
		[Embed(source = '../../assets/sfx/SmallCreeps3-3.mp3')] public static const SFX_DEATH_MAGICSPEED3:Class;
		[Embed(source = '../../assets/sfx/SmallCreeps4-4.mp3')] public static const SFX_DEATH_MAGICSPEED4:Class;
		[Embed(source = '../../assets/sfx/SmallCreeps5-5.mp3')] public static const SFX_DEATH_MAGICSPEED5:Class;
		
		[Embed(source = '../../assets/sfx/SwarmCreeps1-1.mp3')] public static const SFX_DEATH_SWARM1:Class;
		[Embed(source = '../../assets/sfx/SwarmCreeps2-2.mp3')] public static const SFX_DEATH_SWARM2:Class;
		[Embed(source = '../../assets/sfx/SwarmCreeps3-3.mp3')] public static const SFX_DEATH_SWARM3:Class;
		[Embed(source = '../../assets/sfx/SwarmCreeps4-4.mp3')] public static const SFX_DEATH_SWARM4:Class;
		[Embed(source = '../../assets/sfx/SwarmCreeps5-5.mp3')] public static const SFX_DEATH_SWARM5:Class;
		
		[Embed(source = '../../assets/sfx/youwin.mp3')] public static const SFX_GAME_WIN:Class;
		[Embed(source = '../../assets/sfx/youlose.mp3')] public static const SFX_GAME_LOSE:Class;
		/*
		
		[Embed(source = '../../assets/sfx/Wave8Start.mp3')] public static const SFX_GAME_START:Class;
		[Embed(source = '../../assets/sfx/musicdemo3.mp3')] public static const SFX_MUSIC1:Class;
		[Embed(source = '../../assets/sfx/error2test.mp3')] public static const SFX_INVALID:Class;
		[Embed(source = '../../assets/sfx/BuildTower.mp3')] public static const SFX_BUILD_TOWER:Class;
		[Embed(source = '../../assets/sfx/GameStartHighlightSound.mp3')] public static const SFX_START_HIGHLIGHT:Class;
		[Embed(source = '../../assets/sfx/enemyhurttest.mp3')] public static const SFX_PLAYER_HURT:Class;
		[Embed(source = '../../assets/sfx/PopupSound.mp3')] public static const SFX_POPUP:Class;
		[Embed(source = '../../assets/sfx/chiblast2.mp3')] public static const SFX_CHIBLAST:Class;
		[Embed(source = '../../assets/sfx/StartButton.mp3')] public static const SFX_BUTTON_START:Class;
		
		[Embed(source = '../../assets/sfx/Swarm_Death1.mp3')] public static const SFX_DEATH_SWARM1:Class;
		[Embed(source = '../../assets/sfx/Swarm_Death2.mp3')] public static const SFX_DEATH_SWARM2:Class;
		[Embed(source = '../../assets/sfx/Swarm_Death3.mp3')] public static const SFX_DEATH_SWARM3:Class;
		[Embed(source = '../../assets/sfx/Swarm_Death4.mp3')] public static const SFX_DEATH_SWARM4:Class;
		[Embed(source = '../../assets/sfx/Swarm_Death5.mp3')] public static const SFX_DEATH_SWARM5:Class;
		
		[Embed(source = '../../assets/sfx/Armored_Death1.mp3')] public static const SFX_DEATH_ARMOR1:Class;
		[Embed(source = '../../assets/sfx/Armored_Death2.mp3')] public static const SFX_DEATH_ARMOR2:Class;
		
		[Embed(source = '../../assets/sfx/Magic_Speed_Death1.mp3')] public static const SFX_DEATH_MAGICSPEED1:Class;
		[Embed(source = '../../assets/sfx/Magic_Speed_Death2.mp3')] public static const SFX_DEATH_MAGICSPEED2:Class;
		[Embed(source = '../../assets/sfx/Magic_Speed_Death3.mp3')] public static const SFX_DEATH_MAGICSPEED3:Class;
		[Embed(source = '../../assets/sfx/Magic_Speed_Death4.mp3')] public static const SFX_DEATH_MAGICSPEED4:Class;
		[Embed(source = '../../assets/sfx/Magic_Speed_Death5.mp3')] public static const SFX_DEATH_MAGICSPEED5:Class;
		
		[Embed(source = '../../assets/sfx/Regen_Chigen_Death1.mp3')] public static const SFX_DEATH_REGENCHIGEN1:Class;
		[Embed(source = '../../assets/sfx/Regen_Chigen_Death2.mp3')] public static const SFX_DEATH_REGENCHIGEN2:Class;
		[Embed(source = '../../assets/sfx/Regen_Chigen_Death3.mp3')] public static const SFX_DEATH_REGENCHIGEN3:Class;
		[Embed(source = '../../assets/sfx/Regen_Chigen_Death4.mp3')] public static const SFX_DEATH_REGENCHIGEN4:Class;
		[Embed(source = '../../assets/sfx/Regen_Chigen_Death5.mp3')] public static const SFX_DEATH_REGENCHIGEN5:Class;
		*/
		// Misc
		[Embed(source = '../../assets/Board/glow.png')] public static const GFX_GLOW:Class;
		[Embed(source = '../../assets/Board/mute.png')] public static const GFX_MUTE:Class;
		[Embed(source = '../../assets/misc/facebook32px.png')] public static const GFX_MISC_FB:Class;
		
		// Fonts
		[Embed(source = '../../assets/DOMOAN__.ttf', embedAsCFF = "false", fontFamily = 'Domo')] public static const FONT_DOMO:Class
		
		public static const friendNames:Array = new Array("Sereena Castillo");
		public static const devNames:Array = new Array("behindcurtain3", "Wu_Li_Mammoth", "chronocide2000");
		
	}

}