package View.ViewComponent 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import util.math.Path_Generator;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	import View.Viewutil.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import View.GameView.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import flash.events.MouseEvent;
	
	
	/**
	 * testinterface to fun quick test
	 * @author ...
	 */
	public class Visual_testInterface  extends VisualHandler
	{
		public var mouse:MouseTracker;
		
		[Inject]
		public var _primitvie:Visual_primitive;	
		
		
		[Inject]
		public var _objectinfo:Visual_objectInfo;	
		
		
		[Inject]
		public var objectPro:objectProperty;
		//
		//[Inject]
		//public var _path:Path_Generator;
		
		public function Visual_testInterface() 
		{
			
		}
		
		public function init():void
		{
			
			var btn:MultiObject = prepare("aa", new MultiObject() ,GetSingleItem("_view").parent.parent );			
			btn.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);			
			btn.stop_Propagation = true;
			btn.mousedown = test;			
			btn.mouseup = up;			
			btn.Create_by_list(4, ["coin_1"], 0, 0, 4, 110, 0, "Btn_");
			
			//model 		
			objectPro.init();
			
			//visual_interface
			_objectinfo.init();
			_objectinfo.recoderEvent = true;
			//_primitvie.init();
			//_primitvie.recoderEvent = true;
			//
			//_primitvie.g_line =  mouse.graphics;
			//_path.init();		
			
			//point test
			mouse = new MouseTracker();
			add(mouse);
			mouse.init();			
			mouse.mousedown= _objectinfo.select_object_mouse_down
			//mouse.mousemove = _primitvie.g_point_mouse_down;
			//mouse.mouseup = _primitvie.g_point_mouse_up;
			
			
		
		}		
		
		public function test(e:Event, idx:int):Boolean
		{
			utilFun.Log("test=" + idx);	
			
			if ( idx == 0) 
			{				
				_model.putValue(modelName.PLAYER_POKER, ["1d"]);
				dispatcher(new Intobject(modelName.PLAYER_POKER, "pokerupdate"));
            }
			  else if (idx == 1)
			  {
				_model.putValue(modelName.BANKER_POKER, ["2d"]);
				dispatcher(new Intobject(modelName.BANKER_POKER, "pokerupdate"));
				  
			  }
			   else if (idx == 2)
			  {
				_model.putValue(modelName.RIVER_POKER, ["3d"]);
				dispatcher(new Intobject(modelName.RIVER_POKER, "pokerupdate"));
			  }
            else if (idx == 3)
			{				
				
			}
				
			
			
			
			return true;
		}			
		
		
	
		
		public function up(e:Event, idx:int):Boolean
		{			
			return true;
		}	
		
	}

}