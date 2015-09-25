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
		
		private var mcTimer:Timer;
		
		private var now:Date;
		
		public var align_left:String = TextFormatAlign.LEFT;
		public var align_center:String = TextFormatAlign.CENTER;
		public var align_right:String = TextFormatAlign.RIGHT
		
		
		
		public function Visual_Game_Info() 
		{
			
		}
		
		public function init():void
		{			
			var bet:MultiObject = prepare("game_title_info", new MultiObject() , GetSingleItem("_view").parent.parent);
			bet.CustomizedFun = textSetting;
			bet.CustomizedData = [{size:22,color:0xCCCCCC}, "局號:"];
			bet.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			bet.Post_CustomizedData = [[0,0],[1020,0],[1130,0],[1300,0]];
			bet.Create_by_list(bet.CustomizedData.length-1, [ResName.TextInfo], 0, 0, bet.CustomizedData.length-1, 200, 0, "info_");
			bet.container.x = 292;
			bet.container.y = 88;
				
			//now = new Date();
			//var dtf:DateTimeFormatter = new DateTimeFormatter("zh-TW");
			//dtf.setDateTimePattern("yyyy/MM/dd  hh:mm:ss");
			var str:String = "";// dtf.format(now);
			var game_info_data:MultiObject = prepare("game_title_info_data", new MultiObject() , GetSingleItem("_view").parent.parent);			
			game_info_data.CustomizedFun = textSetting;
			game_info_data.CustomizedData = [{size:18,color:0xCCCCCC},_model.getValue("game_round").toString(), "", ""];
			game_info_data.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			game_info_data.Post_CustomizedData = [[0,0],[310,0],[1230,0],[1400,0]];
			game_info_data.Create_by_list(1, [ResName.TextInfo], 0, 0, 1, 200, 0, "info_");
			game_info_data.container.x = 372;
			game_info_data.container.y = 90;
			
			
			//手寫賠率表
			var paytext:DI = _model.getValue(modelName.BIG_POKER_TEXT );
			var bet_text:MultiObject = prepare("pay_text", new MultiObject() , GetSingleItem("_view").parent.parent);
			bet_text.CustomizedFun = _text.textSetting;
			bet_text.CustomizedData = [{size:24,color:0x00b4ff,bold:true}, paytext.getValue("WSBWRoyalFlush"), paytext.getValue("WSBWStraightFlush"), paytext.getValue("WSBWFourOfAKind"), paytext.getValue("WSBWFullHouse"), paytext.getValue("WSBWFlush"), paytext.getValue("WSBWStraight"),paytext.getValue("WSBWTripple"), paytext.getValue("WSBWTwoPair")];		
			bet_text.Create_by_list(bet_text.CustomizedData.length -1, [ResName.TextInfo], 0, 0, 1, 0, 35, "info_");
			bet_text.container.x = 242;
			bet_text.container.y = 165;

			
			var pay_mark:MultiObject = prepare("pay_mark", new MultiObject() , GetSingleItem("_view").parent.parent);			
			pay_mark.CustomizedFun = _text.textSetting;
			pay_mark.CustomizedData = [{size:24,color:0x00b4ff,bold:true},"X","X","X","X","X","X","X","X","X","X"];		
			pay_mark.Create_by_list(bet_text.CustomizedData.length -1, [ResName.TextInfo], 0, 0, 1, 0, 35, "info_");
			pay_mark.container.x = 482;
			pay_mark.container.y = 165;
			
			var pay_odd:MultiObject = prepare("pay_odd", new MultiObject() , GetSingleItem("_view").parent.parent);			
			pay_odd.CustomizedFun = _text.textSetting;
			pay_odd.CustomizedData = [{size:24,color:0x00b4ff,bold:true,align:TextFormatAlign.RIGHT},"200","50","20","3","2","1","0.1","0.05","X","X"];		
			pay_odd.Create_by_list(bet_text.CustomizedData.length -1, [ResName.TextInfo], 0, 0, 1, 0, 35, "info_");
			pay_odd.container.x = 32;
			pay_odd.container.y = 165;
			
			var pay_title:MultiObject = prepare("pay_title", new MultiObject() , GetSingleItem("_view").parent.parent);			
			pay_title.CustomizedFun = textSetting;
			pay_title.CustomizedData = [{size:24,color:0xCCCCCC},"特殊牌型賠率"];		
			pay_title.Create_by_list(1, [ResName.TextInfo], 0, 0, 1, 0, 35, "info_");
			pay_title.container.x = 424;
			pay_title.container.y = 129;
			
			//mcTimer = new Timer(1000);  
			//mcTimer.addEventListener(TimerEvent.TIMER, timerHandler);  
			//mcTimer.start();  
			
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
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_parse():void
		{
			apper();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function show():void
		{
			apper();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function opencard_parse():void
		{
			Get("pay_mark").container.visible = false;
			Get("pay_odd").container.visible = false;
			
			utilFun.Clear_ItemChildren(GetSingleItem("pay_title"));
			
			Get("pay_title").CustomizedData = [{size:24,color:0xCCCCCC},"特殊牌型機率"];		
			Get("pay_title").FlushObject();
		}
		
		public function apper():void
		{			
			Get("pay_mark").container.visible = true;
			Get("pay_odd").container.visible = true;
			
			utilFun.Clear_ItemChildren(GetSingleItem("pay_title"));
			
			Get("pay_title").CustomizedData = [{size:24,color:0xCCCCCC},"特殊牌型賠率"];		
			Get("pay_title").FlushObject();
			
			for ( var i:int = 0; i < Get("pay_text").ItemList.length; i++)
			{
				utilFun.Clear_ItemChildren(GetSingleItem("pay_text",i));
			}
			
			var paytext:DI = _model.getValue(modelName.BIG_POKER_TEXT );
			Get("pay_text").CustomizedData = [{size:24,color:0x00b4ff,bold:true}, paytext.getValue("WSBWRoyalFlush"), paytext.getValue("WSBWStraightFlush"), paytext.getValue("WSBWFourOfAKind"), paytext.getValue("WSBWFullHouse"), paytext.getValue("WSBWFlush"), paytext.getValue("WSBWStraight"),paytext.getValue("WSBWTripple"), paytext.getValue("WSBWTwoPair")];		
			Get("pay_text").FlushObject();
			//
			for ( var i:int = 0; i < Get("pay_mark").ItemList.length; i++)
			{
				utilFun.Clear_ItemChildren(GetSingleItem("pay_mark",i));
			}			
			Get("pay_mark").CustomizedFun = _text.textSetting;
			Get("pay_mark").CustomizedData = [ { size:24, color:0x00b4ff, bold:true }, "X", "X", "X", "X", "X", "X", "X", "X", "X", "X"];		
			Get("pay_mark").FlushObject();
			//
			for ( var i:int = 0; i < Get("pay_odd").ItemList.length; i++)
			{
				utilFun.Clear_ItemChildren(GetSingleItem("pay_odd",i));
			}					
			Get("pay_odd").CustomizedFun = _text.textSetting;
			Get("pay_odd").CustomizedData = [{size:24,color:0x00b4ff,bold:true,align:TextFormatAlign.RIGHT},"200","50","20","3","2","1","0.1","0.05","X","X"];		
			Get("pay_odd").FlushObject();
			
		}
		
		public function textSetting(mc:MovieClip, idx:int, data:Array):void
		{						
			var str:TextField = dynamic_text(data[idx+1],data[0]);			
			mc.addChild(str);
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			utilFun.Clear_ItemChildren(Get("game_title_info_data").ItemList[1]);			
			var round_code:int = _opration.operator("game_round", DataOperation.add,1);
			var textfi:TextField = dynamic_text(round_code.toString(),[18]);
			Get("game_title_info_data").ItemList[1].addChild(textfi);	
		}
		
		public function dynamic_text(text:String,para:Object):TextField
		{		
			//utilFun.Log("para ="+para.size);
			var size:int = para.size;
			var textColor:uint = 0xFFFFFF;
			var align:String = TextFormatAlign.LEFT;
			var bold:Boolean = false;
			
			if ( para["color"] != undefined)  textColor = para.color;
			if( para["align"] != undefined)  align = para.align;
			if( para["bold"] != undefined)  bold = para.bold;
						
			var _NickName:TextField = new TextField();
			_NickName.width = 626.95;
			_NickName.height = 134;
			_NickName.textColor = textColor;
			_NickName.selectable = false;		
			//_NickName.autoSize = TextFieldAutoSize.LEFT;				
			_NickName.wordWrap = true; //auto change line
			_NickName.multiline = true; //multi line
			_NickName.maxChars = 300;
			//"微軟正黑體"
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = size;
			myFormat.align = align;
			myFormat.bold = bold;
			myFormat.font = "Microsoft JhengHei";			
			
			_NickName.defaultTextFormat = myFormat;				
			_NickName.text = text;			
			return _NickName;
		}
		
	}

}