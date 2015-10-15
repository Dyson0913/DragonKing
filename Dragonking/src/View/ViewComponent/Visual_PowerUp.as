package View.ViewComponent 
{
	import flash.events.Event;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * betzone present way
	 * @author ...
	 */
	public class Visual_PowerUp  extends VisualHandler
	{	
		[Inject]
		public var _text:Visual_Text;
		
		[Inject]
		public var _betCommand:BetCommand;	
		
		public function Visual_PowerUp() 
		{
			
		}
		
		public function init():void
		{
			
			//集氣吧
			var powerbar:MultiObject = create("powerbar",  [ResName.powerbar]);
			powerbar.container.x = 1302;
			powerbar.container.y = 390;			
			powerbar.Create_(1, "powerbar");
			//powerbar.container.visible = false;			
			
			var powerbar_3:MultiObject = create("powerbar_3",  [ResName.power_bar3],  powerbar.container);
			powerbar_3.container.x = 4.35;
			powerbar_3.container.y = 6;			
			powerbar_3.Post_CustomizedData = [5, 59, 0 ];
			powerbar_3.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			powerbar_3.Create_(5, "powerbar_3");
						
			var powerbar_2pair:MultiObject = create("power_bar_2pair", [ResName.power_bar_2pair] ,  powerbar.container);
			powerbar_2pair.container.x = 4.35;
			powerbar_2pair.container.y = 46.5;
			powerbar_2pair.Post_CustomizedData = [5, 59, 0 ];
			powerbar_2pair.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			powerbar_2pair.Create_(5, "power_bar_2pair");
			
			var powerbarname:MultiObject = create("powerbarname",  [ResName.powerbar_name], powerbar.container);
			powerbarname.container.x = 15.35;
			powerbarname.Create_(1, "powerbarname");
			
			//next grid 65
			var contractpower:MultiObject = create("contractpower", [ResName.contractpower],  powerbar.container);
			contractpower.container.x = -270;
			contractpower.container.y = -210;			
			contractpower.Create_(1, "contractpower");
			
			//累租金額
			var power_bar_amount:MultiObject = create("power_bar_amount",  [ResName.TextInfo], powerbar.container);		
			power_bar_amount.container.x = 304;
			power_bar_amount.container.y = -4;
			power_bar_amount.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			power_bar_amount.Post_CustomizedData = [2,10,46];
			power_bar_amount.CustomizedFun = _text.textSetting;
			power_bar_amount.CustomizedData = [{size:22,align:_text.align_left}, "",""];
			power_bar_amount.Create_(2, "power_bar_amount");
			
			var PowerJP:MultiObject = create("Power_JP",  [ResName.PowerJP]);
			PowerJP.container.x = 969;
			PowerJP.container.y = 433;			
			PowerJP.Create_(1, "Power_JP");
			PowerJP.container.visible = false;
			
			var PowerJPNum:MultiObject = create("Power_JP_num",  [ResName.PowerJP_Num], Get("Power_JP").container);			
			
			
			put_to_lsit(powerbar);	
			put_to_lsit(powerbar_3);	
			put_to_lsit(powerbar_2pair);	
			put_to_lsit(contractpower);	
			put_to_lsit(power_bar_amount);	
			put_to_lsit(PowerJP);	
			put_to_lsit(PowerJPNum);	
		}		
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="power_up")]
		public function check_power_up_effect(type:Intobject):void
		{			
			var kind:int = type.Value;	
			var arr:Array = [];
			var idx:int ;
			var nowIdx:int;
			var acumu:Number ;
			if ( kind == 0)
			{
				idx = _model.getValue("power_pair_idx");
				arr = _model.getValue("power_pair_posi")[idx];	
				
				GetSingleItem("power_bar_2pair", idx).gotoAndStop(2)
				GetSingleItem("power_bar_2pair", idx).alpha = 0;
				_regular.FadeIn ( GetSingleItem("power_bar_2pair", idx), 3, 3, null);
				GetSingleItem("contractpower").x = arr[0];
				GetSingleItem("contractpower").y = arr[1];			
				GetSingleItem("contractpower").gotoAndPlay(2);
				
				nowIdx = _opration.operator("power_pair_idx", DataOperation.add, 1);				
				
				acumu = _model.getValue("power_jp")[1];
				acumu += _betCommand.check_jp() * 0.05;
				GetSingleItem("power_bar_amount", 1).getChildByName("Dy_Text").text = acumu.toString();
				
				
			}						
			else
			{
				idx = _model.getValue("power_3_idx");
				arr = _model.getValue("power_3_posi")[idx];			
				
				GetSingleItem("powerbar_3", idx).gotoAndStop(2);
				GetSingleItem("powerbar_3", idx).alpha = 0;
				_regular.FadeIn ( GetSingleItem("powerbar_3", idx), 3, 3, null);
				GetSingleItem("contractpower").x = arr[0];
				GetSingleItem("contractpower").y = arr[1];			
				GetSingleItem("contractpower").gotoAndPlay(2);
				nowIdx  = _opration.operator("power_3_idx", DataOperation.add, 1);
				
				acumu = _model.getValue("power_jp")[0];
				acumu += _betCommand.check_jp() * 0.1;
				GetSingleItem("power_bar_amount", 0).getChildByName("Dy_Text").text = acumu.toString();				
				
			}			
			
			
			if ( ! power_jp(nowIdx, acumu, kind))
			{
				dispatcher(new Intobject(1, "settle_step"));	
				utilFun.SetTime(triger, 2);
			}
		}
		
		private function triger():void
		{
			dispatcher(new StringObject("sound_Powerup_poker","sound" ) );
		}
		
		private function power_jp(idx:int,acumu:int,type:int):Boolean
		{
			if ( idx != 5) return false;
			
			Get("Power_JP").container.visible = true;
			var s:String = acumu.toString();
			var arr:Array = utilFun.frameAdj(s.split(""));					
			
			var PowerJPNum:MultiObject = Get("Power_JP_num");
			PowerJPNum.container.x = -30 + ((-57 /2) * (arr.length-1));
			PowerJPNum.container.y = 110;		
			PowerJPNum.CustomizedData = arr;
			PowerJPNum.CustomizedFun = _regular.FrameSetting;
			PowerJPNum.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			PowerJPNum.Post_CustomizedData = [arr.length, 57, 10];
			PowerJPNum.Create_(arr.length, "Power_JP_num");					
			_regular.Call(this, { onComplete:this.showok,onCompleteParams:[type] }, 4, 1, 1, "linear");
			dispatcher(new StringObject("sound_bigPoker", "sound" ) );
			
			return true;
		}
		
		private function showok(type:int):void
		{
			Get("Power_JP").container.visible = false;
			var PowerJPNum:MultiObject = Get("Power_JP_num");
			PowerJPNum.CleanList();			
			
			
			if ( type == 1)
			{
				_model.putValue("power_3_idx", 0 );				
				setFrame("powerbar_3", 1);
				GetSingleItem("power_bar_amount", 0).getChildByName("Dy_Text").text = "";	
			}
			else
			{
				_model.putValue("power_pair_idx",0);
				setFrame("power_bar_2pair", 1);			
				GetSingleItem("power_bar_amount", 1).getChildByName("Dy_Text").text = "";	
			}
			
			dispatcher(new Intobject(1, "settle_step"));	
		}
		
	}

}