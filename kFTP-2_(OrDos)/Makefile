USER_HOME := $(shell echo $$HOME)
C8080 := $(USER_HOME)/i8080/c8080
EMU := $(USER_HOME)/Documents/Orion128/Orion128.app/Contents/Resources
TESTAPP := test.ORD
USE_EMU := true
#true or false

all: kFTP2.ORD

.PHONY: clean
clean:
	rm kFTP2.ORD $(TESTAPP) kFTP-2/main.lst kFTP-2/main.asm

kFTP2.ORD: kFTP-2/main.c Makefile
	$(C8080)/c8080 -m -I$(C8080)/include -IkFTP-2 kFTP-2/main.c
	
ifeq ($(USE_EMU),true)
	rm $(EMU)/$(TESTAPP)
	cp $(TESTAPP) $(EMU)/
endif
