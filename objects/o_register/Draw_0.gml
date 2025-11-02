var cx = x - sprite_get_xoffset(sprite_index) + sprite_get_width(sprite_index) * 0.5;
var left  = cx - handoff_half_w;
var right = cx + handoff_half_w;
var top   = y + handoff_top;     // 若玩家在下方，top/bot 都要比 y 大
var bot   = y + handoff_bottom;

draw_set_alpha(0.25);
draw_set_color(c_green);
draw_rectangle(left, top, right, bot, false);

var hx = cx;
var hy = (top + bot) * 0.5;
draw_set_color(c_red);
draw_circle(hx, hy, handoff_radius, false);
draw_set_alpha(1);
draw_set_color(c_white);
