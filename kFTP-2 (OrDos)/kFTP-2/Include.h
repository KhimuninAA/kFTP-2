//
//  Include.h
//  kFTP-2
//
//  Created by Алексей Химунин on 09.02.2026.
//

#ifndef Include_h
#define Include_h

//#define _IS_MAIN_STACK
//#define _IS_SIMULATOR
//#define _IS_ESP_DELAY

extern unsigned char FONT_8_8_RUS[2048];

#include "Orion/ORDOS.h"
#include "Orion/Monitor.h"
#include "i8255/i8255Include.h"
#include "ESP/ESPInclude.h"
#include "Net/NetInclude.h"
#include "Net/Parser/ParserInclude.h"
#include "Net/Parser/ParserFileInclude.h"
#include "WiFiSettingsView/WiFiSettingsViewInclude.h"
#include "VBOX/VBOXInclude.h"
#include "MyFont/MyFontInclude.h"
#include "HelpView/HelpViewInclude.h"
#include "CurrentView/CurrentViewInclude.h"
#include "StringLocale/StringLocaleInclude.h"
#include "ButtonShadowView/ButtonShadowViewInclude.h"
#include "EditFieldView/EditFieldViewInclude.h"
#include "Keyboard/KeyboardInclude.h"
#include "Threads/ThreadsInclude.h"
#include "WifiStateView/WifiStateViewInclude.h"
#include "DiskView/DiskViewInclude.h"
#include "SelectDiskView/SelectDiskViewInclude.h"
#include "FtpStateView/FtpStateViewInclude.h"
#include "FtpSettingsView/FtpSettingsViewInclude.h"
#include "FtpView/FtpViewInclude.h"
#include "LoadView/LoadViewInclude.h"
#include "WiFiNetworksView/WiFiNetworksViewInclude.h"
#include "Debug/DebugInclude.h"
#include "AllertYesNoView/AllertYesNoViewInclude.h"
#include "ButtonShadowView2/ButtonShadowView2Include.h"
#include "AllertOkView/AllertOkViewInclude.h"
#include "FtpMakeDirectory/FtpMakeDirectoryInclude.h"
#include "ESP/ESPError/ESPErrorInclude.h"


#endif /* Include_h */
