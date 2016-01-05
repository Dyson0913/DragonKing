package View.ViewComponent 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;	
	import util.math.Path_Generator;	
	import View.ViewBase.Visual_Version;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	import View.Viewutil.*;
	
	
	import flash.display.MovieClip;
	import View.GameView.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import flash.events.MouseEvent;	
	import com.adobe.serialization.json.JSON;
	
	/**
	 * testinterface to fun quick test
	 * @author Dyson0913
	 */
	public class Visual_testInterface  extends VisualHandler
	{		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _path:Path_Generator;
		
		[Inject]
		public var _MsgModel:MsgQueue;		
		
		[Inject]
		public var _paytable:Visual_Paytable;
		
		[Inject]
		public var _gameinfo:Visual_Game_Info;
		
		[Inject]
		public var _hint:Visual_Hintmsg;
		
		[Inject]
		public var _timer:Visual_timer;
		
		[Inject]
		public var _poker:Visual_poker;
		
		[Inject]
		public var _betzone:Visual_betZone;	
		
		[Inject]
		public var _coin:Visual_Coin;
		
		[Inject]
		public var _sencer:Visual_betZone_Sence;
		
		[Inject]
		public var _coin_stack:Visual_Coin_stack;
		
		[Inject]
		public var _settle:Visual_Settle;	
		
		[Inject]
		public var _btn:Visual_BtnHandle;
		
		[Inject]
		public var _settle_panel:Visual_SettlePanel;
		
		[Inject]
		public var _debug:Visual_debugTool;
		
		[Inject]
		public var _replayer:Visual_package_replayer;
		
		[Inject]
		public var _loader:Visual_Loder;
		
		[Inject]
		public var _progressbar:Visual_progressbar;
		
		[Inject]
		public var _HistoryRecoder:Visual_HistoryRecoder;
		
		[Inject]
		public var _ProbData:Visual_ProbData;
		
		[Inject]
		public var _fileStream:fileStream;
		
		[Inject]
		public var _Bigwin_Effect:Visual_Bigwin_Effect;
		
		[Inject]
		public var _Version:Visual_Version;
		
		[Inject]
		public var _bg:Visual_bg;
		
		private var _single_test_flag:int;
		static public var Num:int = 0;
		public const history:int = Num++;
		public const powerbar:int = Num++;
		
		public function Visual_testInterface() 
		{
			
		}
		
		public function init():void
		{
			_model.putValue("test_init", false);
			
			_debug.init();			
			_betCommand.bet_init();			
			_model.putValue("result_Pai_list", []);
			_model.putValue("game_round", 1);			
			
			var script:DI = new DI();
			script.putValue("新局",0);
			script.putValue("開始下注",1);
			script.putValue("停止下注",2);
			script.putValue("開牌",3);
			script.putValue("結算",4);
			script.putValue("封包",5);
			script.putValue("單一功能測試",6);
			
			_model.putValue("name_map", script);
			
			//腳本
			var script_list:MultiObject = create("script_list", [ResName.TextInfo]);	
			script_list.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);			
			script_list.stop_Propagation = true;
			script_list.mousedown = script_list_test;
			script_list.CustomizedData = [ { size:18 },"新局","開始下注", "停止下注","開牌", "結算","封包","單一功能測試"];
			script_list.CustomizedFun = _text.textSetting;			
			script_list.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			script_list.Post_CustomizedData = [6, 100, 50];			
			script_list.Create_(script_list.CustomizedData.length -1);			
			
		}				
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "0")]
		public function newround():void
		{
			fake_hisotry();
			_model.putValue(modelName.GAMES_STATE,gameState.NEW_ROUND);			
			dispatcher(new ModelEvent("update_state"));
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "1")]
		public function start_bet():void
		{		
			fake_hisotry();
			_model.putValue(modelName.REMAIN_TIME, 20);
			
			_model.putValue(modelName.GAMES_STATE,gameState.START_BET);			
			dispatcher(new ModelEvent("update_state"));			
		}	
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "2")]
		public function stop_bet():void
		{
			fake_hisotry();
			_model.putValue(modelName.GAMES_STATE,gameState.END_BET);			
			dispatcher(new ModelEvent("update_state"));
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "3")]
		public function opencardScript():void
		{			
			_model.putValue(modelName.PLAYER_POKER, []);				
			_model.putValue(modelName.BANKER_POKER, []);		
			_model.putValue(modelName.RIVER_POKER, []);		
			_model.putValue("scirpt_pai", ["1s","2d","3s","5c","6h","9d"]);
			
			_model.putValue(modelName.GAMES_STATE,gameState.START_OPEN);			
			dispatcher(new ModelEvent("update_state"));
			//================================================ simu deal
			var testpoker:Array = ["Player", "Banker", "Player", "Banker", "River", "River"];
			_regular.Call(Get(modelName.PLAYER_POKER).container, { onUpdate:this.fackeDeal, onUpdateParams:[testpoker] }, 25, 0, 6, "linear");
		}
		
		public function fackeDeal(type:Array):void
		{
			utilFun.Log("fackeDeal = "+fackeDeal);
			var cardlist:Array = _model.getValue("scirpt_pai");
			
			var card_type:String = type[0];
			var card:String = cardlist[0];
			type.shift();
			cardlist.shift();
			utilFun.Log("card = " + card);
			var mypoker:Array = [];
			if ( card_type == "Player")
			{										
				mypoker = _model.getValue(modelName.PLAYER_POKER);										
				mypoker.push(card);
				_model.putValue(modelName.PLAYER_POKER, mypoker);										
				dispatcher(new Intobject(modelName.PLAYER_POKER, "poker_mi"));				
			}
			else if ( card_type == "Banker")
			{							
				mypoker = _model.getValue(modelName.BANKER_POKER);										
				mypoker.push( card);										
				_model.putValue(modelName.BANKER_POKER, mypoker);									
				dispatcher(new Intobject(modelName.BANKER_POKER, "poker_mi"));
			}					
			else if ( card_type == "River")
			{							
				mypoker = _model.getValue(modelName.RIVER_POKER);										
				mypoker.push( card);										
				_model.putValue(modelName.RIVER_POKER, mypoker);										
				dispatcher(new Intobject(modelName.RIVER_POKER, "poker_mi"));
			}					
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "4")]
		public function settleScript():void
		{
			_model.putValue(modelName.PLAYER_POKER, ["1d","5c"]);				
			_model.putValue(modelName.BANKER_POKER, ["2d","6h"]);		
			_model.putValue(modelName.RIVER_POKER, ["3s","9d"]);		
			
		
			dispatcher(new Intobject(modelName.PLAYER_POKER, "show_judge"));
			dispatcher(new Intobject(modelName.BANKER_POKER, "show_judge"));			
			
			//_betCommand.bet_local(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false), 0);
			//_betCommand.bet_local(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false), 1);
			
			//full + 和			
			var fakePacket:Object = {"result_list": [{"bet_attr": "BetAttrMain", "bet_amount": 0, "odds": 1.95, "win_state": "WSBWFlush", "real_win_amount": 0, "bet_type": "BetBWPlayer", "settle_amount": 0}, {"bet_attr": "BetAttrMain", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetBWBanker", "settle_amount": 0}, {"bet_attr": "BetAttrSide", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetBWTiePoint", "settle_amount": 0}, {"bet_attr": "BetAttrSide", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetBWSpecial", "settle_amount": 0}, {"bet_attr": "BetAttrSide", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetBWPlayerPair", "settle_amount": 0}, {"bet_attr": "BetAttrSide", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetBWBankerPair", "settle_amount": 0}, {"bet_attr": "BetAttrBonus", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetBWBonusTripple", "settle_amount": 0}, {"bet_attr": "BetAttrBonus", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetBWBonusTwoPair", "settle_amount": 0}], "game_state": "EndRoundState", "game_result_id": "405996", "timestamp": 1450259923.729869, "remain_time": 9, "game_type": "BigWin", "id": "975d27dca3db11e5ae48f23c9189e2a9", "game_id": "BigWin-1", "message_type": "MsgBPEndRound", "game_round": 1605}
			
			_MsgModel.push(fakePacket);	
			//
			
			_model.putValue(modelName.GAMES_STATE,gameState.END_ROUND);			
			dispatcher(new ModelEvent("update_state"));
		}
		
		public function fake_hisotry():void
		{			
			var arr:Array = [];
			for ( var i:int = 0; i < 60; i++)
			{					
				var p:int = utilFun.Random(3);
				var str:String = "";
				if ( p == 0)  str = "BetBWPlayer";
				if ( p == 1)  str = "BetBWBanker";
				if ( p == 2)  str = "None";
				var ob:Object = { "player_pair": utilFun.Random(2) , "winner": str, "banker_pair": utilFun.Random(2) , "point": utilFun.Random(10) };
				arr.push(ob);
			}			
			 _model.putValue("history_list",arr);
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "5")]
		public function pack_sim():void
		{
			_fileStream.load();
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "6")]
		public function sim_fun():void
		{
			_single_test_flag = powerbar;
			switch(_single_test_flag)
			{
				case history:
				{					
					fake_hisotry();						
				}
				break;
				
				case powerbar:
				{					
					dispatcher(new Intobject(utilFun.Random(2), "power_up"));
				}
				break;
			}
			
			//pack test
			//_loader.init();
			//_replayer.set_mission_id(_loader.getToken());
			//dispatcher(new ArrayObject([_replayer.mission_id(),"pack_player_win.txt",{callback:"replay_config_complete"}], "binary_file_loading"));
				//
			//music test
			//dispatcher(new StringObject("Soun_Bet_BGM","Music_pause" ) );
			//dispatcher(new StringObject("sound_coin","sound" ) );
			//dispatcher(new StringObject("sound_msg","sound" ) );
			//dispatcher(new StringObject("sound_rebet","sound" ) );
			
			//_betCommand.bet_local(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false), 0);
			
		}
		
		public function script_list_test(e:Event, idx:int):Boolean
		{			
			
			var clickname:String = GetSingleItem("script_list", idx).getChildByName("Dy_Text").text;
			var idx:int = _opration.getMappingValue("name_map",clickname);
			if (clickname == "封包") 
			{
				view_init();
				_model.putValue(modelName.GAMES_STATE,gameState.NEW_ROUND);			
				dispatcher(new ModelEvent("update_state"));
			
				dispatcher(new TestEvent(idx.toString()));
				return true;
			}
			
			
			view_init();
			dispatcher(new TestEvent(idx.toString()));
			return true;
		}
		
		public function view_init():void		
		{
			if ( _model.getValue("test_init")) return;
			changeBG(ResName.Bet_Scene);
			
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
			
			//s_progressbar.debug();
			_model.putValue("test_init",true);
		}
		
	}

}