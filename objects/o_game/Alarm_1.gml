var side = next_stain_side;         // 用交替側
next_stain_side = 1 - next_stain_side; // 翻面

var margin = 24;
var xx, yy;

if (side == 0) {
    xx = irandom_range(margin, mid_x - margin);
} else {
    xx = irandom_range(mid_x + margin, room_width - margin);
}
yy = irandom_range(margin, room_height - margin);

instance_create_layer(xx, yy, layer_instances, o_stain);
