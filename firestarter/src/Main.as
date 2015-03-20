package {

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;

import starling.core.Starling;
import starling.utils.HAlign;
import starling.utils.VAlign;

[SWF(width='800', height='600')]
public class Main extends Sprite {

    private var _starling:Starling;

    /**
     * Example project how to modify a simulation dynamically while its running
     */
    public function Main()
    {
        mouseEnabled = mouseChildren = false;
        loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
    }

    private function loaderInfo_completeHandler(event:Event):void
    {
        stage.color = 0x565656;
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.frameRate = 60;
        Starling.handleLostContext = true;
        Starling.multitouchEnabled = true;
        _starling = new Starling(TestApp, stage);
        _starling.enableErrorChecking = false;
        _starling.start();
        _starling.showStatsAt(HAlign.RIGHT, VAlign.BOTTOM);

        stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
        stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
    }

    private function stage_resizeHandler(event:Event):void
    {
        _starling.stage.stageWidth = stage.stageWidth;
        _starling.stage.stageHeight = stage.stageHeight;

        const viewPort:Rectangle = _starling.viewPort;
        viewPort.width = stage.stageWidth;
        viewPort.height = stage.stageHeight;
        try
        {
            _starling.viewPort = viewPort;
        }
        catch(error:Error) {}
    }

    private function stage_deactivateHandler(event:Event):void
    {
        _starling.stop();
        stage.addEventListener(Event.ACTIVATE, stage_activateHandler);
    }

    private function stage_activateHandler(event:Event):void
    {
        stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
        _starling.start();
    }
}
}
