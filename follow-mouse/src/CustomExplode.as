package
{

import idv.cjcat.stardustextended.common.actions.Action;
import idv.cjcat.stardustextended.common.emitters.Emitter;
import idv.cjcat.stardustextended.common.particles.Particle;
import idv.cjcat.stardustextended.twoD.geom.Vec2D;
import idv.cjcat.stardustextended.twoD.geom.Vec2DPool;

/**
 * Creates a shock wave that spreads out from a single point, applying acceleration to particles along the way of propagation.
 */
public class CustomExplode extends Action {

    /**
     * The X coordinate of the center.
     */
    public var x:Number;
    /**
     * The Y coordinate of the center.
     */
    public var y:Number;
    /**
     * The strength of the shockwave.
     */
    public var strength:Number;
    /**
     * The speed of shockwave propagation, in pixels per emitter step.
     */
    public var growSpeed:Number;
    /**
     * The shockwave would not affect particles beyond this distance.
     */
    public var maxDistance:Number;
    /**
     * The attenuation power of the shockwave, in powers per pixel.
     */
    public var attenuationPower:Number;
    /**
     * If a particle is closer to the center than this value, it's treated as if it's this distance away from the center.
     * This is to prevent the simulation to blow up for particles too close to the center.
     */
    public var epsilon:Number;

    /**
     * True is its not in the middle of an explosion
     */
    public var discharged:Boolean;
    private var _currentInnerRadius:Number;
    private var _currentOuterRadius:Number;

    public function CustomExplode(x:Number = 0, y:Number = 0, strength:Number = 5, growSpeed:Number = 40, maxDistance:Number = 200, attenuationPower:Number = 0.1, epsilon:Number = 1) {
        this.x = x;
        this.y = y;
        this.strength = strength;
        this.growSpeed = growSpeed;
        this.maxDistance = maxDistance;
        this.attenuationPower = attenuationPower;
        this.epsilon = epsilon;

        discharged = true;
    }

    /**
     * Causes a shockwave to spread out from the center.
     */
    public function explode():void {
        discharged = false;
        _currentInnerRadius = 0;
        _currentOuterRadius = growSpeed;
    }

    override public function update(emitter:Emitter, particle:Particle, timeDelta:Number, currentTime:Number):void {
        if (discharged) return;

        // Stardust has object pools for various objects that it uses often to prevent garbage collection
        // Vect2D is a subClass of Point with some extra functions
        var r:Vec2D = Vec2DPool.get(particle.x - x, particle.y - y);
        var len:Number = r.length;
        if (len < epsilon) len = epsilon;
        if ((len >= _currentInnerRadius) && (len < _currentOuterRadius)) {
            r.length = strength * Math.pow(len, -attenuationPower);
            particle.vx += r.x * timeDelta;
            particle.vy += r.y * timeDelta;
        }
        Vec2DPool.recycle(r);
    }

    override public function postUpdate(emitter:Emitter, time:Number):void {
        if (discharged) return;

        _currentInnerRadius += growSpeed;
        _currentOuterRadius += growSpeed;
        if (_currentInnerRadius > maxDistance) discharged = true;
    }

    override public function getXMLTagName():String
    {
        return "CustomExplode";
    }
    
}
}