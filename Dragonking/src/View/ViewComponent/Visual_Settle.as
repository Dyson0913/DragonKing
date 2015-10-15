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
			zoneCon.Post_CustomizedData = [[0, 0], [1018, 0], [560, 0]];
			zoneCon.Create_(3, "zone");
			zoneCon.container.x = 358;
			zoneCon.container.y = 560;				
			
			var bigwinfire:MultiObject = create("bigwinfire", [ResName.bigwinfire]);
			bigwinfire.Create_(1, "bigwinfire");
			bigwinfire.container.x = 0;
			bigwinfire.container.y = -90;
			
			var bigwinCon:MultiObject = create("bigwinmsg",  [ResName.Bigwinmsg]);
			bigwinCon.Create_(1, "bigwinmsg");
			bigwinCon.container.x = 981;
			bigwinCon.container.y = 420;		
			
			var PowerJPNum:MultiObject = create("bigwin_JP_num",  [ResName.bigwin_num], bigwinCon.container);			
			
			
			put_to_lsit(zoneCon);
			put_to_lsit(bigwinCon);
			put_to_lsit(bigwinfire);
			put_to_lsit(PowerJPNum);
			
			//_tool.SetControlMc(zoneCon.ItemList[2]);
			//add(_tool);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean():void
		{
			setFrame("zone", 1);
			setFrame("bigwinmsg", 1);
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
			
			var odd:int = -1;
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
						odd = resultob.odds;
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
			_model.putValue("win_odd", odd);
			
			
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
				
				
				var s:String = "x" + _model.getValue("win_odd");;
				var arr:Array = utilFun.frameAdj(s.split(""));				
				//utilFun.Log("arr = "+arr);
				var PowerJPNum:MultiObject = Get("bigwin_JP_num");
				PowerJPNum.container.x = -45 + (( -91 / 2) * (arr.length - 1));
				PowerJPNum.container.y = 160;		
				PowerJPNum.CustomizedData = arr;
				PowerJPNum.CustomizedFun = settlt_FrameSetting;
				PowerJPNum.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
				PowerJPNum.Post_CustomizedData = [arr.length, 91, 0];
				PowerJPNum.Create_(arr.length, "bigwin_JP_num");									
				
				utilFun.scaleXY(Get("bigwinmsg").container,4.0, 4.0);
				Get("bigwinmsg").container.alpha = 0;
				
				Tweener.addTween(Get("bigwinmsg").container, { scaleX: 1, scaleY:1, alpha: 1,time:0.6, transition:"easeInQuart",onComplete:this.ready_to_cunt } );
				
				dispatcher(new StringObject("sound_bigwin_down","sound" ) );
				
				//Tweener.addTween(GetSingleItem("bigwinmsg"), { scaleX: 1.2,scaleY:1.2, time:0.5,transition:"linear",onCompleteParams:[GetSingleItem("bigwinmsg")],onComplete:rubber_out } );
				
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
			dispatcher(new ArrayObject([playerwin, bankerwin,playerPoint,bankerPoint,isTie,isPlayPair,isbankerPair,bigwin],"add_history" ) );			
		}
		
		public function ready_to_cunt():void
		{
			Tweener.addTween(this, {delay:3, transition:"linear",onComplete:this._cunt } );
		}
		
		public function _cunt():void
		{						
			_model.putValue("TotalJP_amoount", _model.getValue("result_total"));
			var s:String = _model.getValue("TotalJP_amoount");
			var arr:Array = utilFun.frameAdj(s.split(""));				
			utilFun.Log("arr = "+arr);
			var PowerJPNum:MultiObject = Get("bigwin_JP_num");
			PowerJPNum.CleanList();
			PowerJPNum.container.x = -45 + (( -91 / 2) * (arr.length - 1));
			PowerJPNum.container.y = 160;		
			PowerJPNum.CustomizedData = arr;
			PowerJPNum.CustomizedFun = settlt_FrameSetting;
			PowerJPNum.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			PowerJPNum.Post_CustomizedData = [arr.length, 91, 0];
			PowerJPNum.Create_(arr.length, "bigwin_JP_num");	
			GetSingleItem("bigwinfire").gotoAndPlay(2);		
			
			//N秒內跑完表
			Tweener.addTween(this, {delay:1, transition:"linear",onComplete:this.num_count } );
		}
		
		public function num_count():void
		{			
			var PowerJPNum:MultiObject = Get("bigwin_JP_num");			
			PowerJPNum.ItemList[PowerJPNum.ItemList.length-1].gotoAndPlay(11);			
			
			Tweener.addCaller(this, { time:2 , count: PowerJPNum.ItemList.length-1 , transition:"easeInQuad", onUpdateParams:[10], onUpdate: this.add_carray } );
			
		}
		
		public function add_carray(amount:int):void
		{
			var total:Number = _model.getValue("TotalJP_amoount");			
			total -= amount;		
			total /= amount;			
			_model.putValue("TotalJP_amoount", total);			
			
			var toIn:int = total;
			var arr:Array = utilFun.frameAdj(toIn.toString().split(""));							
				
			var PowerJPNum:MultiObject = Get("bigwin_JP_num");	
			PowerJPNum.CleanList();
			PowerJPNum.container.x = -45 + (( -91 / 2) * (arr.length - 1));
			PowerJPNum.container.y = 160;
			PowerJPNum.CustomizedData = arr;
			PowerJPNum.CustomizedFun = settlt_FrameSetting;
			PowerJPNum.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			PowerJPNum.Post_CustomizedData = [arr.length, 91, 0];
			PowerJPNum.Create_(arr.length, "bigwin_JP_num");	
			PowerJPNum.ItemList[PowerJPNum.ItemList.length-1].gotoAndPlay(11);			
			
			
			if ( toIn <= 10) 
			{
				utilFun.Log("add carry over");			
				PowerJPNum.ItemList[PowerJPNum.ItemList.length-1].gotoAndStop(10);
				return;
			}
			
			
		}
		
		public function settlt_FrameSetting(mc:MovieClip, idx:int, data:Array):void
		{			
			if ( data[idx] == "x")  data[idx] = 13;
			mc.gotoAndStop(data[idx]);
		}
		
		
		public function showAni():void
		{
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
			//patytable提示框			
			dispatcher(new StringObject(_model.getValue("winstr"), "winstr_hint"));
			
			utilFun.Log("jj " + _opration.getMappingValue(modelName.BIG_POKER_MSG, _model.getValue("winstr")));
			if ( _opration.getMappingValue(modelName.BIG_POKER_MSG, _model.getValue("winstr")) == null)
			{
				//show誰贏
				dispatcher(new Intobject(1, "show_who_win"));		
			}
			
			//結算表
			_regular.Call(this, { onComplete:this.showAni}, 2, 1, 1, "linear");
		}
		
	}
	
	

}