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
			var paytable:MultiObject = prepare("paytable", new MultiObject() ,  GetSingleItem("_view").parent.parent);
			paytable.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);			
			paytable.container.x = 220;
			paytable.container.y =  134;
			paytable.Create_by_list(1, [ResName.emptymc], 0, 0, 1, 0, 0, "time_");
			
			//歷史記錄bar 選項底圖
			var pro:MultiObject = prepare("prob", new MultiObject() , paytable.container);			
			pro.container.x = 157;
			pro.container.y =  42;
			pro.Create_by_list(6, [ResName.prob_square], 0, 0, 1, 0, 50, "time_");				
			
			//歷史記錄bar 點擊呈現區
			var historytable:MultiObject = prepare("Historytable", new MultiObject() ,  GetSingleItem("_view").parent.parent);
			historytable.container.x = 1350;
			historytable.container.y =  150;
			historytable.Create_by_list(1, [ResName.historytable], 0, 0, 1, 0, 0, "time_");
			
			//結果歷史記錄		
			var historyball:MultiObject = prepare("historyball", new MultiObject() ,   historytable.container);
			historyball.container.x = 10;
			historyball.container.y = 10;
			historyball.Post_CustomizedData = [6, 33, 33 ];
			historyball.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			historyball.Create_by_list(60, [ResName.historyball], 0, 0, 1, 0, 0, "histor");
			
			//集氣吧
			var powerbar:MultiObject = prepare("powerbar", new MultiObject() ,   GetSingleItem("_view").parent.parent);
			powerbar.container.x = 1358;
			powerbar.container.y = 370;			
			powerbar.Create_by_list(1, [ResName.powerbar], 0, 0, 1, 0, 0, "histor");			
			
			var powerbar_3:MultiObject = prepare("powerbar_3", new MultiObject() ,  powerbar.container);
			powerbar_3.container.x = 2.85;
			powerbar_3.container.y = 21;			
			powerbar_3.Create_by_list(5, [ResName.power_bar3], 0, 0, 5, 65, 0, "histor");		
						
			var powerbar_2pair:MultiObject = prepare("power_bar_2pair", new MultiObject() ,  powerbar.container);
			powerbar_2pair.container.x = 3.35;
			powerbar_2pair.container.y = 64.5;			
			powerbar_2pair.Create_by_list(5, [ResName.power_bar_2pair], 0, 0, 5, 64.5, 0, "histor");
			
			//next grid 65
			var contractpower:MultiObject = prepare("contractpower", new MultiObject() ,  powerbar.container);
			contractpower.container.x = -270;
			contractpower.container.y = -210;			
			contractpower.Create_by_list(1, [ResName.contractpower], 0, 0, 1, 0, 45, "histor");			
			
			
			var settletable_zone:MultiObject = prepare("opencard_betinfo", new MultiObject(), GetSingleItem("_view").parent.parent);		
			settletable_zone.container.x = 1380;
			settletable_zone.container.y =  140;	
			settletable_zone.CustomizedFun = _text.textSetting;
			settletable_zone.CustomizedData = [{size:24}, "莊","閒","和","莊對","閒對","特殊牌型","總計"];
			settletable_zone.Create_by_list(7, [ResName.TextInfo], 0 , 0, 1, 0, 30, "Bet_");		
			settletable_zone.container.visible = false;
			
			var opencard_bet_amount:MultiObject = prepare("opencard_bet_amount", new MultiObject(), GetSingleItem("_view").parent.parent);		
			opencard_bet_amount.CustomizedFun = _text.textSetting;
			opencard_bet_amount.container.x = 1010;
			opencard_bet_amount.container.y =  140;	
						
			//
			//_tool.SetControlMc(paytable_baridx.container);
			//_tool.SetControlMc(contractpower.ItemList[0]);
			//_tool.y = 200;
			//add(_tool);			
		}
	
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{			
			
			Get("prob").container.visible = false;
			Get("Historytable").container.visible = true;
			
			Get("opencard_betinfo").container.visible = false;
			Get("opencard_bet_amount").container.visible = false;				
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
			
			//下注單
			Get("opencard_betinfo").container.visible = true;
			Get("opencard_bet_amount").container.visible = true;									
			var mylist:Array = [];// ["0", "0", "0", "0", "0", "0", "0", "0"];
			var zone:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX);
			var maping:DI = _model.getValue("idx_to_result_idx");
			for ( var i:int = 0; i < zone.length; i++)
			{				
				var map:int = maping.getValue(zone[i]);				 
				mylist.splice(map, 0,_betCommand.get_total_bet(zone[i]));
			}			
			
			mylist.push(_betCommand.all_betzone_totoal());		
			var font:Array = [{size:24,align:_gameinfo.align_right,color:0xFF0000}];
			font = font.concat(mylist);
			//utilFun.Log("font = "+font);
			Get("opencard_bet_amount").CustomizedData = font;
			Get("opencard_bet_amount").Create_by_list(mylist.length, [ResName.TextInfo], 0 , 0, 1, 0, 30, "Bet_");	
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function hide():void
		{
			var zero:Array = utilFun.Random_N(0, 6);
			zero.push(-1);
			_model.putValue("percent_prob",zero);		
			prob_percentupdate();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_parse():void
		{			
			Get("prob").container.visible = false;
			
			//Get("Historytable").container.visible = false;
		}
		
		
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="caculate_prob")]
		public function prob_percentupdate():void
		{			
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