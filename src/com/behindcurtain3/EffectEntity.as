package com.behindcurtain3 
{
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class EffectEntity extends Entity 
	{
		public var effects:Array = new Array();
		
		public function applyEffects():void
		{
			
			
			for (var i:int = effects.length - 1; i >= 0; i--)
			{
				effects[i].apply();
				
				if (effects[i].finished())
				{
					effects.splice(i, 1);
				}
			}
		}

		public function addEffect(e:Effect):void
		{
			effects.push(e);
		}
		
		public function EffectEntity() 
		{
		}
		
	}

}