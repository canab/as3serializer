package common.serialization
{
	import flash.utils.Dictionary;

	public class ObjectPool
	{
		private var _dictionary:Dictionary = new Dictionary();
		private var _array:Array;

		public function ObjectPool()
		{
		}

		public function getObject(type:Class):Object
		{
			_array = _dictionary[type];

			if (!_array)
			{
				_array = [];
				_dictionary[type] = _array;
			}

			if (_array.length > 0)
				return _array.pop();
			else
				return new type();
		}

		public function putObject(type:Class, object:Object):void
		{
			_array = _dictionary[type];
			_array.push(object);
		}
	}
}
