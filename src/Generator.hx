package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;

import haxe.Md5;

import googleAnalytics.Tracker;
import googleAnalytics.Visitor;
import googleAnalytics.Session;
	
class Generator
{	

	public static function init( hash:String ):Void {
        FlxG.globalSeed = hashToFloat( hash );
	}

    private static function hashToFloat( hash:String ):Float {
        var seed:Float = 0;
        for ( i in 0...hash.length )
            seed += hash.charCodeAt( i );
        return 1 / seed; // 0 - 1
    }

    public static function random():Float {
        return FlxG.random();
    }

    public static function getRandomHash():String {
        return Md5.encode( Std.string( Math.random()*1000000 ) );
    }


}
