// Copyright 2023 QMK
// SPDX-License-Identifier: GPL-2.0-or-later

#include QMK_KEYBOARD_H

#include "oneshot.h"

// Based on Corne default
// 2025-09-10 Callum style mods
// 2025-09-14 Modified the symbol layers from
//  https://getreuer.info/posts/keyboards/symbol-layer/index.html
//   getreuer
//   seniply
// Rearrange layers and moved extra functions to "OTHER" layer for cleaner
// function layer
// 2025-09-17 Add CAPSWORD toggle button to function layer
// 2025-09-18 Rearrange number row and function row similar to
//  https://www.jonashietala.se/blog/2021/06/03/the-t-34-keyboard-layout/
//  and https://github.com/callum-oakley/qmk_firmware/tree/master/users/callum
// 2025-09-27 Swap Backspace and Right Alt keys
// 2025-09-27 Add ctrl and alt to function layer
// 2025-09-27 Move F11 and F12 to inner index finger
// 2025-09-27 Add Ctrl Z X C V to nav layer
// 2025-09-29 Change OSM super key on numnav layer to normal super key and
//            remove super key from thumb cluster (at least on base layer)
// 2025-09-29 Remove default QWERTY layer, gaming layer will suffice in typing
//            QWERTY
// 2025-09-29 Add combos for tab and backspace on base layer, exact
//            configuration is being considered
// 2025-09-29 Move numbers to the same layer as functions, add combo for
//            capsword trigger, move tab on nav layer closer in by a column,
//            add backspace and delete into symbol layer, and cleaned up some
//            unused keys
// 2025-09-29 Make one shot mod cancels not cancel currently held one shot mod
//            instead it marks it as consumed so it acts as if it was a normal
//            modifier being held
// 2025-10-06 Change punctuation layout to that of Gallium
// 2025-10-09 Move non-cancelling space to symbol layer so space is on the same
//            location regardless and treat non-cancelling as if it was a mod

// TODO: Make the symbols and numbers not follow shift

enum layers {
    _COLEMAKDH = 0,
    _GAME,
    _NAV,
    _SYM,
    _FUN,
    _OTHER,
};

enum combos {
    GM_CAPSWORD,
};

enum keycodes {
    OS_SHFT = SAFE_RANGE,
    OS_CTRL,
    OS_ALT,
    OS_GUI,

    CW_NCSP, // Capsword non-cancelling space
};

#define LA_NAV MO(_NAV)
#define LA_SYM MO(_SYM)
#define CTL_TAB C(KC_TAB)

const uint16_t PROGMEM gm_capsword[] = {KC_G, KC_M, COMBO_END};

// clang-format off
// Apparently the keymap won't compile if this wasn't here after enabling
// the combo feature
combo_t key_combos[] = {
    [GM_CAPSWORD]  = COMBO(gm_capsword, CW_TOGG),
};
// clang-format on

// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
     /*
      * ┌───┬───┬───┬───┬───┬───┐       ┌───┬───┬───┬───┬───┬───┐
      * │Tab│ Q │ W │ F │ P │ B │       │ J │ L │ U │ Y │ , │Alt│
      * ├───┼───┼───┼───┼───┼───┤       ├───┼───┼───┼───┼───┼───┤
      * │Ctl│ A │ R │ S │ T │ G │       │ M │ N │ E │ I │ O │ / │
      * ├───┼───┼───┼───┼───┼───┤       ├───┼───┼───┼───┼───┼───┤
      * │Sft│ Z │ X │ C │ D │ V │       │ K │ H │ ' │ ; │ . │Esc│
      * └───┴───┴───┴───┴───┴───┘       └───┴───┴───┴───┴───┴───┘
      *               ┌───┐                   ┌───┐
      *               │GUI├───┐           ┌───┤Bsp│
      *               └───┤NAV├───┐   ┌───┤SYM├───┘
      *                   └───┤Spc│   │Ent├───┘
      *                       └───┘   └───┘
      */
    [_COLEMAKDH] = LAYOUT_split_3x6_3(
        KC_TAB,  KC_Q,    KC_W,    KC_F,    KC_P,    KC_B,                                KC_J,    KC_L,    KC_U,    KC_Y,    KC_COMM, KC_RALT,
        KC_LCTL, KC_A,    KC_R,    KC_S,    KC_T,    KC_G,                                KC_M,    KC_N,    KC_E,    KC_I,    KC_O,    KC_SLSH,
        KC_LSFT, KC_Z,    KC_X,    KC_C,    KC_D,    KC_V,                                KC_K,    KC_H,    KC_QUOT, KC_SCLN, KC_DOT,  KC_ESC,
                                            KC_LGUI,  LA_NAV,  KC_SPC,           KC_ENT,  LA_SYM,  KC_BSPC
    ),
     /* 
      * ┌───────┬───────┬───────┬───────┬───────┬───────┐       ┌───────┬───────┬───────┬───────┬───────┬───────┐
      * │       │  Tab  │       │       │ C-Tab │       │       │       │       │       │       │  Del  │       │
      * ├───────┼───────┼───────┼───────┼───────┼───────┤       ├───────┼───────┼───────┼───────┼───────┼───────┤
      * │       │  GUI  │ OSAlt │ OSSft │ OSCtl │       │       │   ←   │   ↓   │   ↑   │   → 	│  Bsp  │ Pscrn │
      * ├───────┼───────┼───────┼───────┼───────┼───────┤       ├───────┼───────┼───────┼───────┼───────┼───────┤
      * │       │ Ctl Z │ Ctl X │ Ctl C │       │ Ctl V │       │ Home  │ PgDwn │  PgUp │  End  │  Esc  │       │
      * └───────┴───────┴───────┴───────┴───────┴───────┘       └───────┴───────┴───────┴───────┴───────┴───────┘
      *                           ┌───────┐                                   ┌───────┐
      *                           │       ├───────┐                   ┌───────┤       │
      *                           └───────┤  ---  ├───────┐   ┌───────┤  FUN  ├───────┘
      *                                   └───────┤  Spc  │   │  Ent  ├───────┘
      *                                           └───────┘   └───────┘
      */
    [_NAV] = LAYOUT_split_3x6_3(
        XXXXXXX,  KC_TAB, XXXXXXX, XXXXXXX, CTL_TAB, XXXXXXX,                             XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,  KC_DEL, XXXXXXX,
        XXXXXXX, KC_LGUI, OS_ALT,  OS_SHFT, OS_CTRL, XXXXXXX,                             KC_LEFT, KC_DOWN, KC_UP,   KC_RIGHT,KC_BSPC, KC_PSCR,
        XXXXXXX, C(KC_Z), C(KC_X), C(KC_C), XXXXXXX, C(KC_V),                             KC_HOME, KC_PGDN, KC_PGUP, KC_END,   KC_ESC, XXXXXXX,
                                            XXXXXXX, _______,  KC_SPC,           KC_ENT,  _______, XXXXXXX
    ),
     /*
      * ┌───────┬───────┬───────┬───────┬───────┬───────┐       ┌───────┬───────┬───────┬───────┬───────┬───────┐
      * │  Tab  │   `   │   <   │   >   │   -   │   |   │       │   ^   │   {   │   }   │   $   │   \   │  Del  │
      * ├───────┼───────┼───────┼───────┼───────┼───────┤       ├───────┼───────┼───────┼───────┼───────┼───────┤
      * │   ?   │   !   │   *   │   /   │   =   │   &   │       │   #   │ OSCtl │ OSSft │ OSAlt │   "   │   '   │
      * ├───────┼───────┼───────┼───────┼───────┼───────┤       ├───────┼───────┼───────┼───────┼───────┼───────┤
      * │  Sft  │   ~   │   +   │   [   │   ]   │   %   │       │   @   │   (   │   )   │   :   │   _   │  Esc  │
      * └───────┴───────┴───────┴───────┴───────┴───────┘       └───────┴───────┴───────┴───────┴───────┴───────┘
      *                           ┌───────┐                                   ┌───────┐
      *                           │       ├───────┐                   ┌───────┤       │
      *                           └───────┤  FUN  ├───────┐   ┌───────┤  ---  ├───────┘
      *                                   └───────┤ CWSpc │   │  Ent  ├───────┘
      *                                           └───────┘   └───────┘
      */
    [_SYM] = LAYOUT_split_3x6_3(
        KC_TAB,   KC_GRV, KC_LABK, KC_RABK, KC_MINS, KC_PIPE,                            KC_CIRC, KC_LCBR, KC_RCBR,  KC_DLR, KC_BSLS,  KC_DEL,
        KC_QUES, KC_EXLM, KC_ASTR, KC_SLSH,  KC_EQL, KC_AMPR,                            KC_HASH, OS_CTRL, OS_SHFT,  OS_ALT, KC_DQUO, KC_QUOT,
        KC_LSFT, KC_TILD, KC_PLUS, KC_LBRC, KC_RBRC, KC_PERC,                              KC_AT, KC_LPRN, KC_RPRN, KC_COLN, KC_UNDS,  KC_ESC,
                                            XXXXXXX, _______, CW_NCSP,           KC_ENT, _______, XXXXXXX
    ),
     /*
      * ┌───────┬───────┬───────┬───────┬───────┬───────┐       ┌───────┬───────┬───────┬───────┬───────┬───────┐
      * │       │  F6   │  F4   │  F10  │  F2   │  F8   │       │  F9   │  F3   │  F1   │  F5   │  F7   │       │
      * ├───────┼───────┼───────┼───────┼───────┼───────┤       ├───────┼───────┼───────┼───────┼───────┼───────┤
      * │       │   6   │   4   │   0   │   2   │  F12  │       │  F11  │   3   │   1   │   5   │   7   │       │
      * ├───────┼───────┼───────┼───────┼───────┼───────┤       ├───────┼───────┼───────┼───────┼───────┼───────┤
      * │       │       │       │       │   8   │ Other │       │       │   9   │       │       │       │       │
      * └───────┴───────┴───────┴───────┴───────┴───────┘       └───────┴───────┴───────┴───────┴───────┴───────┘
      *                           ┌───────┐                                   ┌───────┐
      *                           │       ├───────┐                   ┌───────┤       │
      *                           └───────┤  ---  ├───────┐   ┌───────┤  ---  ├───────┘
      *                                   └───────┤  Spc  │   │  Ent  ├───────┘
      *                                           └───────┘   └───────┘
      */
    [_FUN] = LAYOUT_split_3x6_3(
        XXXXXXX,   KC_F6,   KC_F4,  KC_F10,   KC_F2,   KC_F8,                              KC_F9,   KC_F3,   KC_F1,   KC_F5,   KC_F7, XXXXXXX,
        XXXXXXX,    KC_6,    KC_4,    KC_0,    KC_2,  KC_F12,                             KC_F11,    KC_3,    KC_1,    KC_5,    KC_7, XXXXXXX,
        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,    KC_8, MO(_OTHER),                         XXXXXXX,    KC_9, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
                                            XXXXXXX, _______,  KC_SPC,           KC_ENT, _______, XXXXXXX
    ),
     /* GAME
      * ┌───┬───┬───┬───┬───┬───┐       ┌───┬───┬───┬───┬───┬───┐
      * │Tab│ Q │ W │ E │ R │ T │       │ Y │ U │ I │ O │ P │Alt│
      * ├───┼───┼───┼───┼───┼───┤       ├───┼───┼───┼───┼───┼───┤
      * │Ctl│ A │ S │ D │ F │ G │       │ H │ J │ K │ L │ ^ │Esc│
      * ├───┼───┼───┼───┼───┼───┤       ├───┼───┼───┼───┼───┼───┤
      * │Sft│ Z │ X │ C │ V │ B │       │ N │ M │   │ < │ v │ > │
      * └───┴───┴───┴───┴───┴───┘       └───┴───┴───┴───┴───┴───┘
      *               ┌───┐                   ┌───┐
      *               │GUI├───┐           ┌───┤Bsp│
      *               └───┤   ├───┐   ┌───┤OFF├───┘
      *                   └───┤Spc│   │Ent├───┘
      *                       └───┘   └───┘
      */
    [_GAME] = LAYOUT_split_3x6_3(
        KC_TAB,  KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,                                KC_Y,           KC_U,    KC_I,    KC_O,    KC_P,    KC_RALT,
        KC_LCTL, KC_A,    KC_S,    KC_D,    KC_F,    KC_G,                                KC_H,           KC_J,    KC_K,    KC_L,    KC_UP,   KC_ESC,
        KC_LSFT, KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,                                KC_N,           KC_M,    XXXXXXX, KC_LEFT, KC_DOWN, KC_RIGHT,
                                            KC_LGUI, XXXXXXX,  KC_SPC,           KC_ENT,  TO(_COLEMAKDH) ,KC_BSPC
    ),
     /*
      * ┌───────┬───────┬───────┬───────┬───────┬───────┐       ┌───────┬───────┬───────┬───────┬───────┬───────┐
      * │ BOOT  │       │       │       │       │ GAMIN │       │       │       │       │       │       │       │
      * ├───────┼───────┼───────┼───────┼───────┼───────┤       ├───────┼───────┼───────┼───────┼───────┼───────┤
      * │ Togg  │ HueUp │ SatUp │ ValUp │       │       │       │ VoMut │ VolDn │ VolUp │  Fwd  │       │       │
      * ├───────┼───────┼───────┼───────┼───────┼───────┤       ├───────┼───────┼───────┼───────┼───────┼───────┤
      * │ Next  │ HueDn │ SatDn │ ValDn │       │  ---  │       │       │ BriDn │ BriUp │  Rwn  │       │       │
      * └───────┴───────┴───────┴───────┴───────┴───────┘       └───────┴───────┴───────┴───────┴───────┴───────┘
      *                           ┌───────┐                                   ┌───────┐
      *                           │       ├───────┐                   ┌───────┤       │
      *                           └───────┤       ├───────┐   ┌───────┤       ├───────┘
      *                                   └───────┤       │   │       ├───────┘
      *                                           └───────┘   └───────┘
      */
    [_OTHER] = LAYOUT_split_3x6_3(
        QK_BOOT, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, TO(_GAME),                          XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
        RM_TOGG, RM_HUEU, RM_SATU, RM_VALU, XXXXXXX, XXXXXXX,                            KC_MUTE, KC_VOLD, KC_VOLU, KC_MFFD, XXXXXXX, XXXXXXX,
        RM_NEXT, RM_HUED, RM_SATD, RM_VALD, XXXXXXX, _______,                            XXXXXXX, KC_BRID, KC_BRIU, KC_MRWD, XXXXXXX, XXXXXXX,
                                            XXXXXXX, XXXXXXX, XXXXXXX,          XXXXXXX, XXXXXXX, XXXXXXX
    ),
};
// clang-format on

