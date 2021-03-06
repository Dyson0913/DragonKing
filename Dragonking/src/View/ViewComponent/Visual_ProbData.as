package View.ViewComponent 
{
	import asunit.errors.AbstractError;
	import caurina.transitions.properties.DisplayShortcuts;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import View.GameView.gameState;
	
	/**
	 * Paytable present way
	 * @author Dyson0913
	 */
	public class Visual_ProbData  extends VisualHandler
	{
		public const prob_square:String = "prob";
		
		public function Visual_ProbData() 
		{
			
		}
		
		public function init():void
		{			
			var pro:MultiObject = create("prob",  [prob_square]);	
			pro.container.x = 384;
			pro.container.y =  176;
			pro.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			pro.Post_CustomizedData = [6, 50, 50];
			pro.Create_(6);
			
			put_to_lsit(pro);
			
			state_parse([gameState.END_BET, gameState.START_OPEN]);
		}
		
		override public function appear():void
		{
			Get("prob").container.visible = true;
			
			var zero:Array = utilFun.Random_N(0, 6);
			_model.putValue("percent_prob", zero);
			
			_model.putValue("five_percent_prob",zero);
			
			prob_update();
		}
		
		override public function disappear():void
		{			
			Get("prob").container.visible = false;
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="caculate_prob")]
		public function prob_percentupdate():void
		{			
			dispatcher(new StringObject("sound_prob","sound" ) );
			prob_update();
			
		}
		
		public function prob_update():void
		{
			//_model.putValue("percent_prob", [0,0,0,0,0,100]);
			var percentlist:Array = sin_ki_formula(_model.getValue("percent_prob"));			
			var len:int = percentlist.length;
			//utilFun.Log("prob_update =" + percentlist);
			
			var sort_percent:Array = [];			
			for (var k:int = 0; k < len ; k++)
			{
				var num:Number = percentlist[k];				
				sort_percent.push( { "idx":k, "num": num } );
			}
			sort_percent.sort(order);			
			
			var hiest:int = -1;	
			for ( var j:int = 0; j < len ; j++)
			{
				var ob:Object = sort_percent[j];
				//utilFun.Log("sort_percent idx =" + ob["idx"] + " num = " + ob["num"]);
				if ( j == 0)
				{
					if( ob["num"] !=0) hiest = ob["idx"];
				}
			}
			
		    //utilFun.Log("hiest = " + hiest);			
			var real:Array = _model.getValue("percent_prob")
			//utilFun.Log("real = " + real);			
			for ( var i:int = 0; i < len; i ++ )
			{				
				var real_per:Number = 	real[i];
				var gowithd:Number =  243 * ( percentlist[i]);
				Tweener.addTween(GetSingleItem("prob", i)["_mask"], { width:gowithd, time:1, onUpdate:this.percent, onUpdateParams:[GetSingleItem("prob", i), real_per,hiest == i] } );
			}
		}
		
		//傳回值 -1 表示第一個參數 a 是在第二個參數 b 之前。
		//傳回值 1 表示第二個參數 b 是在第一個參數 a 之前。
		//傳回值 0 指出元素都具有相同的排序優先順序。
		private function order(a:Object, b:Object):int 
		{
			if ( a["num"] >b["num"]) return -1;
			else if ( a["num"] < b["num"]) return 1;
			else return 0;			
		}
		
		private function sin_ki_formula(data:Array):Array
		{
			var raw_data:Array = [];
			raw_data = data.concat();
			var len:int = raw_data.length;
			for ( var i:int = 0; i < len; i++)
			{				
				raw_data[i] *= 10000;
			}
			//utilFun.Log("after 10000 =" + raw_data);
			for (  i = 0; i < len; i++)
			{				
				raw_data[i] = Math.sqrt(raw_data[i] ) *10 ;
			}
			//utilFun.Log("first q =" + raw_data);
			var total:Number = 0;
			for (  i = 0; i < len; i++)
			{
				raw_data[i] = Math.sqrt(raw_data[i] ) * 10 ;
				total += raw_data[i];
			}
			//utilFun.Log("swc q =" + raw_data);
			//utilFun.Log("total q =" + total);
			if ( total == 0) return raw_data;
			
			for ( i= 0; i < len; i++)
			{
				raw_data[i]  = raw_data[i]  / total ;
			}
			//utilFun.Log("per q =" + raw_data);
			
			//one kind match
			for ( i= 0; i < len; i++)
			{
				if ( raw_data[i] == 1 && total == 1000) return raw_data;
			}
			
			for (  i = 0; i < len; i++)
			{				
				if ( raw_data [i] != 0) 
				{
					raw_data[i] = Math.min( 0.9,  raw_data[i]  + 0.3 );
				}
			}
			return raw_data;
		}
		
		public function percent(mc:MovieClip,per:Number ,hist:Boolean ):void
		{
			
			if ( !hist) 
			{
				mc["_Text"].text = "";				
				mc["_probBar"].gotoAndStop(1);
				return;
			}			
			//if ( mc["_Text"].text == "") mc["_Text"].text = "1";
			
			mc["_probBar"].gotoAndStop(2);		
			
			if ( per == 100) mc["_Text"].text = per.toFixed(0) + "%";
			else mc["_Text"].text = per.toFixed(2) + "%";
			
			mc["_Text"].textColor = 0xFFDD00;
			
			//position follow
			//var po:Number = mc["_mask"].x + mc["_mask"].width;
			//mc["_Text"].x = po;
		}
		
		
		
	}

}