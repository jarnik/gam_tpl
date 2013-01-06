package;

import nme.Lib;
import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.tweens.motion.LinearMotion;
import org.flixel.tweens.util.Ease;
import org.flixel.tweens.FlxTween;

import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;

import Tile;
import PlayState;
	
class Board extends FlxGroup
{	
    // signals
    public var crashSignaler(default, null):Signaler<Void>;
    public var switchStateSignaler(default, null):Signaler<PLAY_STATE>;

    public static inline var ROWS:Int = 7;
    public static inline var COLUMNS:Int = 7;
    public static inline var TILE_SIZE:Float = 32;

    public var player:Player;
    public var crashSprite:Crash;
    public var tileLayer:FlxGroup;
    public var coinLayer:FlxGroup;
    public var map:Array<Array<Tile>>;
    private var coins:Array<Coin>;
    private var castle:Castle;

    private var focus:FlxSprite;
    public var focused:Int;
    public var focusLocked:Bool;

	public function new():Void {
        super();

        add( tileLayer = new FlxGroup() );
        add( coinLayer = new FlxGroup() );

        add( focus = new FlxSprite() );
        focus.makeGraphic( COLUMNS*TILE_SIZE, TILE_SIZE, 0x80800080 );
        focused = 4;
        focusLocked = false;

        add( player = new Player() );

        switchStateSignaler = new DirectSignaler(this);

        crashSignaler = new DirectSignaler(this);
        crashSignaler.bindVoid( crash );
        player.crashSignaler.bindVoid( crash );

        updateFocus();
	}

    public function restart():Void {
        player.visible = true;

        while ( tileLayer.length > 0 )
            tileLayer.remove( tileLayer.members[ 0 ], true );
        while ( coinLayer.length > 0 )
            coinLayer.remove( coinLayer.members[ 0 ], true );

        map = [];
        build();
        
        player.currentTile = null;
        player.exit = TOP;
        findNextStep();
    }

    public function build():Void {
        var t:Tile;
        var row:Array<Tile>;
        var emptyTiles:Array<Tile> = [];
        for ( y in 0...ROWS ) {
            row = [];
            for ( x in 0...COLUMNS ) {
                t = new Tile();
                t.wayConfig = [ TOP, BOTTOM ];
                addTile( x, y, t );
                row.push( t );
                emptyTiles.push( t );
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
                    emptyTiles.remove( t );
                    t = getTile( t.gx + ( w == LEFT ? -1 : 1 ), t.gy );
                    emptyTiles.remove( t );
                    if ( t != null ) {
                        if ( Math.random() > 0.5 )
                            t.removeWay( BOTTOM );
                        t.addWay( Tile.invertWay( w ) );
                    }                    
                }
            }
        }

        var startTile:Tile = getTile( Math.floor( COLUMNS / 2 ), ROWS-1 );
        startTile.addWay( BOTTOM );        
        startTile.addWay( TOP );        
        emptyTiles.remove( startTile ); 

        var endTile:Tile = getTile( Math.floor( COLUMNS / 2 ), 0 );
        castle = new Castle( endTile );
        coinLayer.add( castle );
        emptyTiles.remove( endTile ); 
        endTile.addWay( BOTTOM );

        var coinCount:Int = 3;
        var c:Coin;
        var randIndex:Int;
        coins = [];
        for ( i in 0...coinCount ) {
            randIndex = Math.floor( Math.random()*emptyTiles.length );
            c = new Coin( emptyTiles[ randIndex ] );
            coinLayer.add( c );
            emptyTiles.remove( emptyTiles[ randIndex ] );
            coins.push( c );
        }

        for ( y in 0...ROWS )
            for ( x in 0...COLUMNS ) 
                getTile( x,y ).updateWays();

    }

    private function addTile( x:Int, y:Int, t:Tile ):Void {
        tileLayer.add( t );
        t.move( x, y );
    }

    public function getTile( x:Int, y:Int ):Tile {
        if ( x < 0 || x >= COLUMNS || y < 0 || y >= ROWS )
            return null;
        return map[y][x];
    }

    public function updateRound():Void {
        if ( player.pendingSwap() ) {
            findNextStep();
        }
        checkCoins();
    }

    private function checkCoins():Void {       
        var d:Float;
        var deadCoins:Array<Coin> = [];
        for ( c in coins ) {
            if ( !c.alive )
                continue;

            d = Math.sqrt( Math.pow( c.x-player.x, 2 ) + Math.pow( c.y-player.y, 2 ) );
            if ( d < 3 ) {
                c.pickup();
                deadCoins.push( c );
            }
        }
        for ( c in deadCoins )
            coins.remove( c );

        if ( !castle.isOpen && coins.length == 0 )
            castle.open();          
    }    

    public function setFocused( index:Int ):Void {
        focused = (index + ROWS) % ROWS;
        updateFocus();
    }

    public function moveRow( step:Int ):Void {
        if ( focusLocked )
            return;

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
            row[ i ].move( i, focused, true );
        }
    }
    
    private function updateFocus():Void {
        focusLocked = true;
        Actuate.stop( focus );
        Actuate.tween( focus, 0.05, { y: TILE_SIZE*focused } ).ease( Linear.easeNone ).onComplete( unlockFocus );
    }

    private function unlockFocus():Void {
        focusLocked = false;
    }

    private function crash():Void {
        player.visible = false;
        if ( crashSprite != null )
            remove( crashSprite );
        add( crashSprite = new Crash( player.x, player.y ) );
        switchStateSignaler.dispatch( STATE_FAIL );
        FlxG.log("crash");
    }

    private function win():Void {
        player.visible = false;
        switchStateSignaler.dispatch( STATE_WIN );
        FlxG.log("win");
    }


    private function findNextStep():Void {
        var newTile:Tile;
        var entry:WAY;
        var exit:WAY;

        var newTileAngle:Float = Tile.getWayAngle( player.exit );
        var dx:Int = Math.round( Math.sin( newTileAngle ) );
        var dy:Int = Math.round( -Math.cos( newTileAngle ) );
        if ( player.currentTile == null ) {
            dx = Math.floor(COLUMNS / 2); 
            dy = ROWS-1; 
        } else {
            dx += player.currentTile.gx; 
            dy += player.currentTile.gy; 
            dx = (dx + COLUMNS) % COLUMNS;
            dy = (dy + ROWS) % ROWS;
        }

        newTile = getTile( dx, dy );
        if ( newTile == null ) {
            crashSignaler.dispatch();
            return;
        }

        entry = Tile.invertWay( player.exit );

        if ( newTile == castle.parent ) {
            if ( entry == BOTTOM && castle.isOpen ) {
                win();
                return;
            } else {
                crashSignaler.dispatch();
                return;
            }
        }

        if  ( !newTile.hasWay( entry ) ) {
            crashSignaler.dispatch();
            return;
        }

        var openWays:Array<WAY> = [];
        for ( w in newTile.wayConfig ) {
            if ( w == entry )
                continue;
            openWays.push( w );
        }
        if ( openWays.length == 0 )
            exit = NOWAY;
        else
            exit = openWays[ Math.floor( Math.random() * openWays.length ) ];

        player.enterNewTile( newTile, entry, exit );
    }

}
