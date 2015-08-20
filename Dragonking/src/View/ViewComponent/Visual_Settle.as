package View.ViewComponent 
{
	import flash.display.MovieClip;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * hintmsg present way
	 * @author ...
	 */
	public class Visual_Settle  extends VisualHandler
	{
		[Inject]
		public var _regular:RegularSetting;
		
		public function Visual_Settle() 
		{
			
		}
		
		public function init():void
		{
			var zoneCon:MultiObject = prepare("zone", new MultiObject(), GetSingleItem("_view").parent.parent);
			zoneCon.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			zoneCon.Post_CustomizedData = [[0, 0], [880, 0], [520, 0]];
			zoneCon.Create_by_list(3, [ResName.playerScore, ResName.bankerScore,ResName.TieScore], 0 , 0, 3, 500, 0, "Bet_");		
			zoneCon.container.visible = false;
			zoneCon.container.x = 420;
			zoneCon.container.y = 460;
			
			var bigwinCon:MultiObject = prepare("bigwinmsg", new MultiObject(), GetSingleItem("_view").parent.parent);
			bigwinCon.Create_by_list(1, [ResName.Bigwinmsg], 0 , 0, 1, 0, 0, "Bet_");
			bigwinCon.container.visible = false;
			bigwinCon.container.x = 600;
			bigwinCon.container.y = 420;		
			
			//_tool.SetControlMc(zoneCon.container);
			//_tool.SetControlMc(zoneCon.ItemList[2]);
			//add(_tool);
			Clean();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean():void
		{
			Get("zone").container.visible = false;
			Get("bigwinmsg").container.visible = false;
			
			var a:MultiObject = Get("zone");
			for ( var i:int = 0; i <  a.ItemList.length; i++)
			{
				GetSingleItem("zone", i).visible = false;
				GetSingleItem("zone", i).gotoAndStop(1);
			}
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function round_result():void
		{		
			var result_list:Array = _model.getValue(modelName.ROUND_RESULT);
			var num:int = result_list.length;
				utilFun.Log("result  =  " + result_list);		
				utilFun.Log("num  =  " + num);		
			var result:Array = [];
			var clean:Array = [];
			var lostcount:int = 0;
			for ( var i:int = 0; i < num; i++)
			{
				var resultob:Object = result_list[i];
				
				
				var result:Array  = [];
				result.push(_model.getValue(resultob.bet_type));				
				//frame
				if ( resultob.win_state == "WSLost") result.push(1);
				if ( resultob.win_state == "WSWin") result.push(2);
				
				if ( resultob.win_state == "WSBWNormalWin") result.push(3);				
				if ( resultob.win_state == "WSBWStraight") result.push(4);
				if ( resultob.win_state == "WSBWFlush") result.push(5);
				if ( resultob.win_state == "WSBWFullHouse") result.push(6);
				if ( resultob.win_state == "WSBWFourOfAKind") result.push(7);
				if ( resultob.win_state == "WSBWStraightFlush") result.push(8);
				if ( resultob.win_state == "WSBWRoyalFlush") result.push(9);
				
				utilFun.Log("resultob  =  " + resultob.bet_type +" win_state  =  " + resultob.win_state);	
				utilFun.Log("result  =  " + result);			
				var zone:int = parseInt( result[0]);
				var winstate:int = parseInt(result[1]);
				
				//大獎提示
				if ( winstate >= 4)
				{
					Get("bigwinmsg").container.visible = true;
					GetSingleItem("bigwinmsg").gotoAndStop(winstate-3);	
					_regular.FadeIn( GetSingleItem("bigwinmsg"), 2, 2, _regular.Fadeout);						
				}
				else
				{
					//誰贏?
				}
				
				
				if ( winstate == 1)
				{
					clean.push(zone);
					lostcount += 1;
				}			
				
				//coin show or disapear
				if ( winstate != 1) _regular.Twinkle(GetSingleItem("betzone", zone), 3, 10, 2);	
				else utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone", zone));
				
				if ( zone == 0 || zone == 1)
				{					
					if ( winstate == 1) GetSingleItem("zone", zone ).visible = false;
					else  
					{
						GetSingleItem("zone", zone ).gotoAndStop(2);
						Tweener.addTween(GetSingleItem("zone", zone), { time:1.5, onCompleteParams:[GetSingleItem("zone", zone), winstate], onComplete:fanout } );
					}
					
				}
			}
			
			if ( lostcount == 2)
			{				
				GetSingleItem("zone", 2).visible = true;
				Tweener.addTween(GetSingleItem("zone", 2), { time:1.5, onCompleteParams:[GetSingleItem("zone", 2), winstate], onComplete:fanout } );
			}
			
			
			
			utilFun.Log("clean =" + clean);
			for ( i = 0; i < clean.length ; i++)
			{
				utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone", clean[i]));
			}
			
			
		}
		
		
		public function fanout(hint:MovieClip,winstate):void
		{			
			hint.visible = false;
			
		}
		
		private function countPoint(poke:Array):int
		{
			var total:int = 0;
			for (var i:int = 0; i < poke.length ; i++)
			{
				var strin:String =  poke[i];
				var arr:Array = strin.match((/(\w|d)+(\w)+/));					
				var numb:String = arr[1];				
				
				var point:int = 0;
				if ( numb == "i" || numb == "j" || numb == "q" || numb == "k" ) 				
				{
					point = 10;
				}				
				else 	point = parseInt(numb);
				
				total += point;
			}	
			
			return total %= 10;
		}		
		
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="show_judge")]
		public function early_check_point(type:Intobject):void
		{
			var Mypoker:Array =   _model.getValue(type.Value);
			
			if ( Mypoker.length == 2 )
			{
				
				var point:Array = utilFun.arrFormat(countPoint(Mypoker), 1);
				if ( point[0] == 0 ) point[0] = 10;				
				var zone:int = -1;
				if ( modelName.PLAYER_POKER == type.Value)  zone = 0;
				else if ( modelName.BANKER_POKER == type.Value) zone = 1;				
				if ( zone == -1) return;
				Get("zone").container.visible = true;
				GetSingleItem("zone", zone ).visible = true;
				
				GetSingleItem("zone",zone)["_num0"].gotoAndStop(point[0]);					
			}			
		}
		
		
	}
	
	

}