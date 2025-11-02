// 共用位移
var dx = target_x - x;
var dy = target_y - y;
var dist = point_distance(x, y, target_x, target_y);

if (dist > arrival_radius) {
    x += (dx / max(dist, 0.0001)) * move_speed;
    y += (dy / max(dist, 0.0001)) * move_speed;
} else {
    // 到達目標點時的處理
    if (state == "to_register") {
        state = "at_register"; // 到達服務點，等待咖啡
    }
}


// 結帳倒數
if (state == "checkout") {
    checkout_timer--;
    if (checkout_timer <= 0) {
        // 解鎖收銀機
        var reg = noone;
        var cr = instance_number(o_register);
        for (var r = 0; r < cr; r++) {
            var rr = instance_find(o_register, r);
            if (rr.lane_id == assigned_lane) { reg = rr; break; }
        }
        if (instance_exists(reg)) {
            reg.busy = false;
            reg.slot_taken = false;
            reg.current_cust = noone;
        }

        // 通知 manager 隊伍前進
        //with (o_customer_manager) { pop_head_and_refresh(); }

        // 離場
        state = "leaving";
        target_x = door_x;
        target_y = door_y;
    }
}


// 走出畫面就刪除
if (state == "leaving" && y > room_height + 16) {
    instance_destroy();
}

// 取得被派發的那台收銀機
function get_assigned_register() {
    if (assigned_lane < 0) return noone;
    var cr = instance_number(o_register);
    for (var r = 0; r < cr; r++) {
        var rr = instance_find(o_register, r);
        if (rr.lane_id == assigned_lane) return rr;
    }
    return noone;
}
