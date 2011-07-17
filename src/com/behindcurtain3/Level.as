package com.behindcurtain3 
{
	import flash.utils.ByteArray;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Grid;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Level
	{			
		// Data
		public var LevelData:XML;
		
		public var Name:String;
		public var Description:String;
		public var Difficulty:int;
		
		public function Level(xml:Class) 
		{
			loadLevelData(xml);
		}
		
		public function loadLevelData(xml:Class):void
		{
			var rawData:ByteArray = new xml;
			var dataString:String = rawData.readUTFBytes(rawData.length);
			LevelData = new XML(dataString);
			
			Name = LevelData.@title;
			Description = LevelData.@description;
			Difficulty = LevelData.@difficulty;
		}
		
	}

}