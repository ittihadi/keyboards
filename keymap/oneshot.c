#include "oneshot.h"

void update_oneshot(oneshot_state *state, uint16_t mod, uint16_t trigger,
                    uint16_t keycode, keyrecord_t *record) {
    if (keycode == trigger) {
        if (record->event.pressed) {
            if (*state == os_up_unqueued) {
                register_code(mod);
            }
            *state = os_down_unused;
        } else {
            switch (*state) {
            case os_down_unused:
                *state = os_up_queued;
                break;
            case os_down_used:
                *state = os_up_unqueued;
                unregister_code(mod);
                break;
            default:
                break;
            }
        }
    } else {
        if (record->event.pressed) {
            if (is_oneshot_cancel_key(keycode) && *state != os_up_unqueued) {
                if (*state == os_down_unused || *state == os_down_used) {
                    *state = os_down_used;
                } else {
                    *state = os_up_unqueued;
                    unregister_code(mod);
                }
            }
            if (!is_oneshot_ignored_key(keycode)) {
                switch (*state) {
                case os_up_queued:
                    *state = os_up_queued_used;
                    break;
                case os_up_queued_used:
                    // Change (A down) (B down) (A up) (B up) from outputting
                    // AB to Ab
                    *state = os_up_unqueued;
                    unregister_code(mod);
                    break;
                default:
                    break;
                }
            }
        } else {
            if (!is_oneshot_ignored_key(keycode)) {
                switch (*state) {
                case os_down_unused:
                    *state = os_down_used;
                    break;
                case os_up_queued:
                case os_up_queued_used:
                    *state = os_up_unqueued;
                    unregister_code(mod);
                    break;
                default:
                    break;
                }
            }
        }
    }
}
