package schism.ui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import schism.Assets;
	import schism.Cell;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class BuildMenu extends Entity 
	{
		protected var backgroundGfx:Image;
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
		
		protected var radius:Number;
		
		public function BuildMenu() 
		{
			radius = 75;
			width = radius * 2;
			height = radius * 2;

			backgroundGfx = new Image(Assets.GFX_TOWER_RANGE);
			backgroundGfx.smooth = true;
			backgroundGfx.centerOrigin();
			backgroundGfx.scaleX = width / backgroundGfx.width;
			backgroundGfx.scaleY = height / backgroundGfx.height;			
			
			towerGfx = new Image(Assets.GFX_TOWER_BASIC);
			towerGfx.centerOrigin();
			
			graphic = new Graphiclist(backgroundGfx, towerGfx);
			
			leftUpgradeToken = new Image(Assets.GFX_GEM);
			leftUpgradeToken.centerOrigin();
			
			rightUpgradeToken = new Image(Assets.GFX_GEM);
			rightUpgradeToken.centerOrigin();
			
			layer = 4;
			visible = false;
			centerOrigin();
		}
		
		public function displayAt(cell:Cell):void
		{
			this.x = cell.centerX;
			this.y = cell.centerY;
			
			backgroundGfx.scaleX = (cell.towerRange * 2) / backgroundGfx.width;
			backgroundGfx.scaleY = (cell.towerRange * 2) / backgroundGfx.height;
			
			towerGfx = new Image(cell.towerAsset);
			towerGfx.centerOrigin();
			
			switch(cell.towerAsset)
			{
				case Assets.GFX_TOWER_BASIC:
					leftUpgradeGfx = new Image(Assets.GFX_TOWER_RAPIDFIRE);
					rightUpgradeGfx = new Image(Assets.GFX_TOWER_SPELL);
					
					leftUpgradeCost = new Text("90");
					rightUpgradeCost = new Text("90");
					break;
				case Assets.GFX_TOWER_RAPIDFIRE:
					leftUpgradeGfx = new Image(Assets.GFX_TOWER_SNIPER);
					rightUpgradeGfx = new Image(Assets.GFX_TOWER_PULSE);
					
					leftUpgradeCost = new Text("180");
					rightUpgradeCost = new Text("180");
					break;
				case Assets.GFX_TOWER_SPELL:
					leftUpgradeGfx = new Image(Assets.GFX_TOWER_SLOW);
					rightUpgradeGfx = new Image(Assets.GFX_TOWER_DAMAGEBOOST);
					
					leftUpgradeCost = new Text("180");
					rightUpgradeCost = new Text("180");
					break;
				case Assets.GFX_TOWER_DAMAGEBOOST:
					leftUpgradeGfx = new Image(Assets.GFX_TOWER_RANGEBOOST);
					rightUpgradeGfx = new Image(Assets.GFX_TOWER_RATEBOOST);
					
					leftUpgradeCost = new Text("10");
					rightUpgradeCost = new Text("10");
					break;
				default:
					leftUpgradeGfx = null;
					rightUpgradeGfx = null;
					break;
			}
			
			if (cell.towerAsset == Assets.GFX_TOWER_SNIPER)
				backgroundGfx.visible = false;
			else
				backgroundGfx.visible = true;
			
			if (leftUpgradeGfx != null)
			{
				leftUpgradeGfx.x = -radius + leftUpgradeGfx.width;
				leftUpgradeToken.x = leftUpgradeGfx.x - 15;
				leftUpgradeToken.y = leftUpgradeGfx.y + 30;
				
				leftUpgradeCost.centerOrigin();
				leftUpgradeCost.font = "Domo";
				leftUpgradeCost.color = 0xFFFFFF;
				leftUpgradeCost.x = leftUpgradeGfx.x + 10;
				leftUpgradeCost.y = leftUpgradeToken.y;
			}
			if (rightUpgradeGfx != null)
			{
				rightUpgradeGfx.x = radius - rightUpgradeGfx.width;
				
				rightUpgradeToken.x = rightUpgradeGfx.x - 15;
				rightUpgradeToken.y = rightUpgradeGfx.y + 30;
				
				rightUpgradeCost.centerOrigin();
				rightUpgradeCost.font = "Domo";
				rightUpgradeCost.color = 0xFFFFFF;
				rightUpgradeCost.x = rightUpgradeGfx.x + 10;
				rightUpgradeCost.y = rightUpgradeToken.y;
			}
			if (leftUpgradeGfx != null && rightUpgradeGfx != null)
			{
				leftUpgradeGfx.centerOrigin();
				rightUpgradeGfx.centerOrigin();
				graphic = new Graphiclist(backgroundGfx, towerGfx, leftUpgradeGfx, rightUpgradeGfx, leftUpgradeToken, leftUpgradeCost, rightUpgradeToken, rightUpgradeCost);
			}
			else
				graphic = new Graphiclist(backgroundGfx, towerGfx);
				
			this.visible = true;
		}
		
		public function isMouseOver():Boolean
		{
			if (leftUpgradeGfx == null && rightUpgradeGfx == null)
				return false;
				
			var distance:Number = Math.abs(this.x - Input.mouseX) + Math.abs(this.y - Input.mouseY);
			
			return distance <= this.radius && this.visible;
		}
		
		public function isMouseOverLeft():Boolean
		{
			if (leftUpgradeGfx != null)
			{
				var left:Number = this.x + (leftUpgradeGfx.x - leftUpgradeGfx.width / 2);
				var right:Number = left + leftUpgradeGfx.width;
				var top:Number = this.y  + leftUpgradeGfx.y - leftUpgradeGfx.height / 2;
				var bottom:Number = top + leftUpgradeGfx.height;
				
				return (Input.mouseX >= left && Input.mouseX <= right && Input.mouseY >= top && Input.mouseY <= bottom);
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
				var left:Number = this.x + (rightUpgradeGfx.x - rightUpgradeGfx.width / 2);
				var right:Number = left + rightUpgradeGfx.width;
				var top:Number = this.y  + rightUpgradeGfx.y - rightUpgradeGfx.height / 2;
				var bottom:Number = top + rightUpgradeGfx.height;
				
				return (Input.mouseX >= left && Input.mouseX <= right && Input.mouseY >= top && Input.mouseY <= bottom);
			}
			else
			{
				return false;
			}
		}
		
	}

}