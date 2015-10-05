package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;
	import flash.utils.Timer;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
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
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _text:Visual_Text;
		
		public function Visual_Game_Info() 
		{
			
		}
		
		public function init():void
		{			
			var bet:MultiObject = prepare("game_title_info", new MultiObject() , GetSingleItem("_view").parent.parent);
			bet.CustomizedFun = _text.textSetting;
			bet.CustomizedData = [{size:22,color:0xCCCCCC}, "局號:"];
			bet.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			bet.Post_CustomizedData = [[0,0],[1020,0],[1130,0],[1300,0]];
			bet.Create_by_list(bet.CustomizedData.length-1, [ResName.TextInfo], 0, 0, bet.CustomizedData.length-1, 200, 0, "info_");
			bet.container.x = 292;
			bet.container.y = 88;
				
			var str:String = "";
			var game_info_data:MultiObject = prepare("game_title_info_data", new MultiObject() , GetSingleItem("_view").parent.parent);			
			game_info_data.CustomizedFun = _text.textSetting;
			game_info_data.CustomizedData = [{size:18,color:0xCCCCCC},_model.getValue("game_round").toString(), "", ""];
			game_info_data.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			game_info_data.Post_CustomizedData = [[0,0],[310,0],[1230,0],[1400,0]];
			game_info_data.Create_by_list(1, [ResName.TextInfo], 0, 0, 1, 200, 0, "info_");
			game_info_data.container.x = 372;
			game_info_data.container.y = 90;
			
			
			//手寫賠率表 paytext.getValue("WSBWTripple"), paytext.getValue("WSBWTwoPair")
			var paytext:DI = _model.getValue(modelName.BIG_POKER_TEXT );
			var bet_text:MultiObject = prepare("pay_text", new MultiObject() , GetSingleItem("_view").parent.parent);
			bet_text.CustomizedFun = _text.textSetting;
			bet_text.CustomizedData = [{size:24,color:0x00b4ff,bold:true}, paytext.getValue("WSBWRoyalFlush"), paytext.getValue("WSBWStraightFlush"), paytext.getValue("WSBWFourOfAKind"), paytext.getValue("WSBWFullHouse"), paytext.getValue("WSBWFlush"), paytext.getValue("WSBWStraight")];		
			bet_text.Create_by_list(bet_text.CustomizedData.length -1, [ResName.TextInfo], 0, 0, 1, 0, 50, "info_");
			bet_text.container.x = 262;
			bet_text.container.y = 165;

			
			var pay_mark:MultiObject = prepare("pay_mark", new MultiObject() , GetSingleItem("_view").parent.parent);			
			pay_mark.CustomizedFun = _text.textSetting;
			pay_mark.CustomizedData = [{size:24,color:0x00b4ff,bold:true},"X","X","X","X","X","X"];		
			pay_mark.Create_by_list(bet_text.CustomizedData.length -1, [ResName.TextInfo], 0, 0, 1, 0, 50, "info_");
			pay_mark.container.x = 482;
			pay_mark.container.y = 165;
			
			var pay_odd:MultiObject = prepare("pay_odd", new MultiObject() , GetSingleItem("_view").parent.parent);			
			pay_odd.CustomizedFun = _text.textSetting;
			pay_odd.CustomizedData = [{size:24,color:0x00b4ff,bold:true,align:TextFormatAlign.RIGHT},"200","50","20","3","2","1"];		
			pay_odd.Create_by_list(bet_text.CustomizedData.length -1, [ResName.TextInfo], 0, 0, 1, 0, 50, "info_");
			pay_odd.container.x = 32;
			pay_odd.container.y = 165;
			
			var pay_title:MultiObject = prepare("pay_title", new MultiObject() , GetSingleItem("_view").parent.parent);			
			pay_title.CustomizedFun = _text.textSetting;
			pay_title.CustomizedData = [{size:24,color:0xCCCCCC,align:TextFormatAlign.CENTER},"主注特殊牌型賠率"];		
			pay_title.Create_by_list(1, [ResName.TextInfo], 0, 0, 1, 0, 35, "info_");
			pay_title.container.x = 179;
			pay_title.container.y = 129;
			
			var betlimit:MultiObject = prepare("betlimit", new MultiObject() , GetSingleItem("_view").parent.parent);			
			betlimit.container.x = 40;
			betlimit.container.y = 150;	
			betlimit.Create_by_list(1, [ResName.betlimit], 0, 0, 1, 0, 0, "time_");				
			
			var realtimeinfo:MultiObject = prepare("realtimeinfo", new MultiObject() , GetSingleItem("_view").parent.parent);			
			realtimeinfo.container.x = 1704;
			realtimeinfo.container.y = 160;	
			realtimeinfo.Create_by_list(1, [ResName.realtimeinfo], 0, 0, 1, 0, 0, "time_");				
			
			//_tool.SetControlMc(bet_text.container);			
			//_tool.SetControlMc(game_info_data.ItemList[3]);			
			//_tool.y = 200;
			//add(_tool);	
			
		}
		
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function show():void
		{
			apper();
			
			utilFun.Clear_ItemChildren(Get("game_title_info_data").ItemList[1]);			
			var round_code:int = _opration.operator("game_round", DataOperation.add,1);
			var textfi:TextField = _text.dynamic_text(round_code.toString(),{size:18});
			Get("game_title_info_data").ItemList[1].addChild(textfi);	
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function opencard_parse():void
		{
			Get("pay_mark").container.visible = false;
			Get("pay_odd").container.visible = false;
			Get("betlimit").container.visible = false;
			Get("realtimeinfo").container.visible = false;
			
			utilFun.Clear_ItemChildren(GetSingleItem("pay_title"));
			
			Get("pay_title").CustomizedData = [{size:24,color:0xCCCCCC,align:TextFormatAlign.CENTER},"主注特殊牌型機率"];		
			Get("pay_title").FlushObject();
						
		}
		
		public function apper():void
		{			
			Get("pay_mark").container.visible = true;
			Get("pay_odd").container.visible = true;
			Get("betlimit").container.visible = true;
			Get("realtimeinfo").container.visible = true;
			
			
			utilFun.Clear_ItemChildren(GetSingleItem("pay_title"));
			
			Get("pay_title").CustomizedData = [{size:24,color:0xCCCCCC,align:TextFormatAlign.CENTER},"主注特殊牌型賠率"];		
			Get("pay_title").FlushObject();
			
			for ( var i:int = 0; i < Get("pay_text").ItemList.length; i++)
			{
				utilFun.Clear_ItemChildren(GetSingleItem("pay_text", i));
				utilFun.Clear_ItemChildren(GetSingleItem("pay_mark", i));
				utilFun.Clear_ItemChildren(GetSingleItem("pay_odd",i));
			}
			
			var paytext:DI = _model.getValue(modelName.BIG_POKER_TEXT );
			Get("pay_text").CustomizedData = [{size:24,color:0x00b4ff,bold:true}, paytext.getValue("WSBWRoyalFlush"), paytext.getValue("WSBWStraightFlush"), paytext.getValue("WSBWFourOfAKind"), paytext.getValue("WSBWFullHouse"), paytext.getValue("WSBWFlush"), paytext.getValue("WSBWStraight")];		
			Get("pay_text").FlushObject();			
			
			Get("pay_mark").CustomizedFun = _text.textSetting;
			Get("pay_mark").CustomizedData = [ { size:24, color:0x00b4ff, bold:true },"X", "X", "X", "X", "X", "X", "X", "X"];		
			Get("pay_mark").FlushObject();
			
			Get("pay_odd").CustomizedFun = _text.textSetting;
			Get("pay_odd").CustomizedData = [{size:24,color:0x00b4ff,bold:true,align:TextFormatAlign.RIGHT},"200","50","20","3","2","1"];		
			Get("pay_odd").FlushObject();
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_parse():void
		{
			apper();
		}
		
		
	}

}