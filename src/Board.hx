package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.tweens.motion.LinearMotion;
import org.flixel.tweens.util.Ease;
import org.flixel.tweens.FlxTween;

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

    private var focus:FlxSprite;
    public var focused:Int;

	public function new():Void {
        super();

        add( tileLayer = new FlxGroup() );

        add( focus = new FlxSprite() );
        focus.makeGraphic( COLUMNS*TILE_SIZE, TILE_SIZE, 0x80800080 );
        focused = 4;

        add( player = new Player() );

        restart();

        updateFocus();
	}

    private function restart():Void {
        while ( tileLayer.length > 0 )
            tileLayer.remove( tileLayer.members[ 0 ], true );
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
                addTile( x, y, t );
                row.push( t );
            }
            map.push( row );
        }

        var w:WAY;
        for ( y in 0...ROWS ) {
            for ( x in 0...COLUMNS ) {
                t = getTile( x, y );
                if ( Math.random() < 0.3 ) {
                    if ( Math.random() > 0.5 )
                        t.removeWay( TOP );
                    w = Math.random() > 0.5 ? LEFT: RIGHT;
                    t.addWay( w );
                    t = getTile( t.gx + ( w == LEFT ? -1 : 1 ), t.gy );
                    if ( t != null ) {
                        if ( Math.random() > 0.5 )
                            t.removeWay( BOTTOM );
                        t.addWay( Tile.invertWay( w ) );
                    }
                }
            }
        }

        for ( y in 0...ROWS )
            for ( x in 0...COLUMNS ) 
                getTile( x,y ).updateWays();

    }

    private function addTile( x:Int, y:Int, t:Tile ):Void {
        tileLayer.add( t );
        moveTile( x, y, t );
    }

    private function moveTile( x:Int, y:Int, t:Tile ):Void {
        t.gx = x;
        t.gy = y;
        t.x = TILE_SIZE/2 + x*TILE_SIZE;
        t.y = TILE_SIZE/2 + y*TILE_SIZE;
    }

    public function getTile( x:Int, y:Int ):Tile {
        if ( x < 0 || x >= COLUMNS || y < 0 || y >= ROWS )
            return null;
        return map[y][x];
    }

    public override function update():Void {
        if ( player.pendingSwap() ) {
            findNextStep();
        }
        super.update();
    }

    public function setFocused( index:Int ):Void {
        focused = Math.round( Math.min( ROWS-1, Math.max( 0, index ) ) );
        updateFocus();
    }

    public function moveRow( step:Int ):Void {
        var row:Array<Tile> = map[ focused ];
        var t:Tile;
        
        if ( step == 1 ) {
            t = row.pop();
            row.unshift( t );
        } else {
            t = row.shift();
            row.push( t );
        }
        for ( i in 0...row.length ) {
            moveTile( i, focused, row[ i ] );             
        }
    }
    
    private function updateFocus():Void {
        /*var mt:LinearMotion = new LinearMotion( FlxTween.ONESHOT );
        mt.setMotion( 0, focus.y, 0, TILE_SIZE*focused, 1, Ease.quadIn );
        focus.addTween( mt, true );
        */
        focus.y = TILE_SIZE*focused;
    }

    private function crash():Void {
        restart();
        //player.kill();
        FlxG.log("crash");
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

        dx = (dx + COLUMNS) % COLUMNS;
        dy = (dy + ROWS) % ROWS;

        newTile = getTile( dx, dy );
        if ( newTile == null ) {
            crash();
            return;
        }

        entry = Tile.invertWay( player.exit );

        if  ( !newTile.hasWay( entry ) ) {
            crash();
            return;
        }

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
