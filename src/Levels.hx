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
    swapP:Float,
    cityName:String,    
    citySkin:String
}

class Levels
{	
    public static var config:Level;
    public static var current:Int;

    // Hamburg
    // Linz

    // Baghdad
    // Istanbul

    // Beijing
    // Kyoto

    // Lima
    // Tenochtitlan

    // Prague
    // Pilsen

    public static inline var levels:Array<Level> = [
        // no coins, simple roads
        { tile: "tile_grass.png", coins: 0, speed:0.4, blocks: 0, cows: 0, hens: 0, coinSpeed: 0, crossP: 0.3, swapP: 0.3, cityName:"Hamburg", citySkin:"tile_german.png"  },
        // one coin, simple roads,
        { tile: "tile_grass.png", coins: 1, speed:0.6, blocks: 0, cows: 0, hens: 0, coinSpeed: 0, crossP: 0.5, swapP: 0.3, cityName:"Linz", citySkin:"tile_german.png" },

        // three coins, normal roads
        { tile: "tile_sand.png", coins: 3, speed:0.7, blocks: 0, cows: 0, hens: 0, coinSpeed: 0, crossP: 0.5, swapP: 0.3, cityName:"Istanbul", citySkin:"tile_arabic.png"  },
        // +blocks
        { tile: "tile_sand.png", coins: 3, speed:0.5, blocks: 3, cows: 0, hens: 0, coinSpeed: 0, crossP: 0.5, swapP: 0.3, cityName:"Baghdad", citySkin:"tile_arabic.png"  },

        { tile: "tile_grass.png", coins: 3, speed:0.5, blocks: 3, cows: 0, hens: 0, coinSpeed: 0, crossP: 0.5, swapP: 0.3, cityName:"Beijing", citySkin:"tile_chinese.png"  },
        // +cows
        { tile: "tile_grass.png", coins: 3, speed:0.6, blocks: 3, cows: 3, hens: 0, coinSpeed: 0, crossP: 0.5, swapP: 0.3, cityName:"Kyoto", citySkin:"tile_chinese.png"  },

        // +hens
        { tile: "tile_stones.png", coins: 3, speed:0.6, blocks: 4, cows: 2, hens: 2, coinSpeed: 0, crossP: 0.5, swapP: 0.3, cityName:"Lima", citySkin:"tile_mayan.png" },
        { tile: "tile_stones.png", coins: 3, speed:0.6, blocks: 4, cows: 2, hens: 2, coinSpeed: 0, crossP: 0.5, swapP: 0.3, cityName:"Tenochtitlan", citySkin:"tile_mayan.png" },

        // +running coins
        { tile: "tile_grass.png", coins: 3, speed:0.6, blocks: 1, cows: 0, hens: 3, coinSpeed: 0.2, crossP: 0.5, swapP: 0.3, cityName:"Prague", citySkin:"tile_castle.png"  },
        // +more coins
        { tile: "tile_grass.png", coins: 6, speed:0.9, blocks: 0, cows: 0, hens: 2, coinSpeed: 0.1, crossP: 0.6, swapP:0.5, cityName:"Pilsen", citySkin:"tile_castle.png" }
    ];

}
