package schism.effects 
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
		public var duration:Number;
		protected var durationPosition:Number;
		
		
		public function Effect(e:Entity, d:Number) 
		{
			entity = e;
			duration = d;
			durationPosition = 0;
		}
		
		public function apply():void
		{
			durationPosition += FP.elapsed;
		}
		
		public function finished():Boolean
		{
			return durationPosition >= duration;
		}
		
	}

}