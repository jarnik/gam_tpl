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

class IntroState extends FlxState
{    
    private var bottomLine:FlxSprite;
    private var bottomText:FlxText;

	override public function create():Void
	{
		FlxG.mouse.hide();

        add( bottomLine = new FlxSprite( 0, FlxG.height - 32 ) );
        bottomLine.makeGraphic( FlxG.width, 32, 0xFF000000 );
        add( bottomText = new FlxText( 0, FlxG.height - 28, FlxG.width, "PRESS SPACE" ) );
        bottomText.setFormat( null, 16, 0xf0f0f0, "center" );

        GAM.track("IntroState");
	}
	
	override public function update():Void
	{
		super.update();
        if ( FlxG.keys.justPressed( "SPACE" ) ) {
            FlxG.switchState( new PlayState() );
        }

	}	
}
