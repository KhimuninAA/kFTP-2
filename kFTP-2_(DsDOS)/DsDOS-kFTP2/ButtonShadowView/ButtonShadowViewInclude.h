//
//  ButtonShadowViewInclude.h
//  DsDOS-kFTP2
//
//  Created by Алексей Химунин on 26.08.2026.
//

#ifndef ButtonShadowViewInclude_h
#define ButtonShadowViewInclude_h

/// H - x, L - y
/// D - dx, E - dy
/// BC - text
void ButtonShadowViewShow();
/// Закраска кнопки
/// 0 - прямой
/// 1 - инверсный
void ButtonShadowViewSelectA();
void ButtonShadowViewShowTitleBC();

extern uint8_t ButtonShadowViewX;
extern uint8_t ButtonShadowViewY;
extern uint8_t ButtonShadowViewDX;
extern uint8_t ButtonShadowViewDY;

extern uint8_t ButtonShadowViewColor;
extern uint8_t ButtonShadowViewInvColor;
extern uint16_t ButtonShadowViewTitlePoint;

#endif /* ButtonShadowViewInclude_h */
