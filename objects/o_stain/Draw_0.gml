draw_self();

// --- 進度條設定 ---
var w = 40;
var h = 6;
var ratio = clamp(progress / clean_time, 0, 1);

// 讓進度條在污漬正上方 10px
var bar_y = y - sprite_height/2 - 10;

// 底框（灰色外框）
draw_set_color(c_gray);
draw_rectangle(x - w/2, bar_y, x + w/2, bar_y + h, true);

// 進度條（綠色實心）
draw_set_color(c_lime);
draw_rectangle(x - w/2, bar_y, x - w/2 + w * ratio, bar_y + h, false);

// 還原顏色
draw_set_color(c_white);
