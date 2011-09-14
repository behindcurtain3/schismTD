package schism.util
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Justin Brown
	 */
    public class Vector2
    {
        public var x:Number;
        public var y:Number;
        public var length:Number;
        public var direction:Number;

        public function Vector2(x:Number, y:Number)
        {
            setPoints(x, y);
        }

        public function getPointF():Point
        {
            return new Point(x, y);
        }

        public function setPoints(_x:Number, _y:Number):void
        {
            x = _x;
            y = _y;
			
            length = Math.sqrt(x * x + y * y);
            direction = Math.atan2(x, y) * 180 / Math.PI;
        }
		
		public function setDirection(value:Number):void
		{
			direction = value;
			x = Math.cos(direction / 180 * Math.PI) * length;
			y = Math.sin(direction / 180 * Math.PI) * length;
		}
		
		public function setLength(value:Number):void
		{
			length = value;
			x = Math.cos(direction / 180 * Math.PI) * length;
			y = Math.sin(direction / 180 * Math.PI) * length;			
		}

        public function normalize():void
        {
            var temp:Number = 1 / length;
            setPoints(x * temp, y * temp);
        }

        public function dot(b:Vector2):Number
        {
            return (b.x * x) + (b.y * y);
        }

        public function minus(b:Vector2):void
        {
			setPoints(x - b.x, y - b.y);
        }

        public function plus(b:Vector2):void
        {
			setPoints(x + b.x, y + b.y);
        }

        public function times(scale:Number):void
        {
			setPoints(x * scale, y * scale);
        }

        public static function increment(a:Vector2):Vector2
        {
            a.x++;
            a.y++;
            return a;
        }

        public static function decrement(a:Vector2):Vector2
        {
            a.x--;
            a.y--;
            return a;
        }

        // Negation
        public static function negate(a:Vector2):Vector2
        {
            return new Vector2(-a.x, -a.y);
        }

        public static function isTrue(a:Vector2):Boolean
        {
            if ((a.x != 0) || (a.y != 0))
                return true;
            else
                return false;
        }

        public static function isFalse(a:Vector2):Boolean
        {
            if ((a.x == 0) && (a.y == 0))
                return true;
            else
                return false;
        }
    }
}