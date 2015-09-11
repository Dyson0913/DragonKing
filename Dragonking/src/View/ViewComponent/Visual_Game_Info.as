package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;
	import flash.utils.Timer;
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
		
		private var mcTimer:Timer;
		
		private var now:Date;
		
		public function Visual_Game_Info() 
		{
			
		}
		
		public function init():void
		{			
			var bet:MultiObject = prepare("game_title_info", new MultiObject() , GetSingleItem("_view").parent.parent);
			bet.CustomizedFun = textSetting;
			bet.CustomizedData = [18, "局號:","龍王","最大押住:", "最小押住:"];
			bet.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			bet.Post_CustomizedData = [[240,0],[1020,0],[1130,0],[1300,0]];
			bet.Create_by_list(bet.CustomizedData.length-1, [ResName.TextInfo], 0, 0, bet.CustomizedData.length-1, 200, 0, "info_");
			bet.container.x = 262;
			bet.container.y = 90;
				
			now = new Date();
			var dtf:DateTimeFormatter = new DateTimeFormatter("zh-TW");
			dtf.setDateTimePattern("yyyy/MM/dd  hh:mm:ss");
			var str:String = dtf.format(now);
			var game_info_data:MultiObject = prepare("game_title_info_data", new MultiObject() , GetSingleItem("_view").parent.parent);			
			game_info_data.CustomizedFun = textSetting;
			game_info_data.CustomizedData = [18,str, _model.getValue("game_round").toString(), "", ""];
			game_info_data.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			game_info_data.Post_CustomizedData = [[0,0],[310,0],[1230,0],[1400,0]];
			game_info_data.Create_by_list(game_info_data.CustomizedData.length-1, [ResName.TextInfo], 0, 0, game_info_data.CustomizedData.length-1, 200, 0, "info_");
			game_info_data.container.x = 242;
			game_info_data.container.y = 90;
			
			//_tool.SetControlMc(game_info_data.container);			
			//_tool.SetControlMc(game_info_data.ItemList[3]);			
			//_tool.y = 200;
			//add(_tool);	
			mcTimer = new Timer(1000);  
			mcTimer.addEventListener(TimerEvent.TIMER, timerHandler);  
			mcTimer.start();  
			
		}
		
		public function timerHandler(event:TimerEvent):void 
		{  						
			now = new Date();
			var dtf:DateTimeFormatter = new DateTimeFormatter("zh-TW");
			dtf.setDateTimePattern("yyyy/MM/dd  hh:mm:ss");
			var str:String = dtf.format(now);			
			utilFun.Clear_ItemChildren(Get("game_title_info_data").ItemList[0]);
			var textfi:TextField = dynamic_text(str,18);
			Get("game_title_info_data").ItemList[0].addChild(textfi);			
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
			var textfi:TextField = dynamic_text(round_code.toString(),18);
			Get("game_title_info_data").ItemList[1].addChild(textfi);	
		}
		
		public function dynamic_text(text:String,size:int):TextField
		{		
			var _NickName:TextField = new TextField();
			_NickName.width = 626.95;
			_NickName.height = 134;
			_NickName.textColor = 0xFFFFFF;
			_NickName.selectable = false;		
			_NickName.autoSize = TextFieldAutoSize.LEFT;				
			_NickName.wordWrap = true; //auto change line
			_NickName.multiline = true; //multi line
			_NickName.maxChars = 300;
			//"微軟正黑體"
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = size;
			myFormat.align = TextFormatAlign.LEFT;
			myFormat.font = "Microsoft JhengHei";			
			
			_NickName.defaultTextFormat = myFormat;				
			_NickName.text = text;			
			return _NickName;
		}
		
	}

}