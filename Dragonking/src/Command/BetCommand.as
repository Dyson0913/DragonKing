package Command 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.events.Event;
	import Model.*;
	import Model.valueObject.Intobject;
	import Model.valueObject.StringObject;
	import util.DI;
	import util.utilFun;
	import View.GameView.*;
	import Res.*;
	/**
	 * user bet action
	 * @author hhg4092
	 */
	public class BetCommand 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _Actionmodel:ActionQueue;
		
		[Inject]
		public var _opration:DataOperation;
		
		[Inject]
		public var _model:Model;
		
		public var _Bet_info:DI = new DI();
		
		public function BetCommand() 
		{
		
		}
		
		public function bet_init():void
		{
			_model.putValue("coin_selectIdx", 2);
			_model.putValue("coin_list", [100, 500, 1000, 5000, 10000]);
			_model.putValue("after_bet_credit", 0);
			
			//閒對,閒,和,莊,莊對
			var betzone:Array = [0, 1, 2, 3, 4, 5];
			var betzone_name:Array = ["BetBWPlayer", "BetBWBanker", "BetBWTiePoint", "BetBWBankerPair", "BetBWPlayerPair", "BetBWSpecial"];
			
			var bet_name_to_idx:DI = new DI();
			var bet_idx_to_name:DI = new DI();
			for ( var i:int = 0; i < betzone.length ; i++)
			{
				bet_name_to_idx.putValue(betzone_name[i], i);
				bet_idx_to_name.putValue(i, betzone_name[i]);
			}
			
			var _idx_to_result_idx:DI = new DI();
			
			_idx_to_result_idx.putValue("0", 1);
			_idx_to_result_idx.putValue("1", 0);
			_idx_to_result_idx.putValue("2", 2);
			_idx_to_result_idx.putValue("3", 3);
			_idx_to_result_idx.putValue("4", 4);
			_idx_to_result_idx.putValue("5", 5);
			_model.putValue("idx_to_result_idx", _idx_to_result_idx);		
			//_model.putValue("BetBWPlayer", 0);
			//_model.putValue("BetBWBanker", 1);			
			//_model.putValue("BetBWTie", 2);			
			//_model.putValue("BetBWBankerPair", 3);			
			//_model.putValue("BetBWPlayerPair", 4);						
			//_model.putValue("BetBWSpecial", 5);		
			
			_model.putValue("Bet_name_to_idx", bet_name_to_idx);		
			_model.putValue("Bet_idx_to_name", bet_idx_to_name);
			
			var allzone:Array = [ResName.betzone_player, ResName.betzone_banker,ResName.betzone_tie,ResName.betzone_banker_pair,ResName.betzone_player_pari,ResName.special_Zone];			
			var avaliblezone:Array = [];
			var avaliblezone_s:Array = [];
			for each (var k:int in betzone)
			{
				avaliblezone.push ( allzone[k]);
				avaliblezone_s.push ( allzone[k]+"_sence");
			}
			
			_model.putValue(modelName.AVALIBLE_ZONE_IDX, betzone);
			_model.putValue(modelName.AVALIBLE_ZONE, avaliblezone);
			_model.putValue(modelName.AVALIBLE_ZONE_S, avaliblezone_s);
						
			_model.putValue(modelName.AVALIBLE_ZONE_XY,  [[0, 0], [644, 3], [356, 129], [973, 58], [-259, 48], [369, 3]]);
			_model.putValue(modelName.COIN_STACK_XY,   [ [30, 0], [670, -10],  [350, 23], [970, -20], [-279, -12], [340, -182]]);
			
			var poermapping:DI = new DI();	
			poermapping.putValue("WSBWOnePairBig", -2);			
			poermapping.putValue("WSBWTwoPair", 0);			
			poermapping.putValue("WSBWTripple", 1);
			poermapping.putValue("WSBWStraight", 2);
			poermapping.putValue("WSBWFlush", 3);
			poermapping.putValue("WSBWFullHouse", 4);
			poermapping.putValue("WSBWFourOfAKind", 5);
			poermapping.putValue("WSBWStraightFlush", 6);
			poermapping.putValue("WSBWRoyalFlush", 7);
			_model.putValue(modelName.BIG_POKER_MSG , poermapping);
			
			var history_str:DI = new DI();	
			history_str.putValue(0, "2P");
			history_str.putValue(1, "3K");
			history_str.putValue(2, "STR");
			history_str.putValue(3, "FLU");
			history_str.putValue(4, "FUH");
			history_str.putValue(5, "4K");
			history_str.putValue(6, "STF");
			history_str.putValue(7, "RTF");
			_model.putValue(modelName.SMALL_POKER_MSG , history_str);
			
			var history_str_mapp:DI = new DI();			
			history_str_mapp.putValue("WSBWStraight", "STR");
			history_str_mapp.putValue("WSBWFlush", "FLU");
			history_str_mapp.putValue("WSBWFullHouse", "FUH");
			history_str_mapp.putValue("WSBWFourOfAKind", "4K");
			history_str_mapp.putValue("WSBWStraightFlush", "STF");
			history_str_mapp.putValue("WSBWRoyalFlush", "RTF");
			_model.putValue(modelName.HIS_SHORT_MSG , history_str_mapp);
			
			var poer_msg:DI = new DI();		
			poer_msg.putValue("WSBWOnePairBig", "J以上一對");
			poer_msg.putValue("WSBWTwoPair", "兩對");
			poer_msg.putValue("WSBWTripple", "三條");
			poer_msg.putValue("WSBWStraight", "順子");
			poer_msg.putValue("WSBWFlush", "同花");
			poer_msg.putValue("WSBWFullHouse", "葫蘆");
			poer_msg.putValue("WSBWFourOfAKind", "四條");
			poer_msg.putValue("WSBWStraightFlush", "同花順");
			poer_msg.putValue("WSBWRoyalFlush", "同花大順");
			_model.putValue(modelName.BIG_POKER_TEXT , poer_msg);
			
			_model.putValue("power_jp",[0,0]);
			_model.putValue("power_idx",[0,0]);
			
			_Bet_info.putValue("self", [] ) ;
			_model.putValue("history_bet",[]);
		}		
		
		public function betTypeMain(e:Event,idx:int):Boolean
		{			
			//idx += 1;
			
			if ( _Actionmodel.length() > 0) return false;
			
			//押注金額判定
			if ( all_betzone_totoal() + _opration.array_idx("coin_list", "coin_selectIdx") > _model.getValue(modelName.CREDIT))
			{
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.NO_CREDIT));
				return false;
			}
			utilFun.Log("betType = "+idx);
			var bet:Object = { "betType": idx,
											"bet_idx":_model.getValue("coin_selectIdx"),
			                               "bet_amount": _opration.array_idx("coin_list", "coin_selectIdx"),
										    "total_bet_amount": get_total_bet(idx) +_opration.array_idx("coin_list", "coin_selectIdx")
			};
			
			dispatcher( new ActionEvent(bet, "bet_action"));
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));
			
			return true;
		}		
		
		public function empty_reaction(e:Event, idx:int):Boolean
		{
			//utilFun.Log("emtpey reaction ="+e.currentTarget.name);
			return true;
		}	
		
		public function bet_local(e:Event,idx:int):Boolean
		{			
			//idx += 1;
			utilFun.Log("idx ="+idx);
			
			var bet:Object = { "betType": idx,
										   "bet_idx":_model.getValue("coin_selectIdx"),
			                               "bet_amount": _opration.array_idx("coin_list", "coin_selectIdx"),
										    "total_bet_amount": get_total_bet(idx) +_opration.array_idx("coin_list", "coin_selectIdx")
			};
			
			dispatcher( new ActionEvent(bet, "bet_action"));
			
			//fake bet proccess
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));
			dispatcher(new ModelEvent("updateCoin"));
			
			return true;
		}		
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "Betresult")]
		public function accept_bet():void
		{
			var bet_ob:Object = _Actionmodel.excutionMsg();
			//bet_ob["bet_amount"] -= get_total_bet(bet_ob["betType"]);
			if ( _Bet_info.getValue("self") == null)
			{
				_Bet_info.putValue("self", [bet_ob]);
				
			}
			else
			{
				var bet_list:Array = _Bet_info.getValue("self");
				bet_list.push(bet_ob);
				_Bet_info.putValue("self", bet_list);
			}
			self_show_credit()
			
			//for (var i:int = 0; i < bet_list.length; i++)
			//{
				//var bet:Object = bet_list[i];
				//
				//utilFun.Log("bet_info  = "+bet["betType"] +" amount ="+ bet["bet_amount"] + " idx = " + bet["bet_idx"] );
			//}
		}
		
		private function self_show_credit():void
		{
			var total:Number = get_total_bet(-1);
			
			var credit:int = _model.getValue(modelName.CREDIT);
			_model.putValue("after_bet_credit", credit - total);
			
			
		
		}
		
		public function all_betzone_totoal():Number
		{
			var betzone:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX);
			
			var total:Number = 0;
			for each (var i:int in betzone)
			{
				total +=get_total_bet(i);
			}
			return total;
		}
		
		public function get_total_bet(type:int):Number
		{
			if ( _Bet_info.getValue("self") == null) return 0;
			var total:Number = 0;
			var bet_list:Array = _Bet_info.getValue("self");
			for (var i:int = 0; i < bet_list.length; i++)
			{
				var bet:Object = bet_list[i];
				if ( type == -1)
				{
					total += bet["bet_amount"];
					continue;
				}
				else if( type == bet["betType"])
				{
					total += bet["bet_amount"];
				}
			}
			
			return total;
		}
		
		public function has_Bet_type(type:int):Boolean
		{
			var bet_list:Array = _Bet_info.getValue("self");
			for (var i:int = 0; i < bet_list.length; i++)
			{
				var bet:Object = bet_list[i];
				if ( bet["betType"] == type) return true;				
			}			
			return false;
		}
		
		public function Bet_type_betlist(type:int):Array
		{
			var bet_list:Array = _Bet_info.getValue("self");
			var arr:Array = [];
			for (var i:int = 0; i < bet_list.length; i++)
			{
				var bet:Object = bet_list[i];
				if ( bet["betType"] == type)
				{
					arr.push( bet["bet_amount"]);
				}
			}			
			return arr;
		}
		
		public function bet_zone_amount():Array
		{
			var zone:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX);
			var mylist:Array = [];
			for ( var i:int = 0; i < zone.length; i++)
			{
				mylist.push(0);
			}
			
			var total:int = 0;
			for (  i = 0; i < zone.length; i++)
			{				
				var map:int = _opration.getMappingValue("idx_to_result_idx", zone[i]);
				var amount:int = get_total_bet(zone[i]);
				mylist.splice(map, 1, amount);
				total += amount;
			}
			mylist.push(total);
			return mylist;
		}
		
		public function check_jp():Number
		{
			//var array:Array = _model.getValue("power_jp");
			//for ( var i:int = 0;i< array.length
			//
			//return 
			
			var name_to_idx:DI = _model.getValue("Bet_name_to_idx");
			var check_zone:Array = ["BetBWPlayer", "BetBWBanker"];
					
			var total:Number = 0;
			for ( var i:int = 0; i < check_zone.length ; i++)
			{
				var zone:int = name_to_idx.getValue(check_zone[i]);	
				total += get_total_bet(zone);
			}
			
			return total;
		}
		
		public function get_my_bet_info(type:String):Array
		{
			var arr:Array = _Bet_info.getValue("self");			
			var data:Array = [];
			
			for ( var i:int = 0; i < arr.length ; i++)
			{
				var bet_ob:Object = arr[i];
				if ( type == "table") data.push(bet_ob["betType"]);
				if ( type == "amount") data.push(bet_ob["bet_amount"]);								
			}
			return data;
		}
		
		public function get_my_betlist():Array
		{		
			return _Bet_info.getValue("self");		
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_data_parse():void
		{
			var settle_amount:Array = [];
			var zonebet_amount:Array = [];			
			
			_model.putValue("clean_zone", []);
			_model.putValue("bigwin",null);			
			_model.putValue("win_odd", -1);
			_model.putValue("winstr", "");
			_model.putValue("hit_powerJp", -1);
			
			var total_bet:int = 0;
			var total_settle:int = 0;
			var result_list:Array = _model.getValue(modelName.ROUND_RESULT);
			var betZone:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX);			
			var num:int = result_list.length;	
			for ( var i:int = 0; i < num; i++)
			{
				var resultob:Object = result_list[i];				
				utilFun.Log("bet_type=" + resultob.bet_type  + "  " + resultob.win_state );
				
				var betzon_idx:int = _opration.getMappingValue("Bet_name_to_idx", resultob.bet_type);
				
				check_lost(resultob, betzon_idx);
				check_bingWin(resultob);
				//check_specail(resultob);
				if ( check_powerbar(resultob) ) continue;
				
				//總押注和贏分
				var display_idx:int = _opration.getMappingValue("idx_to_result_idx", betzon_idx);
				settle_amount[ display_idx] =  resultob.settle_amount;				
				zonebet_amount[ display_idx ]  = resultob.bet_amount;				
				total_settle += resultob.settle_amount;
				total_bet += resultob.bet_amount;
			}			
			
			settle_amount.push(total_settle);
			zonebet_amount.push(total_bet);
			
			_model.putValue("result_settle_amount",settle_amount);
			_model.putValue("result_zonebet_amount",zonebet_amount);
			_model.putValue("result_total", total_settle);
			_model.putValue("result_total_bet", total_bet);
			
			utilFun.Log("result_settle_amount =" + settle_amount);
			utilFun.Log("result_zonebet_amount =" + zonebet_amount);
			utilFun.Log("total_settle =" + total_settle);
			utilFun.Log("zonebet_amount =" + zonebet_amount);
			
			if ( _model.getValue("bigwin") != null)
			{
				dispatcher(new ModelEvent("settle_bigwin"));
			}
			else 	if ( _model.getValue("hit_powerJp") != -1)
			{				
				dispatcher(new Intobject(_model.getValue("hit_powerJp"), "power_up"));
			}
			else
			{
				dispatcher(new Intobject(1, "settle_step"));
			}
			
		}
		
		public function check_lost(resultob:Object,betzon_idx:int):void
		{
			if ( resultob.win_state == "WSLost") 
			{
				var clean:Array = _model.getValue("clean_zone");
				clean.push (betzon_idx);
				_model.putValue("clean_zone", clean);				
			}			
		}
		
		public function check_bingWin(resultob:Object):void
		{
			//bigwin condition  type:player,winstat:!WSBWNormalWin && !WSWin
			//winst: winste  odd:result.odds		
			//大獎
			if ( resultob.bet_type == "BetBWPlayer") 
			{						
				//大獎 (排除2對,3條和11以上J對)
				if (  resultob.win_state != "WSBWOnePairBig" &&  
					  resultob.win_state != "WSBWTwoPair" &&
					  resultob.win_state != "WSBWTripple" &&
					  resultob.win_state != "WSBWNormalWin" && 
					  resultob.win_state != "WSLost" )
				{						
					var bigwin:int = _opration.getMappingValue(modelName.BIG_POKER_MSG, resultob.win_state);
					_model.putValue("bigwin", bigwin);
					_model.putValue("winstr", bigwin);
					_model.putValue("win_odd",resultob.odds);
				}				
			}			
		}
		
		public function check_specail(resultob:Object):void
		{
			
		}
		
		public function check_powerbar(resultob:Object):Boolean
		{
			//special condition
			//{"bet_attr": "BetAttrBonus", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetBWBonusTripple", "settle_amount": 0},
			//{"bet_attr": "BetAttrBonus", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetBWBonusTwoPair", "settle_amount": 0}
			var no_recode:Boolean = false;
			if ( resultob.bet_type != "BetBWBonusTwoPair" &&  (resultob.bet_type != "BetBWBonusTripple") ) return no_recode;
			
			var extra:int = resultob.bet_amount * resultob.odds;
			
			var idx:int = 0;// _opration.getMappingValue(modelName.BIG_POKER_MSG, resultob.bet_type);
			if ( resultob.bet_type == "BetBWBonusTwoPair" ) idx = 0;
			if ( resultob.bet_type == "BetBWBonusTripple" ) idx = 1;
			if ( extra > 0)
			{
				var array:Array = _model.getValue("power_jp");
				array[idx] = extra;
				_model.putValue("hit_powerJp", idx);				
			}
			
			no_recode = true;
			return no_recode;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function Clean_bet():void
		{
			save_bet();
			_Bet_info.clean();			
			
			_Bet_info.putValue("self", [] ) ;
		}
		
		public function save_bet():void
		{
			var bet_list:Array = _Bet_info.getValue("self");
			utilFun.Log("save_bet bet_list  = "+bet_list.length );
			if ( bet_list.length ==0) return;
			_model.putValue("history_bet", bet_list);
		}
		
		public function clean_hisotry_bet():void
		{
			_model.putValue("history_bet", []);
			dispatcher(new ModelEvent("can_not_rebet"));
		}
		
		public function need_rebet():Boolean
		{
			var bet_list:Array  = _model.getValue("history_bet");			
			if ( bet_list.length ==0) return false;
			
			return true;
		}
		
		public function re_bet():void
		{
			var bet_list:Array  = _model.getValue("history_bet");
			
			utilFun.Log("check bet_list  = " + bet_list );
			if ( bet_list == null) return;
			
			//與賓果不同,同一注區會分多筆,必需要等上一筆注單確認,再能再下第二筆,不然total_bet_amount,值會錯
			utilFun.Log("bet_list  = " + bet_list.length );
			if ( bet_list.length != 0)
			{			
				var coin_list:Array = _model.getValue("coin_list");
				var bet:Object = bet_list[0];				
				var mybet:Object = { "betType": bet["betType"],
													  "bet_idx":bet["bet_idx"],
														"bet_amount": coin_list[ bet["bet_idx"]],
														"total_bet_amount": (get_total_bet( bet["betType"]) +coin_list[ bet["bet_idx"]])
				};
			
				utilFun.Log("bet_info  = " + mybet["betType"] +" amount =" + mybet["bet_amount"] + " idx = " + bet["bet_idx"] +" total_bet_amount " +  (get_total_bet( bet["betType"]) +coin_list[ bet["bet_idx"]])  );
				bet_list.shift();
				_model.putValue("history_bet",bet_list);
				dispatcher( new ActionEvent(mybet, "bet_action"));
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));
			}
		}
		
	}

}