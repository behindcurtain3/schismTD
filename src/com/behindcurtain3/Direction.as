package com.behindcurtain3 
{
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Direction 
	{
		public static const N:int = 0;
		public static const NE:int = 1;
		public static const E:int = 2;
		public static const SE:int = 3;
		public static const S:int = 4;
		public static const SW:int = 5;
		public static const W:int = 6;
		public static const NW:int = 7;
		
		// degrees for each direction, used when firing projectiles
		public static const DN:int = 180;
		public static const DNE:int = 135;
		public static const DE:int = 90;
		public static const DSE:int = 45;
		public static const DS:int = 0;
		public static const DSW:int = 315;
		public static const DW:int = 270;
		public static const DNW:int = 225;
		
		public static function getAngleFromDir(d:int):int
		{
			switch(d)
			{
				case N:
					return DN;
				case NE:
					return DNE;
				case E:
					return DE;
				case SE:
					return DSE;
				case S:
					return DS;
				case SW:
					return DSW;
				case W:
					return DW;
				case NW:
					return DNW;
			}
			return 0;
		}
	}

}