bool is_oneshot_cancel_key(uint16_t keycode) {
    switch (keycode) {
    case LA_SYM:
    case LA_NAV:
        return true;
    default:
        return false;
    }
}

bool is_oneshot_ignored_key(uint16_t keycode) {
    switch (keycode) {
    case LA_SYM:
    case LA_NAV:
    case OS_SHFT:
    case OS_CTRL:
    case OS_ALT:
    case OS_GUI:
    case KC_LSFT:
        return true;
    default:
        return false;
    }
}

oneshot_state os_shft_state = os_up_unqueued;
oneshot_state os_ctrl_state = os_up_unqueued;
oneshot_state os_alt_state = os_up_unqueued;
oneshot_state os_mod_state = os_up_unqueued;

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    update_oneshot(&os_shft_state, KC_LSFT, OS_SHFT, keycode, record);
    update_oneshot(&os_ctrl_state, KC_LCTL, OS_CTRL, keycode, record);
    update_oneshot(&os_alt_state, KC_LALT, OS_ALT, keycode, record);
    update_oneshot(&os_mod_state, KC_LWIN, OS_GUI, keycode, record);

    switch (keycode) {
    case CW_NCSP:
        if (record->event.pressed) {
            send_char(' ');
        }
        break;
    }

    return true;
}

layer_state_t layer_state_set_user(layer_state_t state) {
    return update_tri_layer_state(state, _NAV, _SYM, _FUN);
}

bool caps_word_press_user(uint16_t keycode) {
    switch (keycode) {
    case KC_A ... KC_Z:
        add_weak_mods(MOD_BIT_LSHIFT);
        return true;

    case KC_1 ... KC_0:
    case KC_COMM: // Add more keys that don't disable CAPSWORD and don't autocap
    case KC_DOT:
    case KC_QUOT:
    case KC_DQUO:
    case KC_UNDS:
    case KC_MINS:
    case KC_BSPC:
    case KC_DEL:
    case KC_SLSH:
    case CW_NCSP:
        return true;

    default:
        return false;
    }
}

// vim: nowrap
