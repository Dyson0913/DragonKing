package View.ViewBase 
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;
	import flash.utils.Timer;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	/**
	 * Dynamic_text (for mandarin font)
	 * @author Dyson0913
	 */
	public class Visual_Text  extends VisualHandler
	{
		
		public function Visual_Text() 
		{
			
		}
		
		public function init():void
		{			
			
		}
		
		public function textSetting(mc:MovieClip, idx:int, data:Array):void
		{						
			var str:TextField = dynamic_text(data[idx+1],data[0]);			
			mc.addChild(str);
		}
		
		public function dynamic_text(text:String,para:Array):TextField
		{		
			var size:int = para[0];
			var textColor:uint = 0xFFFFFF;
			var align:String = TextFormatAlign.LEFT;
			if ( para.length > 1)  
			{
				textColor = para[1];
				align = para[2];
			}
						
			var _NickName:TextField = new TextField();
			_NickName.width = 626.95;
			_NickName.height = 134;
			_NickName.textColor = textColor;
			_NickName.selectable = false;		
			_NickName.autoSize = TextFieldAutoSize.LEFT;				
			_NickName.wordWrap = true; //auto change line
			_NickName.multiline = true; //multi line
			_NickName.maxChars = 300;
			//"微軟正黑體"
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = size;
			myFormat.align = align;
			myFormat.font = "Microsoft JhengHei";			
			
			_NickName.defaultTextFormat = myFormat;				
			_NickName.text = text;			
			return _NickName;
		}
		
	}

}