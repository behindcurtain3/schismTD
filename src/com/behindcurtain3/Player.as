package com.behindcurtain3 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Player extends MoveableEntity
	{			
		// Sounds
		//private var shoot:Sfx = new Sfx(SFX_FIRE);
		
		public function Player(_x:int, _y:int)
		{			
			super(_x, _y);
			
			layer = 2;
			
			// Setup collisions
			type = "player";
			setHitbox(16, 16);
			collidable = true;
			
			// Setup emitters
			particleEmitter = new Emitter(new BitmapData(1, 1, false, 0xFFFFFF), 1, 1);
			particleEmitter.newType("death", [0]);
			particleEmitter.relative = false;
			particleEmitter.setMotion("death", 100, 45, 2, 20, -20, -1.5, Ease.quartOut);
			particleEmitter.setAlpha("death", 1, 0.5);
			particleEmitter.setColor("death", 0xFF0000, 0xBB5555, Ease.expoIn);
			
			// Setup gfx
			spriteMap = new Spritemap(Assets.SKELETON_GFX, 16, 16);
			spriteMap.add("walk", [0, 2, 1, 2], 4, true);
			spriteMap.add("stand", [2]);
			spriteMap.play("stand");
			
			graphic = new Graphiclist(spriteMap, particleEmitter);
			layer = 8;
			
			// Setup stats
			health = 5;
			speed = 64;
			direction = Direction.S;
			
			// Input
			Input.define("shoot", Key.SPACE);
			Input.define("up", Key.W, Key.UP);
			Input.define("down", Key.S, Key.DOWN);
			Input.define("left", Key.A, Key.LEFT);
			Input.define("right", Key.D, Key.RIGHT);
			Input.define("kill", Key.ESCAPE);
		}
		
		override public function update():void
		{
			velocity.x = 0;
			velocity.y = 0;
				
			if (collidable)
			{
				if (Input.check("kill"))
					health = 0;
				
				if (Input.check("left"))
					velocity.x = -speed * FP.elapsed;
				if (Input.check("right"))
					velocity.x = speed * FP.elapsed;
				if (Input.check("up"))
					velocity.y = -speed * FP.elapsed;
				if (Input.check("down"))
					velocity.y = speed * FP.elapsed;
				
				updateDirection();
				updateCollisions();
				
				if (Input.pressed("shoot")) 
				{
					if (this.world != null)
					{
						// Fire the projectile in the directoin we are facing
						var cx:int = x + width / 2;
						var cy:int = y + height / 2;
						var p:Point = Util.getPositionOnCirlce(cx, cy, FP.width, Direction.getAngleFromDir(direction));
						this.world.add(new Bullet(cx, cy, p));
					}
				}
				
				if (health <= 0)
				{
					// Player has died
					collidable = false;
					spriteMap.visible = false;
					
					for (var i:uint = 0; i < PARTICLE_COUNT; i++)
					{
						particleEmitter.emit("death", x + width/2, y + height/2);
					}
				}
			}
			else
			{
				if (particleEmitter.particleCount == 0)
				{
					if(this.world != null)
						this.world.remove(this);
				}
			}
				
			super.update();
		}
		
		private function updateDirection():void
		{
			if (velocity.x == 0 && velocity.y == 0)
			{
				spriteMap.play("stand");
				return;
			}
			else
			{
				spriteMap.play("walk");
			}
				
			var horz:int = FP.sign(velocity.x);
			var vert:int = FP.sign(velocity.y);
			// 8 options, check each with the complicated ones first
			if (horz > 0 && vert < 0)
				direction = Direction.NE;
			else if (horz > 0 && vert > 0)
				direction = Direction.SE;
			else if (horz < 0 && vert > 0)
				direction = Direction.SW;
			else if (horz < 0 && vert < 0)
				direction = Direction.NW;
			else if (horz > 0 && velocity.y == 0)
				direction = Direction.E;
			else if (horz < 0 && velocity.y == 0)
				direction = Direction.W;
			else if (vert < 0 && velocity.x == 0)
				direction = Direction.N;
			else
				direction = Direction.S;
			
		}
		
		private function updateCollisions():void
		{
			x += velocity.x;
			if (collide("scenery", x, y))
			{
				if (velocity.x != 0)
				{
					if (FP.sign(velocity.x) > 0)
					{
						// Moving right
						velocity.x = 0;
						x = Math.floor( x / 4 ) * 4;
					}
					else
					{
						velocity.x = 0;
						x = Math.floor( x / 4 ) * 4 + 4;
					}
				}
			}
			y += velocity.y;
			if (collide("scenery", x, y))
			{
				if (velocity.y != 0)
				{
					if (FP.sign(velocity.y) > 0)
					{
						// Moving down
						velocity.y = 0;
						y = Math.floor( y / 4 ) * 4;
					}
					else
					{
						velocity.y = 0;
						y = Math.floor( y / 4 ) * 4 + 4;
					}
				}
			}
		}
		
	}

}