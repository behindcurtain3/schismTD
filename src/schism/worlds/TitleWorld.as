package schism.worlds
{
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.system.Security;
	import net.flashpunk.utils.Draw;
	import playerio.Client;
	import playerio.Connection;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	import playerio.PlayerIORegistrationError;
	import schism.Assets;
	import schism.ui.MessageDisplay;
	
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	
	import punk.ui.PunkButton;
	import punk.ui.PunkLabel;
	import punk.ui.PunkPasswordField;
	import punk.ui.PunkTextArea;
	import punk.ui.PunkTextField;
	import punk.ui.PunkToggleButton;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class TitleWorld extends World 
	{		
		private var error:String;
		public function TitleWorld(e:String = "")
		{
			error = e;
		}
		
		override public function begin():void 
		{
			super.begin();
			
			var url:String = FP.stage.loaderInfo.url;
			
			if (url.indexOf("kongregate") != -1)
				FP.world = new KongTitleWorld(error);
			else
				FP.world = new FacebookTitleWorld(error);
		}
		
	}
}