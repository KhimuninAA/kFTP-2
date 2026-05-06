//
//  Functions.h
//  kFTP-2
//
//  Created by Алексей Химунин on 09.02.2026.
//

#ifndef Functions_h
#define Functions_h

#include "i8255/i8255Functions.h"
#include "ESP/ESPFunctions.h"
#include "Net/NetFunctions.h"
#include "Net/Parser/ParserFunctions.h"
#include "Net/Parser/ParserFileFunctions.h"
#include "WiFiSettingsView/WiFiSettingsViewFunctions.h"
#include "MyFont/MyFontFunctions.h"
#include "HelpView/HelpViewFunctions.h"
#include "CurrentView/CurrentViewFunctions.h"
#include "StringLocale/StringLocaleFunctions.h"
#include "ButtonShadowView/ButtonShadowViewFunctions.h"
#include "EditFieldView/EditFieldViewFunctions.h"
#include "Keyboard/KeyboardFunctions.h"
#include "Threads/ThreadsFunctions.h"
#include "WifiStateView/WifiStateViewFunctions.h"
#include "DiskView/DiskViewFunctions.h"
#include "SelectDiskView/SelectDiskViewFunctions.h"
#include "FtpStateView/FtpStateViewFunctions.h"
#include "FtpSettingsView/FtpSettingsViewFunctions.h"
#include "FtpView/FtpViewFunctions.h"
#include "LoadView/LoadViewFunctions.h"
#include "WiFiNetworksView/WiFiNetworksViewFunctions.h"
#include "Debug/DebugFunctions.h"
#include "AllertYesNoView/AllertYesNoViewFunctions.h"
#include "ButtonShadowView2/ButtonShadowView2Functions.h"
#include "AllertOkView/AllertOkViewFunctions.h"
#include "FtpMakeDirectory/FtpMakeDirectoryFunctions.h"
#include "ESP/ESPError/ESPErrorFunctions.h"

#include "Orion/font8x8.h"
#include "VBOX/VBOXFunctions.h"

uint8_t Net_buffer_len = 0;
uint8_t Net_buffer[1];

#endif /* Functions_h */
