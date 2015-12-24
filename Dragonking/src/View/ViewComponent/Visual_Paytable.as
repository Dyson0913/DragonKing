package View.ViewComponent 
{
	import asunit.errors.AbstractError;
	import caurina.transitions.properties.DisplayShortcuts;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
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
	 * Paytable present way
	 * @author Dyson0913
	 */
	public class Visual_Paytable  extends VisualHandler
	{
		public const paytablemain:String = "paytable_main"		
		public const paytable_baridx:String = "paytable_bar_idx";
		
		public function Visual_Paytable() 
		{
			
		}
		
		public function init():void
		{			
			//賠率提示
			var paytable:MultiObject = create("paytable", [paytablemain]);
			paytable.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);			
			paytable.container.x = 230;
			paytable.container.y =  124;
			paytable.Create_(1);
			
			var paytable_baridx:MultiObject = create("paytable_baridx", [paytable_baridx]);
			paytable_baridx.container.x = paytable.container.x;
			paytable_baridx.container.y = paytable.container.y;
			paytable_baridx.Create_(1);
			
			put_to_lsit(paytable);	
			put_to_lsit(paytable_baridx);	
			
			state_parse([gameState.NEW_ROUND,gameState.START_BET,gameState.END_ROUND]);
		}
		
		override public function appear():void
		{
			GetSingleItem("paytable").gotoAndStop(1);
			GetSingleItem("paytable_baridx").gotoAndStop(1);
		}
		
		override public function disappear():void
		{
			GetSingleItem("paytable").gotoAndStop(2);
		}	
		
		[MessageHandler(type = "Model.valueObject.StringObject",selector="winstr_hint")]
		public function win_frame_hint():void
		{
			var wintype:String = _model.getValue("winstr");
			utilFun.Log("winst = " + wintype);		
			
			var y:int = 0;
			if (wintype == "WSBWStraight") y = 7;
			if ( wintype == "WSBWFlush") y = 6;
			if (wintype == "WSBWFullHouse") y = 5;
			if ( wintype == "WSBWFourOfAKind")y = 4;
			if ( wintype == "WSBWStraightFlush") y = 3;
			if ( wintype == "WSBWRoyalFlush") y = 2;			
			
			GetSingleItem("paytable_baridx").gotoAndStop(y);			
		}
		
		
	}

}