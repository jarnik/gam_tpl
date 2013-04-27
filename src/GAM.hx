package;

import gaxe.Gaxe;
import gaxe.SoundLib;
import gaxe.Debug;
import gaxe.GameLog;

import pug.model.Library;

import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.Lib;
import nme.ui.Keyboard;
import nme.Assets;

/**
 * @author Jarnik
 */
class GAM extends Gaxe {
	
	public static var lib:Library;
	private static var instance:GAM;
	
	public static function main() 
	{
		lib = new Library();
        lib.onLibLoaded.bindVoid( onLibLoaded );
        lib.importByteArrayPUG( Assets.getBytes("assets/pugs/gam.pug") );
	}
	
	private static function onLibLoaded():Void {
		Gaxe.loadGaxe( new GAM("ld26"), new Menu(), 640, 480 );
	}
	
	public static function track( data:Dynamic ):Void {
        instance._track( data );
    }
	
	private var appID:String;
	
	public function new ( appID:String ) {
		super();
		instance = this;
        this.appID = appID;
		initTracker();
	}
    
    private function initTracker() :Void {
        GameLog.init( appID, 'http://www.jarnik.com/amfphp/gateway.php' );
        GameLog.start();
    }

    public function _track( data: Dynamic ):Void {
        GameLog.log( data );
        Debug.log("tracked "+data);
    }
	
	override private function init():Void {
		super.init();
		SoundLib.autoInit();
		//switchScene( TitleScene ); 
		switchScene( PlayScene ); 
	}
	
	
	
}
