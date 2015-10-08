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
	public class Visual_Paytable  extends VisualHandler
	{
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _gameinfo:Visual_Game_Info;
		
		[Inject]
		public var _text:Visual_Text;
		
		public function Visual_Paytable() 
		{
			
		}
		
		public function init():void
		{
			
			//賠率提示
			var paytable:MultiObject = create("paytable", [ResName.emptymc]);
			paytable.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);			
			paytable.container.x = 220;
			paytable.container.y =  134;
			paytable.Create_(1, "paytable");
			
			//歷史記錄bar 選項底圖
			var pro:MultiObject = create("prob",  [ResName.prob_square], paytable.container);			
			pro.container.x = 157;
			pro.container.y =  39;
			pro.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			pro.Post_CustomizedData = [6, 50, 50];
			pro.Create_(6, "prob");
			
			//歷史記錄bar 點擊呈現區
			var historytable:MultiObject = create("Historytable", [ResName.historytable]);
			historytable.container.x = 1350;
			historytable.container.y =  150;
			historytable.Create_(1, "Historytable");
			
			//結果歷史記錄		
			var historyball:MultiObject = create("historyball",  [ResName.historyball] ,   historytable.container);
			historyball.container.x = 10;
			historyball.container.y = 10;
			historyball.Post_CustomizedData = [6, 33, 33 ];
			historyball.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			historyball.Create_(60, "historyball");
					
			
			put_to_lsit(paytable);	
			put_to_lsit(pro);	
			put_to_lsit(historytable);	
			put_to_lsit(historyball);			
		}
	
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{			
			
			Get("prob").container.visible = false;
			Get("Historytable").container.visible = true;
			
			update_history();
		}
		
		public function update_history():void
		{
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
			Get("prob").container.visible = true;			
			Get("Historytable").container.visible = false;
			
			var zero:Array = utilFun.Random_N(0, 6);
			zero.push(-1);
			_model.putValue("percent_prob",zero);		
			//prob_percentupdate();
			
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_parse():void
		{			
			Get("prob").container.visible = false;		
		}
		
		
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="caculate_prob")]
		public function prob_percentupdate():void
		{			
			dispatcher(new StringObject("sound_prob","sound" ) );
			var percentlist:Array = _model.getValue("percent_prob");	
			var ln:int = percentlist.length - 1;				
			var hiest:int = percentlist[percentlist.length-1];			
			for ( var i:int = 0; i < ln; i ++ )
			{				
				var per:int = percentlist[i];
				var gowithd:int =  125 * (per /100);
				Tweener.addTween(GetSingleItem("prob", i)["_mask"], { width:gowithd, time:1, onUpdate:this.percent, onUpdateParams:[GetSingleItem("prob", i), per, 5,hiest == i] } );
			}
			
		}
		
		public function percent(mc:MovieClip,per:int,start:int ,hist:Boolean ):void
		{
			
			if ( !hist) 
			{
				mc["_Text"].text = "";				
				mc["_probBar"].gotoAndStop(1);
				return;
			}			
			if ( mc["_Text"].text == "") mc["_Text"].text = "1";
			
			mc["_probBar"].gotoAndStop(2);
			
			var p:int = (parseInt( mc["_Text"].text) +start );
			if (p >= per) p = per;
			
			mc["_Text"].text = p.toString();// + "%";
			mc["_Text"].textColor = 0xFFDD00;
			
			//position follow
			//var po:Number = mc["_mask"].x + mc["_mask"].width;
			//mc["_Text"].x = po;
		}
		
		[MessageHandler(type = "Model.valueObject.StringObject",selector="winstr_hint")]
		public function win_frame_hint(winstr:StringObject):void
		{
			var wintype:String = winstr.Value;
			utilFun.Log("winst = " + wintype);
			
			if ( wintype == "") return ;
			if (wintype ==  "WSWin" || wintype == "WSBWNormalWin")  return;
			if (wintype ==  "WSBWOnePairBig")  return;
			
			var y:int = 0;			
			//if ( wintype == "WSBWTwoPair") y = 7;
			//if ( wintype == "WSBWTripple") y = 6;
			if (wintype == "WSBWStraight") y = 5;
			if ( wintype == "WSBWFlush") y = 4;
			if (wintype == "WSBWFullHouse") y = 3;
			if ( wintype == "WSBWFourOfAKind")y = 2;
			if ( wintype == "WSBWStraightFlush") y = 1;
			if ( wintype == "WSBWRoyalFlush") y = 0;			
			
			utilFun.Log("GetSingleItem =" + GetSingleItem("pay_text"));			
			
			GetSingleItem("pay_text",y).getChildByName("Dy_Text").textColor = 0xFFFF00;			
			GetSingleItem("pay_mark",y).getChildByName("Dy_Text").textColor = 0xFFFF00;			
			GetSingleItem("pay_odd",y).getChildByName("Dy_Text").textColor = 0xFFFF00;			
	
		}
		
		
	}

}