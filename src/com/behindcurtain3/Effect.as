package com.behindcurtain3 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Justin Brown
	 */
	public class Effect 
	{
		public var type:String = "base";
		public var entity:Entity;
		public var finished:Boolean = false;
		public var duration:Number;
		protected var durationPosition:Number;
		
		
		public function Effect(e:Entity, d:Number) 
		{
			entity = e;
			duration = d;
		}
		
		public function apply():void
		{
			durationPosition += FP.elapsed;
		}
		
	}

}