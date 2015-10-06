package View.ViewComponent 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Transform;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import util.math.Path_Generator;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	import View.Viewutil.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import View.GameView.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import com.adobe.serialization.json.JSON;
	/**
	 * testinterface to fun quick test
	 * @author ...
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
		public var _text:Visual_Text;
		
		[Inject]
		public var _settle_panel:Visual_SettlePanel;
		
		[Inject]
		public var _betinfo:Visual_Betinfo;
		
		[Inject]
		public var _debug:Visual_debugTool;
		
		[Inject]
		public var _replayer:Visual_package_replayer;
		
		[Inject]
		public var _loader:Visual_Loder;
		
		
		public function Visual_testInterface() 
		{
			
		}
		
		public function init():void
		{			
			_debug.init();
				
			_betCommand.bet_init();			
			_model.putValue("result_Pai_list", []);
			_model.putValue("game_round", 1);			
			
			//腳本
			var script_list:MultiObject = prepare("script_list", new MultiObject() ,GetSingleItem("_view").parent.parent );			
			script_list.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);			
			script_list.stop_Propagation = true;
			script_list.mousedown = script_list_test;
			script_list.CustomizedData = [ { size:18 }, "下注腳本", "開牌腳本", "結算腳本", "封包模擬"];
			script_list.CustomizedFun = _text.textSetting;			
			script_list.Create_by_list(script_list.CustomizedData.length -1, [ResName.TextInfo], 0, 0, script_list.CustomizedData.length-1, 100, 20, "Btn_");			
			
			
			_model.putValue("Script_idx", 0);			
			//_tool.y = 200;
			//add(_tool);
			
		}				
		
		public function script_list_test(e:Event, idx:int):Boolean
		{
			utilFun.Log("script_list_test=" + idx);
			_model.putValue("Script_idx", idx);		
			
			dispatcher(new TestEvent(_model.getValue("Script_idx").toString()));
			
			
			return true;
		}
	
		
		public function _script_item_test(e:Event, idx:int):Boolean
		{
			
			_model.putValue("Script_item_idx", idx);
			
			utilFun.Log("scirpt_id = "+ _model.getValue("Script_idx") + _model.getValue("Script_item_idx"));	
			var str:String = _model.getValue("Script_idx").toString() + _model.getValue("Script_item_idx").toString();			
			
			dispatcher(new TestEvent(str));
			
			return true;		
			//================================================command btn
			//_btn.init();			
			
		}			
		
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "0")]
		public function betScript():void
		{
			//var fakePacket:Object = {"game_state": "EndRoundState", "timestamp": 1443082690.19736, "remain_time": 3, "game_type": "BigWin", "game_round": 105, "cards_info": {"banker_card_list": ["ks", "6c"], "river_card_list": ["9d", "2d"], "player_card_list": ["5s", "7s"]}, "game_id": "BigWin-1", "message_type": "MsgBPInitialInfo", "id": "cacfe8a8629411e5b345f23c9189e2a9"}
			//_MsgModel.push(fakePacket);	
			//return;
			
			changeBG(ResName.Bet_Scene);
			
			
			
			//=============================================gameinfo			
			_gameinfo.init();
			
			//=============================================paytable
			fake_hisotry();
			_paytable.init();
			
			//================================================betzone
			_betzone.init();			
			_coin_stack.init();
			_coin.init();
			_sencer.init();
			
			//=============================================Hintmsg
			_hint.init();
			
			//================================================timer
			_model.putValue(modelName.REMAIN_TIME, 20);					
			_timer.init();
			
			_btn.init();
			
			_btn.debug();
			dispatcher(new ModelEvent("display"));
			
			//dispatcher(new StringObject("WSBWTwoPair", "winstr_hint"));
		}	
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "1")]
		public function opencardScript():void
		{			
			_model.putValue(modelName.PLAYER_POKER, []);				
			_model.putValue(modelName.BANKER_POKER, []);		
			_model.putValue(modelName.RIVER_POKER, []);		
			_model.putValue("scirpt_pai", ["1s","2d","3s","5c","6h","9d"]);		
			
			changeBG(ResName.Bet_Scene);
			
			//=============================================gameinfo			
			_gameinfo.init();
			_gameinfo.opencard_parse();
			
			//=============================================paytable
			fake_hisotry();
			_paytable.init();
			_paytable.debug();
			//_paytable.opencard_parse();
			
			
			_betinfo.init();
			//=============================================Hintmsg
			_hint.init();
			_model.putValue(modelName.GAMES_STATE,gameState.END_BET);
			_hint.hide();			
		
			//================================================poker
			_poker.init();
			
		
			//================================================settle info
			//_settle.init();
			
			
			dispatcher(new ModelEvent("hide"));
			
			
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
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "2")]
		public function settleScript():void
		{
			_model.putValue(modelName.PLAYER_POKER, ["9d","2d"]);				
			_model.putValue(modelName.BANKER_POKER, ["2d","9s"]);		
			_model.putValue(modelName.RIVER_POKER, []);					
			
			
			
			changeBG(ResName.Bet_Scene);
			
			//=============================================gameinfo			
			_gameinfo.init();
			_gameinfo.settle_parse();
			
			
			//=============================================Hintmsg
			//_hint.init();			
			_settle_panel.init();
			
			
			//=============================================paytable
			fake_hisotry();
			_paytable.init();		
			_paytable.settle_parse();
				
			
			
			_poker.init();
			
			//_poker.prob_cal();
			//return;
			//
			
			dispatcher(new ModelEvent("hide"));
			//dispatcher(new ModelEvent("display"));
			//================================================settle info
			_settle.init();
			_settle.debug();
			dispatcher(new Intobject(modelName.PLAYER_POKER, "show_judge"));
			dispatcher(new Intobject(modelName.BANKER_POKER, "show_judge"));			
			//摸擬押注
			//_betzone.init();			
			//_coin_stack.init();
			//_betCommand.bet_local(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false), 0);
			//_betCommand.bet_local(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false), 1);
			
			//
			//同花
			//var fakePacket:Object = {"result_list": [{"bet_type": "BetBWPlayer", "settle_amount": 0, "odds": 3, "win_state": "WSLost", "bet_amount": 0}, {"bet_type": "BetBWBanker", "settle_amount": 0, "odds": 3, "win_state": "WSWin", "bet_amount": 0}, {"bet_type": "BetBWTiePoint", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0}, {"bet_type": "BetBWSpecial", "settle_amount": 0, "odds": 6, "win_state": "WSBWOnePairBig", "bet_amount": 0}, {"bet_type": "BetBWPlayerPair", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0}, {"bet_type": "BetBWBankerPair", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0}], "game_state": "EndRoundState", "game_result_id": "291643", "timestamp": 1443162482.443791, "remain_time": 9, "game_type": "BigWin", "game_round": 971, "game_id": "BigWin-1", "message_type": "MsgBPEndRound", "id": "92b27a3e634e11e5b419f23c9189e2a9"}
			
			//二對
			var fakePacket:Object = {"result_list": [{"bet_type": "BetBWPlayer", "settle_amount": 195.0, "odds": 1.95, "win_state": "WSBWStraight", "bet_amount": 100}, {"bet_type": "BetBWBanker", "settle_amount": 0, "odds": 0, "win_state": "WSBWStraight", "bet_amount": 100}, {"bet_type": "BetBWTiePoint", "settle_amount": 0, "odds": 0, "win_state": "WSWin", "bet_amount": 0}, {"bet_type": "BetBWSpecial", "settle_amount": 0, "odds": 2, "win_state": "WSBWStraight", "bet_amount": 0}, {"bet_type": "BetBWPlayerPair", "settle_amount": 0, "odds": 12, "win_state": "WSWin", "bet_amount": 0}, {"bet_type": "BetBWBankerPair", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0}], "game_state": "EndRoundState", "game_result_id": "299250", "timestamp": 1443593721.364407, "remain_time": 9, "game_type": "BigWin", "game_round": 158, "game_id": "BigWin-1", "message_type": "MsgBPEndRound", "id": "a11fba56673a11e5be2bf23c9189e2a9"}
			_MsgModel.push(fakePacket);	
			
			
			
		}
		
		
		public function fake_hisotry():void
		{
			var history:Array = _model.getValue("history_win_list");			
			for ( var i:int = 0; i < 8; i++)
			{
				var frame:int = utilFun.Random(4) +2;
				var point:int = utilFun.Random(9);			
				var isplayerPair:int = utilFun.Random(2);			
				var isbankerPair:int = utilFun.Random(2);							
				var bigs:int = i;// utilFun.Random(7);
				history.push([frame, point, isplayerPair, isbankerPair,bigs]);
			}			
			_model.putValue("history_win_list",history);
		}
	
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "3")]
		public function pack_sim():void
		{
			_loader.init();
			_replayer.set_mission_id(_loader.getToken());
			dispatcher(new ArrayObject([_replayer.mission_id(),"pack_player_win.txt",{callback:"replay_config_complete"}], "binary_file_loading"));
		}
		
	}

}