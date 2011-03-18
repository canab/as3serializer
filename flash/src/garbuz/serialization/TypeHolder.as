package garbuz.serialization
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	internal final class TypeHolder
	{
		public var index:int;
		public var className:String;
		public var classRef:Class;
		public var fields:Vector.<Field> = new <Field>[];
		public var initialized:Boolean = false;

		public function TypeHolder(index:int, className:String)
		{
			this.index = index;
			this.className = className;
		}

		public function initialize():void
		{
			classRef = Class(getDefinitionByName(className));
			resolveFields();
			initialized = true;
		}

		private function resolveFields():void
		{
			var description:XML = describeType(classRef);
			var variables:XMLList = description.factory.variable;

			for each (var variable:XML in variables)
			{
				fields.push(new Field(variable));
			}

			fields.sort(fieldSorter)
		}

		private function fieldSorter(field1:Field, field2:Field):int
		{
			if (field1.name < field2.name)
				return -1;
			else if (field1.name > field2.name)
				return 1;
			else
				return 0;
		}
	}
}
