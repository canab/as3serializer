package garbuz.serialization
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	internal final class TypeHolder
	{
		public var index:int;
		public var className:String;
		public var classRef:Class;
		public var vectorClassRef:Class;
		public var properties:Array = [];
		public var initialized:Boolean = false;

		public function TypeHolder(index:int, className:String)
		{
			this.index = index;
			this.className = className;
		}

		public function initialize():void
		{
			classRef = Class(getDefinitionByName(className));
			vectorClassRef = Class(getDefinitionByName("__AS3__.vec::Vector.<" + className + ">"));
			resolveProperties();
			initialized = true;
		}

		private function resolveProperties():void
		{
			var description:XML = describeType(classRef);
			var variables:XMLList = description.factory.variable;

			for each (var variable:XML in variables)
			{
				var property:String = variable.@name;
				properties.push(property);
			}

			properties.sort();
		}
	}
}
