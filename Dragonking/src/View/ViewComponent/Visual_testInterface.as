package View.ViewComponent 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Transform;
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
	import flash.geom.Matrix;
	import com.adobe.serialization.json.JSON;
	/**
	 * testinterface to fun quick test
	 * @author ...
	 */
	public class Visual_testInterface  extends VisualHandler
	{
		[Inject]
		public var _coin:Visual_Coin;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _path:Path_Generator;
		
		[Inject]
		public var _MsgModel:MsgQueue;		
		
		
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
			
			_path.init();
			_betCommand.bet_init();
						
			
			//var playerzone:MultiObject = prepare("anitets", new MultiObject() , GetSingleItem("_view").parent.parent);			
			//playerzone.container.x = 200;
			//playerzone.container.y = 200;
			//playerzone.Create_by_list(1, ["flip_poker"], 0, 0, 1,0, 0, "time_");		
			//playerzone.ItemList
			
			//_model.putValue(modelName.PLAYER_POKER, ["1d","2d"]);
			
		
			
		}		
		
		public function test(e:Event, idx:int):Boolean
		{
			utilFun.Log("test=" + idx);	
			
			if ( idx == 0) 
			{				
				_model.putValue(modelName.PLAYER_POKER, ["1d,","2d"]);
				_model.putValue(modelName.BANKER_POKER, ["1s"]);
				dispatcher(new Intobject(modelName.PLAYER_POKER, "poker_No_mi"));
				//dispatcher(new Intobject(modelName.PLAYER_POKER, "poker_mi"));
				//dispatcher(new Intobject(modelName.PLAYER_POKER, "pokerupdate"));
				//dispatcher(new Intobject(modelName.BANKER_POKER, "pokerupdate"));
				//var mypoker:MovieClip = GetSingleItem("anitets");
				//mypoker.gotoAndStop(1);				
				//mypoker["_poker"].gotoAndStop(2);	
				//mypoker["_poker_a"].gotoAndStop(2);	
				//mypoker.gotoAndPlay(2);			
				//Tweener.addTween(mypoker["_poker"], { rotationZ:24.5, time:0.3,onCompleteParams:[mypoker["_poker"],0],onComplete:this.pullback} );
				
				//var mymatrix:Matrix = new Matrix(1, 1, 0, 1, 0, 0);
				//var myTransfrom:Transform = new Transform(mypoker);
				//myTransfrom.matrix = mymatrix;				
				
				//_tool.SetControlMc(coinob.ItemList[0]);
				//_tool.SetControlMc(mypoker);
				//add(_tool);
            }
			  else if (idx == 1)
			  {
				 _model.putValue(modelName.PLAYER_POKER, ["1d", "2d"]);
				_model.putValue(modelName.BANKER_POKER, ["1s"]);
				dispatcher(new Intobject(modelName.PLAYER_POKER, "pokerupdate"));
				dispatcher(new Intobject(modelName.BANKER_POKER, "pokerupdate"));
				//var mypoker:MovieClip = GetSingleItem("anitets");
				//mypoker.gotoAndStop(1);				
				//mypoker["_poker"].gotoAndStop(32);
				//mypoker["_poker_a"].gotoAndStop(32);	
				//mypoker.gotoAndPlay(2);			
				//Tweener.addTween(mypoker["_poker"], { rotationZ:24.5, time:0.3,onCompleteParams:[mypoker["_poker"],0],onComplete:this.pullback} );
			  }
			   else if (idx == 2)
			  {
				//var mypoker:MovieClip = GetSingleItem("anitets");
				//mypoker.gotoAndStop(1);				
				//mypoker["_poker"].gotoAndStop(47);	
				//mypoker["_poker_a"].gotoAndStop(47);	
				//mypoker.gotoAndPlay(2);			
				//Tweener.addTween(mypoker["_poker"], { rotationZ:24.5, time:0.3, onCompleteParams:[mypoker["_poker"], 0], onComplete:this.pullback } );
				
				 _model.putValue(modelName.PLAYER_POKER, ["1d", "2d"]);
				_model.putValue(modelName.BANKER_POKER, ["1s","2s"]);
				_model.putValue(modelName.BANKER_POKER, ["3d","7d"]);
				dispatcher(new Intobject(modelName.PLAYER_POKER, "pokerupdate"));
				dispatcher(new Intobject(modelName.BANKER_POKER, "pokerupdate"));
			  }
            else if (idx == 3)
			{				
				var fakePacket:Object =  { "result_list": [
			                                                                {"bet_type": "BetBWPlayer", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0 },
																			{"bet_type": "BetBWBanker", "settle_amount": 0, "odds": 2, "win_state": "WSLost", "bet_amount": 0 } ],
																			"game_state": "EndRoundState", 
																			"game_result_id": "225761", 
																			"timestamp": 1439967961.396191, 
																			"remain_time": 4, 
																			"game_type": "BigWin", 
																			"game_round": 1, 
																			"game_id": "BigWin-1", 
																			"message_type": 
																			"MsgBPEndRound", 
			"id": "bfc643be464011e599caf23c9189e2a9" } ;
			
			_MsgModel.push(fakePacket);
			}
				
			
			
			
			return true;
		}			
		
		
		public function pullback(mc:MovieClip,angel:int):void
		{
			
				var mypoker:MovieClip = GetSingleItem("anitets");
				mypoker.gotoAndPlay(7);
				
				//_tool.SetControlMc(mc);
				//add(_tool);
				Tweener.addTween(mc, { rotationZ:angel, time:1, delay:1 } );			
		}
		
		public function up(e:Event, idx:int):Boolean
		{			
			return true;
		}	
		
	}

}