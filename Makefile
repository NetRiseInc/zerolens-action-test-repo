# keep binaries in top-level build/
BIN_DIR := ./build
BIN     := $(BIN_DIR)/app.bin 

$(BIN): src/main.c
	@mkdir -p $(BIN_DIR)
	gcc -O0 -g -D_FORTIFY_SOURCE=0 -fno-builtin-strcat -fno-builtin-strcpy $< -o $@

clean:
	rm -f $(BIN)
.PHONY: clean
