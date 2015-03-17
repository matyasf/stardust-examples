package main
{

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

public class MyButton extends SimpleButton
{
    public function MyButton(label : String)
    {
        const tf : TextField = new TextField();
        tf.defaultTextFormat = new TextFormat(null, 22);
        tf.text = label;
        tf.width = tf.textWidth + 5;
        tf.height = 30;
        tf.y = 10;

        const up : Sprite = new Sprite();
        up.graphics.beginFill(0x454545);
        up.graphics.drawRect(0, 0, tf.textWidth + 10, tf.textHeight + 20);
        up.addChild(tf);

        const over : Sprite = new Sprite();
        over.graphics.beginFill(0x459945);
        over.graphics.drawRect(0, 0, tf.textWidth + 10, tf.textHeight + 20);

        const down : Sprite = new Sprite();
        down.graphics.beginFill(0x45EF45);
        down.graphics.drawRect(0, 0, tf.textWidth + 10, tf.textHeight + 20);

        super(up, over, down, up);
    }
}
}
