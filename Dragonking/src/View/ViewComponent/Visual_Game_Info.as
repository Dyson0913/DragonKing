package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;
	import flash.utils.Timer;
	import Model.CommonModel.Model_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import View.ViewBase.Visual_Text;
	
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	
	
	/**
	 * Visual_Game_Info present way
	 * @author Dyson0913
	 */
	public class Visual_Game_Info  extends VisualHandler
	{
		[Inject]
		public var _text:Visual_Text = new Visual_Text();
		
		[Inject]
		public var myModel:Model_Text;
		
		public function Visual_Game_Info() 
		{
			
		}
		
		public function init():void
		{			
			var bet:MultiObject = create("game_title_info", [myModel.ResName]);
			bet.CustomizedFun = _text.textSetting;
			bet.CustomizedData = [{size:22,color:0xCCCCCC}, "局號:"];
			bet.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			bet.Post_CustomizedData = [[0, 0], [1020, 0], [1130, 0], [1300, 0]];
			bet.Create(bet.CustomizedData.length-1,"game_title_info");
			bet.container.x = 292;
			bet.container.y = 88;
			
			var game_info_data:MultiObject = create("game_title_info_data",[myModel.ResName]);	
			game_info_data.CustomizedFun = _text.textSetting;
			game_info_data.CustomizedData = [{size:18,color:0xCCCCCC},_model.getValue("game_round").toString(), "", ""];
			game_info_data.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			game_info_data.Post_CustomizedData = [[0,0],[310,0],[1230,0],[1400,0]];
			game_info_data.Create(1, "game_title_info_data");
			game_info_data.container.x = 372;
			game_info_data.container.y = 90;
			
			
			//手寫賠率表
			var paytext:DI = _model.getValue(modelName.BIG_POKER_TEXT );
			var bet_text:MultiObject = create("pay_text", [myModel.ResName]);
			bet_text.CustomizedFun = _text.textSetting;
			bet_text.CustomizedData = [ { size:24, color:0x00b4ff, bold:true }, paytext.getValue("WSBWRoyalFlush"), paytext.getValue("WSBWStraightFlush"), paytext.getValue("WSBWFourOfAKind"), paytext.getValue("WSBWFullHouse"), paytext.getValue("WSBWFlush"), paytext.getValue("WSBWStraight"), paytext.getValue("WS_Three"), paytext.getValue("WS_Twopair")];		
			bet_text.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			bet_text.Post_CustomizedData = [bet_text.CustomizedData.length -1,0,35];
			bet_text.Create(bet_text.CustomizedData.length -1, "pay_text");
			bet_text.container.x = 242;
			bet_text.container.y = 165;
			
			var pay_mark:MultiObject = create("pay_mark", [myModel.ResName]);
			pay_mark.CustomizedFun = _text.textSetting;
			pay_mark.CustomizedData = [ { size:24, color:0x00b4ff, bold:true }, "X", "X", "X", "X", "X", "X", "X", "X", "X", "X"];
			pay_mark.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			pay_mark.Post_CustomizedData = [bet_text.CustomizedData.length -1,0,35];
			pay_mark.Create(bet_text.CustomizedData.length -1, "pay_mark");
			pay_mark.container.x = 482;
			pay_mark.container.y = 165;
			
			var pay_odd:MultiObject = create("pay_odd", [myModel.ResName]);		
			pay_odd.CustomizedFun = _text.textSetting;
			pay_odd.CustomizedData = [ { size:24, color:0x00b4ff, bold:true, align:TextFormatAlign.RIGHT }, "200", "50", "20", "3", "2", "1", "0.1", "0.05", "X", "X"];
			pay_odd.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			pay_odd.Post_CustomizedData = [bet_text.CustomizedData.length -1,0,35];
			pay_odd.Create(bet_text.CustomizedData.length -1, "pay_odd");
			pay_odd.container.x = 32;
			pay_odd.container.y = 165;
			
			var pay_title:MultiObject = create("pay_title", [myModel.ResName]);		
			pay_title.CustomizedFun = _text.textSetting;
			pay_title.CustomizedData = [ { size:24, color:0xCCCCCC }, "特殊牌型賠率"];
			pay_title.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			pay_title.Post_CustomizedData = [bet_text.CustomizedData.length -1,0,35];
			pay_title.Create(1, "pay_title");
			pay_title.container.x = 424;
			pay_title.container.y = 129;
			
			
			var zone_limit_bet:MultiObject = prepare("zone_limit_bet", new MultiObject() , GetSingleItem("_view").parent.parent);			
			zone_limit_bet.container.x = 3;
			zone_limit_bet.container.y = 135;
			zone_limit_bet.Create_by_list(1,[ResName.zonepaytable], 0, 0, 1, 50, 0, "betzone_");	
			
			var realtime_info:MultiObject = prepare("realtime_info", new MultiObject() , GetSingleItem("_view").parent.parent);			
			realtime_info.container.x = 1730;
			realtime_info.container.y = 145;
			realtime_info.Create_by_list(1, [ResName.real_timeinfo], 0, 0, 1, 50, 0, "betzone_");	
			
			//_tool.SetControlMc(pay_odd.container);			
			//_tool.SetControlMc(game_info_data.ItemList[3]);			
			//_tool.y = 200;
			//add(_tool);	
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function bet_parse():void
		{
			Get("pay_mark").container.visible = false;
			Get("pay_odd").container.visible = false;
			
			utilFun.Clear_ItemChildren(GetSingleItem("pay_title"));
			
			Get("pay_title").CustomizedData = [{size:24,color:0xCCCCCC},"特殊牌型機率"];		
			Get("pay_title").FlushObject();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_parse():void
		{			
			Get("pay_mark").container.visible = true;
			Get("pay_odd").container.visible = true;
			
			Get("pay_title").CustomizedData = [{size:24,color:0xCCCCCC},"特殊牌型賠率"];		
			Get("pay_title").FlushObject();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			utilFun.Clear_ItemChildren(Get("game_title_info_data").ItemList[1]);			
			var round_code:int = _opration.operator("game_round", DataOperation.add,1);
			var textfi:TextField = _text.dynamic_text(round_code.toString(),{size:18});
			Get("game_title_info_data").ItemList[1].addChild(textfi);	
		}
		
	}

}