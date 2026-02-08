// Copyright 2023 QMK
// SPDX-License-Identifier: GPL-2.0-or-later

#ifndef bool
#define bool int
#define true 1
#define false 0
#endif

#include QMK_KEYBOARD_H

#include "oneshot.h"

// Based on
// Corne default keymap
// getreuer symbol keymap
// Jonas Hietala numbers
// Callum style home row mods

// TODO: Make the symbols and numbers not follow shift

enum layers {
    _GALLIUM = 0,
    _COLEMAKDH,
    _GAME,
    _NAV,
    _SYM,
    _FUN,
    _OTHER,
#ifdef MOUSEKEY_ENABLE
    _MOUSE,
#endif
};

enum combos {
    GM_CAPSWORD,
    GP_CAPSWORD,
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
#ifdef MOUSEKEY_ENABLE
#define LA_MOUS TG(_MOUSE)
#else
#define LA_MOUS XXXXXXX
#endif
#define DF_COL DF(_COLEMAKDH)
#define DF_GAL DF(_GALLIUM)
#define CTL_TAB C(KC_TAB)
#define DEL_WORD C(KC_BSPC)

const uint16_t PROGMEM gm_capsword[] = {KC_G, KC_M, COMBO_END};
const uint16_t PROGMEM gp_capsword[] = {KC_G, KC_P, COMBO_END};

// clang-format off
// Apparently the keymap won't compile if this wasn't here after enabling
// the combo feature
combo_t key_combos[] = {
    [GM_CAPSWORD]  = COMBO(gm_capsword, CW_TOGG),
    [GP_CAPSWORD]  = COMBO(gp_capsword, CW_TOGG),
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
      *               │MOU├───┐           ┌───┤Bsp│
      *               └───┤NAV├───┐   ┌───┤SYM├───┘
      *                   └───┤Spc│   │Ent├───┘
      *                       └───┘   └───┘
      */
    [_COLEMAKDH] = LAYOUT_split_3x6_3(
        KC_TAB,  KC_Q,    KC_W,    KC_F,    KC_P,    KC_B,                                KC_J,    KC_L,    KC_U,    KC_Y,    KC_COMM, KC_RALT,
        KC_LCTL, KC_A,    KC_R,    KC_S,    KC_T,    KC_G,                                KC_M,    KC_N,    KC_E,    KC_I,    KC_O,    KC_SLSH,
        KC_LSFT, KC_Z,    KC_X,    KC_C,    KC_D,    KC_V,                                KC_K,    KC_H,    KC_QUOT, KC_SCLN, KC_DOT,  KC_ESC,
                                            LA_MOUS,  LA_NAV,  KC_SPC,           KC_ENT,  LA_SYM,  KC_BSPC
    ),
     /*
      * ┌───┬───┬───┬───┬───┬───┐       ┌───┬───┬───┬───┬───┬───┐
      * │Tab│ B │ L │ D │ C │ V │       │ J │ Y │ O │ U │ , │   │
      * ├───┼───┼───┼───┼───┼───┤       ├───┼───┼───┼───┼───┼───┤
      * │Ctl│ N │ R │ T │ S │ G │       │ P │ H │ A │ E │ I │   │
      * ├───┼───┼───┼───┼───┼───┤       ├───┼───┼───┼───┼───┼───┤
      * │Sft│ X │ Q │ M │ W │ Z │       │ K │ F │ ' │ ; │ . │Esc│
      * └───┴───┴───┴───┴───┴───┘       └───┴───┴───┴───┴───┴───┘
      *               ┌───┐                   ┌───┐
      *               │MOU├───┐           ┌───┤Bsp│
      *               └───┤NAV├───┐   ┌───┤SYM├───┘
      *                   └───┤Spc│   │Ent├───┘
      *                       └───┘   └───┘
      */
    [_GALLIUM] = LAYOUT_split_3x6_3(
        KC_TAB,  KC_B,    KC_L,    KC_D,    KC_C,    KC_V,                                KC_J,    KC_Y,    KC_O,    KC_U,    KC_COMM, XXXXXXX,
        KC_LCTL, KC_N,    KC_R,    KC_T,    KC_S,    KC_G,                                KC_P,    KC_H,    KC_A,    KC_E,    KC_I,    XXXXXXX,
        KC_LSFT, KC_X,    KC_Q,    KC_M,    KC_W,    KC_Z,                                KC_K,    KC_F,    KC_QUOT, KC_SCLN, KC_DOT,  KC_ESC,
                                            LA_MOUS,  LA_NAV,  KC_SPC,           KC_ENT,  LA_SYM,  KC_BSPC
    ),
     /* 
      * ┌───────┬───────┬───────┬───────┬───────┬───────┐       ┌───────┬───────┬───────┬───────┬───────┬───────┐
      * │       │       │  Tab  │       │ C-Tab │       │       │ Pscrn │ Ctl Y │       │ C-Bsp │  Del  │       │
      * ├───────┼───────┼───────┼───────┼───────┼───────┤       ├───────┼───────┼───────┼───────┼───────┼───────┤
      * │       │  GUI  │ OSAlt │ OSSft │ OSCtl │       │       │   ←   │   ↓   │   ↑   │   → 	│  Bsp  │       │
      * ├───────┼───────┼───────┼───────┼───────┼───────┤       ├───────┼───────┼───────┼───────┼───────┼───────┤
      * │       │ Ctl Z │ Ctl X │ Ctl C │ Ctl V │       │       │ Home  │ PgDwn │  PgUp │  End  │  Esc  │       │
      * └───────┴───────┴───────┴───────┴───────┴───────┘       └───────┴───────┴───────┴───────┴───────┴───────┘
      *                           ┌───────┐                                   ┌───────┐
      *                           │       ├───────┐                   ┌───────┤       │
      *                           └───────┤  ---  ├───────┐   ┌───────┤  FUN  ├───────┘
      *                                   └───────┤  Spc  │   │  Ent  ├───────┘
      *                                           └───────┘   └───────┘
      */
    [_NAV] = LAYOUT_split_3x6_3(
        XXXXXXX, XXXXXXX,  KC_TAB, XXXXXXX, CTL_TAB, XXXXXXX,                             KC_PSCR, C(KC_Y), XXXXXXX, DEL_WORD, KC_DEL, XXXXXXX,
        XXXXXXX, KC_LGUI, OS_ALT,  OS_SHFT, OS_CTRL, XXXXXXX,                             KC_LEFT, KC_DOWN, KC_UP,   KC_RIGHT,KC_BSPC, XXXXXXX,
        XXXXXXX, C(KC_Z), C(KC_X), C(KC_C), C(KC_V), XXXXXXX,                             KC_HOME, KC_PGDN, KC_PGUP, KC_END,   KC_ESC, XXXXXXX,
                                            XXXXXXX, _______,  KC_SPC,           KC_ENT,  _______, XXXXXXX
    ),
     /*
      * ┌───────┬───────┬───────┬───────┬───────┬───────┐       ┌───────┬───────┬───────┬───────┬───────┬───────┐
      * │       │   `   │   <   │   >   │   -   │   |   │       │   ^   │   {   │   }   │   $   │   \   │  Del  │
      * ├───────┼───────┼───────┼───────┼───────┼───────┤       ├───────┼───────┼───────┼───────┼───────┼───────┤
      * │       │   !   │   *   │   /   │   =   │   &   │       │   #   │ OSCtl │ OSSft │   ?   │   "   │   '   │
      * ├───────┼───────┼───────┼───────┼───────┼───────┤       ├───────┼───────┼───────┼───────┼───────┼───────┤
      * │       │   ~   │   +   │   [   │   ]   │   %   │       │   @   │   (   │   )   │   :   │   _   │  Esc  │
      * └───────┴───────┴───────┴───────┴───────┴───────┘       └───────┴───────┴───────┴───────┴───────┴───────┘
      *                           ┌───────┐                                   ┌───────┐
      *                           │       ├───────┐                   ┌───────┤       │
      *                           └───────┤  FUN  ├───────┐   ┌───────┤  ---  ├───────┘
      *                                   └───────┤ CWSpc │   │  Ent  ├───────┘
      *                                           └───────┘   └───────┘
      */
    [_SYM] = LAYOUT_split_3x6_3(
        XXXXXXX,  KC_GRV, KC_LABK, KC_RABK, KC_MINS, KC_PIPE,                            KC_CIRC, KC_LCBR, KC_RCBR,  KC_DLR, KC_BSLS,  KC_DEL,
        XXXXXXX, KC_EXLM, KC_ASTR, KC_SLSH,  KC_EQL, KC_AMPR,                            KC_HASH, OS_CTRL, OS_SHFT, KC_QUES, KC_DQUO, KC_QUOT,
        XXXXXXX, KC_TILD, KC_PLUS, KC_LBRC, KC_RBRC, KC_PERC,                              KC_AT, KC_LPRN, KC_RPRN, KC_COLN, KC_UNDS,  KC_ESC,
                                            XXXXXXX, _______, CW_NCSP,           KC_ENT, _______, XXXXXXX
    ),
     /*
      * ┌───────┬───────┬───────┬───────┬───────┬───────┐       ┌───────┬───────┬───────┬───────┬───────┬───────┐
      * │       │  F6   │  F4   │  F10  │  F2   │  F8   │       │  F9   │  F3   │  F1   │  F5   │  F7   │       │
      * ├───────┼───────┼───────┼───────┼───────┼───────┤       ├───────┼───────┼───────┼───────┼───────┼───────┤
      * │       │   6   │   4   │   0   │   2   │  F12  │       │  F11  │   3   │   1   │   5   │   7   │       │
      * ├───────┼───────┼───────┼───────┼───────┼───────┤       ├───────┼───────┼───────┼───────┼───────┼───────┤
      * │       │       │       │       │   8   │ Other │       │       │   9   │   ,   │   .   │   _   │       │
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
        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,    KC_8, MO(_OTHER),                         XXXXXXX,    KC_9, KC_COMM,  KC_DOT, KC_UNDS, XXXXXXX,
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
        KC_TAB,  KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,                                KC_Y,    KC_U,    KC_I,    KC_O,    KC_P,    KC_RALT,
        KC_LCTL, KC_A,    KC_S,    KC_D,    KC_F,    KC_G,                                KC_H,    KC_J,    KC_K,    KC_L,    KC_UP,   KC_ESC,
        KC_LSFT, KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,                                KC_N,    KC_M,    XXXXXXX, KC_LEFT, KC_DOWN, KC_RIGHT,
                                            KC_LGUI, XXXXXXX,  KC_SPC,           KC_ENT,  TO(0),   KC_BSPC
    ),
     /*
      * ┌───────┬───────┬───────┬───────┬───────┬───────┐       ┌───────┬───────┬───────┬───────┬───────┬───────┐
      * │ BOOT  │ NKRO  │       │       │       │ GAMIN │       │       │ COLEM │ GALLI │       │       │       │
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
        QK_BOOT, NK_TOGG, XXXXXXX, XXXXXXX, XXXXXXX, TO(_GAME),                          XXXXXXX,  DF_COL,  DF_GAL, XXXXXXX, XXXXXXX, XXXXXXX,
        RM_TOGG, RM_HUEU, RM_SATU, RM_VALU, XXXXXXX, XXXXXXX,                            KC_MUTE, KC_VOLD, KC_VOLU, KC_MFFD, XXXXXXX, XXXXXXX,
        RM_NEXT, RM_HUED, RM_SATD, RM_VALD, XXXXXXX, _______,                            XXXXXXX, KC_BRID, KC_BRIU, KC_MRWD, XXXXXXX, XXXXXXX,
                                            XXXXXXX, XXXXXXX, XXXXXXX,          XXXXXXX, XXXXXXX, XXXXXXX
    ),
#ifdef MOUSEKEY_ENABLE
     /*
      * ┌───────┬───────┬───────┬───────┬───────┬───────┐       ┌───────┬───────┬───────┬───────┬───────┬───────┐
      * │  ***  │  ***  │  ***  │ ScrUp │  ***  │  ***  │       │  ***  │  ***  │  ***  │  ***  │  ***  │  ***  │
      * ├───────┼───────┼───────┼───────┼───────┼───────┤       ├───────┼───────┼───────┼───────┼───────┼───────┤
      * │  ***  │ ScrLf │  RMB  │  MMB  │  LMB  │ ScrRg │       │ Mo Le │ Mo Dn │ Mo Up │ Mo Ri │  ***  │  ***  │
      * ├───────┼───────┼───────┼───────┼───────┼───────┤       ├───────┼───────┼───────┼───────┼───────┼───────┤
      * │  ***  │  ***  │  ***  │ ScrDn │  ***  │  ***  │       │  ***  │ Acc 0 │ Acc 1 │ Acc 2 │  ***  │  ***  │
      * └───────┴───────┴───────┴───────┴───────┴───────┘       └───────┴───────┴───────┴───────┴───────┴───────┘
      *                           ┌───────┐                                   ┌───────┐
      *                           │  ---  ├───────┐                   ┌───────┤       │
      *                           └───────┤       ├───────┐   ┌───────┤       ├───────┘
      *                                   └───────┤  Spc  │   │  Ent  ├───────┘
      *                                           └───────┘   └───────┘
      */
    [_MOUSE] = LAYOUT_split_3x6_3(
        LA_MOUS, LA_MOUS, LA_MOUS, MS_WHLU, LA_MOUS, LA_MOUS,                            LA_MOUS, LA_MOUS, LA_MOUS, LA_MOUS, LA_MOUS, LA_MOUS,
        LA_MOUS, MS_WHLL, MS_BTN2, MS_BTN3, MS_BTN1, MS_WHLR,                            MS_LEFT, MS_DOWN, MS_UP,   MS_RGHT, LA_MOUS, LA_MOUS,
        LA_MOUS, LA_MOUS, LA_MOUS, MS_WHLD, LA_MOUS, LA_MOUS,                            LA_MOUS, MS_ACL0, MS_ACL1, MS_ACL2, LA_MOUS, LA_MOUS,
                                            _______, LA_NAV,  KC_SPC,            KC_ENT, LA_SYM,  XXXXXXX
    ),
#endif
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
    case LA_MOUS:
        // Clear all keys pressed when switching to mouse layer
        clear_keyboard_but_mods();
        break;
    case LA_NAV:
    case LA_SYM:
        // Turn off mouse layer before doing normal action
        if (IS_LAYER_ON(_MOUSE)) {
            layer_off(_MOUSE);
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
