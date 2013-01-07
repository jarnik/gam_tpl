package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;

import googleAnalytics.Tracker;
import googleAnalytics.Visitor;
import googleAnalytics.Session;
	
class GAM extends FlxGame
{	

    // GA tracker
    private var tracker:Tracker;
    private var session:Session;
    private var visitor:Visitor;
    private var appID:String;
    private var startTime:Float;
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
        startTime = Date.now().getTime();

        this.appID = appID;
        initTracker();
	}

    // ----------------- Google Analytics tracking ----------------------- 
    
    private function initTracker() :Void {
        tracker = new Tracker('UA-9311186-1', 'www.jarnik.info');

        // (could also get unserialized from somewhere)
        visitor = new googleAnalytics.Visitor();
        visitor.setUserAgent('haXe-ga');
        visitor.setScreenResolution( FlxG.width+'x'+FlxG.height);
        
        session = new googleAnalytics.Session();
    }

    public function _track( state:String, action:String ):Void {
        var time:Int = Math.round( Date.now().getTime() - startTime );
        var e:googleAnalytics.Event = new googleAnalytics.Event( 
            appID,
            state,
            action,
            time,
            true
        );
        tracker.trackEvent( e, session, visitor );
        FlxG.log("tracked "+appID+":"+state+":"+action);

        // haxe-ga HACK
        // /usr/lib/haxe/lib/haxe-ga/0,2/googleAnalytics/internals/request/
        // X10 serialization puts in weird "0!", confusing GA
        // I am serializing it by hand using:
        // p.utme = "5("+this.event.getCategory()+"*"+this.event.getAction()+"*"+this.event.getLabel()+")("+this.event.getValue()+")";
    }

    public static function track( state:String, action:String = "" ):Void {
        instance._track( state, action );
    }

}
