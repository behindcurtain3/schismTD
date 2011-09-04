package com.behindcurtain3
{
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
	public class MenuWorld extends World 
	{
		// Login
		protected var username:PunkTextField;
		protected var password:PunkPasswordField;
		
		// Register
		protected var regUsername:PunkTextField;
		protected var regPassword:PunkPasswordField;
		protected var regEmail:PunkTextField;
		
		
		public function MenuWorld (error:String = "")
		{
			var uiX:int = 100;
			var uiY:int = 200;
			var width:int = 250;
			var spacer:int = 25;
			
			// Background
			addGraphic(new Image(Assets.GFX_LOGIN_BACKGROUND), 100);
			
			// Login
			add(new PunkLabel("Username:", uiX, uiY, width, 50));
			username = new PunkTextField("", uiX, uiY + spacer, width);
			add(new PunkLabel("Password:", uiX, uiY + spacer * 2, width, 50));
			password = new PunkPasswordField(uiX, uiY + spacer * 3, width);
			
			add(username);
			add(password);
			add(new PunkButton(uiX, uiY + spacer * 5, width, 50, "Play Now", onPlayNow));
			
			// Register
			uiX = 450;
			
			add(new PunkLabel("Username:", uiX, uiY, width, 50));
			regUsername = new PunkTextField("", uiX, uiY + spacer, width);
			add(new PunkLabel("Password:", uiX, uiY + spacer * 2, width, 50));
			regPassword = new PunkPasswordField(uiX, uiY + spacer * 3, width);
			add(new PunkLabel("Email: (optional)", uiX, uiY + spacer * 4, width, 50));
			regEmail = new PunkTextField("", uiX, uiY + spacer * 5, width);
			
			add(regUsername);
			add(regPassword);
			add(regEmail);
			add(new PunkButton(uiX, uiY + spacer * 7, width, 50, "Register", onPlayNow));			
			
			addGraphic(new Text(Assets.VERSION, 0, FP.screen.height - 15, 50, 15));
			
			if (error != "")
			{
				var eText:Text = new Text(error, 10, 10, FP.screen.width - 20, 20);
				var eTween:VarTween = new VarTween();
				eTween.tween(eText, "alpha", 0, 5, Ease.quadIn);
				
				addGraphic(eText);
				addTween(eTween, true);
			}
		}
		
		override public function end():void
		{
			removeAll();
			super.end();
		}
		
		override public function update():void
		{
			
			super.update();
		}
		
		public function playNow():void
		{
			FP.world = new LoginWorld(getRandomName(), "");
		}
		
		public function onPlayNow():void
		{
			playNow();
		}
		
		private function getRandomName():String
		{
			var names:Array = new Array("Steve", "Rambo", "Rocky 3 - The Best One", "The Girl Next Door", "Sirmixalot", "Ninja Turtle Imposter");
			var i:Number = Math.floor( Math.random() * names.length );  
			return names.splice( i, 1 )[0];
		}
		
		private function randomRange(max:Number, min:Number = 0):Number
		{
			return Math.floor(Math.random()*(1+max-min))+max;
		}
		
	}
}