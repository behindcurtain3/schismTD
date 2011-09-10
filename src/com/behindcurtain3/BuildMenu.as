package com.behindcurtain3 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
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
			backgroundGfx = Image.createCircle(radius, 0x000000);
			backgroundGfx.alpha = 0.75;
			
			//compassGfx = new Image(Assets.GFX_COMPASS);
			//compassGfx.x = radius - (compassGfx.width / 2);
			//compassGfx.y = radius - (compassGfx.height / 2);
			
			towerGfx = new Image(Assets.GFX_TOWER_BASIC);
			towerGfx.x = radius - (towerGfx.width / 2);
			towerGfx.y = radius - (towerGfx.height / 2);
			
			graphic = new Graphiclist(backgroundGfx, towerGfx);
			layer = 4;
			visible = false;
		}
		
		public function displayAt(cell:Cell):void
		{
			this.x = cell.x - radius + cell.halfWidth;
			this.y = cell.y - radius + cell.halfHeight;
			
			towerGfx = new Image(cell.towerAsset);
			towerGfx.x = radius - (towerGfx.width / 2);
			towerGfx.y = radius - (towerGfx.height / 2);
			
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
				//leftUpgradeGfx.x = -(leftUpgradeGfx.width / 2);
				leftUpgradeGfx.y = radius - (leftUpgradeGfx.height / 2);
			}
			if (rightUpgradeGfx != null)
			{
				rightUpgradeGfx.x = (radius * 2) - (rightUpgradeGfx.width);
				rightUpgradeGfx.y = radius - (rightUpgradeGfx.height / 2);
			}
			if(leftUpgradeGfx != null && rightUpgradeGfx != null)
				graphic = new Graphiclist(backgroundGfx, towerGfx, leftUpgradeGfx, rightUpgradeGfx);
			else
				graphic = new Graphiclist(backgroundGfx, towerGfx);
				
			this.visible = true;
		}
		
	}

}