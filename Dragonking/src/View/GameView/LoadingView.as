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
		public var _regular:RegularSetting;	
		
		[Inject]
		public var _visual_test:Visual_testInterface;
		
		[Inject]
		public var _poker:Visual_poker;
		
		[Inject]
		public var _coin:Visual_Coin;
		
		[Inject]
		public var _betzone:Visual_betZone;
		
		[Inject]
		public var _timer:Visual_timer;
		
		[Inject]
		public var _btn:Visual_BtnHandle;
		
		
		[Inject]
		public var _settle:Visual_Settle;
		
		public function LoadingView()  
		{
			
		}
		
			//result:Object
		public function FirstLoad(para:Array ):void
 		{			
			//_model.putValue(modelName.LOGIN_INFO, para[0]);
			_model.putValue(modelName.UUID,  para[0]);
			_model.putValue(modelName.CREDIT, para[1]);
			_model.putValue(modelName.Client_ID, para[2]);
			_model.putValue(modelName.HandShake_chanel, para[3]);
			dispatcher(new Intobject(modelName.Loading, ViewCommand.SWITCH));			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Loading) return;
			super.EnterView(View);
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.Loading_Scene], 0, 0, 1, 0, 0, "a_");
			//
			_regular.strdotloop(view.ItemList[0]["_Text"], 20, 40);		
			utilFun.SetTime(connet, 1);		
			//
			//_visual_test.init();
			//
			//_coin.init();
			//_poker.init();
			//_settle.init();
			
		//	_btn.init();
			//
			//_settle.init();
			//
			
			
			//_betzone.init();
			//_timer.init();
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