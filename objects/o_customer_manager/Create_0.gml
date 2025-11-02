instance_layer_name = "Instances";

// 找出場上所有 o_register，按 X 左→右排序
regs = [];
var cr = instance_number(o_register);
for (var i = 0; i < cr; i++) regs[i] = instance_find(o_register, i);
for (var a=0; a<array_length(regs); a++)
for (var b=a+1; b<array_length(regs); b++)
if (regs[a].x > regs[b].x) { var t=regs[a]; regs[a]=regs[b]; regs[b]=t; }

if (array_length(regs) < 2) {
    show_debug_message("[o_customer_manager] ⚠ 需要兩台 o_register；目前找到：" + string(array_length(regs)));
    active = false; exit;
}
active = true;

// lane 標號：左=0 右=1
regs[0].lane_id = 0;
regs[1].lane_id = 1;
regs[0].busy = false;
regs[1].busy = false;
regs[0].slot_taken = false;
regs[1].slot_taken = false;

// 各 lane 的服務點（客人站位）
function _reg_center_x(inst) {
    return inst.x - sprite_get_xoffset(inst.sprite_index) + sprite_get_width(inst.sprite_index) * 0.5;
}
front_pos = [
    { x: _reg_center_x(regs[0]), y: regs[0].y - 50 }, // 客人上方 50px
    { x: _reg_center_x(regs[1]), y: regs[1].y - 50 }
];

// 中央隊列（倒Y）
center_x = room_width * 0.5;
center_y = room_height * 0.5;
queue = [];
slot_gap = 36;

// 門口在畫面上方
door_x = room_width * 0.5;
door_y = -32;

// 派發節奏控制
max_customers = 20;
spawned_count = 0;
next_lane = 0;          // 兩台都空時，從哪邊先派
dispatch_cooldown = 0;  // 幀級冷卻避免同幀多輪

alarm[0] = room_speed * 4; // 每 4 秒生成 1 位客人


function lane_is_occupied(_lane) {
    var rr = get_register_by_lane(_lane);
    if (instance_exists(rr) && (rr.busy || rr.slot_taken)) return true;

    var n = instance_number(o_customer);
    for (var i = 0; i < n; i++) {
        var c = instance_find(o_customer, i);
        if (!instance_exists(c)) continue;
        if (c.assigned_lane == _lane) {
            if (c.state == "to_register" || c.state == "at_register" || c.state == "checkout") {
                return true;
            }
        }
    }
    return false;
}

// ⚙️ 依 lane_id 取得 register
function get_register_by_lane(lane_id) {
    for (var i = 0; i < array_length(regs); i++) {
        if (regs[i].lane_id == lane_id) return regs[i];
    }
    return noone;
}

// ⚙️ 刷新排隊目標
function refresh_queue_targets() {
    var L = array_length(queue);
    for (var i = 0; i < L; i++) {
        var c = queue[i];
        if (!instance_exists(c)) continue;
        c.queue_index = i;

        // 只更新還在排隊的
        if (c.state == "queue" || c.state == "joining") {
            c.target_x = center_x;
            c.target_y = center_y - i * slot_gap;
            c.state = "queue";
        }
    }
}

// ⚙️ 新增客人（從門口出現）
function spawn_one_customer() {
    if (!is_array(queue)) queue = [];
    if (spawned_count >= max_customers) return;

    var c = instance_create_layer(door_x, door_y, instance_layer_name, o_customer);
    c.door_x = door_x; 
    c.door_y = door_y;
    spawned_count++;

    array_push(queue, c);
    refresh_queue_targets();
}

// ⚙️ 自動派發空收銀台（本幀只跑一次，每台最多派 1 人）
function auto_dispatch_free_registers() {
    if (!is_array(queue) || array_length(queue) == 0) return 0;

    // 蒐集目前空的 lane（包括「沒客在路上」）
    var free = [];
    for (var r = 0; r < array_length(regs); r++) {
        var lane = regs[r].lane_id;
        if (!lane_is_occupied(lane)) array_push(free, lane);
    }
    if (array_length(free) == 0) return 0;

    // 若兩邊都空，用 next_lane 控制交替順序
    if (array_length(free) == 2 && next_lane == 1) {
        var tmp = free[0]; free[0] = free[1]; free[1] = tmp;
    }

    var assigned = 0;

    // 逐個空台派一人
    for (var f = 0; f < array_length(free); f++) {
        var lane = free[f];

        // 找第一個還在排隊的人
        var pick_idx = -1;
        for (var q = 0; q < array_length(queue); q++) {
            var c = queue[q];
            if (instance_exists(c) && c.state == "queue") { pick_idx = q; break; }
        }
        if (pick_idx == -1) break;

        var cand = queue[pick_idx];
        var fp = front_pos[lane];
        cand.assigned_lane = lane;
        cand.state    = "to_register";
        cand.target_x = fp.x;
        cand.target_y = fp.y;

        var rr = get_register_by_lane(lane);
        if (instance_exists(rr)) {
            rr.slot_taken = true;
            if (variable_instance_exists(rr, "slot_timer_max")) rr.slot_timer = rr.slot_timer_max;
        }

        // 從 queue 移除該客人
        queue = array_delete(queue, pick_idx, 1);
        assigned++;

        show_debug_message("[dispatch] sent pick_idx=" + string(pick_idx) + " -> lane=" + string(lane));
    }

    // 若同時派兩台，切換交替順序
    if (assigned > 0 && array_length(free) == 2) next_lane = 1 - next_lane;

    refresh_queue_targets();
    return assigned;
}