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


// 污漬生成節奏
stain_interval = room_speed * 10; // 每 5 秒
alarm[1] = stain_interval;

// 污漬上限，避免太多
max_stains = 6;
next_stain_side = 0; // 0=左, 1=右


// 生成層（請確保房間有這個 Instance Layer）
layer_instances = "Instances";

