//
//  Functions.h
//  DsDOS-Command-1
//
//  Created by Алексей Химунин on 10.07.2026.
//

#ifndef Functions_h
#define Functions_h

#include "MyView/MyViewFunctions.h"
#include "FtpHeaderView/FtpHeaderViewFunctions.h"
#include "WiFiHeaderView/WiFiHeaderViewFunctions.h"
#include "WiFiSettingsView/WiFiSettingsViewFunctions.h"
#include "MyFunc/MyFuncFunctions.h"
#include "HelpFooterView/HelpFooterViewFunctions.h"
#include "FtpView/FtpViewFunctions.h"
#include "DiskView/DiskViewFunctions.h"
#include "CurrentView/CurrentViewFunctions.h"
#include "Debug/DebugFunctions.h"
#include "SelectDiskView/SelectDiskViewFunctions.h"
#include "StringLocale/StringLocaleFunctions.h"
#include "ButtonShadowView/ButtonShadowViewFunctions.h"
#include "EditFieldView/EditFieldViewFunctions.h"
#include "i8255/i8255Functions.h"
#include "ESP/ESPFunctions.h"
#include "ESP/ESPError/ESPErrorFunctions.h"
#include "Net/NetFunctions.h"
#include "Threads/ThreadsFunctions.h"
#include "Net/Parser/ParserFunctions.h"
#include "WiFiNetworksView/WiFiNetworksViewFunctions.h"
#include "FtpSettingsView/FtpSettingsViewFunctions.h"
#include "ButtonShadowView2/ButtonShadowView2Functions.h"
#include "AllertYesNoView/AllertYesNoViewFunctions.h"
#include "AllertOkView/AllertOkViewFunctions.h"
#include "LoadView/LoadViewFunctions.h"
#include "Net/FileParser/FileParserFunctions.h"
#include "DetectHardware/DetectHardwareFunctions.h"

#ifdef _IS_SIMULATOR
    /// Addr (2), Progress (1), 0x3C, DATA ... , SUM (1)
    uint8_t MockFileData[77] = {0x00, 0x00, 0x00, 0x3C,       0x43, 0x4B, 0x42, 0x52, 0x44, 0x24, 0x20, 0x20, 0x00, 0xB8, 0x38, 0x00, 0x00, 0x00, 0x6D, 0x92, 0x0E, 0x00, 0x3E, 0xDC, 0xCD, 0x06, 0xF0, 0x21, 0x20, 0xB8, 0xCD, 0x1B, 0xB8, 0x3A, 0x02, 0xF4, 0xE6, 0x10, 0x21, 0x33, 0xB8, 0xCA, 0x1B, 0xB8, 0x21, 0x2E, 0xB8, 0x3E, 0x02, 0xC3, 0x00, 0xF0, 0x0D, 0xCB, 0xEC, 0xE1, 0xF7, 0xE9, 0xE1, 0xF4, 0xF5, 0xF2, 0xE1, 0x3A, 0x20, 0x00, 0xD2, 0xCB, 0x38, 0x36, 0x00, 0x50, 0x53, 0x2F, 0x32, 0x00,       0xCD};
#else

#endif

uint8_t Net_buffer_len = 0;
uint8_t Net_buffer[1];


#endif /* Functions_h */
