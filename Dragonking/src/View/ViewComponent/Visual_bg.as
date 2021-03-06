package View.ViewComponent 
{
	import flash.display.MovieClip;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import View.GameView.gameState;
	
	/**
	 * hintmsg present way
	 * @author ...
	 */
	public class Visual_bg  extends VisualHandler
	{
		public const bg:String = "bg_item";
		
		public function Visual_bg() 
		{
			
		}
		
		public function init():void
		{
			var ani_dealer:MultiObject = create("dealer", ["dealer"]);
			ani_dealer.container.x = 700;
			ani_dealer.container.y = 150;
			ani_dealer.Create_(1);			
			ani_dealer.container.visible = false;
			
			var bg:MultiObject = create("bg", [bg]);
			bg.Create_(1);
			bg.container.x = 620;
			bg.container.y = 10;
			put_to_lsit(bg);
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "new_round")]
		public function newround():void
		{	
			gotoframe(1);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "stop_bet")]
		public function endbet():void
		{
			gotoframe(2);
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject", selector = "poker_mi")]
		public function poker_mi(type:Intobject):void
		{			
			var po:Array = _model.getValue(modelName.RIVER_POKER);
			if ( po.length == 2) 	return;
			
			utilFun.SetTime(gotodealer, 0.5);
		}
		
		private function gotodealer():void
		{
			gotoframe(3);
			utilFun.SetTime(gotoready, 1);
		}
		
		private function gotoready():void
		{
			gotoframe(2);
		}
		private function gotoframe(frame:int):void
		{
			var ani_dealer:MultiObject = Get("dealer");
			ani_dealer.ItemList[0].gotoAndStop(frame);			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_():void
		{
			utilFun.Log("-----------into settle_")
			gotoframe(4);
		}
		
	}

}