package Command 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.events.Event;
	import Model.*;
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
			Clean_bet();					
		}
		
		public function bet_init():void
		{
			_model.putValue("coin_selectIdx", 0);
			_model.putValue("coin_list", [100, 500, 1000, 5000, 10000]);
			_model.putValue("after_bet_credit", 0);
			
			//閒對,閒,和,莊,莊對
			var betzone:Array = [0, 1 ];// 2, 3, 4, 5];			
			var betzone_name:Array = ["BetBWPlayer", "BetBWBanker", "BetBWTie", "BetBWBankerPair", "BetBWPlayerPair", "BetBWSpecial"];
			
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
			_idx_to_result_idx.putValue("2", 5);
			_idx_to_result_idx.putValue("3", 2);
			_idx_to_result_idx.putValue("4", 3);
			_idx_to_result_idx.putValue("5", 4);
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
						
			_model.putValue(modelName.AVALIBLE_ZONE_XY,  [[0, 0], [644, 3], [420, 100], [730, -72], [128, -66], [469, 2]]);
			_model.putValue(modelName.COIN_STACK_XY,   [ [30, 0], [670, -10],  [360, 53], [640, -110], [50, -120], [360, -62]]);
			
			var poermapping:DI = new DI();			
			poermapping.putValue("WSBWStraight", 2);
			poermapping.putValue("WSBWFlush", 3);
			poermapping.putValue("WSBWFullHouse", 4);
			poermapping.putValue("WSBWFourOfAKind", 5);
			poermapping.putValue("WSBWStraightFlush", 6);
			poermapping.putValue("WSBWRoyalFlush", 7);
			_model.putValue(modelName.BIG_POKER_MSG , poermapping);
			
			var poer_msg:DI = new DI();		
			poer_msg.putValue("WS_Twopair", "兩對");
			poer_msg.putValue("WS_Three", "三條");
			poer_msg.putValue("WSBWStraight", "順子");
			poer_msg.putValue("WSBWFlush", "同花");
			poer_msg.putValue("WSBWFullHouse", "葫蘆");
			poer_msg.putValue("WSBWFourOfAKind", "四條");
			poer_msg.putValue("WSBWStraightFlush", "同花順");
			poer_msg.putValue("WSBWRoyalFlush", "同花大順");
			_model.putValue(modelName.BIG_POKER_TEXT , poer_msg);
			
			
			_Bet_info.putValue("self", [] ) ;
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
			//var bet_list:Array = _Bet_info.getValue("self");
			//for (var i:int = 0; i < bet_list.length; i++)
			//{
				//var bet:Object = bet_list[i];
				//
				//utilFun.Log("bet_info  = "+bet["betType"] +" amount ="+ bet["bet_amount"]);
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
			var betzone:Array = _model.getValue(modelName.BET_ZONE);
			
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
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_bet():void
		{
			_Bet_info.clean();
			_Bet_info.putValue("self", [] ) ;
		}
	}

}