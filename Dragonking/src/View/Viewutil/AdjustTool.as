package View.Viewutil 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getDefinitionByName;
	import Interface.ViewComponentInterface;
	
	import util.utilFun;	
	import caurina.transitions.Tweener;
	
	/**
	 * mc動態調整工具,放入要調整的mc,就不用改一個屬性->complier->測試,一次調完
	 * @author hhg
	 */
	public class AdjustTool extends MovieClip
	{
		private var _ControlItem:DisplayObjectContainer;
		private var _ControlMultiobject:MultiObject;
		
		private var _Menu:TextField;
		
		private var _itemlist:Array = [];
		
		//滑入滑出顏色
		private var _RollInColor:uint = 0x009966;
		private var _RollOutColor:uint = 0xFFFF00;
		
		//微調單位
		private var _AdjustUnit:Number = 10;
		
		//調整屬性數量
		private var _AttributeCnt:int = 1;
		
		public static const _AdValue:String = "AdValue";
		public static const _X:String = "x";
		public static const _Y:String = "y";
		public static const _Rotation:String = "Rotation";
		
		public function AdjustTool() 
		{
			
		}
		
		public function adjust_add(mc:ViewComponentInterface):void
		{
			_ControlItem = mc.getDisplayobject();
			_ControlMultiobject = mc as MultiObject;
			//功能表
			_Menu = Createitem(_ControlItem.name, _RollOutColor);
			addChild(_Menu);
			//utilFun.Log
			for (var i:int = 0; i < _ControlMultiobject.ItemList.length; i++)
			{
				//功能表
				var child:TextField = Createitem(_ControlMultiobject.ItemList[i].name, _RollOutColor);
				child.x = i * 50;
				_itemlist.push( child);
				addChild(child);
			}
			
			
			utilFun.AddMouseListen(_Menu, this.MenuEffect);
		}
		
		//public function SetControlMc(mc:DisplayObject):void
		//{
			//_ControlItem = mc;
			//
			//功能表
			//_Menu = Createitem(mc.name, _RollOutColor);
			//addChild(_Menu);
			//utilFun.AddMouseListen(_Menu, this.MenuEffect);
		//}
		
		
		
		private function MenuEffect(e:Event):void 
		{			
			switch (e.type)
			{
				case MouseEvent.MOUSE_DOWN:
						PopMyFunList();
					break;
				case MouseEvent.ROLL_OUT:
						_Menu.backgroundColor  = _RollOutColor;
					break;
				case MouseEvent.ROLL_OVER:
						_Menu.backgroundColor  = _RollInColor;
				break;
			}
		}
		
		private function PopMyFunList():void
		{
			utilFun.ReMoveMouseListen(_Menu, this.MenuEffect);
			
			var TweenerY:Number = 25;
			
			//想要徵調的屬性
			PopItemList(_AdValue, _AdjustUnit, TweenerY * _AttributeCnt);
			PopItemList(_X, _ControlItem.x, TweenerY * _AttributeCnt);
			PopItemList(_Y, _ControlItem.y, TweenerY * _AttributeCnt);
			PopItemList(_Rotation, _ControlItem.rotation, TweenerY * _AttributeCnt);
		}
		
		private function PopItemList(AttributeName:String, CurrentValue:Number,TweenerY:Number):void
		{
			var ShiftX:Number = 10;
			
			//-
			var minBtn:TextField = Createitem("-", _RollOutColor);
			minBtn.name = "Min_" + AttributeName;
			utilFun.AddMouseListen(minBtn, this.onMin);
			addChild(minBtn);
			Tweener.addTween(minBtn, { y:TweenerY, transition: "easeOutElastic", time: 1 } );
			
			//屬性名
			var AttriBtn:TextField = Createitem(AttributeName, _RollOutColor);
			AttriBtn.x = minBtn.x + minBtn.width + ShiftX;
			addChild(AttriBtn);
			Tweener.addTween(AttriBtn, { y:TweenerY, transition: "easeOutElastic", time: 1 } );
			
			//+
			var PlusBtn:TextField = Createitem("+", _RollOutColor);
			PlusBtn.name =  "Plus_" + AttributeName;
			utilFun.AddMouseListen(PlusBtn, this.onPlus);
			PlusBtn.x = AttriBtn.x + AttriBtn.width + ShiftX;
			
			addChild(PlusBtn);
			Tweener.addTween(PlusBtn, { y:TweenerY, transition: "easeOutElastic", time: 1 } );
			
			
			//目前值
			var ValueBtn:TextField = Createitem(CurrentValue.toString(), _RollOutColor);
			ValueBtn.name = "Value_" + AttributeName;
			ValueBtn.x = PlusBtn.x + PlusBtn.width + ShiftX;
			addChild(ValueBtn);
			Tweener.addTween(ValueBtn, { y:TweenerY, transition: "easeOutElastic", time: 1 } );
			
			_AttributeCnt++;
		}
		
		private function onMin(e:Event):void 
		{
			var sName:String = utilFun.Regex_CutPatten(e.currentTarget.name,/Min_/);
			var Value:Object = this.getChildByName("Value_" + sName);
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_DOWN:
						switch (sName)
						{
							case _AdValue:
								_AdjustUnit--
								Value.text = _AdjustUnit;
							break;
							
							case _X:
								_ControlItem.x -= _AdjustUnit;
								Value.text = _ControlItem.x.toString();
							break;
							
							case _Y:
								_ControlItem.y -= _AdjustUnit;
								Value.text = _ControlItem.y.toString();
							break; 
							
							case _Rotation:
								_ControlItem.rotation -= _AdjustUnit;
								Value.text = _ControlItem.rotation.toString();
							break; 
						}
					break;
				case MouseEvent.ROLL_OUT:
						e.currentTarget.backgroundColor  = _RollOutColor;
					break;
				case "rollOver":
						e.currentTarget.backgroundColor  = _RollInColor;
				break;
			}
		}
		
		private function onPlus(e:Event):void 
		{
			var sName:String = utilFun.Regex_CutPatten(e.currentTarget.name,/Plus_/);
			var Value:Object = this.getChildByName("Value_" + sName);
			
			switch (e.type)
			{
				case MouseEvent.MOUSE_DOWN:
						switch (sName)
						{
							case _AdValue:
								_AdjustUnit++
								Value.text = _AdjustUnit;
							break;
							
							case _X:
								_ControlItem.x += _AdjustUnit;
								Value.text = _ControlItem.x.toString();
							break;
							
							case _Y:
								_ControlItem.y += _AdjustUnit;
								Value.text = _ControlItem.y.toString();
							break; 
							
							case _Rotation:
								_ControlItem.rotation += _AdjustUnit;
								Value.text = _ControlItem.rotation.toString();
							break; 
						}
					break;
				case MouseEvent.ROLL_OUT:
						e.currentTarget.backgroundColor  = _RollOutColor;
					break;
				case MouseEvent.ROLL_OVER:
						e.currentTarget.backgroundColor  = _RollInColor;
				break;
			}
		}
		
		/******************** 元件 ********************/
		
		private	function Createitem(text:String,color:uint,align:String = TextFieldAutoSize.LEFT):TextField
		{
			var tx:TextField = new TextField();
			tx.background = true;
			tx.backgroundColor  = color;
			tx.text = text;
			tx.width = tx.textWidth;
			tx.height = tx.height;
			tx.selectable = false;
			tx.autoSize = align;
			return tx;
		}
		
		
	}

}