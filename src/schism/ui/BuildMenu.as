package schism.ui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
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
					rightUpgradeGfx = new Image(Assets.GFX_TOWER_SLOW);
					
					leftUpgradeCost = new Text("90");
					rightUpgradeCost = new Text("90");
					break;
				case Assets.GFX_TOWER_RAPIDFIRE:
					leftUpgradeGfx = new Image(Assets.GFX_TOWER_SNIPER);
					rightUpgradeGfx = new Image(Assets.GFX_TOWER_PULSE);
					
					leftUpgradeCost = new Text("180");
					rightUpgradeCost = new Text("180");
					break;
				case Assets.GFX_TOWER_SLOW:
					leftUpgradeGfx = new Image(Assets.GFX_TOWER_SPELL);
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
				leftUpgradeCost.color = 0x000000;
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
				rightUpgradeCost.color = 0x000000;
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
		
		public function setRange(r:Number):void
		{
			
		}
		
	}

}