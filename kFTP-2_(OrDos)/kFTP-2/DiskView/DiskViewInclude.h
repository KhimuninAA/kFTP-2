//
//  DiskViewInclude.h
//  VBOX-TEST
//
//  Created by Алексей Химунин on 19.01.2026.
//

#ifndef DiskViewInclude_h
#define DiskViewInclude_h

const uint8_t DiskViewDirProgressCount = 19;

extern uint8_t DiskViewX;
extern uint8_t DiskViewY;
extern uint8_t DiskViewDX;
extern uint8_t DiskViewDY;
extern uint8_t DiskViewColor;
extern uint8_t DiskViewInvColor;
extern uint8_t DiskViewDiskNum;
extern uint8_t DiskViewDirCount;
extern uint16_t DiskViewDirBufer;
extern uint8_t DiskViewFileCurrentPos;
extern uint16_t DiskViewStartNewFile;

extern uint8_t DiskViewDirStartIndex;
extern uint8_t DiskViewDirEndIndex;
extern uint8_t DiskViewDirPageCoint;

extern uint8_t DiskViewTitle[9];
extern uint8_t DiskViewDirRootTitle[3];

extern uint8_t DiskViewExecData[8];

extern uint8_t DiskViewDirProgressLen;

///запуск резидентного выполнения
void DiskViewResidentProgram() __address(0xA800); //0xA800 0xF000

void DiskViewShow();
void DiskViewShowTitle();
void DiskViewUpdateDir();
void DiskViewShowDir();
void DiskViewKeyA();
/// Обновление позиции
/// вх[A]
/// 0 - без изменений
/// 1 - вверх
/// 0xFF - вниз
void DiskViewFileCurrentPosUpdateA();
/// Рисование линии прямым или инверсным цветом
/// 0 - прямой
/// 1 - инверсный
void DiskViewShowSelectLineA();
void DiskViewNextDiskNum();
void DiskViewSetDiskNumA();
void DiskViewUpdateDiskTitle();
void DiskViewUpdateDateAndUI();
void DiskViewDeleteSelectedFile();
void DiskViewUploadSelectedFile();
void DiskViewReload();
/// Проверка, хватит ли места на текущем диске для файла
/// вх[DE] - размер предпологаемого файла. Еще надо прибавить 16 - для заголовка
/// вых[A] - 0 - места нет, 1 - место есть
void DiskViewIsDiskSpaceDE();
/// HL = HL + (-DE)
/// вх[DE,HL]
/// вых[HL, A] - HL - результат вычитания , A = 1 HL > DE
void DiskViewHLSubDE();
/// Возвращает свободное место на диске
/// вых[HL] - результат
void DiskViewDiskFreeSpaceHL();
void DiskViewShowFreeSpace();
void DiskViewFormat();
void DiskViewCurrentFileNameHL();
void DiskViewSelectFileExec();

void DiskViewDirBuferStartIndexToHL();
void DiskViewDirEndIndexCalc();
void DiskViewDirEndIndexCalcFix();
void DiskViewDirProgress();
void DiskViewDirProgressLineCalk();
void DiskViewDirProgressCharByIndexA();

#endif /* DiskViewInclude_h */
