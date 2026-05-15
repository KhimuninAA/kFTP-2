//
//  ButtonShadowView2Include.h
//  kFTP-2
//
//  Created by Алексей Химунин on 17.02.2026.
//

#ifndef ButtonShadowView2Include_h
#define ButtonShadowView2Include_h

extern uint8_t ButtonShadowView2X;
extern uint8_t ButtonShadowView2Y;
extern uint8_t ButtonShadowView2DX;
extern uint8_t ButtonShadowView2DY;

extern uint8_t ButtonShadowView2Color;
extern uint8_t ButtonShadowView2InvColor;
extern uint16_t ButtonShadowView2TitlePoint;

void ButtonShadowView2Show();
void ButtonShadowView2ShowTitleBC();
/// Закраска кнопки
/// 0 - прямой
/// 1 - инверсный
void ButtonShadowView2SelectA();

#endif /* ButtonShadowView2Include_h */
