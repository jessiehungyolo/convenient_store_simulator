function _center_x() {
    var spr = sprite_index;
    return x - sprite_get_xoffset(spr) + sprite_get_width(spr) * 0.5;
}

function _find_front_customer() {
    var cnt = instance_number(o_customer);
    for (var i = 0; i < cnt; i++) {
        var c = instance_find(o_customer, i);
        if (c.assigned_lane == lane_id && c.state == "at_register") return c;
    }
    return noone;
}

if (!busy && slot_taken) {
    var cust = _find_front_customer();
    if (instance_exists(cust)) {
        var cx = _center_x();
        var left  = cx - handoff_half_w;
        var right = cx + handoff_half_w;
        var top   = y + handoff_top;
        var bot   = y + handoff_bottom;

        var hx = cx;                                 // 交付中心點（用於半徑判定）
        var hy = y + (handoff_top + handoff_bottom) * 0.5;

        var pcnt = instance_number(o_player);
        for (var p = 0; p < pcnt; p++) {
            var pl = instance_find(o_player, p);
            var in_rect = (pl.x >= left && pl.x <= right && pl.y >= top && pl.y <= bot);
            var in_circle = (point_distance(pl.x, pl.y, hx, hy) <= handoff_radius);

            if (pl.carry_coffee && (in_rect || in_circle)) {
                // 接收咖啡並開始結帳
                pl.carry_coffee   = false;
                cust.has_coffee   = true;
                cust.needs_coffee = false;

                busy         = true;
                current_cust = cust;
                cust.state   = "checkout";
                cust.checkout_timer = room_speed * 2;
                break;
            }
        }
    } else {
        // 防呆：slot_taken 卻找不到客人
        slot_taken   = false;
        current_cust = noone;
    }
}
