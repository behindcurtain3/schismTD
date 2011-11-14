package schism.ui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Draw;
	import schism.Assets;
	import schism.Cell;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class BuildMenu extends Entity 
	{
		protected var backgroundGfx:Image;
		protected var rangeGfx:Image;
		protected var compassGfx:Image;
		protected var towerGfx:Image;		
		protected var leftUpgradeGfx:Image;
		protected var rightUpgradeGfx:Image;
		protected var leftUpgradeText:Text;
		protected var rightUpgradeText:Text;
		protected var leftUpgradeToken:Image;
		protected var leftUpgradeCost:Text;
		protected var rightUpgradeToken:Image;
		protected var rightUpgradeCost:Text;
		protected var towerName:Text;
		public var towerDmg:Text;
		public var towerRate:Text;
		
		protected var upgrade1:Text;
		protected var upgrade2:Text;
		protected var upgrade1Name:Text;
		protected var upgrade2Name:Text;
		
		protected var sell:Text;
		protected var sellGfx:Image;
		protected var sellCost:Text;
		protected var sellToken:Image;
		
		protected var radius:Number;
		
		protected var bgWidth:Number = 158;
		protected var bgHeight:Number = 230;
		protected var xOffset:Number = -bgWidth - 15;
		protected var yOffset:Number = -bgHeight / 2;
		protected var defaultXOffset:Number = xOffset;
		protected var defaultYOffset:Number = yOffset;
		
		
		protected var _bgColor:uint = 0x111111;
		protected var _borderColor:uint = 0xFFFFFF;
		private var backgroundAlpha:Number = 1;
		
		private var txtOptions:Object = { font:"Domo", outlineColor: 0x000000, outlineStrength: 2, size: 14 }
		
		public var index:int = -1;
		public var color:String;
		
		public function BuildMenu(c:String)
		{
			radius = 75;
			width = radius * 2;
			height = radius * 2;
			color = c;

			backgroundGfx = new Image(Assets.GFX_BUILD_MENU);
			
			rangeGfx = new Image(Assets.GFX_TOWER_RANGE);
			rangeGfx.smooth = true;
			rangeGfx.centerOrigin();
			rangeGfx.scaleX = width / rangeGfx.width;
			rangeGfx.scaleY = height / rangeGfx.height;			
			
			towerGfx = new Image(Assets.GFX_TOWER_BASIC);
			towerGfx.centerOrigin();
			
			graphic = new Graphiclist(backgroundGfx, towerGfx);
			
			leftUpgradeToken = new Image(Assets.GFX_GEM);
			leftUpgradeToken.centerOrigin();
			
			rightUpgradeToken = new Image(Assets.GFX_GEM);
			rightUpgradeToken.centerOrigin();
			
			sell = new Text("Sell: (S)", 0, 0, txtOptions);
			//sell.size = 18;
			//sell.width = bgWidth;
			//sell.align = "center";
			
			sellGfx = new Image(Assets.GFX_TOWER_SELL);
			sellGfx.centerOrigin();
			
			sellToken = new Image(Assets.GFX_GEM);
			sellToken.centerOrigin();
			
			layer = 1;
			visible = false;
			centerOrigin();
		}
		/*
		override public function render():void 
		{
			//Draw.rectPlus(this.x + xOffset + 5, this.y + yOffset + 5, bgWidth, bgHeight, 0x000000, backgroundAlpha - 0.35, true, 1, 15);
			Draw.rectPlus(this.x + xOffset, this.y + yOffset, bgWidth, bgHeight, _bgColor, backgroundAlpha, true, 1, 15);
			
			Draw.linePlus(this.x + xOffset, this.y + towerName.y + towerName.height + 3, this.x + xOffset + bgWidth, this.y + towerName.y + towerName.height + 3);
			
			Draw.rectPlus(this.x + xOffset + 3, this.y + yOffset + 3, bgWidth - 6, bgHeight - 6, _borderColor, backgroundAlpha, false, 2, 15);
			
			super.render();
		}
		*/
		public function displayAt(cell:Cell):void
		{
			this.x = cell.centerX;
			this.y = cell.centerY;
			this.index = cell.getIndex();
			
			rangeGfx.scaleX = (cell.towerRange * 2) / rangeGfx.width;
			rangeGfx.scaleY = (cell.towerRange * 2) / rangeGfx.height;
			
			xOffset = defaultXOffset;
			if (color == "white")
			{
				xOffset = 15;
			}
			
			yOffset = defaultYOffset;
			if (yOffset + this.y < 0)
			{
				while (yOffset + this.y < 0)
				{
					yOffset += 5;
				}
			}
			else if (yOffset + this.y + bgHeight > FP.screen.height)
			{
				while (yOffset + this.y + bgHeight > FP.screen.height)
				{
					yOffset -= 5;
				}
			}
			
			backgroundGfx.x = xOffset;
			backgroundGfx.y = yOffset;
			
			towerName = new Text(cell.getTowerName(), 0, 0, { font:"Domo", outlineColor: 0x000000, outlineStrength: 2, size: 18 } );
			towerName.width = bgWidth;
			towerName.align = "center";
			towerName.x = xOffset;
			towerName.y = yOffset + 10;
			
			towerDmg = new Text("Dmg: " + cell.towerDamage, 0, 0, txtOptions);
			towerDmg.width = bgWidth / 2;
			towerDmg.align = "center";
			towerDmg.x = xOffset;
			towerDmg.y = towerName.y + 30;
			
			towerRate = new Text("Rate: " + cell.towerFireRate / 1000, 0, 0, txtOptions);
			towerRate.width = bgWidth / 2;
			towerRate.align = "center";
			towerRate.x = xOffset + bgWidth / 2;
			towerRate.y = towerDmg.y;
			
			sell.x = xOffset + 15;
			sell.y = towerDmg.y + 125;
			
			sellGfx.x = xOffset + bgWidth - sellGfx.width / 2 - 15;
			sellGfx.y = sell.y + 19;
			
			sellToken.x = sellGfx.x - 7;
			sellToken.y = sellGfx.y + sellGfx.height / 2 + 10;
			
			sellCost = new Text("7", 0, 0, txtOptions);
			sellCost.centerOrigin();
			sellCost.x = sellGfx.x + 8;
			sellCost.y = sellToken.y;
			
			towerGfx = new Image(cell.towerAsset);
			towerGfx.centerOrigin();
			
			switch(cell.towerAsset)
			{
				case Assets.GFX_TOWER_BASIC:
					leftUpgradeGfx = new Image(Assets.GFX_TOWER_RAPIDFIRE);
					rightUpgradeGfx = new Image(Assets.GFX_TOWER_SPELL);
					
					leftUpgradeCost = new Text("90", 0, 0, txtOptions);
					rightUpgradeCost = new Text("90", 0, 0, txtOptions);
					
					upgrade1Name = new Text("Rapid Fire", 0, 0, txtOptions);
					upgrade2Name = new Text("Spell", 0, 0, txtOptions);
					break;
				case Assets.GFX_TOWER_RAPIDFIRE:
					leftUpgradeGfx = new Image(Assets.GFX_TOWER_SNIPER);
					rightUpgradeGfx = new Image(Assets.GFX_TOWER_PULSE);
					
					leftUpgradeCost = new Text("180", 0, 0, txtOptions);
					rightUpgradeCost = new Text("180", 0, 0, txtOptions);
					
					upgrade1Name = new Text("Sniper", 0, 0, txtOptions);
					upgrade2Name = new Text("Pulse", 0, 0, txtOptions);
					sellCost.text = "75";
					break;
				case Assets.GFX_TOWER_SPELL:
					leftUpgradeGfx = new Image(Assets.GFX_TOWER_SLOW);
					rightUpgradeGfx = new Image(Assets.GFX_TOWER_DAMAGEBOOST);
					
					leftUpgradeCost = new Text("180", 0, 0, txtOptions);
					rightUpgradeCost = new Text("180", 0, 0, txtOptions);
					
					upgrade1Name = new Text("Slow", 0, 0, txtOptions);
					upgrade2Name = new Text("Damage Boost", 0, 0, txtOptions);
					sellCost.text = "75";
					break;
				case Assets.GFX_TOWER_DAMAGEBOOST:
					leftUpgradeGfx = new Image(Assets.GFX_TOWER_RANGEBOOST);
					rightUpgradeGfx = new Image(Assets.GFX_TOWER_RATEBOOST);
					
					leftUpgradeCost = new Text("10", 0, 0, txtOptions);
					rightUpgradeCost = new Text("10", 0, 0, txtOptions);
					
					upgrade1Name = new Text("Range Boost", 0, 0, txtOptions);
					upgrade2Name = new Text("Fire Rate Boost", 0, 0, txtOptions);
					
					sellCost.text = "210";
					break;
				case Assets.GFX_TOWER_PULSE:
				case Assets.GFX_TOWER_SNIPER:
				case Assets.GFX_TOWER_SLOW:
					leftUpgradeGfx = null;
					rightUpgradeGfx = null;
					
					sellCost.text = "210";
					break;
				case Assets.GFX_TOWER_RANGEBOOST:
				case Assets.GFX_TOWER_RATEBOOST:
					leftUpgradeGfx = null;
					rightUpgradeGfx = null;
					
					sellCost.text = "217";
					break;					
				default:
					leftUpgradeGfx = null;
					rightUpgradeGfx = null;
					break;
			}
			
			if (cell.towerAsset == Assets.GFX_TOWER_SNIPER)
				rangeGfx.visible = false;
			else
				rangeGfx.visible = true;
			
			if (leftUpgradeGfx != null)
			{
				leftUpgradeGfx.x = xOffset + bgWidth - leftUpgradeGfx.width / 2 - 15;//-radius + leftUpgradeGfx.width;
				leftUpgradeGfx.y = towerDmg.y + 40;
				
				leftUpgradeToken.x = leftUpgradeGfx.x - 10;
				leftUpgradeToken.y = leftUpgradeGfx.y + 25;
				
				leftUpgradeCost.centerOrigin();
				leftUpgradeCost.x = leftUpgradeGfx.x + 10;
				leftUpgradeCost.y = leftUpgradeToken.y;
				
				upgrade1 = new Text("Upgrade 1: (A)", 0, 0, txtOptions);
				upgrade1.x = xOffset + 15;
				upgrade1.y = towerDmg.y + 25;
				
				upgrade1Name.x = upgrade1.x + 5;
				upgrade1Name.y = upgrade1.y + 15;
			}
			if (rightUpgradeGfx != null)
			{
				rightUpgradeGfx.x = xOffset + bgWidth - rightUpgradeGfx.width / 2 - 15;// radius - rightUpgradeGfx.width;
				rightUpgradeGfx.y = upgrade1Name.y + 50;
				
				rightUpgradeToken.x = rightUpgradeGfx.x - 10;
				rightUpgradeToken.y = rightUpgradeGfx.y + 25;
				
				rightUpgradeCost.centerOrigin();
				rightUpgradeCost.x = rightUpgradeGfx.x + 10;
				rightUpgradeCost.y = rightUpgradeToken.y;
				
				upgrade2 = new Text("Upgrade 2: (D)", 0, 0, txtOptions);
				upgrade2.x = upgrade1.x;
				upgrade2.y = upgrade1Name.y + 35;
				
				upgrade2Name.x = upgrade2.x + 5;
				upgrade2Name.y = upgrade2.y + 15;
			}
			if (leftUpgradeGfx != null && rightUpgradeGfx != null)
			{
				leftUpgradeGfx.centerOrigin();
				rightUpgradeGfx.centerOrigin();
				graphic = new Graphiclist(rangeGfx, backgroundGfx, towerGfx, towerName, towerDmg, towerRate, sell, sellGfx, sellToken, sellCost, upgrade1, upgrade1Name, upgrade2, upgrade2Name, leftUpgradeGfx, rightUpgradeGfx, leftUpgradeToken, leftUpgradeCost, rightUpgradeToken, rightUpgradeCost);
			}
			else
				graphic = new Graphiclist(rangeGfx, backgroundGfx, towerGfx, towerName, towerDmg, towerRate, sell, sellGfx, sellToken, sellCost);
				
			this.visible = true;
		}
		
		public function isMouseOver():Boolean
		{
			if (!this.visible) return false;
			
			return (Input.mouseX >= this.x + xOffset && Input.mouseX <= this.x + xOffset + bgWidth && Input.mouseY >= this.y + yOffset && Input.mouseY <= this.y + yOffset + bgHeight);
			/*
			if (leftUpgradeGfx == null && rightUpgradeGfx == null)
				return false;
				
			var distance:Number = Math.abs(this.x - Input.mouseX) + Math.abs(this.y - Input.mouseY);
			
			return distance <= this.radius && this.visible;
			*/
		}
		
		public function isMouseOverLeft():Boolean
		{
			if (leftUpgradeGfx != null)
			{
				var left:Number = leftUpgradeGfx.x - leftUpgradeGfx.width / 2;
				var right:Number = left + leftUpgradeGfx.width;
				var top:Number = leftUpgradeGfx.y - leftUpgradeGfx.height / 2;
				var bottom:Number = top + leftUpgradeGfx.height;
				
				return (Input.mouseX >= this.x + left && Input.mouseX <= this.x + right && Input.mouseY >= this.y + top && Input.mouseY <= this.y + bottom);
			}
			else
			{
				return false;
			}
		}
		
		public function isMouseOverRight():Boolean
		{
			if (rightUpgradeGfx != null)
			{
				var left:Number = rightUpgradeGfx.x - rightUpgradeGfx.width / 2;
				var right:Number = left + rightUpgradeGfx.width;
				var top:Number = rightUpgradeGfx.y - rightUpgradeGfx.height / 2;
				var bottom:Number = top + rightUpgradeGfx.height;
				
				return (Input.mouseX >= this.x + left && Input.mouseX <= this.x + right && Input.mouseY >= this.y + top && Input.mouseY <= this.y + bottom);
			}
			else
			{
				return false;
			}
		}
		
		public function isMouseOverSell():Boolean
		{
			var left:Number = sellGfx.x - sellGfx.width / 2;
			var right:Number = left + sellGfx.width;
			var top:Number = sellGfx.y - sellGfx.height / 2;
			var bottom:Number = top + sellGfx.height;
				
			return (Input.mouseX >= this.x + left && Input.mouseX <= this.x + right && Input.mouseY >= this.y + top && Input.mouseY <= this.y + bottom);
		}
		
		public function setRange(r:Number):void
		{
			rangeGfx.scaleX = (r * 2) / rangeGfx.width;
			rangeGfx.scaleY = (r * 2) / rangeGfx.height;
		}
		
	}

}