package Model.CommonModel 
{	
	import Model.CommonModel.ModelBase;
	import Command.*;
	import Model.ModelEvent;
	
	import util.utilFun;
	import caurina.transitions.Tweener;
	import Model.modelName;
	import View.GameView.gameState
	/**
	 * 
	 * @author Dyson0913
	 */
	public class Model_HintMsg extends ModelBase
	{
		
		
		public function Model_HintMsg() 
		{					
			_ResName = "HintMsg";
			_ModelTag = _ResName;
			_SetPropertyEvent = ["Hintmsg_value"];
			_UpdateEvent = ["Hintmsg_update", "Hintmsg_reset"];			
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "Hintmsg_value")]		
		public function set_attribute():void
		{			
			var state:int = _model.getValue(modelName.GAMES_STATE);
			
			var frame:int = 1;
			if ( state == gameState.NEW_ROUND) frame = 1;
			if ( state == gameState.END_BET) frame = 2;
			if( state == gameState.START_OPEN) frame = 4;
			
			_model.putValue(ModelTag, frame);			
			dispatcher(new ModelEvent(UpdateEvent(0)));			
		}	
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "CreditNotEnough")]
		public function no_credit():void
		{
			_model.putValue(ModelTag, 3);
			dispatcher(new ModelEvent(UpdateEvent(0)));	
		}
	}

}