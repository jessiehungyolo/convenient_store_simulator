if (mouse_check_button_pressed(mb_left)) {
    var mx = mouse_x;
    var my = mouse_y;

    // 先決定這次要控制誰：左半→p1；右半→p2
    var p = (mx < mid_x) ? p1 : p2;
    if (!instance_exists(p)) exit;

    // 依序：點到咖啡機？→ 點到收銀台？→ 否則就走到座標
    var inst = instance_position(mx, my, o_coffee_machine);
    if (inst != noone) {
        p.target_obj = inst;
        // 帶位點（停在機器正下方 50px）
        p.target_x   = inst.x;
        p.target_y   = inst.y + 50;
        exit;
    }

   var reg = instance_position(mouse_x, mouse_y, o_register);
    if (reg != noone) {
        var spot = reg.get_handoff_spot();
        var tx = spot[0];
        var ty = spot[1];

        // 找距離點擊位置最近的玩家（或你指定 P1/P2）
        var best = noone, best_d = infinity;
        var pcnt = instance_number(o_player);
        for (var i = 0; i < pcnt; i++) {
            var pl = instance_find(o_player, i);
            var d = point_distance(pl.x, pl.y, mouse_x, mouse_y);
            if (d < best_d) { best_d = d; best = pl; }
        }
        if (best != noone) {
            best.target_x = tx;
            best.target_y = ty;
        }
    }

    // 沒點到互動物 → 走到座標（但 o_player 會自己做半邊邊界限制）
    p.target_obj = noone;
    p.target_x   = mx;
    p.target_y   = my;
}