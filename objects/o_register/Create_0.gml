function get_handoff_spot() {
    var cx = x - sprite_get_xoffset(sprite_index) + sprite_get_width(sprite_index) * 0.5;
    var hy = y + (handoff_top + handoff_bottom) * 0.5;  // 區域中線
    return [cx, hy];
}


busy         = false;
slot_taken   = false;
lane_id      = -1;
current_cust = noone;

// 交付區（玩家站這裡就能交付）
handoff_half_w = 52;  // 左右半寬
handoff_top    = 10;  // 從收銀台 y 向下開始的位移
handoff_bottom = 64;  // 交付區底線相對收銀台 y
handoff_radius = 36;  // 圓形容忍半徑（保險）

depth = 10