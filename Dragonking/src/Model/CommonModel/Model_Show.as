package Model.CommonModel 
{	
	import Model.CommonModel.ModelBase;
	import Command.*;
	import Model.ModelEvent;
	
	import util.utilFun;
	import caurina.transitions.Tweener;
	
	/**
	 * control most object show hind event
	 * 
	 * _model.putValue( _m_Show.ModelTag, N);
	 * dispatcher(new ModelEvent(_m_Show.PropertyEvent(N)));			
	 * @author Dyson0913
	 */
	public class Model_Show extends ModelBase
	{		
		
		public function Model_Show() 
		{			
			_ResName = "Model_Show";
			_ModelTag = _ResName;			
			_SetPropertyEvent = ["Show_value"]
			_UpdateEvent = ["Show_bet","Show_openCard"];
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "Show_value")]		
		public function set_attribute():void
		{
			var stage:int = _model.getValue(ModelTag);
			if( stage ==0) 	dispatcher(new ModelEvent(UpdateEvent(0)));							
			if( stage ==1) 	dispatcher(new ModelEvent(UpdateEvent(1)));							
			if( stage ==2) 	dispatcher(new ModelEvent(UpdateEvent(2)));							
		}
		
	}

}