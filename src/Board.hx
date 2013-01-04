package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxGroup;

import Tile;
	
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
            BOTTOM,
            TOP
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
            findNextStep();
        }
        super.update();
    }

    private function findNextStep():Void {
        var newTile:Tile;
        var entry:WAY;
        var exit:WAY;

        var newTileAngle:Float = Tile.getWayAngle( player.exit );
        var dx:Int = Math.round( Math.sin( newTileAngle ) );
        var dy:Int = Math.round( -Math.cos( newTileAngle ) );
        dx += player.currentTile.gx; 
        dy += player.currentTile.gy; 

        if ( dx < 0 || dx >= COLUMNS || dy < 0 || dy >= ROWS ) {
            player.kill();
            FlxG.log("crash");
            return;
        }

        newTile = getTile( dx, dy );
        entry = Tile.invertWay( player.exit );
        var openWays:Array<WAY> = [];
        for ( w in newTile.wayConfig ) {
            if ( w == entry )
                continue;
            openWays.push( w );
        }
        exit = openWays[ Math.floor( Math.random() * openWays.length ) ];

        player.enterNewTile( newTile, entry, exit );
    }

}
