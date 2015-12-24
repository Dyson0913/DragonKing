package View.ViewComponent 
{
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
			var bg:MultiObject = create("bg", [bg]);
			bg.Create_(1);
			bg.container.x = 620;
			bg.container.y = 10;
			put_to_lsit(bg);
		}		
		
	}

}