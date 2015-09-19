package Model.CommonModel 
{	
	import Model.CommonModel.ModelBase;
	import Command.*;
	import Model.ModelEvent;
	
	import util.utilFun;
	import caurina.transitions.Tweener;
	
	/**
	 * 
	 * @author Dyson0913
	 */
	public class Model_Timer extends ModelBase
	{		
		
		public function Model_Timer() 
		{
			_ResName = "countDowntimer";
			_ModelTag = _ResName;
			_exTraResName = ["time_light"];
			_SetPropertyEvent = ["Timer_value"]
			_UpdateEvent = ["Timer_update", "Timer_reset"];
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "Timer_value")]		
		public function set_attribute():void
		{			
			var time:int = _model.getValue(ModelTag);			
			Tweener.addCaller(this, { time:time , count: time+1, onUpdate:TimeCount , transition:"linear" } );
		}
		
		private function TimeCount():void
		{
			dispatcher(new ModelEvent(UpdateEvent(0)));					
			var time:int  = _opration.operator(ModelTag, DataOperation.sub, 1);
			if ( time == -1) dispatcher(new ModelEvent(UpdateEvent(1)));
		}
		
	}

}