package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
	
class Board extends FlxGroup
{	
    public static inline var ROWS:Int = 5;
    public static inline var COLUMNS:Int = 5;
    public static inline var TILE_SIZE:Float = 32;

    public var player:Player;
    public var tileLayer:FlxGroup;
    //public var map:Hash<Tile>;
    public var map:Array<Array<Tile>>;

	public function new():Void {
        super();

        add( tileLayer = new FlxGroup() );
        add( player = new Player() );

        map = [];
        build();
        player.enterNewTile( 
            getTile( 0, 3 ),
            getTile( 0, 2 )
        );
	}

    public function build():Void {
        var t:Tile;
        var row:Array<Tile>;
        for ( y in 0...ROWS ) {
            row = [];
            for ( x in 0...COLUMNS ) {
                t = new Tile();
                t.wayConfig = [ TOP, BOTTOM ];
                t.updateWays();
                addTile( x, y, t );
                row.push( t );
            }
            map.push( row );
        }
    }

    private function addTile( x:Int, y:Int, t:Tile ):Void {
        tileLayer.add( t );
        t.gx = x;
        t.gy = y;
        t.x = TILE_SIZE/2 + x*TILE_SIZE;
        t.y = TILE_SIZE/2 + y*TILE_SIZE;
    }

    public function getTile( x:Int, y:Int ):Tile {
        return map[y][x];
    }

    public override function update():Void {
        if ( player.pendingSwap() ) {
            player.enterNewTile( player.nextTile, getTile( 0, player.nextTile.gy-1 ) );
        }
        super.update();
    }

}
