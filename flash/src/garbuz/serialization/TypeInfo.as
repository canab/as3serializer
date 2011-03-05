package garbuz.serialization
{
	import flash.utils.getDefinitionByName;

	internal class TypeInfo
	{
		public var index:int;
		public var className:String;
		public var classRef:Class;
		public var properties:Array;
		public var initialized:Boolean = false;

		public function TypeInfo(index:int, className:String)
		{
			this.index = index;
			this.className = className;
		}

		public function initialize():void
		{
			classRef = Class(getDefinitionByName(className));
			resolveProperties();
			initialized = true;
		}

		private function resolveProperties():void
		{
		}
	}
}
