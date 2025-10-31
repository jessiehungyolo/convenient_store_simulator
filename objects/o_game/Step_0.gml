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

    inst = instance_position(mx, my, o_register);
    if (inst != noone) {
        p.target_obj = inst;
        // 帶位點（停在收銀台正上方 50px）
        p.target_x   = inst.x;
        p.target_y   = inst.y - 50;
        exit;
    }

    // 沒點到互動物 → 走到座標（但 o_player 會自己做半邊邊界限制）
    p.target_obj = noone;
    p.target_x   = mx;
    p.target_y   = my;
}
