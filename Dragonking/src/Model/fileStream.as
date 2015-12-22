package Model 
{	
	import flash.events.*;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import com.adobe.serialization.json.JSON	
	import flash.utils.ByteArray;
	import Model.valueObject.ArrayObject;
	import util.utilFun;
	
	/**
	 * 輸出模型
	 * @author hhg4092
	 */
	public class fileStream 
	{
		private var _recodeData:Array = [];
		
		private var _packlist:Array = [];
		private var _pack_idx:int = 0;
		
		public var _start:Boolean = false;
		
		private var _openfile:FileReference = new FileReference();
		
		[Inject]
		public var _MsgModel:MsgQueue;
		
		public function fileStream() 
		{
			
		}
		
		//start recoding
		[MessageHandler(type = "Model.ModelEvent", selector = "new_round")]
		public function recoding():void
		{
			if ( CONFIG::release ) return;
			
			write();
			if( !_start) switch_recode(true);
		}
		
		[MessageHandler(type="Model.valueObject.ArrayObject",selector="pack_recoder")]
		public function get_package(pack:ArrayObject):void
		{
			if ( CONFIG::release ) return;
			
			if ( !_start) return;
			recode(pack.Value[0]);
		}
		
		public function write():void
		{
			if ( !_start ) return;
			
			var file:FileReference = new FileReference();
			
			//var myob:Object = { size:1, aaa:3 };
			//var myob2:Object = { size:3, aaa:2 };
			//_recodeData.push(myob);
			//_recodeData.push(myob2);
			var arr:Array = [];
			for ( var i:int = 0; i < _recodeData.length ; i++)
			{
				var jsonString:String = JSON.encode(_recodeData[i]);				
				arr.push(jsonString);
			}			
			_recodeData.length = 0;
			
			var packhead:String = "{\"packlist\":[\n" + arr.join(",\n") +"]}";			
			file.save(packhead, "pack_.txt");
		}
		
		public function load():void
		{			
			_openfile.addEventListener(Event.SELECT, onFileSelected); 
			   var textTypeFilter:FileFilter = new FileFilter("Text Files (*.txt, *.rtf)", 
                        "*.txt;*.rtf"); 
            _openfile.browse([textTypeFilter]); 
		}
		
		public function onFileSelected(evt:Event):void 
        {            
            _openfile.addEventListener(Event.COMPLETE, onComplete); 
            _openfile.load(); 
        } 
		
		public function onComplete(evt:Event):void 
        { 
			_packlist.length = 0;
			_pack_idx = 0;
            //utilFun.Log("File was successfully loaded."); 
			var ba:ByteArray = ByteArray(_openfile.data); 
			var utf8Str:String = ba.readMultiByte(ba.length, 'utf8');
			//utilFun.Log("data = "+utf8Str); 
			var result:Object  = JSON.decode(utf8Str);
			
			var arr:Array = result.packlist;
			utilFun.Log("data one = "+arr.length); 
			utilFun.Log("data one = " + arr[0]); 
			
			
        } 
		
		public function pack_play():void
		{			
			var fakePacket:Object  = _packlist[_pack_idx]; 
			_MsgModel.push(fakePacket);			
			_pack_idx += 1;
			_pack_idx %= _packlist.length;			
		}
		
		public function switch_recode(recode:Boolean):void
		{
			_start = recode;
		}
		
		public function recode(ob:Object):void
		{
			utilFun.Log("recoe !");
			_recodeData.push(ob);			
		}
	
	}

}