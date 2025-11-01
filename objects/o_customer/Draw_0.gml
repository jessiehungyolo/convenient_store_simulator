draw_self();

if (state == "checkout") {
    var total = max(room_speed * 2, 1);
    var ratio = 1 - (checkout_timer / total);
    var w = 40, h = 6;
    var bar_y = y - sprite_height/2 - 12;

    draw_set_color(c_gray);
    draw_rectangle(x - w/2, bar_y, x + w/2, bar_y + h, true);

    draw_set_color(c_yellow);
    draw_rectangle(x - w/2, bar_y, x - w/2 + w * ratio, bar_y + h, false);

    draw_set_color(c_white);
}
