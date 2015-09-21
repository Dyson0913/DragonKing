package Model.CommonModel 
{	
	import Model.CommonModel.ModelBase;
	import Command.*;
	import Model.ModelEvent;
	
	import util.utilFun;
	import caurina.transitions.Tweener;
	
	/**
	 * most of test no need to process or logic handle, unitfy to handle in this model,using way like belong
	 * 
	 * _model.putValue( _m_Text.ModelTag, N);
	 * dispatcher(new ModelEvent(_m_Text.PropertyEvent(N)));			
	 * @author Dyson0913
	 */
	public class Model_Text extends ModelBase
	{		
		
		public function Model_Text() 
		{			
			_ResName = "Text_Info";
			_ModelTag = _ResName;			
			_SetPropertyEvent = ["Text_value"]
			_UpdateEvent = ["Text_betText", "Text_openCardText", "Text_updateRoundcode"];
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "Text_value")]		
		public function set_attribute():void
		{
			var stage:int = _model.getValue(ModelTag);
			if( stage ==0) 	dispatcher(new ModelEvent(UpdateEvent(0)));							
			if( stage ==1) 	dispatcher(new ModelEvent(UpdateEvent(1)));							
			if( stage ==2) 	dispatcher(new ModelEvent(UpdateEvent(2)));							
		}
		
	}

}