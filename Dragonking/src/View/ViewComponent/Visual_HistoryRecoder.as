package View.ViewComponent 
{
	import asunit.errors.AbstractError;
	import caurina.transitions.properties.DisplayShortcuts;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * Paytable present way
	 * @author Dyson0913
	 */
	public class Visual_HistoryRecoder  extends VisualHandler
	{
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _gameinfo:Visual_Game_Info;
		
		[Inject]
		public var _text:Visual_Text;
		
		public function Visual_HistoryRecoder() 
		{
			
		}
		
		public function init():void
		{
			//歷史記錄
			var historytable:MultiObject = create("Historytable", [ResName.historytable]);
			historytable.container.x = 1290;
			historytable.container.y =  140;
			historytable.Create_(1, "Historytable");
			
			//結果歷史記錄		
			var historyball:MultiObject = create("historyball",  [ResName.historyball] ,   historytable.container);
			historyball.container.x = 10;
			historyball.container.y = 10;
			historyball.Post_CustomizedData = [6, 33, 33 ];
			historyball.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			historyball.Create_(60, "historyball");
			
			put_to_lsit(historytable);	
			put_to_lsit(historyball);			
		}
	
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{			
			Get("Historytable").container.visible = true;			
			update_history();
		}
		
		public function update_history():void
		{			
			for ( var i:int = 0; i < 60; i ++)
			{
				GetSingleItem("historyball", i).gotoAndStop(1);
				GetSingleItem("historyball", i)["_Text"].text = "";
				GetSingleItem("historyball", i)["_pair"].gotoAndStop(1);
			}
			
			var history_model:Array = _model.getValue("history_win_list");			
			Get("historyball").CustomizedData = history_model;
			Get("historyball").CustomizedFun = history_ball_Setting;
			Get("historyball").FlushObject();			
		}
		
		public function history_ball_Setting(mc:MovieClip, idx:int, data:Array):void
		{	
			//frame,point,playerPair,bankerPair			
			var info:Array =  data[idx];			
			//utilFun.Log("info "+info);
			if (info == null ) return;
			
			if( info[4] !=-1)
			{
				var str:DI = _model.getValue(modelName.SMALL_POKER_MSG);				
				mc.gotoAndStop(5);				
				mc["_Text"].text = str.getValue(info[4])
				return;
			}
			var frame:int = info[0];
			mc.gotoAndStop(frame);						
			mc["_Text"].text = info[1];
			
			if ( info[2] == 1 && info[3] == 1) mc["_pair"].gotoAndStop(4);
			else if ( info[2] == 1) mc["_pair"].gotoAndStop(3);		
			else if ( info[3] == 1) mc["_pair"].gotoAndStop(2);		
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function opencard_parse():void
		{
			Get("Historytable").container.visible = false;
		}
		
		[MessageHandler(type="Model.valueObject.ArrayObject",selector="add_history")]
		public function add_data(arr:ArrayObject):void
		{			
			var playerwin:int = arr.Value[0];		
			var bankerwin:int = arr.Value[1];		
			var playerPoint:int = arr.Value[2];
			var bankerPoint:int = arr.Value[3];	
			var isTie:int = arr.Value[4];			
			var isPlayPair:int =  arr.Value[5];
			var isbankerPair:int =  arr.Value[6];
			var bigwin:int = arr.Value[7];
			
			history_add(playerwin, bankerwin,playerPoint,bankerPoint,isTie,isPlayPair,isbankerPair,bigwin);
			
		}
		
		private function history_add(playerwin:int, bankerwin:int,playPoint:int,bankerPoint:int,isTie:int ,isPlayPair:int,isbankerPair:int,bigwin:int):void
		{
			//history recode 
			//utilFun.Log("playerwin  =  " + playerwin +" bankerwin  =  " + bankerwin);	
			//utilFun.Log("playerwin  =  " + playPoint +" bankerwin  =  " + bankerPoint);	
			var history:Array = _model.getValue("history_win_list");
			var arr:Array = [];
			if ( bigwin != -1)
			{
				//寫字大獎
				arr.push(5);
				arr.push(playPoint);					
			}
			else if ( !playerwin && !bankerwin) 
			{
				//TIE
				arr.push(4);
				arr.push(playPoint);
			}
			else
			{
				if ( playerwin == 1) 
				{
					arr.push(2);
					arr.push(playPoint);
				}
				else if ( bankerwin == 1) 
				{
					arr.push(3);
					arr.push(bankerPoint);
				}
				//else if ( isTie == 1) 
				//{
					//arr.push(4);
					//arr.push(bankerPoint);
				//}
			}
			
			arr.push(isPlayPair);
			arr.push(isbankerPair);
			arr.push(bigwin);
						
			history.push(arr);
			//utilFun.Log("history = " + arr);
			if ( history.length > 60) 
			{
				history = history.slice(6);
			}
			_model.putValue("history_win_list", history);			
			
			
		}
		
	}

}