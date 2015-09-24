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
			zoneCon.Post_CustomizedData = [[0, 0], [1020, 0], [550, 0]];
			zoneCon.Create_by_list(3, [ResName.playerScore, ResName.bankerScore,ResName.TieScore], 0 , 0, 3, 500, 0, "Bet_");					
			zoneCon.container.x = 370;
			zoneCon.container.y = 560;			
			
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
			settletable_title.Post_CustomizedData = [[0,0],[270,0],[480,0]];
			settletable_title.CustomizedFun = _gameinfo.textSetting;
			settletable_title.CustomizedData = [{size:24}, "投注內容","得分","開牌結果"];
			settletable_title.Create_by_list(3, [ResName.TextInfo], 0 , 0, 3, 200, 0, "Bet_");		
			
			var settletable_zone:MultiObject = prepare("settletable_zone", new MultiObject(), settletable.container);		
			settletable_zone.container.x = 70;
			settletable_zone.container.y = 90;		
			settletable_zone.CustomizedFun = _gameinfo.textSetting;
			settletable_zone.CustomizedData = [{size:24}, "莊","閒","和","莊對","閒對","特殊牌型","合計"];
			settletable_zone.Create_by_list(7, [ResName.TextInfo], 0 , 0, 1, 0, 50, "Bet_");		
			
			var settletable_zone_bet:MultiObject = prepare("settletable_zone_bet", new MultiObject(), settletable.container);		
			settletable_zone_bet.container.x = 200;
			settletable_zone_bet.container.y = 90;		
			settletable_zone_bet.CustomizedFun = _gameinfo.textSetting;
			settletable_zone_bet.CustomizedData = [{size:24}, "100","100","1000","0","200","100000"];
			settletable_zone_bet.Create_by_list(6, [ResName.TextInfo], 0 , 0, 1, 0, 50, "Bet_");		
			
			
			var settletable_zone_settle:MultiObject = prepare("settletable_zone_settle", new MultiObject(), settletable.container);		
			settletable_zone_settle.container.x = -200;
			settletable_zone_settle.container.y = 90;		
			settletable_zone_settle.CustomizedFun = colortextSetting;
			settletable_zone_settle.CustomizedData = [{size:24}, "0","0","1000","0","0","100000","10000"];
			settletable_zone_settle.Create_by_list(7, [ResName.TextInfo], 0 , 0, 1, 0, 50, "Bet_");		
			
			var settletable_desh:MultiObject = prepare("settletable_desh", new MultiObject(), settletable.container);		
			settletable_desh.container.x = 40;
			settletable_desh.container.y = 364;		
			settletable_desh.CustomizedFun = _gameinfo.textSetting;
			settletable_desh.CustomizedData = [{size:24},"--------------------------------------"];
			settletable_desh.Create_by_list(1, [ResName.TextInfo], 0 , 0, 1, 7, 0, "Bet_");		
			//settletable_desh.container.visible = false;
			
			var settletable_H_desh:MultiObject = prepare("settletable_H_desh", new MultiObject(), settletable.container);		
			settletable_H_desh.container.x = 454;
			settletable_H_desh.container.y = 40;		
			settletable_H_desh.CustomizedFun = _gameinfo.textSetting;
			settletable_H_desh.CustomizedData = [ { size:24 }, "|", "|", "|", "|", "|", "|", "|", "|", "|", "|", "|", "|", "|", "|", "|"];
			settletable_H_desh.Create_by_list(14, [ResName.TextInfo], 0 , 0, 1, 0, 28, "Bet_");
			
			
			var result_pai:MultiObject = prepare("result_pai", new MultiObject(), settletable.container);		
			result_pai.container.x = 288;
			result_pai.container.y = 90;
			result_pai.CustomizedFun = _gameinfo.textSetting;
			result_pai.CustomizedData = [{size:24,align:TextFormatAlign.CENTER}, "閒","莊","公牌"];
			result_pai.Create_by_list(3, [ResName.TextInfo], 0 , 0, 1, 0, 80, "Bet_");		
			
			//開牌結果
			_model.putValue("result_Pai_list", ["1d","2d","3d","4d","5d","6d"]);
			var historyPai_model:Array = _model.getValue("result_Pai_list");			
			var history_play_pai:MultiObject = prepare("history_Pai_list", new MultiObject() , settletable.container);
			history_play_pai.CustomizedFun = sprite_idx_setting_player;			
			history_play_pai.CustomizedData = historyPai_model;			
			history_play_pai.container.x = 579;
			history_play_pai.container.y = 133;			
			history_play_pai.Create_by_bitmap(historyPai_model.length, utilFun.Getbitmap("poker_atlas"), 0, 0, 6, 22, 25, "o_");		
			
			
			_model.putValue("result_str_list", []);
			var historystr_model:Array = _model.getValue("result_str_list");			
			var result_str_list:MultiObject = prepare("result_str_list", new MultiObject() , settletable.container);
			result_str_list.CustomizedFun =_gameinfo.textSetting;
			result_str_list.CustomizedData =[{size:20,align:TextFormatAlign.CENTER},historystr_model.join("、")];	
			result_str_list.container.x = 287;
			result_str_list.container.y = 344;
			result_str_list.Create_by_list(1, [ResName.TextInfo], 0 , 0,1,0 , 0, "Bet_");		
			
			//_tool.SetControlMc(zoneCon.container);
			//_tool.SetControlMc(zoneCon.ItemList[1]);
			//_tool.y = 200;
			//add(_tool);
			Clean();
		}
		
		public function colortextSetting(mc:MovieClip, idx:int, data:Array):void
		{			
			var str:TextField = dynamic_text(data[idx+1],data[0]);			
			mc.addChild(str);
		}
		
		public function dynamic_text(text:String,para:Object):TextField
		{	
			var size:int = para.size;
			var textColor:uint = 0xFFFFFF;
			var align:String = TextFormatAlign.LEFT;
			var bold:Boolean = false;
			
			if ( para["color"] != undefined)  textColor = para.color;
			if( para["align"] != undefined)  align = para.align;
			if ( para["bold"] != undefined)  bold = para.bold;
						
			if ( parseInt( text) > 0) textColor= 0x00FF33;
			if ( parseInt( text) < 0) textColor= 0xFF0000;		
			
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
			myFormat.bold = bold;
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
			//if ( idx % 2 == 1 ) shif = -10;
			mc.x = (idx % 2 * 25	) + shif;						
			mc.y = ( Math.floor(idx / 2) * 80);	
			
			//押暗
			//if ( history_win[Math.floor(idx / 5)] != ResName.angelball) mc.alpha =  0.5;			
			mc.drawTile(code);	
			//utilFun.scaleXY(mc, 2, 2);
		
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean():void
		{			
			var a:MultiObject = Get("zone");
			for ( var i:int = 0; i <  a.ItemList.length; i++)
			{				
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
			
			var isTie:int = 0;
			var isPlayPair:int = 0;
			var isbankerPair:int = 0;
			
			var playerPoint:int = pokerUtil.ca_point(_model.getValue(modelName.PLAYER_POKER));
			var bankerPoint:int = pokerUtil.ca_point(_model.getValue(modelName.BANKER_POKER));
			var clean:Array = [];
			for ( var i:int = 0; i < num; i++)
			{
				var resultob:Object = result_list[i];				
				utilFun.Log("bet_type=" + resultob.bet_type  + "  " + resultob.win_state);
				
				//coin 清除區
				if ( resultob.win_state == "WSLost") clean.push (name_to_idx.getValue(resultob.bet_type));
				else
				{
					//大獎
					if ( resultob.win_state != "WSBWNormalWin" && resultob.win_state !="WSWin")
					{
						bigwin = bigpokermapping.getValue( resultob.win_state);
						result_str.push(pokerstr.getValue(resultob.win_state));								
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
					if ( resultob.bet_type == "BetBWTiePoint" ) 
					{
						isTie = 1;
					}
					if ( resultob.bet_type == "BetBWPlayerPair" ) 
					{
						isPlayPair = 1;
					}
					if ( resultob.bet_type == "BetBWBankerPair" ) 
					{
						isbankerPair = 1;
					}
					winst = resultob.win_state;
				}
				
				//總押注和贏分
				settle_amount[ idx_to_result_idx.getValue( name_to_idx.getValue(resultob.bet_type) )] =  resultob.settle_amount;
				zonebet_amount[ idx_to_result_idx.getValue( name_to_idx.getValue(resultob.bet_type)) ]  = resultob.bet_amount;
				total += resultob.settle_amount;
			}
			
			if( playerwin ==0  && bankerwin ==0)  result_str.push("和");	
			if( bigwin == -1) result_str.push("無特殊牌型");
			
			
			
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
			//for ( var i:int = 0; i < wintzone.length; i++)
			//{
				//utilFun.Log("wintzone[i]  =" + wintzone[i] );
				//_regular.Twinkle(GetSingleItem("betzone", wintzone[i] ), 3, 10, 2);	
			//}
			
			//輸分收
			//for ( var i:int = 0; i < clean.length; i++)
			//{
				//utilFun.Log("wintzone[i]  =" + wintzone[i] );
				//utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone",  clean[i]));				
			//}
			
			//大獎
			if ( bigwin!=-1)
			{				
				//GetSingleItem("bigwinmsg").gotoAndStop(bigwin);
				//GetSingleItem("bigwinfire").gotoAndPlay(2);				
				//_regular.FadeIn( GetSingleItem("bigwinmsg"), 2, 2, _regular.Fadeout);
				//utilFun.scaleXY(GetSingleItem("bigwinmsg"), 0, 0);
				//Tweener.addTween(GetSingleItem("bigwinmsg"), { scaleX: 1.2,scaleY:1.2, time:0.5,transition:"linear",onCompleteParams:[GetSingleItem("bigwinmsg")],onComplete:rubber_out } );
				//Tweener.addTween(GetSingleItem("bigwinmsg"), { scaleX: 0.8,scaleY:0.8, time:0.5,transition:"easeOutCubic" } );
				//_regular.rubber_effect(GetSingleItem("bigwinmsg"), 1, 1, 0.4, 0.4, _regular.rubber_effect);
			}
						
			//patytable提示框			
			dispatcher(new StringObject(winst, "winstr_hint"));
			
			//show誰贏
			dispatcher(new Intobject(1, "show_who_win"));
			
			//歷史記錄
			history_add(playerwin, bankerwin,playerPoint,bankerPoint,isTie,isPlayPair,isbankerPair,bigwin);
			
			var delaytime:int = 2;
			if ( bigwin != -1) delaytime = 3;
			
			//結算表
			_regular.Call(this, { onComplete:this.showAni}, 1, delaytime, 1, "linear");
		}
		
		public function showAni():void
		{
			GetSingleItem("bigwinmsg").gotoAndStop(1);
			show_settle();
			
			
		}
		
		public function rubber_out(mc:MovieClip):void
		{
			Tweener.addTween(mc, { scaleX: 0.8,scaleY:0.8, time:0.5,transition:"linear",onCompleteParams:[mc],onComplete:rubber_over } );
		}
		
		public function rubber_over(mc:MovieClip):void
		{
			Tweener.addTween(mc, { scaleX: 1,scaleY:1, time:0.5,transition:"linear" } );
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
				arr.push(isPlayPair);
				arr.push(isbankerPair);
				
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
			//utilFun.Log("history = " + history);
			if ( history.length > 60) history.shift();			
			_model.putValue("history_win_list",history);			
		}
		
		public function show_settle():void
		{				
			var settletable:MultiObject = Get("settletable");
			settletable.container.visible = true;		
			//押注
			var zone_amount:Array = _model.getValue("result_zonebet_amount");			
			var font:Array = [{size:24}];
			font = font.concat(zone_amount);			
			Get("settletable_zone_bet").CustomizedFun = _gameinfo.textSetting;
			Get("settletable_zone_bet").CustomizedData = font;
			Get("settletable_zone_bet").Create_by_list(6, [ResName.TextInfo], 0 , 0, 1, 0, 50, "Bet_");		
			
			//總結
			var settle_amount:Array = _model.getValue("result_settle_amount");			
			var font2:Array = [{size:24,align:TextFormatAlign.RIGHT}];
			font2 = font2.concat(settle_amount);		
			font2 = font2.concat( _model.getValue("result_total"));			
			Get("settletable_zone_settle").CustomizedFun = colortextSetting;
			Get("settletable_zone_settle").CustomizedData = font2;
			Get("settletable_zone_settle").Create_by_list(7, [ResName.TextInfo], 0 , 0, 1, 0, 50, "Bet_");				
			
			//小 poker
			var ppoker:Array =   _model.getValue(modelName.PLAYER_POKER);
			var bpoker:Array =   _model.getValue(modelName.BANKER_POKER);
			var rpoker:Array =   _model.getValue(modelName.RIVER_POKER);
			
			var totalPoker:Array = [];			
			totalPoker = totalPoker.concat(ppoker);			
			totalPoker = totalPoker.concat(bpoker);
			totalPoker = totalPoker.concat(rpoker);
			_model.putValue("result_Pai_list", totalPoker);
			var historyPai_model:Array = _model.getValue("result_Pai_list");					
			Get("history_Pai_list").CustomizedFun = sprite_idx_setting_player;			
			Get("history_Pai_list").CustomizedData = historyPai_model;			
			Get("history_Pai_list").Create_by_bitmap(historyPai_model.length, utilFun.Getbitmap("poker_atlas"), 0, 0, 6, 22, 25, "o_");		
			
			
			//小牌結果
			var historystr_model:Array = _model.getValue("result_str_list");
			var add_parse:String = historystr_model.join("、");
			add_parse = add_parse.slice(0, 0) + "(" + add_parse.slice(0);
			add_parse = add_parse +")";
			
			Get("result_str_list").CustomizedFun =_gameinfo.textSetting;
			Get("result_str_list").CustomizedData =[{size:20,align:TextFormatAlign.CENTER},add_parse];				
			Get("result_str_list").Create_by_list(1, [ResName.TextInfo], 0 , 0,1,0 , 0, "Bet_");		
			
			
		}	
		
		
		
	
		
		
		
		
	}
	
	

}