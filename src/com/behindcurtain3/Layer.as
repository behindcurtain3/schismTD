package com.behindcurtain3 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Layer extends Entity 
	{
		// Tile sizes
		private var tw:int = 16;
		private var th:int = 16;
		private var tc:int = 16;
		private var tr:int = 16;
		
		private var tiles:Tilemap;
		private var grid:Grid;
		
		public function Layer(xml:XMLList, l:int) 
		{
			tiles = new Tilemap(Assets.TILES, 640, 480, tw, th);
			graphic = tiles;
			layer = l;
			type = "layer";
			
			var element:XML;
			for each(element in xml)
			{
				tiles.setTile(int(element.@x) / tw, int(element.@y) / th, getIndex(int(element.@tx), int(element.@ty)));
			}
		}
		
		public function setGrid(xml:XMLList):void
		{
			grid = new Grid(640, 480, 4, 4, 0, 0);
			var element:XML;
			for each(element in xml)
			{
				grid.setRect(int(element.@x) / 4, int(element.@y) / 4, int(element.@w) / 4, int(element.@h) / 4, true);
			}
			mask = grid;
		}
		
		private function getIndex(x:int, y:int):int
		{
			var col:int = x / tw;
			var row:int = y / th;
			
			return col + (row * tc);			
		}
		
	}

}