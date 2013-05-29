PLATFORM ?= $(shell uname)

CC = gcc
SRCS = main.c view.c server.c client.c
LIBS = -liup -lpthread
CFLAGS +=
EXE =

SRC_DIR = ./src
BIN_DIR = ./bin

ifeq ($(findstring Linux,$(PLATFORM)),Linux)
	SRCS += socket_linux.c string_value_utf8.c
else
	EXE = .exe
	SRCS += socket_win32.c string_value_gbk.c
	LIBS += -lmingw32 -lgdi32 -luser32 -lcomdlg32 \
			-lcomctl32 -luuid -lole32 -lwsock32 -lkernel32 -mwindows
endif

OBJS = $(SRCS:%.c=%.o)
BIN = chartoom$(EXE)

all: bin

run: bin
	cd $(BIN_DIR) && ./$(BIN)

clean:
	@cd $(SRC_DIR) && rm -f $(OBJS)

bin: $(BIN_DIR)/$(BIN)

$(BIN_DIR)/$(BIN): $(OBJS:%=$(SRC_DIR)/%)
	$(CC) -o $@ $^ $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

.PHONY: all bin run clean
