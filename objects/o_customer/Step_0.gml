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

// 在服務點時可接收咖啡
if (state == "at_register" && !has_coffee) {
    var cntp = instance_number(o_player);
    for (var i = 0; i < cntp; i++) {
        var p = instance_find(o_player, i);
        if (p.carry_coffee && point_distance(x, y, p.x, p.y) <= 24) {
            p.carry_coffee = false;
            has_coffee = true;
            needs_coffee = false;

            // 開始結帳：鎖定 busy 2 秒
            var reg = get_assigned_register();
            if (instance_exists(reg)) {
                reg.busy = true;
                checkout_timer = room_speed * 2;
                state = "checkout";
            }
            break;
        }
    }
}

// 結帳倒數
if (state == "checkout") {
    checkout_timer--;
    if (checkout_timer <= 0) {
        // 解鎖收銀機（釋放 slot_taken & busy）
        var reg2 = get_assigned_register();
        if (instance_exists(reg2)) {
            reg2.busy = false;
            reg2.slot_taken = false;
        }

        // 通知 manager：隊伍前進（彈出頭部）
        with (o_customer_manager) {
            pop_head_and_refresh();
        }

        // 離場
        state    = "leaving";
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
