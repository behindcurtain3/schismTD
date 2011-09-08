package com.behindcurtain3
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	
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
			
			if (checkDomain("localhost"))
			{
				world = new LoginWorld();
				FP.world = world;
			}
			else 
			{
				trace("Game is sitelocked, the current site is not on the whitelist.");
			}
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