package View.GameView
{	
	import com.adobe.utils.DictionaryUtil;
	import Command.BetCommand;
	import Command.RegularSetting;
	import Command.ViewCommand;
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	import flash.text.TextField;
	import Model.valueObject.Intobject;
	import Res.ResName;
	import util.DI;
	import util.node;
	import View.ViewBase.ViewBase;
	import Command.DataOperation;
	import flash.text.TextFormat;
	import View.ViewComponent.*;
	import View.Viewutil.*;
	
	import Model.*;
	import util.utilFun;
	import caurina.transitions.Tweener;	
	
	/**
	 * ...
	 * @author hhg
	 */

	 
	public class LoadingView extends ViewBase
	{		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _test:Visual_testInterface;
		
		public function LoadingView()  
		{
			
		}
		
			//result:Object
		public function FirstLoad(para:Array ):void
 		{			
			utilFun.Log("FirstLoad =" + para);
			//_model.putValue(modelName.LOGIN_INFO, para[0]);
			_model.putValue(modelName.UUID,  para[0]);
			_model.putValue(modelName.CREDIT, para[1]);
			_model.putValue(modelName.Client_ID, para[2]);
			_model.putValue(modelName.HandShake_chanel, para[3]);
			_model.putValue(modelName.Domain_Name, para[4]);
			
			_betCommand.bet_init();
			
			_model.putValue("history_win_list", []);				
			_model.putValue("result_Pai_list", []);
			_model.putValue("game_round", 1);			
			
			_model.putValue("power_3_posi", [[0, 0], [65, 0], [130, 0], [195, 0],[260, 0]]);
			_model.putValue("power_pair_posi", [[0, 45], [65, 45], [130, 45], [195, 45],[260, 45]]);
			_model.putValue("power_3_idx", 0);
			_model.putValue("power_pair_idx", 0);
			
			dispatcher(new Intobject(modelName.Loading, ViewCommand.SWITCH));			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Loading) return;
			super.EnterView(View);
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.emptymc], 0, 0, 1, 0, 0, "a_");
					
			//utilFun.SetTime(connet, 0.1);
			_test.init();			
		}
		private function connet():void
		{	
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.CONNECT));
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Loading) return;
			super.ExitView(View);
			utilFun.Log("LoadingView ExitView");
		}
		
		
	}

}