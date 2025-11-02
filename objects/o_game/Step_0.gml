/// o_game.Step  — 點擊控制（左右分半：左=P1、右=P2；收銀台/咖啡機有固定站位）
if (mouse_check_button_pressed(mb_left)) {
    var mx = mouse_x;
    var my = mouse_y;

    // 中線（若沒在 Create 設 mid_x，就用房間寬度算一次）
    var mid_x_local = room_width * 0.5;

    // 這次要控制的玩家：左半=P1、右半=P2（若某邊不存在，就用另一邊頂上）
    var p = (mx < mid_x_local) ? p1 : p2;
    if (!instance_exists(p)) {
        p = (mx < mid_x_local) ? p2 : p1;
        if (!instance_exists(p)) exit; // 兩個都不在就不做事
    }

    // 1) 點到咖啡機：移動到咖啡機正下方固定站位（避免滑動）
    var mach = instance_position(mx, my, o_coffee_machine);
    if (mach != noone) {
        var stop_off = 50; // 與機器的垂直距
        p.target_obj = mach;
        p.target_x   = mach.x;
        p.target_y   = mach.y + stop_off;  // 玩家視角在下方 → 用 + 往下
        exit; // 已處理本次點擊
    }

    // 2) 點到收銀台：移動到該收銀台的「可達固定站位」
    var reg = instance_position(mx, my, o_register);
    if (reg != noone) {
        // 由收銀台提供「玩家站位」（會避開阻擋線）
        var spot = reg.get_handoff_spot();
        var tx = spot[0];
        var ty = spot[1];

        p.target_obj = noone; // 純站位移動
        p.target_x   = tx;
        p.target_y   = ty;
        exit; // 已處理本次點擊
    }

    // 3) 其他情況：移動到點擊座標（o_player 內部已有半場邊界/碰撞限制）
    p.target_obj = noone;
    p.target_x   = mx;
    p.target_y   = my;
}
