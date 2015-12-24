package View.ViewComponent 
{			
	import flash.display.MovieClip;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import View.GameView.gameState;
	
	/**
	 * Paytable present way
	 * @author Dyson0913
	 */
	public class Visual_HistoryRecoder  extends VisualHandler
	{
		public const historytable:String = "history_table";
		public const historyball:String = "history_ball";
		
		public function Visual_HistoryRecoder() 
		{
			
		}
		
		public function init():void
		{
			//歷史記錄
			var historytable:MultiObject = create("Historytable", [historytable]);
			historytable.container.x = 1290;
			historytable.container.y =  140;
			historytable.Create_(1);
			
			//結果歷史記錄		
			var historyball:MultiObject = create("historyball",  [historyball] ,   historytable.container);
			historyball.container.x = 6.5;
			historyball.container.y = 8.7;
			historyball.Post_CustomizedData = [6, 37.8, 37.9 ];
			historyball.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			historyball.Create_(60);
			
			put_to_lsit(historytable);	
			put_to_lsit(historyball);
			
			state_parse([gameState.NEW_ROUND, gameState.START_BET]);
		}
		
		override public function appear():void
		{
			Get("Historytable").container.visible = true;
			update_history();
		}
		
		override public function disappear():void
		{
			Get("Historytable").container.visible = false;	
		}		
		
		public function update_history():void
		{			
			for ( var i:int = 0; i < 60; i ++)
			{
				GetSingleItem("historyball", i).gotoAndStop(1);
				GetSingleItem("historyball", i)["_Text"].text = "";
				GetSingleItem("historyball", i)["_Special"].text = "";
				GetSingleItem("historyball", i)["_pair"].gotoAndStop(1);
			}
			
			var history_model:Array = _model.getValue("history_list");			
			Get("historyball").CustomizedData = history_model;
			Get("historyball").CustomizedFun = history_ball_Setting;
			Get("historyball").FlushObject();			
		}
		
		//{"player_pair": false, "winner": "BetBWPlayer", "banker_pair": false, "point": 4}
		public function history_ball_Setting(mc:MovieClip, idx:int, data:Array):void
		{		
			//2,player  3,banker,4 tie ,5 sp
			var info:Object = data[idx];
			
			if ( _opration.getMappingValue(modelName.BIG_POKER_MSG,  info.winner) >= 2	)
			{
				var str:DI = _model.getValue(modelName.HIS_SHORT_MSG);	
				mc.gotoAndStop(5);
				mc["_Special"].text = str.getValue( info.winner);				
				return;
			}
			
			var frame:int = 0;
			if ( info.winner == "BetBWPlayer") frame = 2;			
			if ( info.winner == "BetBWBanker") frame = 3;
			if ( info.winner == "None") frame = 4;			
			mc.gotoAndStop(frame);
			mc["_Text"].text =  info.point;			
			
			if( info.banker_pair && info.player_pair) mc["_pair"].gotoAndStop(4);
			else if( info.banker_pair) mc["_pair"].gotoAndStop(2);
			else if ( info.player_pair) mc["_pair"].gotoAndStop(3);
		}
	}

}