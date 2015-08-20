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
		public var _regular:RegularSetting;
		
		[Inject]
		public var _path:Path_Generator;
		
		public function Visual_poker() 
		{
			
		}
		
		public function init():void
		{
			var playerCon:MultiObject = prepare(modelName.PLAYER_POKER, new MultiObject(), GetSingleItem("_view").parent.parent);
			playerCon.autoClean = true;
			playerCon.CleanList();
			playerCon.Create_by_list(2, [ResName.flippoker], 0 , 0, 2, 165, 0, "Bet_");
			playerCon.container.x = 320;
			playerCon.container.y = 580;
			playerCon.container.alpha = 0;
			
			var bankerCon:MultiObject =  prepare(modelName.BANKER_POKER, new MultiObject(), GetSingleItem("_view").parent.parent);
			bankerCon.autoClean = true;
			bankerCon.CleanList();		
			bankerCon.Create_by_list(2, [ResName.flippoker], 0 , 0, 2, 165, 0, "Bet_");
			bankerCon.container.x = 1310;
			bankerCon.container.y = 580;
			bankerCon.container.alpha = 0;
			
			var riverCon:MultiObject = prepare(modelName.RIVER_POKER, new MultiObject(), GetSingleItem("_view").parent.parent);
			riverCon.autoClean = true;
			riverCon.CleanList();
			riverCon.Create_by_list(2, [ResName.flippoker], 0 , 0, 2, 165, 0, "Bet_");			
			riverCon.container.x = 820;
			riverCon.container.y = 580;			
			riverCon.container.alpha = 0;
			//_tool.SetControlMc(riverCon.container);
			//add(_tool);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_poker():void
		{
			utilFun.Log("poker clean");
			if ( Get(modelName.PLAYER_POKER) != null) 
			{								
				var playerCon:MultiObject = Get(modelName.PLAYER_POKER);
				playerCon.CleanList();				
				playerCon.Create_by_list(2, [ResName.flippoker], 0 , 0, 2, 165, 0, "Bet_");
				playerCon.container.alpha = 0;
				//playerCon.container.x = 320;
				//playerCon.container.y = 580;
			}
			if ( Get(modelName.BANKER_POKER) != null) 
			{								
				var bankerCon:MultiObject = Get(modelName.BANKER_POKER);
				bankerCon.CleanList();			    
				bankerCon.Create_by_list(2, [ResName.flippoker], 0 , 0, 2, 165, 0, "Bet_");
				bankerCon.container.alpha = 0;
				//bankerCon.container.x = 1310;
				//bankerCon.container.y = 580;
			}
			
			if ( Get(modelName.RIVER_POKER) != null) 
			{				
				var riverCon:MultiObject = Get(modelName.RIVER_POKER);
				riverCon.CleanList();				
				riverCon.Create_by_list(2, [ResName.flippoker], 0 , 0, 2, 165, 0, "Bet_");
				riverCon.container.alpha = 0;
				//riverCon.container.x = 820;
				//riverCon.container.y = 580;		
			}
			
			_model.putValue(modelName.PLAYER_POKER, [] );
			_model.putValue(modelName.BANKER_POKER, [] );
			_model.putValue(modelName.RIVER_POKER, []);
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function poker_display():void
		{
			
			var playerCon:MultiObject = Get(modelName.PLAYER_POKER);			
			_regular.FadeIn(playerCon.container, 1, 1,null);
			
			var bankerCon:MultiObject = Get(modelName.BANKER_POKER);
			_regular.FadeIn(bankerCon.container, 1, 1,null);
			
			var riverCon:MultiObject = Get(modelName.RIVER_POKER);
			_regular.FadeIn(riverCon.container, 1, 1,null);
			
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="pokerupdate")]
		public function playerpokerupdate(type:Intobject):void
		{
		
			var Mypoker:Array =   _model.getValue(type.Value);				
			for ( var pokernum:int = 0; pokernum < Mypoker.length; pokernum++)
			{
				//paipathinit(type.Value, pokernum);
				var pokerid:int = pokerUtil.pokerTrans(Mypoker[pokernum])
				paideal(pokerid, type.Value, pokernum,true);
			}			
			
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
				anipoker["_poker_a"].gotoAndStop(pokerid);
				anipoker.gotoAndStop(anipoker.totalFrames);
				dispatcher(new Intobject(type.Value, "show_judge"));
				//Tweener.addTween(anipoker["_poker"], { rotationZ:24.5, time:0.3,onCompleteParams:[anipoker,anipoker["_poker"],0],onComplete:this.pullback} );
			}				
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject", selector = "poker_mi")]
		public function poker_mi(type:Intobject):void
		{
			var mypoker:Array =   _model.getValue(type.Value);
			var pokerid:int = pokerUtil.pokerTrans(mypoker[mypoker.length - 1])					
			var anipoker:MovieClip = GetSingleItem(type.Value, mypoker.length - 1);
			anipoker.visible = true;
			anipoker.gotoAndStop(1);
			anipoker["_poker"].gotoAndStop(pokerid);
			anipoker["_poker_a"].gotoAndStop(pokerid);
			anipoker.gotoAndPlay(2);
			Tweener.addTween(anipoker["_poker"], { rotationZ:24.5, time:0.3,onCompleteParams:[anipoker,anipoker["_poker"],0,mypoker.length,type.Value],onComplete:this.pullback} );			
		}
		
		
		
		public function pullback(anipoker:MovieClip,mc:MovieClip,angel:int,pokerle:int,type:int):void
		{			
			if ( pokerle == 1)	Tweener.addCaller( anipoker, { time:1 , count: 1 , transition:"linear", onCompleteParams:[anipoker, mc, angel,type], onComplete: this.dis } );	
			else Tweener.addCaller( anipoker, { time:2 , count: 1 , transition:"linear", onCompleteParams:[anipoker, mc, angel,type], onComplete: this.dis } );		
			
					
		}
		
		public function dis(anipoker:MovieClip,mc:MovieClip,angel:int,type:int):void
		{	
			anipoker.gotoAndPlay(7);				
			Tweener.addTween(mc, { rotationZ:angel, time:1, delay:1 } );
			Tweener.addCaller( anipoker, { time:1 , count: 1 , transition:"linear", onCompleteParams:[type], onComplete: this.showjudge } );	
		}
		
		public function showjudge(type:int):void
		{
			dispatcher(new Intobject(type, "show_judge"));
		}
		
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="playerpokerAni")]
		public function playerpokerani(type:Intobject):void
		{				
			var mypoker:Array =   _model.getValue(type.Value);			
			//取得第n 張牌路徑			
			paipathinit(type.Value, mypoker.length - 1);
			var pokerid:int = pokerUtil.pokerTrans(mypoker[mypoker.length - 1])
			paideal(pokerid, type.Value, mypoker.length - 1);
			
		}
		
		public function paideal(pokerid:int, cardtype:int, pokernum:int, static_deal:Boolean = false):void
	   {		   
		   	var mypoker:MovieClip = utilFun.GetClassByString(ResName.Poker);					
			mypoker.gotoAndStop(pokerid);			
			
			var pokerbac:MovieClip = GetSingleItem(cardtype, pokernum);			
			pokerbac.visible = true;
			pokerbac.addChild(mypoker)
			//_tool.SetControlMc(mypoker);
			//add(_tool);
			//
			if ( static_deal )
			{				
				//pokerbac.rotationY = -180;
				//Tweener.addTween(pokerbac, { rotationY: -180, time:1, transition:"easeInOutCubic" } )
				//pokerbac.x = pokerpath [pokerpath.length-1].x;
				//pokerbac.y = pokerpath [pokerpath.length - 1].y;
			}
			else
			{
				mypoker.visible = false;
				mypoker.x = 168;
				mypoker.rotationY = -180;
				
				pokerbac.rotation = -65;
				pokerbac.scaleX = 0.48;
				pokerbac.scaleY = 0.48;
				
				
				pokerbac.x = pokerpath[0].x;
				pokerbac.y = pokerpath[0].y;
				Tweener.addTween(pokerbac, {
					x:pokerpath [pokerpath.length -1].x,
					y:pokerpath [pokerpath.length -1].y,
					_bezier:_path.makeBesierArray(pokerpath),
					time:0.5, onComplete:ok, onCompleteParams:[pokerbac,mypoker], transition:"linear"});
			
				Tweener.addTween(pokerbac, { scaleX:0.8, scaleY:0.8, rotation: 0, time:0.5, transition:"easeInOutCubic" } )
			}
	   }
		
	   public function ok(pokerbac:MovieClip,mypoker:MovieClip):void
		{		
			//翻牌
			Tweener.addTween(pokerbac, { rotationY:-180, time:0.5, transition:"linear",onUpdate:this.show,onUpdateParams:[pokerbac,mypoker] } )
		}
		
		public function show(pokerbac:MovieClip,mypoker:MovieClip):void
		{			
			if ( pokerbac.rotationY <= -100)
			{
				mypoker.visible = true;
			}
		}
		
		public function paipathinit(cardtype:int ,npoker:int):void
		{
			var path:Array;
			if ( cardtype == modelName.PLAYER_POKER) path = _model.getValue("player_pokerpath")		
			else path = _model.getValue("banker_pokerpath");
			
			pokerpath.length = 0;
			pokerpath = _path.get_Path_isometric(path,npoker);
			
		}
	}

}