package View.GameView
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import Model.valueObject.*
	import Res.ResName;
	import util.DI;
	import Model.*
	import util.math.Path_Generator;
	import util.node;
	import View.ViewBase.Visual_Version;
	import View.Viewutil.*;
	import View.ViewBase.ViewBase;
	import util.*;
	import View.ViewComponent.*;
	
	import Command.*;
	
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author hhg
	 */
	public class betView extends ViewBase
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _poker:Visual_poker;
		
		[Inject]
		public var _timer:Visual_timer;
		
		[Inject]
		public var _hint:Visual_Hintmsg;
		
		[Inject]
		public var _betzone:Visual_betZone;
		
		[Inject]
		public var _coin:Visual_Coin;
	
		[Inject]
		public var _settle:Visual_Settle;
		
		[Inject]
		public var _btn:Visual_BtnHandle;
		
		[Inject]
		public var _sencer:Visual_betZone_Sence;
		
		[Inject]
		public var _gameinfo:Visual_Game_Info;
		
		[Inject]
		public var _paytable:Visual_Paytable;
		
		[Inject]
		public var _coin_stack:Visual_Coin_stack;
		
		[Inject]
		public var _settle_panel:Visual_SettlePanel;
		
		[Inject]
		public var _HistoryRecoder:Visual_HistoryRecoder;
		
		[Inject]
		public var _ProbData:Visual_ProbData;
		
		[Inject]
		public var _progressbar:Visual_progressbar;
		
		[Inject]
		public var _Bigwin_Effect:Visual_Bigwin_Effect;
		
		[Inject]
		public var _Version:Visual_Version;
		
		[Inject]
		public var _bg:Visual_bg;
		
		[Inject]
		public var _strem:Visual_stream;
		
		[Inject]
		public var _betTimer:Visual_betTimer;
		
		public function betView()  
		{
			utilFun.Log("betView");
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Bet) return;
			super.EnterView(View);
			//清除前一畫面
			utilFun.Log("in to EnterBetview=");			
			
			_tool = new AdjustTool();			
			
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.Bet_Scene], 0, 0, 1, 0, 0, "a_");	
			
			_bg.init();
			_Version.init();
			
			_HistoryRecoder.init();
			_ProbData.init();
			_progressbar.init();
			
			_gameinfo.init();
			_paytable.init();
			_settle_panel.init();			
			_timer.init();		
			_hint.init();			
			
			_betzone.init();
			_coin_stack.init();
			_coin.init();
			_poker.init();
			
			_settle.init();
			_sencer.init();	
			
			_btn.init();
			_Bigwin_Effect.init();
			
			_betTimer.init();
			
			_strem.init();
			
			var jsonob:Object = {
												  "online":{
															 "stream_link":[
																						{"stream_name":"live1", "strem_url":"52.69.102.66/live", "channel_ID":" /BW", "size": { "itemwidth":800, "itemheight":600 }},
																					   {"stream_name":"live2", "strem_url":"52.69.102.66/live", "channel_ID":" /BW1", "size": { "itemwidth":800, "itemheight":600 }}
																					   ]
														   },
												 "development":{
															 "stream_link":[
															                          {"stream_name":"big_stream", "strem_url":"192.168.1.136/live/", "channel_ID":"livestream", "size": { "itemwidth":320, "itemheight":240 }},
															                          {"stream_name":"test1", "strem_url":"184.72.239.149/vod", "channel_ID":"BigBuckBunny_115k.mov", "size": { "itemwidth":320, "itemheight":240 }},
																					  {"stream_name":"live1", "strem_url":"52.69.102.66/live", "channel_ID":" /BW", "size": { "itemwidth":800, "itemheight":600 }},
																					   {"stream_name":"live2", "strem_url":"52.69.102.66/live", "channel_ID":" /BW1", "size": { "itemwidth":800, "itemheight":600 }}
																					 
																					]
															
															   }
												}
			dispatcher(new ArrayObject([1, jsonob], "urlLoader_complete"));
			dispatcher(new StringObject("live1", "stream_connect"));
			
			//dispatcher(new StringObject("Soun_Bet_BGM","Music" ) );
		}
		
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Bet) return;
			super.ExitView(View);
		}		
	}

}