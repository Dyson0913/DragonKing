package View.ViewComponent 
{
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * betzone present way
	 * @author ...
	 */
	public class Visual_betZone  extends VisualHandler
	{
		[Inject]
		public var _regular:RegularSetting;
		
		[Inject]
		public var _betCommand:BetCommand;	
		
		public function Visual_betZone() 
		{
			
		}
		
		public function init():void
		{
			var avaliblezone:Array = _model.getValue(modelName.AVALIBLE_ZONE);
			
			//下注區
			var playerzone:MultiObject = prepare("betzone", new MultiObject() , GetSingleItem("_view").parent.parent);
			playerzone.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,3,1]); //1 ,2,3,2
			playerzone.container.x = 366;
			playerzone.container.y = 602;
			playerzone.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			playerzone.Post_CustomizedData = [[233,148],[789,142]] //[[0,0],[233,148],[512,186],[789,142],[1016,-6]];
			playerzone.Create_by_list(avaliblezone.length, avaliblezone, 0, 0, avaliblezone.length, 50, 0, "time_");		
			
			//_tool.SetControlMc(coinob.ItemList[0]);
			//_tool.SetControlMc(coinob.container);
			//add(_tool);
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			var betzone:MultiObject = Get("betzone");
			betzone.mousedown = _betCommand.betTypeMain;
			betzone.mouseup = _betCommand.empty_reaction;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function timer_hide():void
		{
			var betzone:MultiObject = Get("betzone");
			betzone.mousedown = null;
		}
		
		
	}

}