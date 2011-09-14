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
		
		protected var radius:int;
		
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
			layer = 4;
			visible = false;
			centerOrigin();
		}
		
		public function displayAt(cell:Cell):void
		{
			this.x = cell.centerX;
			this.y = cell.centerY;
			
			towerGfx = new Image(cell.towerAsset);
			towerGfx.centerOrigin();
			
			switch(cell.towerAsset)
			{
				case Assets.GFX_TOWER_BASIC:
					leftUpgradeGfx = new Image(Assets.GFX_TOWER_RAPIDFIRE);
					rightUpgradeGfx = new Image(Assets.GFX_TOWER_SLOW);
					break;
				case Assets.GFX_TOWER_RAPIDFIRE:
					leftUpgradeGfx = new Image(Assets.GFX_TOWER_SNIPER);
					rightUpgradeGfx = new Image(Assets.GFX_TOWER_PULSE);
					break;
				case Assets.GFX_TOWER_SLOW:
					leftUpgradeGfx = new Image(Assets.GFX_TOWER_SPELL);
					rightUpgradeGfx = new Image(Assets.GFX_TOWER_DAMAGEBOOST);
					break;
				case Assets.GFX_TOWER_DAMAGEBOOST:
					leftUpgradeGfx = new Image(Assets.GFX_TOWER_RANGEBOOST);
					rightUpgradeGfx = new Image(Assets.GFX_TOWER_RATEBOOST);
					break;
				default:
					leftUpgradeGfx = null;
					rightUpgradeGfx = null;
					break;
			}
			if (leftUpgradeGfx != null)
			{
				leftUpgradeGfx.x = -radius;
			}
			if (rightUpgradeGfx != null)
			{
				rightUpgradeGfx.x = radius;
			}
			if (leftUpgradeGfx != null && rightUpgradeGfx != null)
			{
				leftUpgradeGfx.centerOrigin();
				rightUpgradeGfx.centerOrigin();
				graphic = new Graphiclist(backgroundGfx, towerGfx, leftUpgradeGfx, rightUpgradeGfx);
			}
			else
				graphic = new Graphiclist(backgroundGfx, towerGfx);
				
			this.visible = true;
		}
		
	}

}