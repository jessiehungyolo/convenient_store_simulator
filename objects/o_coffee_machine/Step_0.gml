if (is_brewing) {
    brew_timer--;
    if (brew_timer <= 0) {
        if (instance_exists(waiting_player)) with (waiting_player) carry_coffee = true;
        is_brewing = false;
        waiting_player = noone;
    }
} else {
    var p = instance_find(o_player, 0);
    if (instance_exists(p)) {
        // 到達自己的帶位點（target_x/target_y）
        var arrived = (point_distance(p.x, p.y, p.target_x, p.target_y) <= p.arrival_radius);

        // 玩家點了我，且站到指定位置（我正下方 50px）
        if (p.target_obj == id && arrived) {
            is_brewing     = true;
            brew_timer     = room_speed; // 1 秒
            waiting_player = p;
        }
    }
}
