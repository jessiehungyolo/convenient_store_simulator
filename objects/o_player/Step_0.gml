// --- 計算往目標的一步 ---
var dx   = target_x - x;
var dy   = target_y - y;
var dist = point_distance(x, y, target_x, target_y);

if (dist > arrival_radius) {
    var nx = x + (dx / max(dist, 0.0001)) * move_speed;
    var ny = y + (dy / max(dist, 0.0001)) * move_speed;

    // 檢查是否會撞到收銀台本體或阻擋線
    var hit_block = place_meeting(nx, ny, o_register) || place_meeting(nx, ny, o_register_block);

    if (!hit_block) {
        x = nx; y = ny;
    } else {
        // 滑牆：先試 X、再試 Y
        if (!place_meeting(nx, y, o_register) && !place_meeting(nx, y, o_register_block)) {
            x = nx;
        } else if (!place_meeting(x, ny, o_register) && !place_meeting(x, ny, o_register_block)) {
            y = ny;
        } else {
            // 兩方向都撞 → 停下（避免抖動）
        }
    }
}
