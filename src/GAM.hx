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
        tracker = new Tracker('UA-9311186-1', 'www.jarnik.info');

        // (could also get unserialized from somewhere)
        visitor = new googleAnalytics.Visitor();
        visitor.setUserAgent('haXe-ga');
        visitor.setScreenResolution( FlxG.width+'x'+FlxG.height);
        
        session = new googleAnalytics.Session();
    }

    public function _track( action:String ):Void {
        var e:googleAnalytics.Event = new googleAnalytics.Event( 
            action,
            appID
        );
        tracker.trackEvent( e, session, visitor );
        /*
        var page = new googleAnalytics.Page("/gam");
        page.setTitle(action);
        tracker.trackPageview(page, session, visitor);        
        */
        FlxG.log("tracked "+appID+":"+action);
    }

    public static function track( action:String ):Void {
        instance._track( action );
    }

}
