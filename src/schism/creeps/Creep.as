package schism.creeps 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import schism.Assets;
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
		
		protected var deathSounds:Array;
		
		protected var deathEmitter:Emitter;
		protected var healEmitter:Emitter;
		protected var particleCount:int = 20;
		protected var graphicList:Graphiclist;
		
		protected var destroyTimer:Number = 0.5;
		protected var destroyPosition:Number = 0;
		protected var destroy:Boolean = false;
		protected var target:Image;
		
		protected var offsetX:Number;
		protected var offsetY:Number;
		
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
			
			deathSounds = new Array();
			
			healEmitter = new Emitter(Assets.GFX_CREEP_HEAL, 7, 7);
			healEmitter.newType("Heal", [0, 1, 0, 1, 0]);
			healEmitter.setAlpha("Heal", 1, 0.25, Ease.bounceInOut);
			healEmitter.setMotion("Heal", 90, 30, 0.5);
			
			deathEmitter = new Emitter(Assets.GFX_CREEP_DEATH);
			deathEmitter.newType("die", [0]);
			deathEmitter.setAlpha("die", 1, 0.5, Ease.circOut);
			deathEmitter.setMotion("die", 0, 3, destroyTimer, 360, 15, 0.05);
			deathEmitter.setGravity("die", 0.1);
			
			target = new Image(Assets.GFX_CREEP_TARGET);
			target.centerOrigin();
			target.visible = false;
			
			offsetX = 0;
			offsetY = 0;
		}
		
		override public function added():void 
		{
			graphicList = new Graphiclist(spriteMap, healEmitter, deathEmitter, target);
			graphic = graphicList;
			super.added();
		}
		
		public function flash():void
		{
			target.visible = true;
			target.scale = 1.5;
			
			var t:VarTween = new VarTween();
			t.tween(target, "scale", 1, 0.25);
			addTween(t);
		}
		
		public function removeTarget():void
		{
			target.visible = false;
		}
		
		override public function update():void 
		{
			if (destroy)
			{
				destroyPosition += FP.elapsed;
				
				if (world != null && destroyPosition >= destroyTimer)
					world.remove(this);
				
				return;
			}			
			
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
				movement.minus(new Vector2(MovingTo.centerX + offsetX, MovingTo.centerY + offsetY));
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
		
		public function die():void
		{
			path = [];
			for (var i:int = 0; i < particleCount; i++)
			{
				deathEmitter.emit("die", 0, 0);
			}
			destroy = true;
			destroyPosition = 0;
			playDeathSound();
			spriteMap.visible = false;
			target.visible = false;
		}
		
		public function updateLife(value:int):void
		{
			if (life == -1)
			{
				startingLife = value;
			}
			else if (value > life)
			{
				healEmitter.emit("Heal", -8, 0);
				healEmitter.emit("Heal", 0, 5);
				healEmitter.emit("Heal", 7, 0);
			}
			life = value;
		}
		
		public function updatePath(_path:Array):void
		{
			this.path = _path.slice();
			this.MovingTo = path[0];	
			updateAngle();
		}
		
		public function setPositionFromServer(_x:Number, _y:Number, length:int):void
		{
			// If we are further than x away do something about it
			if (getDistanceFromXY(_x, _y) > 30)
			{
				this.x = _x;
				this.y = _y;
				
				setPathToLength(length);
			}
		}
		
		public function setPathToLength(length:int):void
		{
			while (this.path.length > length)
			{
				this.path = this.path.splice(0, 1);
			}
			MovingTo = null;
		}
		
		public function getDistanceFromXY(x:Number, y:Number):Number
		{
			return Math.abs(x - centerX) + Math.abs(y - centerY);
		}
		
		public function getDistance(cell:Cell):Number
		{
			return Math.abs(cell.centerX + offsetX - centerX) + Math.abs(cell.centerY + offsetY - centerY);
		}
		
		public function updateAngle():void
		{
			if (MovingTo == null || spriteMap == null || !doFacing)
				return;
				
			spriteMap.angle = FP.angle(centerX, centerY, MovingTo.centerX + offsetX, MovingTo.centerY + offsetY) + 90;	
		}
		
		public function playDeathSound():void
		{
			var i:int = Math.round(Math.random() * deathSounds.length) - 1;
			if (i < 0)
				i = deathSounds.length - 1;
				
			deathSounds[i].play();
		}
		
		public static function getIcon(type:String):Class
		{
			switch(type)
			{
				case "Armor":
					return Assets.GFX_ICONS_ARMOR;
					break;
				case "Chigen":
					return Assets.GFX_ICONS_CHIGEN;
					break;
				case "Magic":
					return Assets.GFX_ICONS_MAGIC;
					break;
				case "Quick":
					return Assets.GFX_ICONS_QUICK;
					break;
				case "Regen":
					return Assets.GFX_ICONS_REGEN;
					break;
				case "Swarm":
					return Assets.GFX_ICONS_SWARM;
					break;				
			}
			
			return null;
		}
		
		public static function getCost(type:String):int
		{
			switch(type)
			{
				case "Armor":
					return 3;
					break;
				case "Chigen":
					return 2;
					break;
				case "Magic":
					return 1;
					break;
				case "Quick":
					return 1;
					break;
				case "Regen":
					return 2;
					break;
				case "Swarm":
					return 1;
					break;				
			}
			
			return 0;
		}
	}

}