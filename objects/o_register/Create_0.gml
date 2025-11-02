/// 初始化狀態
busy         = false;      // 是否正在結帳
slot_taken   = false;      // 該台服務點被隊首占用
lane_id      = -1;         // 由 manager 指派
current_cust = noone;      // 正在被這台服務的客人（可為 noone）

// 交付區（玩家需站在此區才能交付咖啡）
handoff_half_w = 56;  // 左右半寬
handoff_top    = 10;  // 從收銀台 y 向下開始的位移（玩家在「下方」→ y 變大）
handoff_bottom = 68;  // 交付區底線相對收銀台 y
handoff_radius = 40;  // 容忍圓半徑（避免卡邊）

// 防卡派發：若隊首很久到不了服務點，釋放 slot
slot_timer_max = room_speed * 3; // 3 秒到位時限
slot_timer     = 0;

/// o_register 內：取得「玩家站位」（一定在阻擋線玩家側，且可達）
function get_handoff_spot() {
    var cx = x - sprite_get_xoffset(sprite_index) + sprite_get_width(sprite_index) * 0.5;

    // 試著找到同 lane 的 block（建議房間裡左右各放一條，分別把 block.lane_id 設 0/1）
    var best = noone, best_d = infinity;
    var n = instance_number(o_register_block);
    for (var i = 0; i < n; i++) {
        var b = instance_find(o_register_block, i);
        if (b.lane_id == lane_id) {
            var d = point_distance(b.x, b.y, x, y);
            if (d < best_d) { best_d = d; best = b; }
        }
    }

    if (best != noone) {
        // 玩家視角在「收銀台下方」，block 應該貼近收銀台前緣
        // 站位放在 block 的玩家側（下方）外 2px
        var y_stand = best.bbox_bottom + 2;
        var cx2 = x - sprite_get_xoffset(sprite_index) + sprite_get_width(sprite_index) * 0.5;
        return [cx2, y_stand];
    }

    // 若沒放 block：退而把站位放在收銀台下方固定距離
    return [x - sprite_get_xoffset(sprite_index) + sprite_get_width(sprite_index) * 0.5, y + 44];
}
