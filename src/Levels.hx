package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;

import haxe.Md5;

import googleAnalytics.Tracker;
import googleAnalytics.Visitor;
import googleAnalytics.Session;
	
enum ENEMY {
    COW;
}

typedef Level = {
    tile:String,
    coins:Int,
    speed:Float,
    blocks:Int,
    enemies:Array<ENEMY>
    //cityName:String,    
}

class Levels
{	
    public static var config:Level;

    public static inline var levels:Array<Level> = [
        { tile: "tile_grass.png", coins: 3, speed:0.8, blocks: 0, enemies: [] },
        { tile: "tile_grass.png", coins: 0, speed:0.6, blocks: 0, enemies: [] }
    ];

}
