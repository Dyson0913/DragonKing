package View.ViewComponent 
{
	import asunit.errors.AbstractError;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
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
		
		public function Visual_Paytable() 
		{
			
		}
		
		public function init():void
		{
			
			var paytable_baridx:MultiObject = prepare("paytable_baridx", new MultiObject() ,  GetSingleItem("_view").parent.parent);
			paytable_baridx.container.x = 224;
			paytable_baridx.container.y =  169;
			paytable_baridx.Create_by_list(1, [ResName.paytable_baridx], 0, 0, 1, 0, 0, "time_");			
			//paytable_baridx.ItemList[0].gotoAndStop(2);			
			
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
			pro.Create_by_list(8, [ResName.prob_square], 0, 0, 1, 0, 35, "time_");				
			
			//歷史記錄bar 點擊呈現區
			var historytable:MultiObject = prepare("Historytable", new MultiObject() ,  GetSingleItem("_view").parent.parent);
			historytable.container.x = 1350;
			historytable.container.y =  150;
			historytable.Create_by_list(1, [ResName.historytable], 0, 0, 1, 0, 0, "time_");
			
			//結果歷史記錄
			var history_model:Array = _model.getValue("history_win_list");
			var historyball:MultiObject = prepare("historyball", new MultiObject() ,   historytable.container);
			historyball.container.x = 10;
			historyball.container.y = 10;
			historyball.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			historyball.Post_CustomizedData = [6,33,33 ];
			historyball.Create_by_list(history_model.length, history_model, 0, 0, 1, 0, 0, "histor");
			
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
			settletable_zone.CustomizedFun = _gameinfo.textSetting;
			settletable_zone.CustomizedData = [{size:24}, "莊","閒","和","莊對","閒對","特殊牌型","總計"];
			settletable_zone.Create_by_list(7, [ResName.TextInfo], 0 , 0, 1, 0, 30, "Bet_");		
			settletable_zone.container.visible = false;
			
			var opencard_bet_amount:MultiObject = prepare("opencard_bet_amount", new MultiObject(), GetSingleItem("_view").parent.parent);		
			opencard_bet_amount.container.x = 1010;
			opencard_bet_amount.container.y =  140;	
			opencard_bet_amount.CustomizedFun = _gameinfo.textSetting;
			opencard_bet_amount.CustomizedData = [{size:24,align:_gameinfo.align_right}, "","","","","","",""];
			opencard_bet_amount.Create_by_list(7, [ResName.TextInfo], 0 , 0, 1, 0, 30, "Bet_");		
			opencard_bet_amount.container.visible = false;
			
			//
			//_tool.SetControlMc(opencard_bet_amount.container);
			//_tool.SetControlMc(contractpower.ItemList[0]);
			//_tool.y = 200;
			//add(_tool);			
		}
	
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			GetSingleItem("paytable_baridx").gotoAndStop(1);
			var probpercet:MultiObject = Get("prob");
			probpercet.container.visible = false;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function opencard_parse():void
		{
			var probpercet:MultiObject = Get("prob");
			probpercet.container.visible = true;
			
			Get("Historytable").container.visible = false;
			Get("opencard_betinfo").container.visible = true;
			
			
			//Get("opencard_bet_amount").container.visible = true;			
			Get("opencard_bet_amount").container.visible = true;			
			//utilFun.Clear_ItemChildren(Get("opencard_bet_amount"));
			
			//var amount:Array = _betCommand.get_my_bet_info("amount");	
			var mylist:Array = ["0", "0", "0", "0", "0", "0", "0"];
			//for (var i:int = 0; i < 6; i++)
			//{
				//if ( amount[i] != undefined)	mylist.push(amount[i])
				//else mylist.push(0);
			//}
			//
			//mylist.push( _betCommand.all_betzone_totoal());
			
			var font:Array = [{size:24,align:_gameinfo.align_right}];
			font = font.concat(mylist);
			Get("opencard_bet_amount").CustomizedData = font;
			Get("opencard_bet_amount").Create_by_list(7, [ResName.TextInfo], 0 , 0, 1, 0, 30, "Bet_");	
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function timer_hide():void
		{
			_model.putValue("percent_prob",[0,0,0,0,0,0,0,0]);						
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_parse():void
		{
			var probpercet:MultiObject = Get("prob");
			probpercet.container.visible = false;
			
			//Get("Historytable").container.visible = false;
		}
		
		
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="caculate_prob")]
		public function prob_percentupdate():void
		{			
			var probpercet:MultiObject = Get("prob");
			probpercet.container.visible = true;
			var ln:int = probpercet.ItemList.length;
			
			var percentlist:Array = _model.getValue("percent_prob");
			var hiest:int = utilFun.Random(ln);			
			for ( var i:int = 0; i < ln; i ++ )
			{				
				var per:int = utilFun.Random(50);
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
		
		public function win_frame_hint(wintype:String):void
		{
			if ( wintype == "") return ;
			if (wintype ==  "WSWin" || wintype == "WSBWNormalWin")  return;
			
			var y:int = 0;			
			if (wintype == "WSBWStraight") y = 161;
			if ( wintype == "WSBWFlush") y = 128;
			if (wintype == "WSBWFullHouse") y = 96;
			if ( wintype == "WSBWFourOfAKind")y = 64;
			if ( wintype == "WSBWStraightFlush") y = 32;
			if ( wintype == "WSBWRoyalFlush") y=0;	
			
			
			
			GetSingleItem("paytable_baridx").y = y;
			_regular.Twinkle(GetSingleItem("paytable_baridx"), 5, 15, 2);
			
		}
		
		public function history_sence(e:Event, idx:int):Boolean
		{			
			var betzone:MultiObject = Get("history_select_item_bar");			
			var mc:MovieClip = betzone.ItemList[idx];
			mc.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false));			
			return true;
		}
		
		//public function historySelect(e:Event, idx:int):Boolean
		//{			
			//var betzone:MultiObject = Get("history_select_item_bar");						
			//betzone.exclusive(idx, 1);
			//
			//var hisoty_show_info:MultiObject = Get("Historytable");		
			//hisoty_show_info.ItemList[0].gotoAndStop(idx+1);
			//hisoty_show_info.customized();
			//
			//history_display(idx + 1);
			//return true;
			//
		//}
		
		public function history_display(select:int):void
		{
			var history_model:Array = _model.getValue("history_win_list");			
			Get("historyball").Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			Get("historyball").Post_CustomizedData = [6, 33, 33 ];
			Get("historyball").Create_by_list(history_model.length, history_model, 0, 0, 1, 0, 0, "histor");
			Get("historyball").customized();
		}
		
		//public function history_display(select:int):void
		//{
			//if ( select == 1)
			//{
				//Get("history_Pai_list").container.visible = false;
				//Get("history_banker_Pai_list").container.visible = false;
				//
				//var history_model:Array = _model.getValue("history_win_list");
				//Get("historyball").container.visible = true;
				//Get("historyball").Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
				//Get("historyball").Post_CustomizedData = [6, -33, 33 ];
				//Get("historyball").Create_by_list(history_model.length, history_model, 0, 0, 1, 0, 0, "histor");
				//Get("historyball").customized();
			//}
			//else if (select == 2)
			//{
				//Get("historyball").container.visible = false;
				//
				//var historyPai_model:Array = _model.getValue("history_Play_Pai_list");
				//Get("history_Pai_list").container.visible = true;
				//Get("history_Pai_list").CustomizedFun = sprite_idx_setting_player;			
				//Get("history_Pai_list").CustomizedData = historyPai_model;				
				//Get("history_Pai_list").Create_by_bitmap(historyPai_model.length, utilFun.Getbitmap("poker_atlas"), 0, 0, historyPai_model.length, 22, 25, "o_");				
				//
				//
				//var historyPai_banker_model:Array = _model.getValue("history_banker_Pai_list");
				//Get("history_banker_Pai_list").container.visible = true;			
				//Get("history_banker_Pai_list").CustomizedFun = sprite_idx_setting_banker;			
				//Get("history_banker_Pai_list").CustomizedData = historyPai_banker_model;				
				//Get("history_banker_Pai_list").Create_by_bitmap(historyPai_banker_model.length, utilFun.Getbitmap("poker_atlas"), 0, 0, historyPai_banker_model.length, 22, 25, "o_");		
			//
			//}
			//
		//}		
		
		//滑入bar 效果
		//public function paytable_sence(e:Event, idx:int):Boolean
		//{			
			//if ( idx == 0)
			//{
				//GetSingleItem("paytable").gotoAndStop(idx+1);
				//Tweener.addTween(GetSingleItem("paytable_colorbar"), { x:0,time:0.5, transition:"easeOutCubic"} );
			//}
			//else if (idx  == 1)
			//{
				//GetSingleItem("paytable").gotoAndStop(idx+1);
				//Tweener.addTween(GetSingleItem("paytable_colorbar"), { x:220,time:0.5, transition:"easeOutCubic"} );
			//}
			//return false;
		//}		
		
	}

}