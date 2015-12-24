package View.ViewComponent 
{
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
	 * betzone present way
	 * @author ...
	 */
	public class Visual_betZone  extends VisualHandler
	{	
		public const bet_tableitem:String = "bet_table_item";
		public const highpayrate:String = "high_payrate";
		
		public function Visual_betZone() 
		{
			
		}
		
		public function init():void
		{
			
			var tableitem:MultiObject = create("tableitem", [bet_tableitem]);	
			tableitem.container.x = 193;
			tableitem.container.y = 655;
			tableitem.Create_(1);
			
			var avaliblezone:Array = _model.getValue(modelName.AVALIBLE_ZONE);
			var zone_xy:Array = _model.getValue(modelName.AVALIBLE_ZONE_XY);						
			
			//下注區
			var pz:MultiObject = create("betzone", avaliblezone);
			pz.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,2,0]);
			pz.container.x = 457;
			pz.container.y = 662;
			pz.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			pz.Post_CustomizedData = zone_xy;
			pz.Create_(avaliblezone.length);
			
			var highpayrate:MultiObject = create("highpayrate", [highpayrate]);	
			highpayrate.Create_(1);
			
			put_to_lsit(pz);
			put_to_lsit(tableitem);
			put_to_lsit(highpayrate);
			
			state_parse([gameState.NEW_ROUND,gameState.START_BET]);
		}		
		
		override public function appear():void
		{	
			Get("tableitem").container.visible = true;
			GetSingleItem("highpayrate").gotoAndStop(2);
			
			
			var state:int = _model.getValue(modelName.GAMES_STATE);			
			if ( state  == gameState.NEW_ROUND) return;
			
			GetSingleItem("highpayrate").gotoAndStop(1);
			Get("highpayrate").container.x = 783;
			Get("highpayrate").container.y = 575;
			
			pull();
			
			_regular.Twinkle_by_JumpFrame(GetSingleItem("betzone", 5), 25, 25, 1, 3);
			
			var betzone:MultiObject = Get("betzone");
			betzone.mousedown = empty_reaction;
			betzone.rollout = empty_reaction;
			betzone.rollover = empty_reaction;
		}
		
		override public function disappear():void
		{			
			var betzone:MultiObject = Get("betzone");
			betzone.mousedown = null;
			betzone.rollout = empty_reaction;
			betzone.rollover = empty_reaction;
			
			setFrame("betzone", 1);
			
			Get("tableitem").container.visible = false;
			Tweener.pauseTweens(GetSingleItem("betzone", 5));
			
			GetSingleItem("highpayrate").gotoAndStop(2);			
			Tweener.pauseTweens(Get("highpayrate"));	
		}		
		
		public function pull():void
		{
			_regular.moveTo(Get("highpayrate").container, Get("highpayrate").container.x, Get("highpayrate").container.y - 10, 1, 0, pull_up);
		}
		
		public function pull_up():void
		{
			_regular.moveTo(Get("highpayrate").container, Get("highpayrate").container.x, Get("highpayrate").container.y + 10, 1, 0, pull);
		}
		
	}

}