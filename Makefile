CC := gcc

CSRCS-X := example-small.c
CSRCS-X += example-codelock.c
CSRCS-X += example-buffer.c

CSRCS := example-small-addrlabels.c
CSRCS += example-small-switch.c

ISRCS-XA := $(CSRCS-X:%.c=%.addrlabels.i)
ISRCS-XS := $(CSRCS-X:%.c=%.switch.i)
ISRCS := $(CSRC:%.c=%.i)

TARGET-XA := $(CSRCS-X:%.c=%.addrlabels)
TARGET-XS := $(CSRCS-X:%.c=%.switch)
TARGET := $(CSRCS:%.c=%)

CFLAGS = -O -Wuninitialized -Werror -g
%.addrlabels.i: CFLAGS += -D'LC_INCLUDE="lc-addrlabels.h"'
%.switch.i: CFLAGS += -D'LC_INCLUDE="lc-switch.h"'

.PHONY: all
all: $(TARGET) $(TARGET-XA) $(TARGET-XS) $(ISRCS) $(ISRCS-XA) $(ISRCS-XS)

$(TARGET): %:%.c
	$(CC) $(CFLAGS) $< -o $@

$(TARGET-XA): %.addrlabels:%.c
	$(CC) $(CFLAGS) $< -o $@

$(TARGET-XS): %.switch:%.c
	$(CC) $(CFLAGS) $< -o $@

$(ISRCS): %.i:%.c
	$(CC) -E $(CFLAGS) $< -o $@

$(ISRCS-XA): %.addrlabels.i:%.c
	$(CC) -E $(CFLAGS) $< -o $@

$(ISRCS-XS): %.switch.i:%.c
	$(CC) -E $(CFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) $(TARGET-XA) $(TARGET-XS) $(ISRCS) $(ISRCS-XA) $(ISRCS-XS)
