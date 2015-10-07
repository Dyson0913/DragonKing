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
			var packName:Array = [];
			for (var i:int = 0; i < packinfo.length ; i++)
			{
				utilFun.Log("my pack = " + packinfo[i]);
				packName.push(packinfo[i].message_type);
				
			}
			utilFun.Log("my packName = " + packName);
			//var sim_pack:MultiObject = create("sim_pack", [ResName.TextInfo]);	
			//sim_pack.container.x = 100;
			//sim_pack.container.y = 100
			//sim_pack.CustomizedFun = _text.textSetting;
			//sim_pack.CustomizedData = [ { size:18,align:_text.align_right,color:0xFF0000 }, packName];
			//sim_pack.Post_CustomizedData = [packinfo.length, 30, 32];
			//sim_pack.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			//sim_pack.Create_(packinfo.length, "sim_pack");
			//
			//put_to_lsit(sim_pack);
		}
		
		
		
	}

}