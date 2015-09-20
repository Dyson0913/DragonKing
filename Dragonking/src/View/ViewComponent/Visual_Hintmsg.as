package View.ViewComponent 
{
	import Model.CommonModel.Model_HintMsg;
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
	public class Visual_Hintmsg  extends VisualHandler
	{
		[Inject]
		public var myModel:Model_HintMsg;
		
		public function Visual_Hintmsg() 
		{
			
		}
		
		public function init():void
		{
			var hintmsg:MultiObject = create(myModel.ResName, [myModel.ResName]);
			hintmsg.Create(1,myModel.ResName);			
			hintmsg.container.x = 960.3;
			hintmsg.container.y = 439.3;
			hintmsg.container.visible = false;		
			
			//_tool.SetControlMc(coinob.ItemList[0]);
			//_tool.SetControlMc(hintmsg.container);
			//add(_tool);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "Hintmsg_update")]
		public function display():void
		{
			Get(myModel.ResName).container.visible = true;
			
			var frame:int = _model.getValue(myModel.ModelTag);	
			GetSingleItem(myModel.ResName).gotoAndStop(frame);	
			_regular.FadeIn( GetSingleItem(myModel.ResName), 2, 2, _regular.Fadeout);		
		}
		
	}

}