package View.ViewComponent 
{
	import asunit.framework.Assert;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
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
	 * hintmsg present way
	 * @author ...
	 */
	public class Visual_Settle  extends VisualHandler
	{
		[Inject]
		public var _text:Visual_Text;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		public function Visual_Settle() 
		{
			
		}
		
		public function init():void
		{
			var zoneCon:MultiObject = create("zone", [ResName.playerScore, ResName.bankerScore, ResName.TieScore]);
			zoneCon.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			zoneCon.Post_CustomizedData = [[0, 0], [1018, 0], [570, 0]];
			zoneCon.Create_(3, "zone");
			zoneCon.container.x = 358;
			zoneCon.container.y = 560;				
			
			var bigwinfire:MultiObject = prepare("bigwinfire", new MultiObject(), GetSingleItem("_view").parent.parent);
			bigwinfire.Create_by_list(1, [ResName.bigwinfire], 0 , 0, 1, 0, 0, "Bet_");			
			bigwinfire.container.x = 620;
			bigwinfire.container.y = 240;			
			
			var bigwinCon:MultiObject = prepare("bigwinmsg", new MultiObject(), GetSingleItem("_view").parent.parent);
			bigwinCon.Create_by_list(1, [ResName.Bigwinmsg], 0 , 0, 1, 0, 0, "Bet_");			
			bigwinCon.container.x = 981;
			bigwinCon.container.y = 420;		
			
			put_to_lsit(zoneCon);
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean():void
		{			
			//var a:MultiObject = Get("zone");
			//for ( var i:int = 0; i <  a.ItemList.length; i++)
			//{				
				//GetSingleItem("zone", i).gotoAndStop(1);
			//}
			setFrame("zone", 1);
		}
		
		//move to model command to parse ,then send event
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function round_():void
		{
			var result_list:Array = _model.getValue(modelName.ROUND_RESULT);
			var num:int = result_list.length;
			var name_to_idx:DI = _model.getValue("Bet_name_to_idx");
			var idx_to_result_idx:DI = _model.getValue("idx_to_result_idx");
			var betZone:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX);
			var bigwin:int = -1;
			var pigwin:int = -1;
			var sigwin:int = -1;
			
			var result_str:Array = [];
			var settle_amount:Array = [0,0,0,0,0,0];
			var zonebet_amount:Array = [0, 0, 0, 0, 0, 0];			
			var total:int = 0;
			
			var playerwin:int = 0;
			var bankerwin:int = 0;
			var winst:String = "";
			
			var isTie:int = 0;
			var isPlayPair:int = 0;
			var isbankerPair:int = 0;
			
			var playerPoint:int = pokerUtil.ca_point(_model.getValue(modelName.PLAYER_POKER));
			var bankerPoint:int = pokerUtil.ca_point(_model.getValue(modelName.BANKER_POKER));
			var clean:Array = [];
			for ( var i:int = 0; i < num; i++)
			{
				var resultob:Object = result_list[i];				
				utilFun.Log("bet_type=" + resultob.bet_type  + "  " + resultob.win_state + " bigwin= " + bigwin);				
				
				//coin 清除區
				if ( resultob.win_state == "WSLost") clean.push (name_to_idx.getValue(resultob.bet_type));
				else
				{					
					
					if ( resultob.bet_type == "BetBWPlayer" ) 
					{
						playerwin = 1;
						//大獎
						if ( resultob.win_state != "WSBWNormalWin" && resultob.win_state !="WSWin")
						{						
							bigwin = _opration.getMappingValue(modelName.BIG_POKER_MSG, resultob.win_state)		
							if( pigwin != bigwin) result_str.push( _opration.getMappingValue(modelName.BIG_POKER_TEXT, resultob.win_state) );						
						}
						else result_str.push("閒贏");
						winst = resultob.win_state;
					}
					if ( resultob.bet_type == "BetBWBanker") 
					{
						bankerwin = 1;						
						//大獎
						if ( resultob.win_state != "WSBWNormalWin" && resultob.win_state !="WSWin")
						{						
							pigwin = _opration.getMappingValue(modelName.BIG_POKER_MSG, resultob.win_state)		
							if( pigwin != bigwin) result_str.push( _opration.getMappingValue(modelName.BIG_POKER_TEXT, resultob.win_state) );						
						}
						else result_str.push("莊贏");
						winst = resultob.win_state;
					}
					
					if ( resultob.bet_type == "BetBWTiePoint" ) 
					{
						isTie = 1;
						result_str.push("和");
					}
					if ( resultob.bet_type == "BetBWPlayerPair" ) isPlayPair = 1;
					if ( resultob.bet_type == "BetBWBankerPair" ) isbankerPair = 1;
					if ( resultob.bet_type == "BetBWSpecial" ) 
					{						
						
						sigwin = _opration.getMappingValue(modelName.BIG_POKER_MSG, resultob.win_state)		
						if( sigwin != bigwin) result_str.push( _opration.getMappingValue(modelName.BIG_POKER_TEXT, resultob.win_state) );	
					}
					
				}
				
				//總押注和贏分
				settle_amount[ idx_to_result_idx.getValue( name_to_idx.getValue(resultob.bet_type) )] =  resultob.settle_amount;
				zonebet_amount[ idx_to_result_idx.getValue( name_to_idx.getValue(resultob.bet_type)) ]  = resultob.bet_amount;
				total += resultob.settle_amount;
			}
			
			if( sigwin == -1) result_str.push("無特殊牌型");
			
			
			
			_model.putValue("result_settle_amount",settle_amount);
			_model.putValue("result_zonebet_amount",zonebet_amount);
			_model.putValue("result_total", total);
			_model.putValue("result_str_list", result_str);
			_model.putValue("winstr", winst);
			
			var wintzone:Array = utilFun.Get_restItem(betZone, clean);
			//utilFun.Log("clean zone =" + clean);
			//utilFun.Log("wintzone =" + wintzone);
			//utilFun.Log("result_settle_amount =" + settle_amount);
			//utilFun.Log("result_zonebet_amount =" + zonebet_amount);
			//utilFun.Log("result_total =" + total);
			//utilFun.Log("bigwin =" + bigwin);
			//utilFun.Log("result_str =" + result_str);
			
			//大獎 (排除2對,3條和11以上J對)
			if ( bigwin!=-1 && bigwin >=2)
			{				
				dispatcher(new StringObject("sound_bigPoker","sound" ) );
				GetSingleItem("bigwinmsg").gotoAndStop(bigwin);
				GetSingleItem("bigwinfire").gotoAndPlay(2);				
				//_regular.FadeIn( GetSingleItem("bigwinmsg"), 2, 2, _regular.Fadeout);
				//utilFun.scaleXY(GetSingleItem("bigwinmsg"), 0, 0);
				Tweener.addTween(GetSingleItem("bigwinmsg"), { scaleX: 1.2,scaleY:1.2, time:0.5,transition:"linear",onCompleteParams:[GetSingleItem("bigwinmsg")],onComplete:rubber_out } );
				//Tweener.addTween(GetSingleItem("bigwinmsg"), { scaleX: 0.8,scaleY:0.8, time:0.5,transition:"easeOutCubic" } );
				//_regular.rubber_effect(GetSingleItem("bigwinmsg"), 1, 1, 0.4, 0.4, _regular.rubber_effect);
			}
			else
			{
				//2對,3條集氣吧
				//if ( sigwin == 0 || sigwin == 1) dispatcher(new Intobject(sigwin, "power_up"));			
				if ( _betCommand.check_jp() > 0 && (sigwin ==1 || sigwin ==0)) dispatcher(new Intobject(sigwin, "power_up"));
				else settle(new Intobject(1, "settle_step"));
			}
			
			//歷史記錄
			history_add(playerwin, bankerwin,playerPoint,bankerPoint,isTie,isPlayPair,isbankerPair,bigwin);
		}
		
		public function showAni():void
		{
			GetSingleItem("bigwinmsg").gotoAndStop(1);
			
			//TODO settle panel
			dispatcher(new ModelEvent("show_settle_table"));
		}
		
		public function rubber_out(mc:MovieClip):void
		{
			Tweener.addTween(mc, { scaleX: 0.8,scaleY:0.8, time:0.5,transition:"linear",onCompleteParams:[mc],onComplete:rubber_over } );
		}
		
		public function rubber_over(mc:MovieClip):void
		{
			Tweener.addTween(mc, { scaleX: 1, scaleY:1, time:0.5, transition:"linear" } );		
			
			settle(new Intobject(1, "settle_step"));
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="settle_step")]
		public function settle(v:Intobject):void
		{
			//show誰贏
			dispatcher(new Intobject(1, "show_who_win"));			
			
			//patytable提示框			
			dispatcher(new StringObject(_model.getValue("winstr"), "winstr_hint"));
			
			//結算表
			_regular.Call(this, { onComplete:this.showAni}, 2, 1, 1, "linear");
		}
		
		public function history_add(playerwin:int, bankerwin:int,playPoint:int,bankerPoint:int,isTie:int ,isPlayPair:int,isbankerPair:int,bigwin:int):void
		{
			//history recode 
			//utilFun.Log("playerwin  =  " + playerwin +" bankerwin  =  " + bankerwin);	
			//utilFun.Log("playerwin  =  " + playPoint +" bankerwin  =  " + bankerPoint);	
			var history:Array = _model.getValue("history_win_list");
			var arr:Array = [];
			if ( bigwin != -1)
			{
				//寫字大獎
				arr.push(5);
				arr.push(playPoint);					
			}
			else if ( !playerwin && !bankerwin) 
			{
				//TIE
				arr.push(4);
				arr.push(playPoint);
			}
			else
			{
				if ( playerwin == 1) 
				{
					arr.push(2);
					arr.push(playPoint);
				}
				else if ( bankerwin == 1) 
				{
					arr.push(3);
					arr.push(bankerPoint);
				}
				//else if ( isTie == 1) 
				//{
					//arr.push(4);
					//arr.push(bankerPoint);
				//}
			}
			
			arr.push(isPlayPair);
			arr.push(isbankerPair);
			arr.push(bigwin);
						
			history.push(arr);
			//utilFun.Log("history = " + arr);
			if ( history.length > 60) history.shift();			
			_model.putValue("history_win_list", history);			
			
			
		}
		
	}
	
	

}