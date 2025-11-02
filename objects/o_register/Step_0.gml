/// 防呆：slot_taken 卻沒有該台的「已到服務點」客人 → 若超時則釋放
{
    var has_at = false;
    var has_to = false;
    var cnt = instance_number(o_customer);
    for (var i = 0; i < cnt; i++) {
        var c = instance_find(o_customer, i);
        if (c.assigned_lane == lane_id && c.state == "at_register") { has_at = true; break; }
        if (c.assigned_lane == lane_id && c.state == "to_register")  { has_to = true; }
    }

    if (slot_taken) {
        if (has_at) {
            slot_timer = slot_timer_max; // 到位了，重置計時
        } else if (has_to) {
            // 在路上 → 倒數，避免永遠卡住
            slot_timer--;
            if (slot_timer <= 0) {
                slot_taken   = false;
                current_cust = noone;
            }
        } else {
            // 沒人在路上也沒到位 → 直接釋放
            slot_taken   = false;
            current_cust = noone;
        }
    }
}

function _center_x() {
    return x - sprite_get_xoffset(sprite_index) + sprite_get_width(sprite_index) * 0.5;
}
function _find_front_customer() {
    var cnt = instance_number(o_customer);
    for (var i = 0; i < cnt; i++) {
        var c = instance_find(o_customer, i);
        if (c.assigned_lane == lane_id && c.state == "at_register") return c;
    }
    return noone;
}

// 這台閒著且服務點被佔 → 嘗試接咖啡並開帳
if (!busy && slot_taken) {
    var cust = _find_front_customer();
    if (instance_exists(cust)) {
        var cx = _center_x();
        var left  = cx - handoff_half_w;
        var right = cx + handoff_half_w;
        var top   = y + handoff_top;     // 玩家側在下方 → 用 +
        var bot   = y + handoff_bottom;

        var hx = cx, hy = (top + bot) * 0.5;

        var pcnt = instance_number(o_player);
        for (var p = 0; p < pcnt; p++) {
            var pl = instance_find(o_player, p);

            // 玩家在交付區矩形內 或 距交付中心在容忍半徑內
            var in_rect   = (pl.x >= left && pl.x <= right && pl.y >= top && pl.y <= bot);
            var in_circle = (point_distance(pl.x, pl.y, hx, hy) <= handoff_radius);

            if (pl.carry_coffee && (in_rect || in_circle)) {
                // 交付並開始結帳
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
        // 服務點被占卻找不到客人 → 釋放
        slot_taken   = false;
        current_cust = noone;
    }
}
