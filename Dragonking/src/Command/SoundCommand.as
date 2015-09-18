package Command 
{
	import flash.events.Event;
	import Model.*;
	import Model.valueObject.StringObject;
	import treefortress.sound.SoundTween;
	
	import util.*;	
	
	import treefortress.sound.SoundAS;
     import treefortress.sound.SoundInstance;
     import treefortress.sound.SoundManager;

	 
	/**
	 * sound play
	 * @author hhg4092
	 */
	public class SoundCommand 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _model:Model;
		
		
		public function SoundCommand() 
		{
			
		}
		
		//[MessageHandler(type = "Model.ModelEvent", selector = "update_state")]
		public function init():void
		{
			SoundAS.addSound("Soun_Bet_BGM", new Soun_Bet_BGM());
			//SoundAS.addSound("C", new C());						
		}
		
		[MessageHandler(type="Model.valueObject.StringObject",selector="Music")]
		public function playMusic(sound:StringObject):void
		{
			
			//var s:SoundTween  = SoundAS.addTween(sound.Value);			
			
			var ss:SoundInstance = SoundAS.playFx(sound.Value);
			ss.fadeFrom(0, 1,2000);
		}
		
		public function playSound():void
		{
			
		}
		
	}

}