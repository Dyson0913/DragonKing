package View.ViewComponent 
{
	import flash.display.MovieClip;
	import util.math.Path_Generator;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;	
	import Command.*;
	
	/**
	 * poker present way
	 * @author ...
	 */
	public class Visual_poker  extends VisualHandler
	{
		private var pokerpath:Array = [];
			
		[Inject]
		public var _path:Path_Generator;
		
		public function Visual_poker() 
		{
			
		}
		
		public function init():void
		{			
			var table_hint:MultiObject = prepare("table_hint", new MultiObject(), GetSingleItem("_view").parent.parent);
			table_hint.autoClean = true;
			table_hint.CleanList();
			table_hint.Create_by_list(1, [ResName.open_tableitem], 0 , 0, 1, 0, 0, "Bet_");
			table_hint.container.x = 272;
			table_hint.container.y = 560;	
			table_hint.container.visible = false;
			
			var pokerkind:Array = [ResName.just_turnpoker];
			var playerCon:MultiObject = prepare(modelName.PLAYER_POKER, new MultiObject(), GetSingleItem("_view").parent.parent);
			playerCon.autoClean = true;
			playerCon.CleanList();
			playerCon.Create_by_list(2, pokerkind, 0 , 0, 2, 184, 0, "Bet_");
			playerCon.container.x = 283;
			playerCon.container.y = 627;
			playerCon.container.alpha = 0;
			
			var bankerCon:MultiObject =  prepare(modelName.BANKER_POKER, new MultiObject(), GetSingleItem("_view").parent.parent);
			bankerCon.autoClean = true;
			bankerCon.CleanList();		
			bankerCon.Create_by_list(2, pokerkind, 0 , 0, 2, 184, 0, "Bet_");
			bankerCon.container.x = 1298;
			bankerCon.container.y = 627;
			bankerCon.container.alpha = 0;
			
			var riverCon:MultiObject = prepare(modelName.RIVER_POKER, new MultiObject(), GetSingleItem("_view").parent.parent);
			riverCon.autoClean = true;
			riverCon.CleanList();
			riverCon.Create_by_list(2,pokerkind, 0 , 0, 2, 184, 0, "Bet_");			
			riverCon.container.x = 792;
			riverCon.container.y = 627;			
			riverCon.container.alpha = 0;
			
			var mipoker:MultiObject =  prepare("mipoker", new MultiObject(), GetSingleItem("_view").parent.parent);			
			mipoker.Create_by_list(1, [ResName.Mipoker_zone], 0 , 0, 1, 0, 0, "Bet_");			
			mipoker.container.x = 740;
			mipoker.container.y = 570;
			mipoker.container.alpha = 0;
			
			//_tool.SetControlMc(riverCon.container);
			//_tool.SetControlMc(playerCon.ItemList[1]);
			//add(_tool);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_poker():void
		{
			var pokerkind:Array = [ResName.just_turnpoker];			
			if ( Get(modelName.PLAYER_POKER) != null) 
			{								
				var playerCon:MultiObject = Get(modelName.PLAYER_POKER);
				playerCon.CleanList();				
				playerCon.Create_by_list(2,pokerkind, 0 , 0, 2, 184, 0, "Bet_");
				playerCon.container.alpha = 0;				
			}
			if ( Get(modelName.BANKER_POKER) != null) 
			{								
				var bankerCon:MultiObject = Get(modelName.BANKER_POKER);
				bankerCon.CleanList();			    
				bankerCon.Create_by_list(2,pokerkind, 0 , 0, 2, 184, 0, "Bet_");
				bankerCon.container.alpha = 0;				
			}
			
			if ( Get(modelName.RIVER_POKER) != null) 
			{				
				var riverCon:MultiObject = Get(modelName.RIVER_POKER);
				riverCon.CleanList();				
				riverCon.Create_by_list(2, pokerkind, 0 , 0, 2, 184, 0, "Bet_");
				riverCon.container.alpha = 0;				
			}
			
			Get("mipoker").CleanList();		
			Get("mipoker").Create_by_list(1, [ResName.Mipoker_zone], 0 , 0, 1, 130, 0, "Bet_");			
			Get("mipoker").container.alpha = 0;
			
			_model.putValue(modelName.PLAYER_POKER, [] );
			_model.putValue(modelName.BANKER_POKER, [] );
			_model.putValue(modelName.RIVER_POKER, []);
			
			Get("table_hint").container.visible = false;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function poker_display():void
		{
			
			var playerCon:MultiObject = Get(modelName.PLAYER_POKER);			
			_regular.FadeIn(playerCon.container, 1, 1,null);
			
			var bankerCon:MultiObject = Get(modelName.BANKER_POKER);
			_regular.FadeIn(bankerCon.container, 1, 1,null);
			
			var riverCon:MultiObject = Get(modelName.RIVER_POKER);
			_regular.FadeIn(riverCon.container, 1, 1, null);
			
			Get("table_hint").container.visible = true;
			
		}
		
		
		[MessageHandler(type = "Model.valueObject.Intobject", selector = "poker_No_mi")]
		public function poker_no_mi(type:Intobject):void
		{
			var mypoker:Array =   _model.getValue(type.Value);
			for ( var pokernum:int = 0; pokernum < mypoker.length; pokernum++)
			{				
				var pokerid:int = pokerUtil.pokerTrans(mypoker[pokernum])
				var anipoker:MovieClip = GetSingleItem(type.Value, pokernum);
				anipoker.visible = true;
				anipoker.gotoAndStop(1);
				anipoker["_poker"].gotoAndStop(pokerid);				
				anipoker.gotoAndStop(anipoker.totalFrames);				
				//Tweener.addTween(anipoker["_poker"], { rotationZ:24.5, time:0.3,onCompleteParams:[anipoker,anipoker["_poker"],0],onComplete:this.pullback} );
			}				
			dispatcher(new Intobject(type.Value, "show_judge"));
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject", selector = "poker_mi")]
		public function poker_mi(type:Intobject):void
		{
			var mypoker:Array =   _model.getValue(type.Value);
			var pokerid:int = pokerUtil.pokerTrans(mypoker[mypoker.length - 1]);		
			if ( mypoker.length == 2 && type.Value != modelName.RIVER_POKER )
			{				
				Get("mipoker").CleanList();		
				Get("mipoker").Create_by_list(1, [ResName.Mipoker_zone], 0 , 0, 1, 130, 0, "Bet_");
				Get("mipoker").container.alpha = 0;
				
				var mipoker:MultiObject = Get("mipoker");
				var mc:MovieClip = mipoker.ItemList[0];
				
				var pokerf:MovieClip = utilFun.GetClassByString(ResName.Poker);				
				var pokerb:MovieClip = utilFun.GetClassByString(ResName.poker_back);				
				var pokerm:MovieClip = utilFun.GetClassByString(ResName.pokermask);
				pokerb.x  = 140;
				pokerb.y  = 64;
				pokerf.x = 140;
				pokerf.y  = 64;
				pokerm.x = 136.35;
				pokerm.y = 185.8;
				pokerf.gotoAndStop(pokerid);
				pokerf.visible = false;
				pokerf.addChild(pokerm);
				mc.addChild(pokerf);
				mc.addChild(pokerb);				
				Tweener.addTween(mipoker.container, { alpha:1, time:1, onCompleteParams:[pokerf,pokerid,type.Value],onComplete:this.poker_mi_ani } );
				
				return;
			}			
			
			var anipoker:MovieClip = GetSingleItem(type.Value, mypoker.length - 1);
			anipoker.visible = true;
			anipoker.gotoAndStop(1);
			anipoker["_poker"].gotoAndStop(pokerid);			
			anipoker.gotoAndPlay(2);
			_regular.Call(anipoker, { onComplete:this.show_point_prob, onCompleteParams:[type.Value] }, 1, 0, 1);
			//Tweener.addTween(anipoker["_poker"], { rotationZ:24.5, time:0.3,onCompleteParams:[anipoker,anipoker["_poker"],0,mypoker.length,type.Value],onComplete:this.pullback} );
		}
		
		public function poker_mi_ani(pokerf:MovieClip,pokerid:int,pokertype:int):void
		{
			pokerf.visible = true;
			Tweener.addTween(pokerf, { x: (pokerf.x +50) , time:1, transition:"easeInSine" , onCompleteParams:[pokerf,pokerid,pokertype], onComplete: this.poker_mi_ani_2 } );			
		}
		
		public function poker_mi_ani_2(pokerf:MovieClip,pokerid:int,pokertype:int):void
		{
			//see 0.5 s
			Tweener.addTween(pokerf, { x: (pokerf.x +32) , time:1, delay:0.5, transition:"easeInSine",onCompleteParams:[pokerf,pokerid,pokertype],onComplete: this.sec_wait } );			
		}
		
		public function sec_wait(pokerf:MovieClip,pokerid:int, pokertype:int):void
		{
			//see 0.5 again
			Tweener.addTween(pokerf, { delay:0.5, transition:"easeInSine",onCompleteParams:[pokerf,pokerid,pokertype],onComplete: this.sec_wait_to_see } );
		}
		
		public function sec_wait_to_see(pokerf:MovieClip, pokerid:int, pokertype:int):void
		{
			//staty 0.5 to check 
			Tweener.addTween(pokerf, { delay:0.5, transition:"easeInSine",onCompleteParams:[pokerid,pokertype],onComplete: this.showfinal } );
		}
		
		public function showfinal(pokerid:int,pokertype:int):void
		{
			var mipoker:MultiObject = Get("mipoker");
			Tweener.addTween(mipoker.container, { alpha:0, time:1 } );
			var anipoker:MovieClip = GetSingleItem(pokertype, 1);
			anipoker.visible = true;			
			anipoker.gotoAndStop(1);
			anipoker["_poker"].gotoAndStop(pokerid);	
			anipoker.gotoAndStop(anipoker.totalFrames);
			
			show_point_prob(pokertype);
		}
		
		
		public function pullback(anipoker:MovieClip,mc:MovieClip,angel:int,pokerle:int,type:int):void
		{			
			if ( pokerle == 1)	Tweener.addCaller( anipoker, { time:1 , count: 1 , transition:"linear", onCompleteParams:[anipoker, mc, angel,type], onComplete: this.dis } );	
			else Tweener.addCaller( anipoker, { time:2 , count: 1 , transition:"linear", onCompleteParams:[anipoker, mc, angel, type], onComplete: this.dis } );
			
		}
		
		public function dis(anipoker:MovieClip,mc:MovieClip,angel:int,type:int):void
		{	
			anipoker.gotoAndPlay(7);				
			Tweener.addTween(mc, { rotationZ:angel, time:1, delay:1 } );
			Tweener.addCaller( anipoker, { time:1 , count: 1 , transition:"linear", onCompleteParams:[type], onComplete: this.show_point_prob } );	
		}
		
		public function show_point_prob(type:int):void
		{			
			
			dispatcher(new Intobject(type, "show_judge"));
			
			prob_cal();
			dispatcher(new Intobject(type, "caculate_prob"));	
			
			//TODO move to settle
			//check_power_up_effect();
			
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="show_judge")]
		public function early_check_point(type:Intobject):void
		{
			var Mypoker:Array =   _model.getValue(type.Value);
			
			var zone:int = -1;
			if ( modelName.PLAYER_POKER == type.Value)  zone = 0;
			else if ( modelName.BANKER_POKER == type.Value) zone = 1;
			if ( zone == -1 ) return;
			
			if ( Mypoker.length != 2) return;
			
			var point:int = pokerUtil.ca_point(Mypoker);
			utilFun.Log("point = " + point);
			if ( point == 0) point = 10;
			GetSingleItem("zone", zone ).gotoAndStop(2);
			GetSingleItem("zone", zone)["_num0"].gotoAndStop(point);
			
			//是否該提示公牌
			dispatcher(new Intobject(type.Value, "check_opencard_msg"));			
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="check_opencard_msg")]
		public function early_check_result(type:Intobject):void
		{			
			var ppoker:Array =   _model.getValue(modelName.PLAYER_POKER);
			var bpoker:Array =   _model.getValue(modelName.BANKER_POKER);			
			
			if ( ppoker.length + bpoker.length != 4) return;
			dispatcher(new ModelEvent("show_public_card_hint"));		
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject", selector = "show_who_win")]
		public function show_who_win():void
		{
			var ppoker:Array =   _model.getValue(modelName.PLAYER_POKER);
			var bpoker:Array =   _model.getValue(modelName.BANKER_POKER);
			
			var ppoint:int = pokerUtil.ca_point(ppoker);
			var bpoint:int = pokerUtil.ca_point(bpoker);			
			if ( ppoint > bpoint ) 
			{
				utilFun.Log("p>b");
				GetSingleItem("zone", 0 ).gotoAndStop(3);
				if ( ppoint == 0) ppoint = 10;
				GetSingleItem("zone", 0)["_num0"].gotoAndStop(ppoint);
			}
			else if ( ppoint < bpoint )
			{
				utilFun.Log("b>p");
				GetSingleItem("zone", 1 ).gotoAndStop(3);
				if ( bpoint == 0) bpoint = 10;
				GetSingleItem("zone", 1)["_num0"].gotoAndStop(bpoint);
			}
			else
			{
				utilFun.Log("tie");
				GetSingleItem("zone", 0 ).gotoAndStop(1);
				GetSingleItem("zone", 1 ).gotoAndStop(1);
				GetSingleItem("zone", 2 ).gotoAndStop(2);
			}
		}
		
		
		//TODO compare to pounit
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
		
		
		public function check_power_up_effect():void
		{			
			var re:int = utilFun.Random(2);
			
			//if ( re)
			//{
				//var idx:int = _model.getValue("power_pair_idx");
				//var arr:Array = _model.getValue("power_pair_posi")[idx];			
				//GetSingleItem("contractpower").x = arr[0];
				//GetSingleItem("contractpower").y = arr[1];			
				//GetSingleItem("contractpower").gotoAndPlay(2);
				//
				//
				//GetSingleItem("power_bar_2pair", idx).gotoAndStop(2)
				//GetSingleItem("power_bar_2pair", idx).alpha = 0;
				//_regular.FadeIn ( GetSingleItem("power_bar_2pair", idx), 3, 3,null);
				//_opration.operator("power_pair_idx", DataOperation.add, 1);
				//
			//}						
			//else
			//{
				//var idx:int = _model.getValue("power_3_idx");
				//var arr:Array = _model.getValue("power_3_posi")[idx];
			//
				//GetSingleItem("contractpower").x = arr[0];
				//GetSingleItem("contractpower").y = arr[1];			
				//GetSingleItem("contractpower").gotoAndPlay(2);
				//
				//GetSingleItem("powerbar_3", idx).gotoAndStop(2);
				//GetSingleItem("powerbar_3", idx).alpha = 0;
				//_regular.FadeIn ( GetSingleItem("powerbar_3", idx), 3, 3,null);
				//_opration.operator("power_3_idx", DataOperation.add, 1);
				//
			//}			
		
			
			
			
			
			
		//
			//GetSingleItem("powerbar_3", 0).gotoAndStop(2);
			//_model.getValue("power_pair_idx")
		}
		
		public function prob_cal():void
		{
			var arr:Array = utilFun.Random_N(80, 8);
			arr.push(utilFun.Random(8));
			_model.putValue("percent_prob",arr);
			return;
			
			var ppoker:Array =   _model.getValue(modelName.PLAYER_POKER);
			var bpoker:Array =   _model.getValue(modelName.BANKER_POKER);
			var rpoker:Array =   _model.getValue(modelName.RIVER_POKER);
			
			var totalPoker:Array = [];			
			totalPoker = totalPoker.concat(ppoker);
			totalPoker = totalPoker.concat(bpoker);
			totalPoker = totalPoker.concat(rpoker);
			var rest_poker_num:int = 52 - totalPoker.length;
			utilFun.Log("rest_poker_num = " + rest_poker_num);
			utilFun.Log("totalpoker = " + totalPoker);
			totalPoker.sort(order);
			utilFun.Log("after sort = " + totalPoker);
			var num_amount:Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			var color_amount:Array = [0,0,0,0];
			
			for ( var i:int = 0; i < totalPoker.length; i++)
			{
				var point:String = totalPoker[i].substr(0, 1);
				var color:String = totalPoker[i].substr(1, 1);
				if ( color == "d") color_amount[0] += 1;	
				if ( color == "h") color_amount[1] += 1;	
				if ( color == "s") color_amount[2] += 1;	
				if ( color == "c") color_amount[3] += 1;	
				
				if ( point == "i" ) point = "10";
				if ( point == "j" ) point = "11";
				if ( point == "q" ) point = "12";
				if ( point == "k" ) point = "13";				
				num_amount[parseInt(point)] += 1;				
			}
			utilFun.Log("num_amount= " + num_amount);
			utilFun.Log("color_amount= " + color_amount);
			
			//3條 (每個張數都要算)
			var three:int = 0;			
			var maxValue:Number = Math.max.apply(null, num_amount);
			//var minValue:Number = Math.min.apply(null, num_amount);
			utilFun.Log("maxValue= " + maxValue);			
			utilFun.Log("three_prob  = (4- samepoint_max_cnt/rest_poker_num)= " + (4 - maxValue) / rest_poker_num * 100);
			
			
			
			//dispatcher(new Intobject(type, "caculate_prob"));
		}		
		
		//傳回值 -1 表示第一個參數 a 是在第二個參數 b 之前。
		//傳回值 1 表示第二個參數 b 是在第一個參數 a 之前。
		//傳回值 0 指出元素都具有相同的排序優先順序。
		private function order(a:String, b:String):int 
		{
			var apoint:String = a.substr(0, 1);
			var bpoint:String = b.substr(0, 1);
			if ( apoint == "i" ) apoint = "10";
			if ( apoint == "j" ) apoint = "11";
			if ( apoint == "q" ) apoint = "12";
			if ( apoint == "k" ) apoint = "13";
			
			if ( bpoint == "i" ) bpoint = "10";
			if ( bpoint == "j" ) bpoint = "11";
			if ( bpoint == "q" ) bpoint = "12";
			if ( bpoint == "k" ) bpoint = "13";
			
			if ( parseInt( apoint)  < parseInt( bpoint) ) return -1;
			else if (  parseInt( apoint) > parseInt( bpoint )) return 1;
			else return 0;			
		}	 
	
	}

}