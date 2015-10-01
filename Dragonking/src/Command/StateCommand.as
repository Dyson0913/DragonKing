package Command 
{
	import flash.events.Event;
	import Model.*;
	
	import util.*;
	import View.GameView.*;
	/**
	 * state event
	 * @author hhg4092
	 */
	public class StateCommand 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _model:Model;
		
		[Inject]
		public var _fileStream:fileStream;
		
		public function StateCommand() 
		{
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "update_state")]
		public function state_update():void
		{
			var state:int = _model.getValue(modelName.GAMES_STATE);		
			if ( state  == gameState.NEW_ROUND)
			{
				dispatcher(new ModelEvent("display"));
				dispatcher(new ModelEvent("clearn"));	
				_fileStream.write();
				if( !_fileStream._start) _fileStream.switch_recode(true);
			}
			else if ( state == gameState.END_BET) dispatcher(new ModelEvent("hide"));
			else if ( state == gameState.START_OPEN) dispatcher(new ModelEvent("hide"));
			else if ( state == gameState.END_ROUND) dispatcher(new ModelEvent("hide"));
			
			
		}
	}

}