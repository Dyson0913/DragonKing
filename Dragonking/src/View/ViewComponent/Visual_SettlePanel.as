package View.ViewComponent 
{
	import flash.display.MovieClip;
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
		
		
		public static const R_settleLine:String = "settle_line";
		
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
			settletable_title.container.y = 43;
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
			settletable_zone.Post_CustomizedData = [[0, 0], [0, 32], [0, 64], [0, 96], [0, 128], [0, 160], [0, 200]];
			settletable_zone.Posi_CustzmiedFun = _regular.Posi_xy_Setting
			settletable_zone.Create_(7);
			
			var settletable_zone_bet:MultiObject = create("settletable_zone_bet", [ResName.TextInfo], settletable.container);		
			settletable_zone_bet.container.x = -360;
			settletable_zone_bet.container.y = settletable_zone.container.y;		
			settletable_zone_bet.CustomizedFun = _text.textSetting;
			settletable_zone_bet.CustomizedData = [ { size:24,align:_text.align_right,color:0xFF0000 }, "100", "100", "1000", "0", "200", "100000","0"];
			settletable_zone_bet.Post_CustomizedData = [[0, 0], [0, 32], [0, 64], [0, 96], [0, 128], [0, 160], [0, 200]];
			settletable_zone_bet.Posi_CustzmiedFun = _regular.Posi_xy_Setting
			settletable_zone_bet.Create_(7);
			
			
			var settletable_zone_settle:MultiObject = create("settletable_zone_settle",  [ResName.TextInfo], settletable.container);		
			settletable_zone_settle.container.x = -240;
			settletable_zone_settle.container.y = settletable_zone.container.y;		
			settletable_zone_settle.CustomizedFun = _text.colortextSetting;
			settletable_zone_settle.CustomizedData = [ { size:18,align:_text.align_right }, "0", "0", "1000", "0", "0", "100000", "10000"];
			settletable_zone_settle.Post_CustomizedData = [[0, 0], [0, 32], [0, 64], [0, 96], [0, 128], [0, 160], [0, 200]];
			settletable_zone_settle.Posi_CustzmiedFun = _regular.Posi_xy_Setting
			settletable_zone_settle.Create_(7);
			settletable_zone_settle.container.visible = false;
			
			var settleline:MultiObject = create("settletable_line",  [R_settleLine], settletable.container);		
			settleline.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			settleline.Post_CustomizedData = [2, 50, 20];			
			settleline.container.x = 40;
			settleline.container.y = settletable_zone.container.y + 195;
			settleline.Create_(2);
			
			put_to_lsit(settletable);
			put_to_lsit(settletable_title);
			put_to_lsit(settletable_zone);
			put_to_lsit(settletable_zone_bet);
			put_to_lsit(settletable_zone_settle);
			
			state_parse([gameState.END_BET,gameState.START_OPEN,gameState.END_ROUND]);
		}
		
		override public function appear():void
		{
			Get("settletable").container.visible = true;
			
			//得分 列先hide
			GetSingleItem("settletable_title", 2).visible = false;
			Get("settletable_zone_settle").container.visible = false;
			
			
			var mylist:Array = _betCommand.bet_zone_amount();
			
			//會計符號
			for ( var i:int = 0; i < mylist.length; i++)
			{
				mylist[i] = utilFun.Accounting_Num(mylist[i]);
			}
			
			var font:Array = [{size:24,align:_text.align_right,color:0xFFFFFF}];
			font = font.concat(mylist);			
			var zone_bet:MultiObject = Get("settletable_zone_bet");
			zone_bet.CleanList();
			zone_bet.CustomizedData = font;			
			zone_bet.Create_(7);			
			
			var special_handle:MovieClip = GetSingleItem("settletable_zone_bet", zone_bet.ItemList.length - 1);
			utilFun.Clear_ItemChildren(special_handle);
			_text.textSetting_s(special_handle, [ { size:24, align:_text.align_right, color:0xFF0000 } , mylist[mylist.length-1]]);			
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
			
			//會計符號
			for ( var i:int = 0; i < zone_amount.length; i++)
			{
				zone_amount[i] = utilFun.Accounting_Num(zone_amount[i]);
			}
			
			var font:Array = [ { size:24, align:_text.align_right, color:0xFFFFFF } ];			
			font = font.concat(zone_amount);
			var zone_bet:MultiObject = Get("settletable_zone_bet");
			zone_bet.CleanList();
			zone_bet.CustomizedData = font;
			zone_bet.Create_(zone_amount.length);
			
			var special_handle:MovieClip = GetSingleItem("settletable_zone_bet", zone_bet.ItemList.length - 1);
			utilFun.Clear_ItemChildren(special_handle);
			_text.textSetting_s(special_handle, [ { size:24, align:_text.align_right, color:0xFF0000 } , zone_amount[zone_amount.length-1]]);			
			
			
			//總結
			var settle_amount:Array = _model.getValue("result_settle_amount");
			
			//會計符號
			for (  i = 0; i < settle_amount.length; i++)
			{
				settle_amount[i] = utilFun.Accounting_Num(settle_amount[i]);
			}
			
			var font2:Array = [ { size:24, align:_text.align_right } ];			
			font2 = font2.concat(settle_amount);			
			utilFun.Log("font2 = " + font2);
			var zone_settle:MultiObject = Get("settletable_zone_settle");
			zone_settle.CleanList();
			zone_settle.CustomizedFun = _text.colortextSetting;
			zone_settle.CustomizedData = font2;
			zone_settle.Create_(settle_amount.length);
			
			special_handle = GetSingleItem("settletable_zone_settle", zone_settle.ItemList.length - 1);
			utilFun.Clear_ItemChildren(special_handle);
			_text.textSetting_s(special_handle, [ { size:24, align:_text.align_right, color:0xFF0000 } , settle_amount[settle_amount.length-1]]);			
			
			
			if ( _betCommand.all_betzone_totoal() == 0) return;
			
			dispatcher(new StringObject("sound_get_point", "sound" ) );
			
		}	
		
		
	}

}