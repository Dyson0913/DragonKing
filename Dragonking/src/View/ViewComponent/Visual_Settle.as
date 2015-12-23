package View.ViewComponent 
{
	import asunit.framework.Assert;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import View.GameView.gameState;
	
	/**
	 * settle present way
	 * @author Dyson0913
	 */
	public class Visual_Settle  extends VisualHandler
	{
		public const playerScore:String = "PlayerScore";
		public const bankerScore:String = "BankerScore";
		public const TieScore:String = "tieScore";
		
		public function Visual_Settle() 
		{
			
		}
		
		public function init():void
		{
			var zoneCon:MultiObject = create("zone", [playerScore, bankerScore, TieScore]);
			zoneCon.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			zoneCon.Post_CustomizedData = [[0, 0], [1018, 0], [560, 0]];
			zoneCon.Create_(3, "zone");
			zoneCon.container.x = 358;
			zoneCon.container.y = 560;
			
			put_to_lsit(zoneCon);
			
			state_parse([gameState.END_ROUND]);
		}
		
		override public function appear():void
		{
			
		}
		
		override public function disappear():void
		{			
			setFrame("zone", 1);
		}		
			
		[MessageHandler(type="Model.valueObject.Intobject",selector="settle_step")]
		public function settles(v:Intobject):void
		{			
			//沒中大獎 才秀 誰贏
			if (  _model.getValue("bigwin") == null) dispatcher(new Intobject(1, "show_who_win"));
			
			//結算表
			dispatcher(new ModelEvent("show_settle_table"));			
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
				GetSingleItem("zone", 0 ).gotoAndStop(3);
				if ( ppoint == 0) ppoint = 10;
				GetSingleItem("zone", 0)["_num0"].gotoAndStop(ppoint);
				dispatcher(new StringObject("sound_player_win", "sound" ) );
			}
			else if ( ppoint < bpoint )
			{			
				GetSingleItem("zone", 1 ).gotoAndStop(3);
				if ( bpoint == 0) bpoint = 10;
				GetSingleItem("zone", 1)["_num0"].gotoAndStop(bpoint);
				dispatcher(new StringObject("sound_deal_win", "sound" ) );
			}
			else
			{			
				GetSingleItem("zone", 2).gotoAndStop(2);
				dispatcher(new StringObject("sound_tie_win", "sound" ) );
			}
		}
		
	}
	
	

}