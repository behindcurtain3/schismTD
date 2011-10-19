package schism.worlds 
{
	import Facebook.FB;
	import flash.net.navigateToURL;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import playerio.Client;
	import punk.ui.PunkButton;
	import schism.Assets;
	import schism.ui.CustomMouse;
	import schism.ui.MessageDisplay;
	import schism.ui.Tooltip;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class HomeWorld extends AuthWorld 
	{
		private var messageDisplay:MessageDisplay;
		private var startSfx:Sfx;
		private var ratingDisplay:Text;
		private var facebook:Image;
		
		public function HomeWorld(c:Client, error:String = "") 
		{
			super(c);
			
			addGraphic(new Image(Assets.GFX_TITLE), 99, FP.screen.width / 2 - 275, 50);
			
			var width:int = 250;
			var uiX:int = FP.screen.width / 2 - width / 2;
			var uiY:int = 225;
			var spacer:int = 25;
			
			var b:PunkButton = new PunkButton(uiX, FP.screen.height / 2 - 25, width, 50, "Play", onPlay)
			add(b);
			
			b = new PunkButton(uiX, FP.screen.height / 2 - 25 + 60, width, 50, "Wave Builder", onWaveBuilderClick)
			add(b);
			//add(new Tooltip("Build your own custom waves!", b.x + b.width + 5, b.y));
			
			add(new MessageDisplay("", 0, 36, FP.screen.width / 2, FP.screen.height / 2 + 55, width + 35, 185));
			
			if (error != "")
			{
				messageDisplay = new MessageDisplay(error, 5, 18, FP.screen.width / 2);
				messageDisplay.sound();
				add(messageDisplay);
			}
			
			startSfx = new Sfx(Assets.SFX_BUTTON_START);
			
			var t:Text = new Text("Logged in as: " + AuthWorld.playerName, 0, 0, { font: "Domo", color: 0xFFFFFF, outlineColor: 0x000000, outlineStrength: 2 } );
			if (AuthWorld.playerName != "Guest")
			{
				t.x = FP.screen.width - t.textWidth;
				t.y = FP.screen.height - t.textHeight;
				addGraphic(t);
			}
			else
			{
				if (isKongUser)
				{
					AuthWorld.playerName = QuickKong.userName;
					t.text = "Logged in as: " + AuthWorld.playerName;
					t.x = FP.screen.width - t.textWidth;
					t.y = FP.screen.height - t.textHeight;
					addGraphic(t);
				}
				else
				{
					// facebook user
					try
					{
						FB.init( { access_token: AuthWorld.accessToken, debug: true } );

						FB.api('/me', function(response:*) : void {
							if (response.username == undefined || response.username == "")
								AuthWorld.playerName = response.name;
							else
								AuthWorld.playerName = response.username;
							
							t.text = "Logged in as: " + AuthWorld.playerName;
							t.x = FP.screen.width - t.textWidth;
							t.y = FP.screen.height - t.textHeight;
							addGraphic(t);
						});
					}
					catch (e:Error)
					{
						trace(e.message);
					}
				}
			}
			
			
			if(playerObject == null)
				loadPlayerObject();
			
			facebook = new Image(Assets.GFX_MISC_FB);
			facebook.x = 0;
			facebook.y = FP.screen.height - facebook.height;
			addGraphic(facebook);
				
			//addGraphic(new Text(Assets.VERSION, facebook.width + 5, FP.screen.height - 15, { outlineColor: 0x000000, outlineStrength: 2, font: "Domo" } ));
		}
			
		override public function end():void
		{
			removeAll();
			super.end();
		}
		
		override public function update():void 
		{
			if (playerObject != null && ratingDisplay == null)
			{
				var rating:String = playerObject["rating"] == undefined ? "1500" : playerObject["rating"];
				
				ratingDisplay = new Text("Rating: " + rating, FP.screen.width / 2, FP.screen.height / 2 + 105, { font: "Domo", size: 24, outlineStrength: 2 } );
				ratingDisplay.x -= ratingDisplay.textWidth / 2;
				addGraphic(ratingDisplay);
			}
			
			if (Input.mouseX > facebook.x && Input.mouseX < facebook.x + facebook.width && Input.mouseY > facebook.y && Input.mouseY < facebook.y + facebook.height)
			{
				Mouse.show();
				Mouse.cursor = MouseCursor.BUTTON;
				(FP.stage.getChildByName("CustomMouse") as CustomMouse).visible = false;
				
				if (Input.mousePressed)
				{
					var goto:URLRequest = new URLRequest("https://www.facebook.com/pages/SchismTD/231809410207524");
					navigateToURL(goto, "_blank");
				}
			}
			else
			{
				Mouse.hide();
				Mouse.cursor = MouseCursor.ARROW;
				(FP.stage.getChildByName("CustomMouse") as CustomMouse).visible = true;
			}
			
			super.update();
		}
		
		public function onPlay():void
		{
			startSfx.play();
			FP.world = new MatchFinderWorld(client);
		}
		
		public function onWaveBuilderClick():void
		{
			FP.world = new WaveBuilder(client);
		}
		
	}

}