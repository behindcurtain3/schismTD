package schism.ui 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	import punk.ui.skin.PunkSkinButtonElement;
	import punk.ui.skin.PunkSkinLabelElement;
	import punk.ui.skin.PunkSkin;
	import punk.ui.skin.PunkSkinImage;
	import punk.ui.skin.PunkSkinHasLabelElement;
	import punk.ui.skin.PunkSkinToggleButtonElement;
	import punk.ui.skin.PunkSkinWindowElement;
	
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class SchismSkin extends PunkSkin 
	{
		
		/**
		 * The asset to use for the skin images
		 */
		[Embed(source="../../../assets/Board/punkuimenus.png")] protected const I:Class;
		
		/**
		 * Constructor.
		 * @param	roundedButtons If using rounded buttons
		 * @param	passwordField defines which image style is used for the Password Field
		 * @param	textArea defines which image style is used for the Text Area
		 * @param	textField defines which image style is used for the Text Field
		 * @param	windowCaption defines which image style is used for the Window Caption
		 * @param	windowBody defines which image style is used for the Window Body
		 */
		public function SchismSkin()
		{
			super();
			var textColor:int = 0xFFFFFF;
			punkButton = new PunkSkinButtonElement(gy(0, 0, 32, 32), gy(32, 0, 32, 32), gy(64, 0, 32, 32), gy(0, 0, 32, 32), { color: 0xFFFFFF, size: 18 } );
			punkLabel = new PunkSkinHasLabelElement( { color: textColor, size: 16 } );
			punkTextField = new PunkSkinLabelElement( { color: 0x000000, size: 16 }, gy(0, 32, 32, 32));
			punkPasswordField = new PunkSkinLabelElement( { color: 0x000000, size: 16 }, gy(0, 32, 32, 32));
		}
		
		/**
		 * Returns the portion of the skin image as a PunkSkinImage object in a 9-Slice format
		 * @param	x X-Coordinate for the image offset
		 * @param	y Y-Coordinate for the image offset
		 * @param	w Width of the image sub-section
		 * @param	h Height of the image sub-section
		 * @return PunkSkinImage for the image sub-section requested in 9-Slice format
		 */
		protected function gy(x:int, y:int, w:int=16, h:int=16):PunkSkinImage
		{
			return new PunkSkinImage(gi(x, y, w, h), true, 4, 4, 4, 4);
		}
		
		/**
		 * Returns the portion of the skin image as a PunkSkinImage object in a non 9-Sliced format
		 * @param	x X-Coordinate for the image offset
		 * @param	y Y-Coordinate for the image offset
		 * @param	w Width of the image sub-section
		 * @param	h Height of the image sub-section
		 * @return PunkSkinImage for the image sub-section requested in a non 9-Sliced format
		 */
		protected function gn(x:int, y:int, w:int=16, h:int=16):PunkSkinImage
		{
			return new PunkSkinImage(gi(x, y, w, h), false);
		}
		
		/**
		 * Returns the portion of the skin image requested as a BitmapData object
		 * @param	x X-Coordinate for the image offset
		 * @param	y Y-Coordinate for the image offset
		 * @param	w Width of the image sub-section
		 * @param	h Height of the image sub-section
		 * @return BitmapData for the image sub-section requested
		 */
		protected function gi(x:int, y:int, w:int=16, h:int=16):BitmapData
		{
			_r.x = x;
			_r.y = y;
			_r.width = w;
			_r.height = h;
			
			var b:BitmapData = new BitmapData(w, h, true, 0);
			b.copyPixels(FP.getBitmap(I), _r, FP.zero, null, null, true);
			return b;
		}
		
		private var _r:Rectangle = new Rectangle;
		
	}

}