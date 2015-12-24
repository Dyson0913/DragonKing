package View.ViewComponent 
{
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import View.GameView.*;
	/**
	 * hintmsg present way
	 * @author ...
	 */
	public class Visual_SettlePanel  extends VisualHandler
	{
		
		[Inject]
		public var _betCommand:BetCommand;
		
		public function Visual_SettlePanel() 
		{
			
		}
		
		public function init():void
		{
			var settletable:MultiObject = create("settletable",  [ResName.emptymc]);
			settletable.Create_(1);	
			settletable.container.x = 1240;
			settletable.container.y = 90;
			settletable.container.visible = false;
			
			var settletable_title:MultiObject = create("settletable_title",  [ResName.TextInfo], settletable.container);		
			settletable_title.container.x = 70;
			settletable_title.container.y = 40;
			settletable_title.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			settletable_title.Post_CustomizedData = [[0,0],[150,0],[270,0]];
			settletable_title.CustomizedFun = _text.textSetting;
			settletable_title.CustomizedData = [{size:22}, "投注內容","押分","得分"];
			settletable_title.Create_(3);
			GetSingleItem("settletable_title", 2).visible = false;
			
			var settletable_zone:MultiObject = create("settletable_zone", [ResName.TextInfo], settletable.container);		
			settletable_zone.container.x = 70;
			settletable_zone.container.y = 70;		
			settletable_zone.CustomizedFun = _text.textSetting;
			settletable_zone.CustomizedData = [ { size:22 }, "莊", "閒", "和", "莊對", "閒對", "特殊牌型", "合計"];
			settletable_zone.Post_CustomizedData = [7, 30, 32];
			settletable_zone.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			settletable_zone.Create_(7);
			
			var settletable_zone_bet:MultiObject = create("settletable_zone_bet", [ResName.TextInfo], settletable.container);		
			settletable_zone_bet.container.x = -360;
			settletable_zone_bet.container.y = settletable_zone.container.y;		
			settletable_zone_bet.CustomizedFun = _text.textSetting;
			settletable_zone_bet.CustomizedData = [ { size:24,align:_text.align_right,color:0xFF0000 }, "100", "100", "1000", "0", "200", "100000","0"];
			settletable_zone_bet.Post_CustomizedData = [7, 30, 32];
			settletable_zone_bet.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			settletable_zone_bet.Create_(7);
			
			
			var settletable_zone_settle:MultiObject = create("settletable_zone_settle",  [ResName.TextInfo], settletable.container);		
			settletable_zone_settle.container.x = -240;
			settletable_zone_settle.container.y = settletable_zone.container.y;		
			settletable_zone_settle.CustomizedFun = _text.colortextSetting;
			settletable_zone_settle.CustomizedData = [ { size:18,align:_text.align_right }, "0", "0", "1000", "0", "0", "100000", "10000"];
			settletable_zone_settle.Post_CustomizedData = [7, 30, 32];
			settletable_zone_settle.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			settletable_zone_settle.Create_(7);
			settletable_zone_settle.container.visible = false;
			
			//var settletable_desh:MultiObject = create("settletable_desh", [ResName.TextInfo], settletable.container);		
			//settletable_desh.container.x = 70;
			//settletable_desh.container.y = 235;					
			//settletable_desh.CustomizedFun = _text.textSetting;
			//settletable_desh.CustomizedData = [{size:24},"______________________________"];
			//settletable_desh.Create_(1, "settletable_desh");
			
			//_model.putValue("result_str_list", []);
			//var historystr_model:Array = _model.getValue("result_str_list");			
			//var result_str_list:MultiObject = prepare("result_str_list", new MultiObject() , settletable.container);
			//result_str_list.CustomizedFun =_text.textSetting;
			//result_str_list.CustomizedData =[{size:20,align:_text.align_center},historystr_model.join("、")];	
			//result_str_list.container.x = 287;
			//result_str_list.container.y = 344;
			//result_str_list.Create_by_list(1, [ResName.TextInfo], 0 , 0,1,0 , 0, "Bet_");		
			
			put_to_lsit(settletable);
			put_to_lsit(settletable_title);
			put_to_lsit(settletable_zone);
			put_to_lsit(settletable_zone_bet);
			put_to_lsit(settletable_zone_settle);
			
			state_parse([gameState.END_BET,gameState.START_OPEN,gameState.END_ROUND]);
		}		
		
		public function sprite_idx_setting_player(mc:*, idx:int, data:Array):void
		{			
			var code:int  = pokerUtil.pokerTrans_s(data[idx]);			
			mc.x += 25;			
			//押暗
			//if ( history_win[Math.floor(idx / 5)] != ResName.angelball) mc.alpha =  0.5;			
			mc.drawTile(code);	
			//utilFun.scaleXY(mc, 2, 2);
		
		}
		
		override public function appear():void
		{
			Get("settletable").container.visible = true;
			
			//得分 列先hide
			GetSingleItem("settletable_title", 2).visible = false;
			Get("settletable_zone_settle").container.visible = false;
			
			
			var mylist:Array = _betCommand.bet_zone_amount();
			var font:Array = [{size:24,align:_text.align_right,color:0xFF0000}];
			font = font.concat(mylist);			
			var zone_bet:MultiObject = Get("settletable_zone_bet");
			zone_bet.CleanList();
			zone_bet.CustomizedData = font;
			zone_bet.Create_(7);			
		}
		
		override public function disappear():void
		{			
			Get("settletable").container.visible = false;			
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "show_settle_table")]
		public function show_settle():void
		{
			
			utilFun.Log("show_settle");			
			Get("settletable").container.visible = true;			
			GetSingleItem("settletable_title", 2).visible = true;
			Get("settletable_zone_settle").container.visible = true;	
			
			//押注
			var zone_amount:Array = _model.getValue("result_zonebet_amount");			
			var font:Array = [ { size:24, align:_text.align_right, color:0xFF0000 } ];			
			font = font.concat(zone_amount);
			var zone_bet:MultiObject = Get("settletable_zone_bet");
			zone_bet.CleanList();
			zone_bet.CustomizedData = font;
			zone_bet.Create_(zone_amount.length);
			
			//總結
			var settle_amount:Array = _model.getValue("result_settle_amount");			
			var font2:Array = [ { size:24, align:_text.align_right } ];			
			font2 = font2.concat(settle_amount);			
			utilFun.Log("font2 = " + font2);
			var zone_settle:MultiObject = Get("settletable_zone_settle");
			zone_settle.CleanList();
			zone_settle.CustomizedFun = _text.colortextSetting;
			zone_settle.CustomizedData = font2;
			zone_settle.Create_(settle_amount.length);
			
			if ( _betCommand.all_betzone_totoal() == 0) return;
			
			dispatcher(new StringObject("sound_get_point","sound" ) );
			
			//小牌結果
			//var historystr_model:Array = _model.getValue("result_str_list");
			//var add_parse:String = historystr_model.join("、");
			//add_parse = add_parse.slice(0, 0) + "(" + add_parse.slice(0);
			//add_parse = add_parse +")";
			//
			//Get("result_str_list").CustomizedFun =_text.textSetting;
			//Get("result_str_list").CustomizedData =[{size:24,align:_text.align_center},add_parse];				
			//Get("result_str_list").Create_by_list(1, [ResName.TextInfo], 0 , 0,1,0 , 0, "Bet_");			
			
		}	
		
		
	}

}