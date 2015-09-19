package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import Model.CommonModel.Model_Timer;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * timer present way
	 * @author ...
	 */
	public class Visual_timer  extends VisualHandler
	{
		public var Waring_sec:int;		
		
		[Inject]
		public var _m_timer:Model_Timer;
		
		public function Visual_timer() 
		{
			
		}
		
		public function init():void
		{
		   var _countDown:MultiObject = create(_m_timer.ResName, [_m_timer.ResName]);	
		   _countDown.Create(1,_m_timer.ResName);
		   _countDown.container.x = 1208;
		   _countDown.container.y = 338;		   
		   
		   var _timellight:MultiObject  = create(_m_timer.exTraResName(0), [_m_timer.exTraResName(0)], _countDown.container);		   
		   _timellight.Create(1,_m_timer.exTraResName(0));		   
		   _timellight.container.x = 75;
		   _timellight.container.y = 75;
		   	
		   	//_tool.SetControlMc(playerzone.ItemList[0]);
			//_tool.SetControlMc(timellight.container);
			//_tool.x = 100;
			//add(_tool);
			timer_reset()
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "Timer_reset")]
		public function timer_reset():void
		{			
			Get(_m_timer.ResName).container.visible = false;
			
			GetSingleItem(_m_timer.ResName)["_Text"].textColor = 0x0099CC;
			GetSingleItem(_m_timer.ResName).gotoAndStop(1);
			GetSingleItem(_m_timer.ResName).gotoAndStop(1);
			
			Waring_sec = 7;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "Timer_update")]
		public function dddisplay():void
		{			
			var time:int = _model.getValue(_m_timer.ModelTag);			
			Get(_m_timer.ResName).container.visible = true;			
			utilFun.SetText(GetSingleItem(_m_timer.ResName)["_Text"], utilFun.Format(time, 2) );
			
			var mc:MovieClip = GetSingleItem(_m_timer.exTraResName(0));
			if ( time == Waring_sec )
			{
				GetSingleItem(_m_timer.ResName)["_Text"].textColor = 0xFF0000;
				GetSingleItem(_m_timer.ResName).gotoAndStop(2);
				mc.gotoAndStop(2);
			}
			
			Tweener.addCaller(mc, { time:1 , count: 36, onUpdate:TimeLight , onUpdateParams:[mc, 10 ], transition:"linear" } );	
		}
		
		private function TimeLight(mc:MovieClip,angel:int):void
		{
		   mc.rotation += angel;
		}
		
	}

}