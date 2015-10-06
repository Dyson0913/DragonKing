package View.Viewutil 
{	
	import flash.display.Sprite;
	import flash.events.Event;
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
	import Res.ResName;
	
	/**
	 * replay package present way
	 * @author Dyson0913
	 */
	public class Visual_package_replayer extends VisualHandler
	{
		[Inject]
		public var _text:Visual_Text;
		
	
		
		public function Visual_package_replayer() 
		{
			
		}
		
		public function init():void
		{
		
		}
		
		[MessageHandler(type="Model.valueObject.ArrayObject",selector="replay_config_complete")]		
		public function lsit(replayinfo:ArrayObject):void
		{	
			//確認為自己要求的mission
				//utilFun.Log("replayinfo.Value[0]"+replayinfo.Value[0]);
				//utilFun.Log("mission_id()"+mission_id());
			if ( replayinfo.Value[0] != mission_id()) return;
				
			
			utilFun.Log("parse");
			var jsonob:Object =  replayinfo.Value[1];
			var packinfo:Array = jsonob.packlist;
			//for (var i:int = 0; i < packinfo.length ; i++)
			//{
				//utilFun.Log("pack = "+ packinfo[i]);
			//}
			
			
		}
		
		
		
	}

}