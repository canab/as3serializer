package common.serialization
{
	import flash.utils.getDefinitionByName;

	public class Field
	{
		public var name:String;
		public var vectorClass:Class;

		public function Field(description:XML)
		{
			name = description.@name;

			var type:String = description.@type;
			if (type.indexOf("__AS3__.vec::Vector") == 0)
				vectorClass = Class(getDefinitionByName(type));
		}

		public function getValue(object:Object):Object
		{
			return object[name];
		}

		public function setValue(object:Object, value:Object):void
		{
			object[name] = value;
		}
	}
}
