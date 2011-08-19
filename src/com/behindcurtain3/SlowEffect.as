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
			super.apply();
			
			if (entity is Creep)
			{
				var c:Creep = entity as Creep;
			
				if(!finished())
					c.effectedSpeed -= c.Speed * 0.5;
			}
		}
		
	}

}