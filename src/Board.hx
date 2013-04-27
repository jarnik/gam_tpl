package ;
import nme.display.Sprite;
import pug.render.Render;
import pug.render.RenderGroup;
import gaxe.Debug;
import Creature;

/**
 * ...
 * @author Jarnik
 */
class Board extends Sprite
{
	public static inline var W:Float = 320;
	public static inline var H:Float = 120;
	
	private var player:Creature;
	private var creatures:Array<Creature>;
	private var map:RenderGroup;
	
	private var creatureLayer:Sprite;
	private var groundLayer:Sprite;
	
	public function new() {
		super();
		
		addChild( map = cast( Render.renderSymbol( GAM.lib.get("playscreen") ), RenderGroup ) );
		map.render( 0 );		
		
		addChild( groundLayer = new Sprite() );
		addChild( creatureLayer = new Sprite() );
		
		creatures = [];
		
		groundLayer.addChild( new Pool( SMALL, 8, 8 ) );
		
		creatureLayer.addChild( player = new Creature( TINY ) );
		player.moveTo( 50, 0 );
		creatures.push( player );
		
		spawnCreature( LARGE, 200, 50 );		
		spawnCreature( LARGE, 20, 50 );		
		spawnCreature( MEDIUM, 140, 10 );		
		spawnCreature( MEDIUM, 140, 60 );		
		spawnCreature( SMALL, 40, 60 );		
	}
	
	private function spawnCreature( type:CREATURE_TYPE, x:Float, y:Float ):Creature {
		var c:CreatureAI = new CreatureAI( type, x, y );
		creatureLayer.addChild( c );
		creatures.push( c );
		return c;
	}
	
	private function sortByY( c1:Creature, c2:Creature ):Int {
		if ( c1.y == c2.y )
			return 0;
		if ( c1.y < c2.y )
			return -1;
		else
			return 1;
	}
	
	public function sortCreatures():Void {
		creatures.sort( sortByY );
		for ( i in 0...creatures.length )
			creatureLayer.setChildIndex( creatures[ i ], i );
	}
	
	public function update( timeElapsed:Float ):Void {
		for ( c in creatures ) {
			c.update( timeElapsed );
		}
		sortCreatures();
		var c1:Creature;
		var c2:Creature;
		var dead:Array<Creature> = [];
		for ( i in 0...creatures.length ) {
			c1 = creatures[ i ];
			for ( j in (i + 1)...creatures.length ) {
				c2 = creatures[ j ];
				if ( !c1.alive || !c2.alive )
					continue;
				
				if ( !c1.touches( c2 ) )
					continue;
					
				c2 = creatures[ j ];
				// devouring
				if ( c1.devours( c2 ) ) {
					c1.setFull( true );
					devourCreature( c2 );
				} else if ( c2.devours( c1 ) ) {
					c2.setFull( true );
					devourCreature( c1 );
				}
				// mating
				if ( c1.mates( c2 ) ) {
					bornCreature( c1, c2 );
				} else if ( c1.mates( c2 ) ) {
					bornCreature( c1, c2 );
				}
			}
			
			if ( !c1.alive )
				dead.push( c1 );
			
			// swamp interaction
			// pheromone interaction
		}
		
		for ( c in dead ) {
			creatureLayer.removeChild( c );
			creatures.remove( c );
		}
	}
	
	public function devourCreature( c:Creature ):Void {
		c.alive = false;
	}
	
	public function bornCreature( c1:Creature, c2:Creature ):Void {
		c1.setFull( false );
		c2.setFull( false );
	}
	
	public function setPlayerTarget( key:String ):Void {
		var r:Render = map.fetch( key );
		player.setTarget( r.x, r.y );
	}
	
}