package;

import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;

class MenuState extends FlxState
{
	override public function create():Void
	{
		#if !neko
		FlxG.bgColor = 0xff131c1b;
		#else
		FlxG.bgColor = {rgb: 0x131c1b, a: 0xff};
		#end		
		FlxG.mouse.show();

        var bgr:FlxSprite = new FlxSprite( 80,60,"assets/screen_start.png" );
        bgr.scale.x = 2;
        bgr.scale.y = 2;
        add( bgr );

	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
        if ( FlxG.keys.justPressed( "SPACE" ) ) {
            FlxG.switchState( new PlayState() );
        }

	}	
}
