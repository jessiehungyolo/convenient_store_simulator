// 只朝 target_x / target_y 前進
var dx = target_x - x;
var dy = target_y - y;
var dist = point_distance(x, y, target_x, target_y);

if (dist > arrival_radius) {
    x += (dx / max(dist, 0.0001)) * move_speed;
    y += (dy / max(dist, 0.0001)) * move_speed;
}

// --- 畫面邊界 ---
if (x < 0) x = 0;
if (x > room_width - sprite_width)  x = room_width - sprite_width;
if (y < 0) y = 0;
if (y > room_height - sprite_height) y = room_height - sprite_height;

// --- 半邊邊界（重點）：限制各自在自己半邊 ---
if (x < min_x_bound) x = min_x_bound;
if (x > max_x_bound - sprite_width) x = max_x_bound - sprite_width;
