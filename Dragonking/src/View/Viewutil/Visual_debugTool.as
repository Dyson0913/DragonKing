package View.Viewutil 
{	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.Timer;
	import Interface.ViewComponentInterface;
	import View.Viewutil.AdjustTool;
	
	import View.ViewBase.*;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	
	
	/**
	 * Visual_text present way
	 * @author Dyson0913
	 */
	public class Visual_debugTool extends Sprite
	{		
		private var  _tool:MultiObject = null;
		
		
		private var  _toollsit:Array = null;
		
		public function Visual_debugTool() 
		{
			
		}
		
		public function init():void
		{
			_tool = new MultiObject();
			_tool.setContainer(this);
		}
		
		public function put_to_lsit(viewcompo:ViewComponentInterface):void
		{			
			utilFun.Log("putin no "+viewcompo.getName());
			
			//"View.ViewComponent.FinancialGraph"
			_tool.put_to_lsit(viewcompo);
			
		}
		
		public function create_tool():void
		{
			utilFun.Log("create_tool " +_toollsit);
			if ( !_toollsit )
			{
				_toollsit = [];
				utilFun.Log("_tool.ItemList.length " +_tool.ItemList.length);
				for (var i:int = 0; i < _tool.ItemList.length; i++)
				{
					var t:AdjustTool = new AdjustTool();					
					t.adjust_add(_tool.ItemList[i]);				
					t.x = i* 100 + 100;
					_toollsit.push(t);
					addChild(_toollsit[i]);					
				}
			}
			
		}
		
	
		
	}

}