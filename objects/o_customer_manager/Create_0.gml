////////////////////////////////////////////////////////////////////////////////
// o_customer_manager.Create
// 單隊列（倒Y），入口在上方，每4秒進1人；前兩位隨機直上左右收銀機，其餘開始中央排隊
////////////////////////////////////////////////////////////////////////////////

///////////////////////////////
// 內建函式（只給本物件使用） //
///////////////////////////////

// 重新計算中央佇列每位客人的目標位置（由下往上=靠近收銀機方向）
function refresh_queue_targets() {
    var L = array_length(queue);
    for (var i = 0; i < L; i++) {
        var c = queue[i];
        if (!instance_exists(c)) continue;
        c.queue_index = i;

        // 隊首若已被派往收銀機（或正在服務/結帳），不要覆蓋 target
        if (i == 0 && (c.state == "to_register" || c.state == "at_register" || c.state == "checkout")) {
            continue;
        }

        // 倒Y：收銀機在下方，隊伍由下往上排
        c.target_x = center_x;
        c.target_y = center_y - i * slot_gap; // index 越大越上面
        if (c.state == "queue" || c.state == "joining") c.state = "queue";
    }
}

// 隊首完成後彈出，並刷新站位（給 o_customer 結帳完呼叫）
function pop_head_and_refresh() {
    if (array_length(queue) > 0) {
        queue = array_delete(queue, 0, 1);
        refresh_queue_targets();
    }
}

// 嘗試把隊首派發到任一空檔的收銀機（不忙、服務點未被占用）
function try_dispatch_head_to_free_register() {
    if (array_length(queue) <= 0) return;

    var head = queue[0];
    if (!instance_exists(head)) return;
    if (head.state != "queue") return;

    // 找出可用收銀機（不 busy & 不 slot_taken）
    var free_lanes = [];
    for (var i = 0; i < array_length(regs); i++) {
        var r = regs[i];
        if (instance_exists(r) && !r.busy && !r.slot_taken) {
            array_push(free_lanes, r.lane_id);
        }
    }

    if (array_length(free_lanes) > 0) {
        var chosen_lane = choose(free_lanes[0], (array_length(free_lanes) > 1 ? free_lanes[1] : free_lanes[0]));
        var fp = front_pos[chosen_lane];

        head.assigned_lane = chosen_lane;
        head.state    = "to_register";
        head.target_x = fp.x;
        head.target_y = fp.y;

        var rr = get_register_by_lane(chosen_lane);
        if (instance_exists(rr)) rr.slot_taken = true;
    }
}

// 依 lane_id 取得收銀機實例
function get_register_by_lane(lane_id) {
    for (var i = 0; i < array_length(regs); i++) {
        if (regs[i].lane_id == lane_id) return regs[i];
    }
    return noone;
}

// 生成一位新客人：若有空服務點→隨機派去左/右；否則加入中央隊伍尾端
function spawn_one_customer() {
    if (spawned_count >= max_customers) return;

    var c = instance_create_layer(door_x, door_y, instance_layer_name, o_customer);
    c.door_x = door_x; c.door_y = door_y; // 只是存參考，離場用不到

    spawned_count++;

    // 蒐集空服務點
    var free_lanes = [];
    for (var i = 0; i < array_length(regs); i++) {
        var r = regs[i];
        if (instance_exists(r) && !r.busy && !r.slot_taken) {
            array_push(free_lanes, r.lane_id);
        }
    }

    if (array_length(free_lanes) > 0) {
        // 入口剛進來：有空就「隨機」派去左或右其中一個空機
        var chosen_lane = free_lanes[irandom(array_length(free_lanes)-1)];
        var fp = front_pos[chosen_lane];

        c.assigned_lane = chosen_lane;
        c.state    = "to_register";
        c.target_x = fp.x;
        c.target_y = fp.y;

        var rr = get_register_by_lane(chosen_lane);
        if (instance_exists(rr)) rr.slot_taken = true;
    } else {
        // 沒空位：加到中央佇列尾端
        array_push(queue, c);
        refresh_queue_targets();
    }
}

//////////////////////////
// 變數與場景初始化區塊 //
//////////////////////////

instance_layer_name = "Instances";

// 找出場上所有 o_register，按 x 左→右排序，並標 lane_id
regs = [];
var cr = instance_number(o_register);
for (var i = 0; i < cr; i++) regs[i] = instance_find(o_register, i);
for (var a=0; a<array_length(regs); a++)
for (var b=a+1; b<array_length(regs); b++)
if (regs[a].x > regs[b].x) { var t=regs[a]; regs[a]=regs[b]; regs[b]=t; }

if (array_length(regs) < 2) {
    show_debug_message("[o_customer_manager] 需要兩台 o_register；目前找到：" + string(array_length(regs)));
    active = false; exit;
}
active = true;

// 左右兩台 lane 初始化
regs[0].lane_id = 0; regs[0].busy = false; regs[0].slot_taken = false;
regs[1].lane_id = 1; regs[1].busy = false; regs[1].slot_taken = false;

// 服務點在收銀機【上方】50px（收銀機在下方）
front_pos = [
    { x: regs[0].x, y: regs[0].y - 50 },
    { x: regs[1].x, y: regs[1].y - 50 }
];

// 單列隊首錨點在兩個服務點的中間再往上 20px
center_x = (regs[0].x + regs[1].x) * 0.5;
center_y = min(front_pos[0].y, front_pos[1].y) - 20;

// 單一中央隊列與間距（倒Y：由下往上排）
queue = [];
slot_gap = 36;

// 門口在畫面正上方（從上方走進來）
door_x = room_width * 0.5;
door_y = -32;

// 生成節奏：每4秒進1人，最多20人
max_customers  = 20;
spawned_count  = 0;
alarm[0] = room_speed * 4; // 啟動週期生成
