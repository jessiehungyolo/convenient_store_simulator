var p = instance_find(o_player, 0);
if (instance_exists(p)) {
    var arrived = (point_distance(p.x, p.y, p.target_x, p.target_y) <= p.arrival_radius);

    if (p.target_obj == id && arrived) {
        if (p.carry_coffee) {
            p.carry_coffee = false;
            show_debug_message("結帳完成！");
            // 這裡可加分數等
        }
    }
}
