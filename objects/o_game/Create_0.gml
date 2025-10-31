// 中線（用房間寬度的一半）
mid_x = room_width * 0.5;

// 生成兩位玩家（或改成使用你已放進房間的玩家）
p1 = instance_create_layer(mid_x * 0.5, room_height * 0.6, "Instances", o_player);
p2 = instance_create_layer(mid_x + (room_width - mid_x) * 0.5, room_height * 0.6, "Instances", o_player);

// 設定各自活動邊界（左右半邊、留出2px安全距）
var margin = 2;
with (p1) {
    side = 1;
    sprite_index = spr_player1; // 直接指定外觀
    min_x_bound = 0 + 2;
    max_x_bound = other.mid_x - 2;
}
with (p2) {
    side = 2;
    sprite_index = spr_player2; // 直接指定外觀（關鍵）
    min_x_bound = other.mid_x + 2;
    max_x_bound = room_width - 2;
}
