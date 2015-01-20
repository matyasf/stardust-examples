package
{

import com.funkypandagame.stardustplayer.SimLoader;
import com.funkypandagame.stardustplayer.SimPlayer;

import flash.events.MouseEvent;

import flash.events.Event;

import flash.utils.ByteArray;

import idv.cjcat.stardustextended.common.clocks.SteadyClock;

import idv.cjcat.stardustextended.common.initializers.Initializer;

import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.initializers.PositionAnimated;
import idv.cjcat.stardustextended.twoD.zones.SinglePoint;

import starling.core.Starling;

import starling.display.Sprite;
import starling.events.EnterFrameEvent;

import starling.events.Event;
import starling.text.TextField;
import starling.utils.HAlign;
import starling.utils.VAlign;

public class TestApp extends Sprite
{

    [Embed(source="/../assets/gravityFields.sde", mimeType = 'application/octet-stream')]
    private static var Asset:Class;
    private static var assetInstance:ByteArray = new Asset();

    private var simContainer : Sprite;
    private var player : SimPlayer;
    private var loader : SimLoader;
    private var infoTF : TextField;
    private var cnt : uint = 0;
    private var explode : CustomExplode;
    private var emitter : Emitter2D;

    public function TestApp()
    {
        Starling.current.stage.color = 0x232323;
        Starling.current.showStatsAt(HAlign.LEFT, VAlign.TOP);

        simContainer = new Sprite();
        simContainer.touchable = false;
        addChild(simContainer);

        player = new SimPlayer();
        loader = new SimLoader();
        loader.addEventListener(flash.events.Event.COMPLETE, onSimLoaded);
        loader.loadSim(assetInstance);

        infoTF = new TextField(200, 25, "");
        infoTF.color = 0xefefef;
        addChild(infoTF);
    }

    private function onSimLoaded(event : flash.events.Event) : void
    {
        player.setSimulation(loader.project, simContainer);
        // step the simulation on every frame
        addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);

        // this simulation has just one emitter, so we need to care about one only
        emitter = loader.project.emittersArr[0];

        // Add a custom action that was not made with the editor
        explode = new CustomExplode(0,0, 25, 12, 200, 0);
        emitter.addAction(explode);

        Starling.current.nativeStage.addEventListener(MouseEvent.CLICK, onClick);
        Starling.current.nativeStage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
    }

    private function onEnterFrame(event : starling.events.Event) : void
    {
        if (explode.discharged == false)
        {
            // do not emit any particles during the explosion
            SteadyClock(emitter.clock).ticksPerCall = 0;
        }
        else
        {
            SteadyClock(emitter.clock).ticksPerCall = 10;
        }
        player.stepSimulation();

        cnt++;
        if (cnt%60 == 0)
        {
            infoTF.text = "particles: " + loader.project.numberOfParticles;
        }
    }

    private function onClick(evt : MouseEvent) : void
    {
        explode.x = Starling.current.nativeStage.mouseX;
        explode.y = Starling.current.nativeStage.mouseY;
        explode.explode();
    }

    private function onMove(evt : MouseEvent) : void
    {
        //Set the emitter's position to the pointer coordinate
        for each (var init : Initializer in emitter.initializers)
        {
            if (init is PositionAnimated)
            {
                var initialPosition : SinglePoint = PositionAnimated(init).zone as SinglePoint;
                initialPosition.x = evt.stageX;
                initialPosition.y = evt.stageY;
                break;
            }
        }

    }

}
}