package Model.CommonModel 
{	
	import Command.*;
	import Model.*;
	
	import util.*;
	import View.GameView.*;
	/**
	 * model response to 
	 * ---packing visual res & object model 
	 * make object easy to reuse and take to other pjoect
	 * @author Dyson0913
	 */
	public class ModelBase 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _model:Model;
		
		[Inject]
		public var _opration:DataOperation;
		
		protected var _ResName:String;		
		public function get ResName():String
		{
			return _ResName;
		}
		
		protected var _exTraResName:Array;	
		
		protected var _ModelTag:String;		
		public function get ModelTag():String
		{
			return _ModelTag;
		}
		
		public function exTraResName(value:int):String
		{
			return _exTraResName[value];
		}
		
		protected var _SetPropertyEvent:Array;
		
		public function PropertyEvent(value:int):String
		{
			return _SetPropertyEvent[value];
		}
		
		protected var _UpdateEvent:Array;
		
		public function UpdateEvent(value:int):String
		{
			return _UpdateEvent[value];
		}
		
		public function ModelBase() 
		{
			
		}
		
		
		
	}

}