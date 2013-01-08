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
    cows:Int,
    hens:Int,
    coinSpeed:Float,
    crossP:Float,
    swapP:Float
    //cityName:String,    
}

class Levels
{	
    public static var config:Level;

    public static inline var levels:Array<Level> = [
        { tile: "tile_stones.png", coins: 3, speed:0.8, blocks: 0, cows: 0, hens: 0, coinSpeed: 0, crossP: 0.3 ,swapP: 0.3  },
        { tile: "tile_stones.png", coins: 3, speed:0.8, blocks: 0, cows: 0, hens: 0, coinSpeed: 0, crossP: 0 ,swapP:0 }
    ];

}
