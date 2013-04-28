package;

import gaxe.Gaxe;
import gaxe.Scene;
import gaxe.Debug;
import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent; 
import nme.ui.Keyboard;
import pug.render.RenderGroupStates;
import pug.render.Render;
import com.eclecticdesignstudio.motion.Actuate;


class GuideScene extends Scene
{
    //private var board:Board;
	private var howto:RenderGroupStates;
    
	override public function create():Void
	{
		howto = cast( Render.renderSymbol( GAM.lib.get("howto") ), RenderGroupStates );
		howto.play();
		addChild( howto );
		
		//title.fetch("planetix_logo439").onClick( onTitleClicked );
		howto.fetch("btnContinue").onEvents( [ MouseEvent.MOUSE_UP ], onContinueClicked );
	}

    override public function update( elapsed:Float ):Void {
		howto.update( elapsed );
    }

	private function onContinueClicked( e:MouseEvent ):Void {
		Gaxe.head.switchScene( TitleScene );
	}

}
