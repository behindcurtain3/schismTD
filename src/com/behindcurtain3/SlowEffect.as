package com.behindcurtain3 
{
	import net.flashpunk.Entity;
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class SlowEffect extends Effect 
	{
		public function SlowEffect(e:Entity, d:Number)
		{
			super(e, d);
			
			type = "slow";
		}
		
		override public function apply():void 
		{
			if (entity is Creep)
			{
				var c:Creep = entity as Creep;
				
				c.effectedSpeed -= c.Speed * 0.5;
			}
			
			super.apply();
		}
		
	}

}