package Model 
{	
	import flash.net.FileReference;
	import com.adobe.serialization.json.JSON	
	import util.utilFun;
	/**
	 * 輸出模型
	 * @author hhg4092
	 */
	public class fileStream 
	{
		private var _recodeData:Array = [];
		
		public var _start:Boolean = false;
		
		public function fileStream() 
		{
			
		}
		
		public function write():void
		{
			if ( !_start ) return;
			
			var file:FileReference = new FileReference();
			
			var myob:Object = { size:1, aaa:3 };
			var myob2:Object = { size:3, aaa:2 };
			_recodeData.push(myob);
			_recodeData.push(myob2);
			var arr:Array = [];
			for ( var i:int = 0; i < _recodeData.length ; i++)
			{
				var jsonString:String = JSON.encode(_recodeData[i]);			
				jsonString += "\n";
				utilFun.Log("js = "+jsonString);
				arr.push(jsonString);
			}
			utilFun.Log("j = "+arr.join(""));
			
			file.save(arr.join(""), "myfile.txt");
			
		}
		
		public function switch_recode(recode:Boolean):void
		{
			_start = recode;
		}
		
		public function recode(ob:Object):void
		{
			if ( _start) _recodeData.push(ob);
			
		}
	
	}

}