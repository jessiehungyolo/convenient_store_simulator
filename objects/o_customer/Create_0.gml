// 狀態：在隊伍中 -> 前往收銀機 -> 到位等待咖啡 -> 結帳 -> 離場
state = "queue"; // "to_register", "at_register", "checkout", "leaving"

move_speed     = 2.2;
arrival_radius = 8;

target_x = x; target_y = y;

queue_index = -1;     // 由 manager 指派
assigned_lane = -1;   // 被派到哪一台收銀機 0/1（未派發=-1）

// 需求：每位都要咖啡
needs_coffee = true;
has_coffee   = false;

// 結帳計時器
checkout_timer = 0;

// 門口（由 manager 設置）
door_x = room_width * 0.5;
door_y = room_height + 32;
