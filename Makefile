CC := gcc

CSRCS-X := example-small.c
CSRCS-X += example-codelock.c
CSRCS-X += example-buffer.c

CSRCS := example-small-addrlabels.c
CSRCS += example-small-switch.c
CSRCS += example-small-setjmp.c

ISRCS-XA := $(CSRCS-X:%.c=%.addrlabels.i)
ISRCS-XS := $(CSRCS-X:%.c=%.switch.i)
ISRCS-XJ := $(CSRCS-X:%.c=%.setjmp.i)
ISRCS := $(CSRC:%.c=%.i)

TARGET-XA := $(CSRCS-X:%.c=%.addrlabels)
TARGET-XS := $(CSRCS-X:%.c=%.switch)
TARGET-XJ := $(CSRCS-X:%.c=%.setjmp)
TARGET := $(CSRCS:%.c=%)

CFLAGS = -O -Wuninitialized -Werror -g
$(ISRCS-XA) $(TARGET-XA): CFLAGS += -D'LC_INCLUDE="lc-addrlabels.h"'
$(ISRCS-XS) $(TARGET-XS): CFLAGS += -D'LC_INCLUDE="lc-switch.h"'
$(ISRCS-XJ) $(TARGET-XJ): CFLAGS += -D'LC_INCLUDE="lc-setjmp.h"'

.PHONY: all
all: $(TARGET) $(TARGET-XA) $(TARGET-XS) $(TARGET-XJ) $(ISRCS) $(ISRCS-XA) $(ISRCS-XS) $(ISRCS-XJ)

$(TARGET): %:%.c
	$(CC) $(CFLAGS) $< -o $@

$(TARGET-XA): %.addrlabels:%.c
	$(CC) $(CFLAGS) $< -o $@

$(TARGET-XS): %.switch:%.c
	$(CC) $(CFLAGS) $< -o $@

$(TARGET-XJ): %.setjmp:%.c
	$(CC) $(CFLAGS) $< -o $@

$(ISRCS): %.i:%.c
	$(CC) -E $(CFLAGS) $< -o $@

$(ISRCS-XA): %.addrlabels.i:%.c
	$(CC) -E $(CFLAGS) $< -o $@

$(ISRCS-XS): %.switch.i:%.c
	$(CC) -E $(CFLAGS) $< -o $@

$(ISRCS-XJ): %.setjmp.i:%.c
	$(CC) -E $(CFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) $(TARGET-XA) $(TARGET-XS) $(TARGET-XJ) $(ISRCS) $(ISRCS-XA) $(ISRCS-XS) $(ISRCS-XJ)
