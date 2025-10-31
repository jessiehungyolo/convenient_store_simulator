// 控制總量
if (instance_number(o_stain) < max_stains) {

    // 隨機選左右半邊
    var side = choose(0, 1); // 0=左半, 1=右半
    var margin = 24;

    var xx, yy;
    if (side == 0) {
        xx = irandom_range(margin, mid_x - margin);
    } else {
        xx = irandom_range(mid_x + margin, room_width - margin);
    }
    yy = irandom_range(margin, room_height - margin);

    // 生成污漬
    instance_create_layer(xx, yy, layer_instances, o_stain);
}

// 重啟鬧鐘（循環）
alarm[1] = stain_interval;
