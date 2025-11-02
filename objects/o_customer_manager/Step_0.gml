if (!active) exit;

if (dispatch_cooldown > 0) {
    dispatch_cooldown--;
} else {
    var assigned = auto_dispatch_free_registers();
    if (assigned > 0) dispatch_cooldown = 1;
}

refresh_queue_targets();
