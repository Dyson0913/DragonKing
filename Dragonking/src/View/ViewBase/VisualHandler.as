package View.ViewBase
{
	import Command.BetCommand;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import Model.Model;
	import Command.*;
	import Interface.ViewComponentInterface;
	import util.*;
	import Model.*;
	import View.Viewutil.*;
	
	/**
	 * handle display item how to presentation
	 * * @author hhg
	 */
	

	public class VisualHandler
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _model:Model;
		
		[Inject]
		public var _viewcom:ViewCommand;
		
		[Inject]
		public var _regular:RegularSetting;
		
		[Inject]
		public var _opration:DataOperation;

		[Inject]
		public var _debugTool:Visual_debugTool;

		public var _tool:AdjustTool;
		
		public function VisualHandler() 
		{
			
		}
		
		protected function put_to_lsit(viewcompo:MultiObject):void
		{
			if ( CONFIG::release ) return;
			
			_debugTool.put_to_lsit(viewcompo);			
		}
		
		public function debug():void
		{
			if ( CONFIG::release ) return;	
			_debugTool.create_tool();
			add(_debugTool);
		}
		
		protected function changeBG(name:String):void
		{
			utilFun.Clear_ItemChildren(GetSingleItem("_view"));
			GetSingleItem("_view").addChild(utilFun.GetClassByString(name) );
		}
 
		
		//only for same view clean item
		protected function Del(name:*):void
		{			
			_viewcom.currentViewDI.Del(name);
		}
		
		protected function Get(name:*):*
		{			
			return _viewcom.currentViewDI.getValue(name);
		}
		
		protected function GetSingleItem(name:*,idx:int = 0):*
		{
			if( _viewcom.currentViewDI .getValue(name) )
			{
				var ob:* = _viewcom.currentViewDI .getValue(name);
				return ob.ItemList[idx];
			}
			return null;
		}
		
		protected function add(item:*):void
		{
			//item ->container ->view
			GetSingleItem("_view").parent.parent.addChild(item);
		}
		
		protected function removie(item:*):void
		{
			GetSingleItem("_view").parent.parent.removeChild(item);
		}
		
		protected function prepare(name:*, ob:ViewComponentInterface, container:DisplayObjectContainer = null):*
		{
			ob.setContainer(new Sprite());
			return utilFun.prepare(name,ob , _viewcom.currentViewDI , container);
		}
		
		//========================= better way		
		protected function create(name:*,resNameArr:Array, Stick_in_container:DisplayObjectContainer = null):*
		{
			if ( Stick_in_container == null) Stick_in_container = GetSingleItem("_view").parent.parent;
			var ob:MultiObject = new MultiObject();
			ob.resList = resNameArr;
			
			var sp:Sprite = new Sprite();
			sp.name  = name;
			ob.setContainer(sp);
			return utilFun.prepare(name,ob , _viewcom.currentViewDI , Stick_in_container);
		}		
	}

}