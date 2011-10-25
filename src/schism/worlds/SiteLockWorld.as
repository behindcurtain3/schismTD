package schism.worlds 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import schism.Assets;
	import schism.ui.MessageDisplay;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class SiteLockWorld extends World 
	{
		private var message:Text;
		
		public function SiteLockWorld() 
		{
			addGraphic(new Image(Assets.GFX_MENUBG), 100);
			add(new MessageDisplay("SchismTD is not available for play on the current site.\nPlease visit schismtd.com", 0, 24, FP.screen.width / 2, FP.screen.height / 2));
		}
		
	}

}