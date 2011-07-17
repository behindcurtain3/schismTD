package com.behindcurtain3 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Util 
	{
		public static const toRadians:Number = Math.PI / 180;
		public static function getPositionOnCirlce(cx:int, cy:int, r:int, angle:int):Point
		{
			var p:Point = new Point();
			
			p.x = cx + r * Math.sin(angle * toRadians);
			p.y = cy + r * Math.cos(angle * toRadians);
			
			return p;
		}
	}

}