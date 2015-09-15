package View.ViewComponent 
{
	import asunit.framework.Assert;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
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
		public var _paytable:Visual_Paytable;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _gameinfo:Visual_Game_Info;
		
		public function Visual_Settle() 
		{
			
		}
		
		public function init():void
		{
			var zoneCon:MultiObject = prepare("zone", new MultiObject(), GetSingleItem("_view").parent.parent);
			zoneCon.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			zoneCon.Post_CustomizedData = [[0, 0], [980, 0], [550, 0]];
			zoneCon.Create_by_list(3, [ResName.playerScore, ResName.bankerScore,ResName.TieScore], 0 , 0, 3, 500, 0, "Bet_");					
			zoneCon.container.x = 390;
			zoneCon.container.y = 430;
			
			var bigwinfire:MultiObject = prepare("bigwinfire", new MultiObject(), GetSingleItem("_view").parent.parent);
			bigwinfire.Create_by_list(1, [ResName.bigwinfire], 0 , 0, 1, 0, 0, "Bet_");			
			bigwinfire.container.x = 620;
			bigwinfire.container.y = 240;			
			
			var bigwinCon:MultiObject = prepare("bigwinmsg", new MultiObject(), GetSingleItem("_view").parent.parent);
			bigwinCon.Create_by_list(1, [ResName.Bigwinmsg], 0 , 0, 1, 0, 0, "Bet_");			
			bigwinCon.container.x = 981;
			bigwinCon.container.y = 420;		
			
			var settletable:MultiObject = prepare("settletable", new MultiObject(), GetSingleItem("_view").parent.parent);		
			settletable.Create_by_list(1, [ResName.settletable], 0 , 0, 1, 0, 0, "Bet_");		
			settletable.container.x = 588;
			settletable.container.y = 425;
			settletable.container.visible = false;
			
			var settletable_title:MultiObject = prepare("settletable_title", new MultiObject(), settletable.container);		
			settletable_title.container.x = 70;
			settletable_title.container.y = 40;
			settletable_title.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			settletable_title.Post_CustomizedData = [[0,0],[280,0],[480,0]];
			settletable_title.CustomizedFun = _gameinfo.textSetting;
			settletable_title.CustomizedData = [[24], "投注內容","開牌結果","得分"];
			settletable_title.Create_by_list(3, [ResName.TextInfo], 0 , 0, 3, 200, 0, "Bet_");		
			
			var settletable_zone:MultiObject = prepare("settletable_zone", new MultiObject(), settletable.container);		
			settletable_zone.container.x = 70;
			settletable_zone.container.y = 90;		
			settletable_zone.CustomizedFun = _gameinfo.textSetting;
			settletable_zone.CustomizedData = [[24], "莊","閒","莊對","閒對","特殊牌型","和","合計"];
			settletable_zone.Create_by_list(7, [ResName.TextInfo], 0 , 0, 1, 0, 50, "Bet_");		
			
			var settletable_zone_bet:MultiObject = prepare("settletable_zone_bet", new MultiObject(), settletable.container);		
			settletable_zone_bet.container.x = 200;
			settletable_zone_bet.container.y = 90;		
			settletable_zone_bet.CustomizedFun = _gameinfo.textSetting;
			settletable_zone_bet.CustomizedData = [[24], "100","100","1000","0","200","100000"];
			settletable_zone_bet.Create_by_list(6, [ResName.TextInfo], 0 , 0, 1, 0, 50, "Bet_");		
			
			
			var settletable_zone_settle:MultiObject = prepare("settletable_zone_settle", new MultiObject(), settletable.container);		
			settletable_zone_settle.container.x = 550;
			settletable_zone_settle.container.y = 90;		
			settletable_zone_settle.CustomizedFun = colortextSetting;
			settletable_zone_settle.CustomizedData = [[24,TextFormatAlign.RIGHT], "0","0","1000","0","0","100000","10000"];
			settletable_zone_settle.Create_by_list(7, [ResName.TextInfo], 0 , 0, 1, 0, 50, "Bet_");		
			
			var settletable_desh:MultiObject = prepare("settletable_desh", new MultiObject(), settletable.container);		
			settletable_desh.container.x = 40;
			settletable_desh.container.y = 364;		
			settletable_desh.CustomizedFun = _gameinfo.textSetting;
			settletable_desh.CustomizedData = [[24],"---------------------------------------------------------"];
			settletable_desh.Create_by_list(1, [ResName.TextInfo], 0 , 0, 1, 7, 0, "Bet_");		
			//settletable_desh.container.visible = false;
			
			
			var result_pai:MultiObject = prepare("result_pai", new MultiObject(), settletable.container);		
			result_pai.container.x = 328;
			result_pai.container.y = 130;			
			result_pai.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			result_pai.Post_CustomizedData = [[0,0],[54,0],[133,0]];
			result_pai.CustomizedFun = _gameinfo.textSetting;
			result_pai.CustomizedData = [[24], "閒","公牌","莊"];
			result_pai.Create_by_list(3, [ResName.TextInfo], 0 , 0, 3, 50, 0, "Bet_");		
			
			//開牌結果
			_model.putValue("result_Pai_list", ["1d","2d","3d","4d","5d","6d"]);
			var historyPai_model:Array = _model.getValue("result_Pai_list");			
			var history_play_pai:MultiObject = prepare("history_Pai_list", new MultiObject() , settletable.container);
			history_play_pai.CustomizedFun = sprite_idx_setting_player;			
			history_play_pai.CustomizedData = historyPai_model;			
			history_play_pai.container.x = 320;
			history_play_pai.container.y = 166;
			history_play_pai.Create_by_bitmap(historyPai_model.length, utilFun.Getbitmap("poker_atlas"), 0, 0, 6, 22, 25, "o_");		
			
			_model.putValue("result_str_list", []);
			var historystr_model:Array = _model.getValue("result_str_list");			
			var result_str_list:MultiObject = prepare("result_str_list", new MultiObject() , settletable.container);
			result_str_list.CustomizedFun =_gameinfo.textSetting;
			result_str_list.CustomizedData =[[16],historystr_model.join("、")];	
			result_str_list.container.x = 317;
			result_str_list.container.y = 194;
			result_str_list.Create_by_list(1, [ResName.TextInfo], 0 , 0,1,0 , 0, "Bet_");		
			
			_tool.SetControlMc(bigwinCon.container);
			//_tool.SetControlMc(result_pai.ItemList[2]);
			add(_tool);
			Clean();
		}
		
		public function colortextSetting(mc:MovieClip, idx:int, data:Array):void
		{			
			var str:TextField = dynamic_text(data[idx+1],data[0]);			
			mc.addChild(str);
		}
		
		public function dynamic_text(text:String,para:Array):TextField
		{	
			//utilFun.Log("para = " + para);			
			//utilFun.Log("para [1]= " + para[1]);			
			//utilFun.Log("para [1]= " + typeof(para[1]) );		
			//TODO cant set alig
			var size:int = para[0];
			var textColor:uint = 0xFFFFFF;
			var align:String = TextFormatAlign.LEFT;			
			if ( parseInt( text) > 0) textColor= 0x00FF33;
			if ( parseInt( text) < 0) textColor= 0xFF0000;		
			//if ( para.length > 1)
			//{
				//align = para[1].toString();
			//}
			
			var _NickName:TextField = new TextField();
			_NickName.width = 626.95;
			_NickName.height = 134;
			_NickName.textColor = textColor;
			_NickName.selectable = false;		
			_NickName.autoSize = TextFieldAutoSize.LEFT;				
			_NickName.wordWrap = true; //auto change line
			_NickName.multiline = true; //multi line
			_NickName.maxChars = 300;
			//"微軟正黑體"
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = size;
			myFormat.align = align;
			myFormat.font = "Microsoft JhengHei";			
			
			_NickName.defaultTextFormat = myFormat;				
			_NickName.text = text;			
			return _NickName;
		}
		
		public function sprite_idx_setting_player(mc:*, idx:int, data:Array):void
		{			
			var code:int  = pokerUtil.pokerTrans_s(data[idx]);
						
			var history_win:Array = _model.getValue("result_Pai_list");
			
			var shif:int = 0;
			if ( idx % 2 == 1 ) shif = -10;
			mc.x = (idx % 6 * 33	) + shif;						
			//mc.y = ( Math.floor(idx / 6) * 33);	
			//押暗
			//if ( history_win[Math.floor(idx / 5)] != ResName.angelball) mc.alpha =  0.5;			
			mc.drawTile(code);		
		
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean():void
		{
			Get("zone").container.visible = false;			
			
			var a:MultiObject = Get("zone");
			for ( var i:int = 0; i <  a.ItemList.length; i++)
			{
				GetSingleItem("zone", i).visible = false;
				GetSingleItem("zone", i).gotoAndStop(1);
			}
			
			Get("settletable").container.visible = false;			
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
			var bigpokermapping:DI = _model.getValue(modelName.BIG_POKER_MSG);
			var pokerstr:DI = _model.getValue(modelName.BIG_POKER_TEXT);
			var bigwin:int = -1;
			
			var result_str:Array = [];
			var settle_amount:Array = [0,0,0,0,0,0];
			var zonebet_amount:Array = [0, 0, 0, 0, 0, 0];			
			var total:int = 0;
			
			var playerwin:int = 0;
			var bankerwin:int = 0;
			var winst:String = "";
			
			var clean:Array = [];
			for ( var i:int = 0; i < num; i++)
			{
				var resultob:Object = result_list[i];
				utilFun.Log("resultob =" + resultob.win_state);
				
				//coin 清除區
				if ( resultob.win_state == "WSLost") clean.push (name_to_idx.getValue(resultob.bet_type));
				else
				{
					//大獎
					if ( resultob.win_state != "WSBWNormalWin")
					{
						bigwin = bigpokermapping.getValue( resultob.win_state);
						result_str.push(pokerstr.getValue(resultob.win_state));		
						winst = resultob.win_state;
					}
					
					if ( resultob.bet_type == "BetBWPlayer" ) 
					{
						playerwin = 1;						
						if( bigwin == -1) result_str.push("閒贏");
					}
					else if ( resultob.bet_type == "BetBWBanker") 
					{
						bankerwin = 1;						
						if( bigwin == -1) result_str.push("莊贏");
					}
				}
				
				//總押注和贏分
				settle_amount[ idx_to_result_idx.getValue( name_to_idx.getValue(resultob.bet_type) )] =  resultob.settle_amount;
				zonebet_amount[ idx_to_result_idx.getValue( name_to_idx.getValue(resultob.bet_type)) ]  = resultob.bet_amount;
				total += resultob.settle_amount;
			}
			
			_model.putValue("result_settle_amount",settle_amount);
			_model.putValue("result_zonebet_amount",zonebet_amount);
			_model.putValue("result_total", total);
			_model.putValue("result_str_list", result_str);
			
			var wintzone:Array = utilFun.Get_restItem(betZone, clean);
			//utilFun.Log("clean zone =" + clean);
			//utilFun.Log("wintzone =" + wintzone);
			//utilFun.Log("result_settle_amount =" + settle_amount);
			//utilFun.Log("result_zonebet_amount =" + zonebet_amount);
			//utilFun.Log("result_total =" + total);
			//utilFun.Log("bigwin =" + bigwin);
			//utilFun.Log("result_str =" + result_str);
			
			//贏分注區閃爍
			for ( var i:int = 0; i < wintzone.length; i++)
			{
				//utilFun.Log("wintzone[i]  =" + wintzone[i] );
				_regular.Twinkle(GetSingleItem("betzone", wintzone[i] ), 3, 10, 2);	
			}
			
			//輸分收
			for ( var i:int = 0; i < clean.length; i++)
			{
				//utilFun.Log("wintzone[i]  =" + wintzone[i] );
				utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone",  clean[i]));				
			}
			
			//大獎
			if ( bigwin!=-1)
			{				
				GetSingleItem("bigwinmsg").gotoAndStop(bigwin);
				GetSingleItem("bigwinfire").gotoAndPlay(2);				
				//_regular.FadeIn( GetSingleItem("bigwinmsg"), 2, 2, _regular.Fadeout);
				utilFun.scaleXY(GetSingleItem("bigwinmsg"), 0, 0);
				Tweener.addTween(GetSingleItem("bigwinmsg"), { scaleX: 1.2,scaleY:1.2, time:0.5,transition:"linear",onCompleteParams:[GetSingleItem("bigwinmsg")],onComplete:rubber_out } );
				//Tweener.addTween(GetSingleItem("bigwinmsg"), { scaleX: 0.8,scaleY:0.8, time:0.5,transition:"easeOutCubic" } );
				//_regular.rubber_effect(GetSingleItem("bigwinmsg"), 1, 1, 0.4, 0.4, _regular.rubber_effect);
			}
				
			//patytable提示框
			//if( _betCommand.get_my_betlist().length !=0)
			//{
				//_regular.Call(Get("coinstakeZone").container, { onComplete:this.start_settle }, 1, 2);
				utilFun.Log("winst = "+winst);
				_paytable.win_frame_hint(winst);
			//}		
			
			//歷史記錄
			history_add(playerwin, bankerwin);
			
			//結算表
			//show_settle();			
		}
		
		public function rubber_out(mc:MovieClip):void
		{
			Tweener.addTween(mc, { scaleX: 0.8,scaleY:0.8, time:0.5,transition:"linear",onCompleteParams:[mc],onComplete:rubber_over } );
		}
		
		public function rubber_over(mc:MovieClip):void
		{
			Tweener.addTween(mc, { scaleX: 1,scaleY:1, time:0.5,transition:"linear" } );
		}
		
		public function history_add(playerwin:int, bankerwin:int):void
		{
			//history recode 
			utilFun.Log("playerwin  =  " + playerwin +" bankerwin  =  " + bankerwin);	
			var arr:Array = _model.getValue("history_win_list");
			if ( !playerwin && !bankerwin) 
			{
				arr.push(ResName.Noneball);
			}
			else 
			{
				if ( playerwin == 1) arr.push(ResName.angelball);
				else if ( bankerwin == 1) arr.push(ResName.evilball);
			}
			
			utilFun.Log("arr = "+arr);
			if ( arr.length > 60) arr.shift();			
			_model.putValue("history_win_list",arr);
			_paytable.history_display(1);
		}
		
		public function show_settle():void
		{
			var settletable:MultiObject = Get("settletable");
			settletable.container.visible = true;
			
			//押注
			var zone_amount:Array = _model.getValue("result_zonebet_amount");			
			var font:Array = [[24]];
			font = font.concat(zone_amount);			
			Get("settletable_zone_bet").CustomizedFun = _gameinfo.textSetting;
			Get("settletable_zone_bet").CustomizedData = font;
			Get("settletable_zone_bet").Create_by_list(6, [ResName.TextInfo], 0 , 0, 1, 0, 50, "Bet_");		
			
			//總結
			var settle_amount:Array = _model.getValue("result_settle_amount");			
			var font2:Array = [[24,TextFormatAlign.RIGHT]];
			font2 = font2.concat(settle_amount);		
			font2 = font2.concat( _model.getValue("result_total"));
			utilFun.Log("font2 = "+font2);
			Get("settletable_zone_settle").CustomizedFun = colortextSetting;
			Get("settletable_zone_settle").CustomizedData = font2;
			Get("settletable_zone_settle").Create_by_list(7, [ResName.TextInfo], 0 , 0, 1, 0, 50, "Bet_");				
			
			//小 poker
			var ppoker:Array =   _model.getValue(modelName.PLAYER_POKER);
			var bpoker:Array =   _model.getValue(modelName.BANKER_POKER);
			var rpoker:Array =   _model.getValue(modelName.RIVER_POKER);
			
			var totalPoker:Array = [];			
			totalPoker = totalPoker.concat(ppoker);			
			totalPoker = totalPoker.concat(rpoker);
			totalPoker = totalPoker.concat(bpoker);
			_model.putValue("result_Pai_list", totalPoker);
			var historyPai_model:Array = _model.getValue("result_Pai_list");					
			Get("history_Pai_list").CustomizedFun = sprite_idx_setting_player;			
			Get("history_Pai_list").CustomizedData = historyPai_model;			
			Get("history_Pai_list").Create_by_bitmap(historyPai_model.length, utilFun.Getbitmap("poker_atlas"), 0, 0, 6, 22, 25, "o_");		
			
			
			//小牌結果
			var historystr_model:Array = _model.getValue("result_str_list");						
			Get("result_str_list").CustomizedFun =_gameinfo.textSetting;
			Get("result_str_list").CustomizedData =[[16],historystr_model.join("、")];				
			Get("result_str_list").Create_by_list(1, [ResName.TextInfo], 0 , 0,1,0 , 0, "Bet_");		
			
			
			
			//var settletable:MultiObject = Get("settletable");
			//settletable.container.visible = true;
		}	
		
		private function countPoint(poke:Array):int
		{
			var total:int = 0;
			for (var i:int = 0; i < poke.length ; i++)
			{
				var strin:String =  poke[i];
				var arr:Array = strin.match((/(\w|d)+(\w)+/));					
				var numb:String = arr[1];				
				
				var point:int = 0;
				if ( numb == "i" || numb == "j" || numb == "q" || numb == "k" ) 				
				{
					point = 10;
				}				
				else 	point = parseInt(numb);
				
				total += point;
			}	
			
			return total %= 10;
		}		
		
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="show_judge")]
		public function early_check_point(type:Intobject):void
		{
			var Mypoker:Array =   _model.getValue(type.Value);
			
			if ( Mypoker.length == 2 )
			{				
				var point:Array = utilFun.arrFormat(countPoint(Mypoker), 1);
				if ( point[0] == 0 ) point[0] = 10;				
				var zone:int = -1;
				if ( modelName.PLAYER_POKER == type.Value)  zone = 0;
				else if ( modelName.BANKER_POKER == type.Value) zone = 1;				
				if ( zone == -1) return;
				Get("zone").container.visible = true;
				GetSingleItem("zone", zone ).visible = true;
				
				GetSingleItem("zone",zone)["_num0"].gotoAndStop(point[0]);					
			}			
		}
		
		
	}
	
	

}