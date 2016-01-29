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
		[Inject]
		public var _betCommand:BetCommand;		
		
		public const bet_tableitem:String = "bet_table_item";
		public const highpayrate:String = "high_payrate";
		
		public const rebet_btn:String = "btn_rebet";
		
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
			
			//rebet
			var mylist:Array = [ rebet_btn];
			var mybtn_group:MultiObject = create("mybtn_group", mylist);
			mybtn_group.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,3,1]);
			mybtn_group.container.x = 1710;
			mybtn_group.container.y = 950;		
			mybtn_group.Create_(mylist.length);
			mybtn_group.rollout = empty_reaction;
			mybtn_group.rollover = empty_reaction;
			mybtn_group.mousedown = rebet_fun;
			mybtn_group.mouseup = empty_reaction;
			
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
			
			utilFun.Log("_betCommand.need_rebet() ="+_betCommand.need_rebet());
			if ( !_betCommand.need_rebet() ) can_not_rebet();
			else can_rebet();
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
			
			var betzone:MultiObject = Get("mybtn_group");
			betzone.container.visible = false;
		}		
		
		public function pull():void
		{
			_regular.moveTo(Get("highpayrate").container, Get("highpayrate").container.x, Get("highpayrate").container.y - 10, 1, 0, pull_up);
		}
		
		public function pull_up():void
		{
			_regular.moveTo(Get("highpayrate").container, Get("highpayrate").container.x, Get("highpayrate").container.y + 10, 1, 0, pull);
		}
		
		public function rebet_fun(e:Event, idx:int):Boolean
		{			
			can_not_rebet();
			
			_betCommand.re_bet();
			dispatcher(new StringObject("sound_rebet","sound" ) );
			return false;
		}
		
		public function can_rebet():void
		{
			var betzone:MultiObject = Get("mybtn_group");
			betzone.container.visible = true;
			betzone.ItemList[0].gotoAndStop(1);
			betzone.rollout = empty_reaction;
			betzone.rollover = empty_reaction;
			betzone.mousedown = rebet_fun;
			betzone.mouseup = empty_reaction;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "can_not_rebet")]
		public function can_not_rebet():void
		{
			var betzone:MultiObject = Get("mybtn_group");
			betzone.container.visible = false;
			betzone.ItemList[0].gotoAndStop(4);
			betzone.rollout = null;
			betzone.rollover = null;
			betzone.mousedown = null;
			betzone.mouseup = null;
		}		
		
	}

}