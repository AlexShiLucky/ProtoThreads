CC := gcc

CSRC := example-small.c
CSRC += example-codelock.c
CSRC += example-buffer.c

CSRC += example-small-addrlabels.c
CSRC += example-small-switch.c

OBJS := $(CSRC:%.c=%.o)
iSRC := $(CSRC:%.c=%.i)
BIN := $(CSRC:%.c=%)

CFLAGS = -O -Wuninitialized -Werror -g

.PHONY: all
all: $(BIN) $(iSRC)

$(BIN): %:%.c
	$(CC) $(CFLAGS) $< -o $@

$(iSRC): %.i:%.c
	$(CC) -E $(CFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -f $(BIN) $(TXT) $(OBJS)
