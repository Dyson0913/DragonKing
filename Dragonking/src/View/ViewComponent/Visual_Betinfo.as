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
	
	/**
	 * betinfo present way
	 * @author ...
	 */
	public class Visual_Betinfo  extends VisualHandler
	{
		[Inject]
		public var _text:Visual_Text;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		public function Visual_Betinfo() 
		{
			
		}
		
		public function init():void
		{
			var settletable_zone:MultiObject = prepare("opencard_betinfo", new MultiObject(), GetSingleItem("_view").parent.parent);		
			settletable_zone.container.x = 1380;
			settletable_zone.container.y =  140;	
			settletable_zone.CustomizedFun = _text.textSetting;
			settletable_zone.CustomizedData = [{size:24}, "莊","閒","和","莊對","閒對","特殊牌型","總計"];
			settletable_zone.Create_by_list(7, [ResName.TextInfo], 0 , 0, 1, 0, 30, "Bet_");		
			settletable_zone.container.visible = false;
			
			var opencard_bet_amount:MultiObject = prepare("opencard_bet_amount", new MultiObject(), GetSingleItem("_view").parent.parent);		
			opencard_bet_amount.CustomizedFun = _text.textSetting;
			opencard_bet_amount.container.x = 1010;
			opencard_bet_amount.container.y =  140;	
			
			//_tool.SetControlMc(zoneCon.container);
			//_tool.SetControlMc(zoneCon.ItemList[2]);
			//_tool.y = 200;
			//add(_tool);
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			Get("opencard_betinfo").container.visible = false;
			Get("opencard_bet_amount").container.visible = false;		
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function opencard_parse():void
		{
			//下注單
			Get("opencard_betinfo").container.visible = true;
			Get("opencard_bet_amount").container.visible = true;
			
			var mylist:Array = [];// ["0", "0", "0", "0", "0", "0", "0", "0"];
			var zone:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX);
			var maping:DI = _model.getValue("idx_to_result_idx");
			for ( var i:int = 0; i < zone.length; i++)
			{				
				var map:int = maping.getValue(zone[i]);				 
				mylist.splice(map, 0,_betCommand.get_total_bet(zone[i]));
			}			
			
			mylist.push(_betCommand.all_betzone_totoal());		
			var font:Array = [{size:24,align:_text.align_right,color:0xFF0000}];
			font = font.concat(mylist);
			//utilFun.Log("font = "+font);
			Get("opencard_bet_amount").CustomizedData = font;
			Get("opencard_bet_amount").Create_by_list(mylist.length, [ResName.TextInfo], 0 , 0, 1, 0, 30, "Bet_");	
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_parse():void
		{
			Get("opencard_betinfo").container.visible = false;
			Get("opencard_bet_amount").container.visible = false;	
		}
		
	}
	
	

}