package schism.creeps 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.VarTween;
	import schism.Cell;
	import schism.effects.EffectEntity;
	import schism.util.Vector2;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Creep extends EffectEntity
	{		
		public var MovingTo:Cell = null;
		public var doFacing:Boolean = false;
		
		public var ID:String;
		public var player:int;
		public var path:Array;
		
		public var Speed:int;
		public var effectedSpeed:int;
		
		public var life:int = -1;
		public var startingLife:int;
		
		public var spriteMap:Spritemap;
		public var isActive:Boolean;
		private var mActivationTime:Number = 0;
		
		public function Creep(s:String, pId:int, _x:int, _y:int, sp:int, _path:Array) 
		{
			super();
			ID = s;		
			player = pId;
			Speed = sp;
			
			type = "creep";
		
			layer = 10;
			
			updatePath(_path);
			
			isActive = false;
		}
		
		public function flash():void
		{
			spriteMap.color = 0xFF0000;

			var colorTween:VarTween = new VarTween();
			colorTween.tween(spriteMap, "color", 0xFFFFFF, 2.5);
			addTween(colorTween, true);
		}
		
		override public function update():void 
		{
			if (!isActive)
			{
				mActivationTime += FP.elapsed;
				
				if (mActivationTime >= 1.0)
					isActive = true;
				
				return;
			}
			
			if (path.length > 0)
			{
				// Reset values
				effectedSpeed = Speed;
				
				// Apply effects
				applyEffects();
				
				
				if (MovingTo == null)
				{
					MovingTo = path[0];
					updateAngle();
				}
				
				var d:Number = getDistance(MovingTo);
				var velocity:Number = effectedSpeed * FP.elapsed;
				
				if (d <= velocity)
				{
					path.splice(0, 1);
					
					if (path.length != 0)
					{
						MovingTo = path[0];
						updateAngle();
					}
				}
				
				// Move the creep
				var movement:Vector2 = new Vector2(centerX, centerY);
				movement.minus(new Vector2(MovingTo.centerX, MovingTo.centerY));
				movement.normalize();
				movement.times(velocity);
				
				x -= movement.x;
				y -= movement.y;	
				
				if (life != -1 && spriteMap != null)
				{
					spriteMap.alpha = (life / startingLife) + 0.25;
				}
			}
			
			super.update();
		}
		
		public function updateLife(value:int):void
		{
			if (life == -1)
			{
				startingLife = value;
			}
			life = value;
		}
		
		public function updatePath(_path:Array):void
		{
			this.path = _path.slice();
			this.MovingTo = path[0];	
			updateAngle();
		}
		
		public function getDistance(cell:Cell):Number
		{
			return Math.abs(cell.centerX - centerX) + Math.abs(cell.centerY - centerY);
		}
		
		public function updateAngle():void
		{
			if (MovingTo == null || spriteMap == null || !doFacing)
				return;
				
			var dx:int = centerX - MovingTo.centerX;
			var dy:int = centerY - MovingTo.centerY;
			
			var up:Boolean = false;
			var down:Boolean = false;
			var left:Boolean = false;
			var right:Boolean = false;
			
			if (dx < -3)
				left = true;
			else if (dx > 3)
				right = true;
			if (dy < -3)
				down = true;
			else if (dy > 3)
				up = true;
				
			if (up && left)
				spriteMap.angle = 135;
			else if (up && right)
				spriteMap.angle = 225;
			else if (down && left)
				spriteMap.angle = 45;
			else if (down && right)
				spriteMap.angle = 315;
			else if (up)
				spriteMap.angle = 180;
			else if (right)
				spriteMap.angle = 270;
			else if (left)
				spriteMap.angle = 90;
			else
				spriteMap.angle = 0;
		}
	}

}