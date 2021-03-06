package View.ViewComponent 
{
	import flash.display.MovieClip;	
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import View.GameView.gameState;
	
	/**
	 * timer present way
	 * @author ...
	 */
	public class Visual_timer  extends VisualHandler
	{
		public const Timer:String = "countDowntimer";
		public const timellight:String = "time_light";
		
		public var Waring_sec:int = 7;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _betTimer:Visual_betTimer;
		
		public function Visual_timer() 
		{
			
		}
		
		public function init():void
		{
			var countDown:MultiObject = create(Timer,[Timer]);
		   countDown.Create_(1);
		   countDown.container.x = 1148;
		   countDown.container.y = 338;
		   countDown.container.visible = false;
		   
		   
		   	var light:MultiObject = create("timellight" , [timellight], countDown.container);
		   light.Create_(1);		   
		   light.container.x = 75;
		   light.container.y = 75;		
			
			put_to_lsit(countDown);
			put_to_lsit(light);
			
			state_parse([gameState.START_BET]);
		}
		
		override public function appear():void
		{
			Get(Timer).container.visible = true;	
			var time:int = _model.getValue(modelName.REMAIN_TIME);
			utilFun.SetText(GetSingleItem(Timer)["_Text"], utilFun.Format(time, 2) );
			
			Tweener.addCaller(this, { time:time , count: time, onUpdate:TimeCount , transition:"linear" } );			
		}
		
		override public function disappear():void
		{			
			Get(Timer).container.visible = false;
			
			GetSingleItem(Timer)["_Text"].textColor = 0x0099CC;
			GetSingleItem(Timer).gotoAndStop(1);
			GetSingleItem("timellight").gotoAndStop(1);
			Tweener.pauseTweens(this);
		}
		
		private function TimeCount():void
		{			
			var time:int  = _opration.operator(modelName.REMAIN_TIME, DataOperation.sub, 1);
			if ( time < 0) return;
			if ( time <= Waring_sec ) dispatcher(new StringObject("sound_final", "sound" ) );
			
			if (time == 0) {
				//注區停止押注
				var betzone:MultiObject = Get("betzone_s");
				betzone.mousedown = null;
				betzone.mouseup = null;
				betzone.rollout = null;
				betzone.rollover = null;
				
				//送出最後一張還在計時的注單
				_betTimer.send_bet(_betTimer.current_idx);			
			}
			
			Text_setting_way(time);
		}
		
		public function Text_setting_way(time:int):void
		{
			var mc:MovieClip = GetSingleItem("timellight");
			if ( time == Waring_sec ) 
			{
				GetSingleItem(Timer)["_Text"].textColor = 0xFF0000;
				GetSingleItem(Timer).gotoAndStop(2);
				mc.gotoAndStop(2);
			}			
			
			utilFun.SetText(GetSingleItem(Timer)["_Text"], utilFun.Format(time, 2) );						
			Tweener.addCaller(mc, { time:1 , count: 36, onUpdate:TimeLight , onUpdateParams:[mc, 10 ], transition:"linear" } );		
		}
		
		private function TimeLight(mc:MovieClip,angel:int):void
		{
		   mc.rotation += angel;
		}	
		
		public function frame_setting_way(time:int):void
		{
			var arr:Array = utilFun.arrFormat(time, 2);
			if ( arr[0] == 0 ) arr[0] = 10;
			if ( arr[1] == 0 ) arr[1] = 10;
			GetSingleItem(Timer)["_num_0"].gotoAndStop(arr[0]);
			GetSingleItem(Timer)["_num_1"].gotoAndStop(arr[1]);
		}		
	
		
	}

}