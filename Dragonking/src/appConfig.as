package  
{	
	
	import org.spicefactory.parsley.asconfig.processor.ActionScriptConfigurationProcessor;
	import org.spicefactory.parsley.core.registry.ObjectDefinition;
	
	import ConnectModule.websocket.WebSoketComponent;
	
	import Command.*;	
	import Model.*;	
	import util.math.*;
	import util.*;
	import View.ViewBase.*;
	import View.ViewComponent.*;
	import View.Viewutil.Visual_debugTool;
	import View.GameView.*;
	import Model.CommonModel.*;	
	/**
	 * ...
	 * @author hhg
	 */
	public class appConfig 
	{
		//要unit test 就切enter來達成
		
		//singleton="false"
		[ObjectDefinition(id="Enter")]
		public var _LoadingView:LoadingView = new LoadingView();		
		public var _betView:betView = new betView();
		public var _HudView:HudView = new HudView();
		
		//model
		public var _Model:Model = new Model();
		public var _MsgModel:MsgQueue = new MsgQueue();
		public var _Actionmodel:ActionQueue = new ActionQueue();
		
		//common model
		public var _m_timer:Model_Timer = new Model_Timer();
		public var _m_hintmsg:Model_HintMsg = new Model_HintMsg();
		public var _m_Text:Model_Text = new Model_Text();
		public var _m_Show:Model_Show = new Model_Show();
		
		//connect module
		public var _socket:WebSoketComponent = new WebSoketComponent();
		
		//command 
		public var _viewcom:ViewCommand = new ViewCommand();
		public var _state:StateCommand = new StateCommand();
		public var _dataoperation:DataOperation = new DataOperation();
		public var _betcom:BetCommand = new BetCommand();
		public var _regular:RegularSetting = new RegularSetting();
		public var _sound:SoundCommand = new SoundCommand(); 
		
		//util
		public var _path:Path_Generator = new Path_Generator();
		
		//visual base
		public var _text:Visual_Text = new Visual_Text();
		public var _debugTool:Visual_debugTool = new Visual_debugTool();
		
		//visual
		public var _pokerhandler:Visual_poker = new Visual_poker();
		public var _timer:Visual_timer = new Visual_timer();
		public var _hint:Visual_Hintmsg = new Visual_Hintmsg();
		public var _playerinfo:Visual_PlayerInfo = new Visual_PlayerInfo();
		public var _coin:Visual_Coin = new Visual_Coin();
		public var _coin_stack:Visual_Coin_stack = new Visual_Coin_stack();
		public var _betzone:Visual_betZone = new Visual_betZone();
		public var _btn:Visual_BtnHandle = new Visual_BtnHandle();
		public var _settle:Visual_Settle = new Visual_Settle();
		public var _sencer:Visual_betZone_Sence = new Visual_betZone_Sence();
		public var _gameinfo:Visual_Game_Info = new Visual_Game_Info();
		public var _paytable:Visual_Paytable = new Visual_Paytable();
		
		//test
		public var _test:Visual_testInterface = new Visual_testInterface();
		
		
		//[ProcessSuperclass]
		//public var _vibase:ViewBase = new ViewBase();
		
		
		public function appConfig() 
		{
			
		}
	
	}

}