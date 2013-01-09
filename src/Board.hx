package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxEmitter;
import org.flixel.tweens.motion.LinearMotion;
import org.flixel.tweens.util.Ease;
import org.flixel.tweens.FlxTween;

import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;

import PlayState;

class Board extends FlxGroup
{	
    // signals
    public var switchStateSignaler(default, null):Signaler<PLAY_STATE>;

    public static var OFFSET_X:Float;
    public static var OFFSET_Y:Float;

    public static inline var ROWS:Int = 7;
    public static inline var COLUMNS:Int = 7;
    public static inline var TILE_SIZE:Float = 32;

    public var tileLayer:FlxGroup;
    public var movableLayer:FlxGroup;
    //public var map:Array<Array<Tile>>;
    //private var movables:Array<Movable>;

	public function new():Void {
        super();

        OFFSET_X = (FlxG.width - TILE_SIZE*COLUMNS) / 2;
        OFFSET_Y = (FlxG.height - TILE_SIZE*ROWS) / 2;

        add( tileLayer = new FlxGroup() );
        add( movableLayer = new FlxGroup() );

        switchStateSignaler = new DirectSignaler(this);
	}

    public function restart():Void {
        while ( tileLayer.length > 0 )
            tileLayer.remove( tileLayer.members[ 0 ], true );
        while ( movableLayer.length > 0 )
            movableLayer.remove( movableLayer.members[ 0 ], true );

        //map = [];
        build();
        
        updateRound();
    }

    public function build():Void {
        //var t:Tile;
        /*
        var row:Array<Tile>;
        var emptyTiles:Array<Tile> = [];
        for ( y in 0...ROWS ) {
            row = [];
            for ( x in 0...COLUMNS ) {
                t = new Tile( Levels.config.tile );
                t.wayConfig = [ TOP, BOTTOM ];
                addTile( x, y, t );
                row.push( t );
                emptyTiles.push( t );
            }
            map.push( row );
        }*/

        //movables = [];
    }

    /*
    private function addTile( x:Int, y:Int, t:Tile ):Void {
        tileLayer.add( t );
        t.move( x, y );
    }

    public function getTile( x:Int, y:Int ):Tile {
        if ( x < 0 || x >= COLUMNS || y < 0 || y >= ROWS )
            return null;
        return map[y][x];
    }
    */

    public function updateRound( enableMovement:Bool = true ):Void {
        /*
        for ( m in movables ) {  
            m.updateRound( enableMovement );
            if ( enableMovement && m.pendingSwap() ) {
                m.findNextStep( this );
            }
        }

        for ( m in movables ) {
            switch ( Type.getClass( m )) {
                default:
            }
        }
        */
    }

    private function win():Void {
        switchStateSignaler.dispatch( STATE_WIN );
        FlxG.log("win");
    }

}
