package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
	
class GAM extends FlxGame
{	

    private var appID:String;
    private static var instance:GAM;

	public function new( appID:String )
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		var ratioX:Float = stageWidth / 320;
		var ratioY:Float = stageHeight / 240;
		var ratio:Float = Math.min(ratioX, ratioY);
		super(Math.floor(stageWidth / ratio), Math.floor(stageHeight / ratio), MenuState, ratio, 30, 30);
		//super(Math.floor(stageWidth / ratio), Math.floor(stageHeight / ratio), PlayState, ratio, 30, 30);
		forceDebugger = true;

        instance = this;

        this.appID = appID;
        initTracker();
	}

    // ----------------- Google Analytics tracking ----------------------- 
    
    private function initTracker() :Void {
        GameLog.init( appID, 'http://www.jarnik.com/amfphp/gateway.php' );
        GameLog.start();
    }

    public function _track( data: Dynamic ):Void {
        GameLog.log( data );
        FlxG.log("tracked "+data);
    }

    public static function track( data:Dynamic ):Void {
        instance._track( data );
    }

}
