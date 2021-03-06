package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;
	import flash.utils.Timer;
	import org.spicefactory.parsley.core.view.lifecycle.AutoremoveLifecycle;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import View.GameView.gameState;

	
	/**
	 * Visual_Game_Info present way
	 * @author Dyson0913
	 */
	public class Visual_Game_Info  extends VisualHandler
	{
		public const betlimit:String = "bet_limit";
		public const betstaticarrow:String = "betstatic_arrow";
		
		public const realtimeinfo:String = "realtime_info";
		public const betstaticarrow_right:String = "betstatic_arrow_right";
		
		public function Visual_Game_Info() 
		{
			
		}
		
		public function init():void
		{			
			var bet:MultiObject = create("game_title_info" ,[ResName.TextInfo]);
			bet.CustomizedFun = _text.textSetting;
			bet.CustomizedData = [{size:22,color:0xCCCCCC}, "局號:"];
			bet.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			bet.Post_CustomizedData = [[0,0]];
			bet.Create_(bet.CustomizedData.length - 1);
			bet.container.x = 292;
			bet.container.y = 88;
			
			var game_info_data:MultiObject = create("game_title_info_data", [ResName.TextInfo]);			
			game_info_data.CustomizedFun = _text.textSetting;
			game_info_data.CustomizedData = [{size:18,color:0xCCCCCC},_model.getValue("game_round").toString()];
			game_info_data.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			game_info_data.Post_CustomizedData = [[0,0]];
			game_info_data.Create_(1);
			game_info_data.container.x = 372;
			game_info_data.container.y = 90;
			
			var betlimit:MultiObject = create("betlimit",  [betlimit, betstaticarrow]);
			betlimit.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 0]);
			betlimit.mousedown = local;
			betlimit.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			betlimit.Post_CustomizedData = [[0,0],[194,164]];
			betlimit.container.x = -12;
			betlimit.container.y = 120;	
			betlimit.Create_(2);
			
			var realtimeinfo:MultiObject = create("realtimeinfo", [realtimeinfo, betstaticarrow_right]);	
			realtimeinfo.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 0]);
			realtimeinfo.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			realtimeinfo.Post_CustomizedData = [[0, 0], [7, 164]];
			realtimeinfo.mousedown = local_reverse;
			realtimeinfo.container.x = 1719;
			realtimeinfo.container.y = 120;	
			realtimeinfo.Create_(2);	
			
			put_to_lsit(bet);
			put_to_lsit(game_info_data);
			put_to_lsit(betlimit);
			put_to_lsit(realtimeinfo);
			
			utilFun.SetTime(triger, 2);
			
			state_parse([gameState.NEW_ROUND]);
		}
		
		override public function appear():void
		{
			Get("betlimit").container.visible = true;
			Get("realtimeinfo").container.visible = true;
			
			var round_code:int = _model.getValue("game_round");			
			GetSingleItem("game_title_info_data", 0).getChildByName("Dy_Text").text = round_code.toString();
		}
		
		override public function disappear():void
		{
			Get("betlimit").container.visible = false;
			Get("realtimeinfo").container.visible = false;
		}	
		
		private function triger():void
		{
			local_reverse(new MouseEvent(MouseEvent.CLICK, true, false), 0);
			local(new MouseEvent(MouseEvent.CLICK, true, false), 0);
		}
		
		public function local_reverse(e:Event, idx:int):Boolean
		{
			if( GetSingleItem("realtimeinfo",1).currentFrame == 1)
			{				
				GetSingleItem("realtimeinfo", 1).gotoAndStop(2);						
				_regular.moveTo(Get("realtimeinfo").container,1883,Get("realtimeinfo").container.y, 1, 0, shide);						
			}
			else
			{				
				GetSingleItem("realtimeinfo").visible =  true;				
				GetSingleItem("realtimeinfo", 1).gotoAndStop(1);			
				_regular.moveTo(Get("realtimeinfo").container, 1719, Get("realtimeinfo").container.y, 1, 0, null);
			}
			return false;
		}
		
		public function shide():void
		{
			GetSingleItem("realtimeinfo").visible = false;
		}
		
		public function local(e:Event, idx:int):Boolean
		{
			if( GetSingleItem("betlimit",1).currentFrame == 1)
			{				
				GetSingleItem("betlimit", 1).gotoAndStop(2);						
				_regular.moveTo(Get("betlimit").container,-195,Get("betlimit").container.y, 1, 0, hide);						
			}
			else
			{				
				GetSingleItem("betlimit").visible =  true;				
				GetSingleItem("betlimit", 1).gotoAndStop(1);			
				_regular.moveTo(Get("betlimit").container, -12, Get("betlimit").container.y, 1, 0, null);
			}
			return false;
		}
		
		public function hide():void
		{
			GetSingleItem("betlimit").visible = false;
		}
		
		
		
	}

}