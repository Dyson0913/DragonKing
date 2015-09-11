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
	
	/**
	 * betzone present way
	 * @author ...
	 */
	public class Visual_betZone  extends VisualHandler
	{	
		
		[Inject]
		public var _betCommand:BetCommand;	
		
		public function Visual_betZone() 
		{
			
		}
		
		public function init():void
		{
			var avaliblezone:Array = _model.getValue(modelName.AVALIBLE_ZONE);
			var zone_xy:Array = _model.getValue(modelName.AVALIBLE_ZONE_XY);
			
			//下注區
			var pz:MultiObject = prepare("betzone", new MultiObject() , GetSingleItem("_view").parent.parent);
			pz.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,2,0]);
			pz.container.x = 353;
			pz.container.y = 805;
			pz.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			pz.Post_CustomizedData = zone_xy;
			pz.Create_by_list(avaliblezone.length, avaliblezone, 0, 0, avaliblezone.length, 50, 0, "betzone_");		
			
			//pz.ItemList[0].gotoAndStop(2);
			//for (var i:int = 0; i < avaliblezone.length; i++)
			//{
				//pz.ItemList[i].gotoAndStop(2);
			//}					
			
			//_tool.SetControlMc(pz.ItemList[5]);
			//_tool.SetControlMc(pz.container);
			//add(_tool);
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			var betzone:MultiObject = Get("betzone");
			betzone.mousedown = _betCommand.empty_reaction;			
			betzone.rollout = _betCommand.empty_reaction;
			betzone.rollover = _betCommand.empty_reaction;
		}
		
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function timer_hide():void
		{
			var betzone:MultiObject = Get("betzone");
			betzone.mousedown = null;				
			
			betzone.rollout = _betCommand.empty_reaction;
			betzone.rollover = _betCommand.empty_reaction;
			
			var frame:Array = [];
			for ( var i:int = 0; i  <  betzone.ItemList.length; i++) frame.push(1);
			betzone.CustomizedFun = _regular.FrameSetting;
			betzone.CustomizedData = frame;
			betzone.FlushObject();
		}
		
		
	}

}