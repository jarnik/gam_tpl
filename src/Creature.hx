package ;
import nme.display.Sprite;
import nme.geom.Point;
import pug.render.RenderGroupStates;
import pug.render.Render;
import gaxe.Debug;

enum CREATURE_TYPE {
	TINY;
	SMALL;
}

/**
 * ...
 * @author Jarnik
 */
class Creature extends Sprite {

	private var skin:RenderGroupStates;
	private var target:Point;
	private var position:Point;
	private var speed:Float;
	
	public function new( t:CREATURE_TYPE ) {
		super();
		skin = cast( Render.renderSymbol( GAM.lib.get("creature") ), RenderGroupStates );
		skin.render( 0, false );
		addChild( skin );
		target = new Point();
		position = new Point();
		speed = 80;
	}
	
	public function moveTo( x:Float, y:Float ):Void {
		position.x = x;
		position.y = y;
		this.x = Math.round( position.x );
		this.y = Math.round( position.y );
	}
	
	public function setTarget( x:Float, y:Float ):Void {
		target.x = x;
		target.y = y;
	}
	
	public function update( timeElapsed:Float ):Void {
		var direction:Point = target.clone();
		direction = direction.subtract( position );
		var d:Float = Math.min( direction.length, timeElapsed * speed );
		direction.normalize( d );
		
		position = position.add( direction );
		moveTo( position.x, position.y );
	}
}