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
	
	/**
	 * Paytable present way
	 * @author Dyson0913
	 */
	public class Visual_ProbData  extends VisualHandler
	{
		
		public function Visual_ProbData() 
		{
			
		}
		
		public function init():void
		{			
			var pro:MultiObject = create("prob",  [ResName.prob_square]);	
			pro.container.x = 384;
			pro.container.y =  176;
			pro.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			pro.Post_CustomizedData = [6, 50, 50];
			pro.Create_(6, "prob");
			
			put_to_lsit(pro);	
		}
	
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{			
			Get("prob").container.visible = false;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function opencard_parse():void
		{
			Get("prob").container.visible = true;
			
			var zero:Array = utilFun.Random_N(0, 6);
			_model.putValue("percent_prob",zero);
			prob_update();
			
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="caculate_prob")]
		public function prob_percentupdate():void
		{			
			dispatcher(new StringObject("sound_prob","sound" ) );
			prob_update();
			
		}
		
		public function prob_update():void
		{
			var percentlist:Array = _model.getValue("percent_prob");	
			utilFun.Log("prob_update =" + percentlist);
			var total:Number = 0;
			var len:int = percentlist.length;
			for ( var i:int = 0; i < len; i++)
			{
				total += percentlist[i];
			}
			utilFun.Log("total =" + total);
			var relative_percent:Array = [];
			var sort_percent:Array = [];
			
			for (var k:int = 0; k < len ; k++)
			{
				var num:Number =0;
				if ( total != 0) num = (percentlist[k]  / total) ;
				relative_percent.push ( num);				
				sort_percent.push( { "idx":k, "num": num } );
			}
			sort_percent.sort(order);
			
			//utilFun.Log("after prob_update =" + relative_percent);
			
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
			for ( var i:int = 0; i < len; i ++ )
			{				
				var real_per:Number = 	percentlist[i];
				var gowithd:int =  125 * ( relative_percent[i]);
				Tweener.addTween(GetSingleItem("prob", i)["_mask"], { width:gowithd, time:1, onUpdate:this.percent, onUpdateParams:[GetSingleItem("prob", i), real_per, 5,hiest == i] } );
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
		
		public function percent(mc:MovieClip,per:Number,start:int ,hist:Boolean ):void
		{
			
			if ( !hist) 
			{
				mc["_Text"].text = "";				
				mc["_probBar"].gotoAndStop(1);
				return;
			}			
			if ( mc["_Text"].text == "") mc["_Text"].text = "1";
			
			mc["_probBar"].gotoAndStop(2);
			
			var p:Number = (parseInt( mc["_Text"].text) +start );
			if (p >= per) p = per;
			
			mc["_Text"].text = p.toString() + "%";
			mc["_Text"].textColor = 0xFFDD00;
			
			//position follow
			//var po:Number = mc["_mask"].x + mc["_mask"].width;
			//mc["_Text"].x = po;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_parse():void
		{			
			Get("prob").container.visible = false;		
		}
		
	}

}