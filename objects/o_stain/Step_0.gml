// 若已經在被清潔
if (current_cleaner != noone && instance_exists(current_cleaner)) {
    var p = current_cleaner;

    // 清潔者需保持在半徑內
    if (point_distance(x, y, p.x, p.y) <= clean_radius) {
        // 是否原地不動（幾乎沒移動）
        var moved = point_distance(p.x, p.y, last_cleaner_x, last_cleaner_y);
        if (moved <= 0.5) {
            progress += 1; // 積累 3 秒
        } else {
            progress = 0; // 有移動就重置
        }

        // 更新上次位置（每幀刷新，用來判斷是否站住）
        last_cleaner_x = p.x;
        last_cleaner_y = p.y;

        // 完成清潔
        if (progress >= clean_time) {
            // 這裡可加分數：global.score += 5;
            instance_destroy();
        }
    } else {
        // 走出清潔半徑 → 釋放清潔權 & 重置
        current_cleaner = noone;
        progress = 0;
    }

} else {
    // 尚未有人清潔：找在半徑內的玩家，指派為清潔者
    var best = noone;
    var best_d = infinity;
    var cnt = instance_number(o_player);

    for (var i = 0; i < cnt; i++) {
        var p = instance_find(o_player, i);
        var d = point_distance(x, y, p.x, p.y);
        if (d <= clean_radius && d < best_d) {
            best_d = d;
            best   = p;
        }
    }

    if (best != noone) {
        current_cleaner = best;
        progress = 0;
        last_cleaner_x = best.x;
        last_cleaner_y = best.y;
    }
}
