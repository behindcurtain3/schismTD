package schism
{
	import flash.display.StageScaleMode;
	import flash.ui.Mouse;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import playerio.PlayerIO;
	import punk.ui.PunkUI;
	import punk.ui.skins.RolpegeBlue;
	import punk.ui.skins.SchismUI;
	import schism.ui.CustomMouse;
	import schism.ui.SchismSkin;
	import schism.worlds.LoginWorld;
	import schism.worlds.SiteLockWorld;
	import schism.worlds.TitleWorld;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Main extends Engine
	{
		protected var world:World;
		
		public function Main():void
		{			
			super(800, 600, 30, false);
		}
		
		override public function init():void 
		{
			super.init();
			
			FP.stage.addChild(new CustomMouse());
			FP.stage.scaleMode = StageScaleMode.SHOW_ALL;
			
			if (checkDomain(["www.schismtd.com", "schismtd.com", "schismtd.heroku.com", "kongregate.com", "flashgamelicense.com", "www.flashgamelicense.com"]))
			{
				//PlayerIO.showLogo(FP.stage, "BC");
				PunkUI.skin = new SchismSkin;
				world = new TitleWorld();
			}
			else 
			{
				world = new SiteLockWorld();				
			}
			FP.world = world;
		}
		
		override public function update():void
		{	
			super.update();
		}
		
		public function checkDomain (allowed:*):Boolean
		{
			var url:String = FP.stage.loaderInfo.url;

			var startCheck:int = url.indexOf('://' ) + 3;
			
			if (url.substr(0, startCheck) == 'file://') return true;
			
			var domainLen:int = url.indexOf('/', startCheck) - startCheck;
			var host:String = url.substr(startCheck, domainLen);
			
			if (allowed is String) allowed = [allowed];
			for each (var d:String in allowed)
			{
				if (host.substr(-d.length, d.length) == d) return true;
			}
			
			return false;
		}
		
	}
	
}