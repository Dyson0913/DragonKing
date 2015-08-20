package View.ViewComponent 
{
	import flash.events.Event;
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
	
	/**
	 * bet coin  & coin present way
	 * @author ...
	 */
	public class Visual_Coin  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _regular:RegularSetting;
		
			
		[Inject]
		public var _Actionmodel:ActionQueue;
		
		public function Visual_Coin() 
		{
			
		}
		
		public function init():void
		{
			var avaliblezone:Array = _model.getValue(modelName.AVALIBLE_ZONE);
			
			//select bet coin
			var coinob:MultiObject = prepare("CoinOb", new MultiObject(), GetSingleItem("_view").parent.parent);
			coinob.container.x = 640;
			coinob.container.y = 910;
			coinob.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,2,0]);
			coinob.CustomizedFun = _regular.FrameSetting;
			coinob.CustomizedData = [1, 1, 1, 1, 1];
			//coinob.Posi_CustzmiedFun = _regular.Posi_y_Setting;
			//coinob.Post_CustomizedData = [0,10,20,10,0];
			coinob.Create_by_list(5,  [ResName.coin1,ResName.coin2,ResName.coin3,ResName.coin4,ResName.coin5], 0 , 0, 5, 130, 0, "Coin_");
			coinob.rollout = excusive_select_action;
			coinob.rollover = excusive_select_action;
			coinob.mousedown = betSelect;
			coinob.ItemList[0].y -= 20;
			coinob.ItemList[0].gotoAndStop(2);
			
			//stick cotainer  
			var coinstack:MultiObject = prepare("coinstakeZone", new MultiObject(), GetSingleItem("_view").parent.parent);	
			coinstack.container.x = 366;
			coinstack.container.y = 602;
			coinstack.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			coinstack.Post_CustomizedData =  [[183,128],[729,122]]
			coinstack.Create_by_list(avaliblezone.length, [ResName.emptymc], 0, 0, avaliblezone.length, 0, 0, "time_");
			
			//_tool.SetControlMc(coinstack.ItemList[1]);
			//_tool.SetControlMc(coinstack.container);
			//add(_tool);
			
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_poker():void
		{
			var a:MultiObject = Get("coinstakeZone");
			for ( var i:int = 0; i <  a.ItemList.length; i++)
			{
				utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone",i));
			}
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display_coin():void
		{
			var a:MultiObject = Get("CoinOb");			
			_regular.Fadeout(a.container, 0, 1);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function hide_coin():void
		{
			var a:MultiObject = Get("CoinOb");
			_regular.FadeIn(a.container as MovieClip, 0, 1,null);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "updateCoin")]
		public function updateCredit():void
		{			
			var bet_ob:Object = _Actionmodel.excutionMsg();			
			_Actionmodel.dropMsg();
			//coin動畫
			if (bet_ob["betType"]  == CardType.BET_PLAYER )
			{				
				
				stack(_betCommand.Bet_type_betlist(CardType.BET_PLAYER), GetSingleItem("coinstakeZone"));
			}
			
			 if ( bet_ob["betType"]  ==CardType.BET_BANKER ) 
			{					
				stack(_betCommand.Bet_type_betlist(CardType.BET_BANKER), GetSingleItem("coinstakeZone",1));
			}			
			//
			//if ( _betCommand.has_Bet_type(CardType.Tie))
			//{			
				//stack(_betCommand.Bet_type_betlist(CardType.Tie), GetSingleItem("coinstakeZone",2));
			//}			
		}		
		
		public function stack(coinarr:Array,contain:DisplayObjectContainer):void
		{
			utilFun.Log("coinarr"+coinarr);
			utilFun.Clear_ItemChildren(contain);
			var coin:Array = [];
			var shY:int = 0;
			var shX:int = 0;
			var coinshY:int = -5;
			var player:Array = [0, -5, -10, -5, 0];
			var b:Array = [0, 10, 20, 35, 60];
			var t:Array = [0, 5, 10, 5, 0];
			for (var i:int = 0; i < 5; i++)
			{
				//if ( contain == GetSingleItem("coinstakeZone",2))
				//{					
					//shY = t[i];
					//shX = 60;
					//coinshY = -5;
				//}
				//else
				if ( contain == GetSingleItem("coinstakeZone",1))
				{				
					shY = player[i];
					shX = 50;
				}
				else if ( contain == GetSingleItem("coinstakeZone"))
				{				
					shY = player[i];
					shX = 50;
				}
				
				coin.length = 0;
				//每疊coin 的multiobject
				createcoin(i, coin, coinarr.concat(), contain,shY,shX,coinshY);
			}			
		}	
		
		public function createcoin(cointype:int, coin:Array, coinstack:Array, contain:DisplayObjectContainer ,shY:int,shX:int,coinshY:int):void
		{			
			coin.length = 0;
			while (coinstack.indexOf(_model.getValue("coin_list")[cointype]) != -1)
			{
				var idx:int = coinstack.indexOf( _model.getValue("coin_list")[cointype]);
				coin.push(coinstack[idx]);
				coinstack.splice(idx, 1);
			}
			
			
			var shifty:int = 0;
			var shiftx:int = 0;
			
			var secoin:MultiObject = new MultiObject()
			secoin.CleanList();
			//if ( contain == GetSingleItem("coinstakeZone",2))
			//{				
				secoin.CustomizedFun = coinput;
				secoin.CustomizedData = coin;
			//}
			
			secoin.Create( coin.length, "coin_"+(cointype+1) , 0 +shiftx+ (cointype * shX) , 0+shifty +shY, 1, 0, coinshY, "Bet_",  contain);			
		}
		
		public function coinput(mc:MovieClip, idx:int, coinstack:Array):void
		{
			//utilFun.Log("coinstack = "+coinstack);
			//utilFun.Log("coinstack[0] = "+coinstack[0]);
			//utilFun.Log("coinstack.length = "+coinstack.length);
			utilFun.scaleXY(mc, 0.5, 0.5);
			mc.gotoAndStop(3);
			mc["_text"].text = "";
			if ( idx == coinstack.length -1) 
			{
				var total:int = coinstack[0] * coinstack.length;
				mc["_text"].text = total.toString();
			}
			
		}	
		
		public function excusive_select_action(e:Event, idx:int):Boolean
		{
			var select:int = _model.getValue("coin_selectIdx");
			if ( idx == select) return false;
			else return true;
		}
		
		public function betSelect(e:Event, idx:int):Boolean
		{			
			utilFun.Log("betselect = " + idx);
			var old_select:int = _model.getValue("coin_selectIdx");
			
			_model.putValue("coin_selectIdx", idx);		
			var coinob:MultiObject = Get("CoinOb");			
			
			//position chagne 
			for (var i:int = 0; i < coinob.ItemList.length; i++)
			{
				if ( i == old_select ) 
				{				
					coinob.ItemList[old_select].y += 20;					
				}
				if ( i == idx)
				{					
					coinob.ItemList[idx].y -= 20;				
				}
			}
			
			//frame change
			coinob.exclusive(idx,1);
			
			
			return true;
		}
	}

}