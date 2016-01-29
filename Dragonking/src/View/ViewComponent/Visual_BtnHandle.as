package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import View.GameView.gameState;
	
	/**
	 * btn handle present way
	 * @author ...
	 */
	public class Visual_BtnHandle  extends VisualHandler
	{
		private var _rule_table:MultiObject ;
		
		public const paytable_btn:String = "btn_paytable";
		public const ruletable:String = "rule_table";
		
		public function Visual_BtnHandle() 
		{
			
		}
		
		public function init():void
		{
			var btnlist:Array = [paytable_btn];
			//patable說明
			var btn_group:MultiObject = create("btn_group", btnlist);
			btn_group.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,3,1]);
			btn_group.container.x = -4;
			btn_group.container.y = 952;
			btn_group.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			btn_group.Post_CustomizedData = [[0, 0], [1580, -10], [1780, -10]];
			btn_group.Create_(btnlist.length);
			btn_group.rollout = empty_reaction;
			btn_group.rollover = empty_reaction;
			btn_group.mousedown = table_true;
			btn_group.mouseup = empty_reaction;
			
			_rule_table  = create("rule_table", [ruletable]);
			_rule_table.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);
			_rule_table.mousedown = table_true;
			_rule_table.mouseup = empty_reaction;
			_rule_table.container.x = -10;
			_rule_table.container.y = 50;			
			_rule_table.Create_(1);
			_rule_table.container.visible = false;
			
			put_to_lsit(_rule_table);
			
			state_parse([gameState.START_BET]);
			
		}
		
		public function table_true(e:Event, idx:int):Boolean
		{
			_rule_table.container.visible = !_rule_table.container.visible;				
			return true;
		}
		
	
	}

}