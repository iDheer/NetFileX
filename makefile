# Compiler and Flags
CC = gcc
CFLAGS = -pthread -g
LDFLAGS = -lmpv

# Directories for source files
NM_SRC = namingServer/namingServer.c \
         namingServer/lru/lru.c \
         namingServer/log/log.c \
         namingServer/caching/caching.c \
         namingServer/path/path.c \
         namingServer/tries/tries.c

SS_SRC = storage_server/*.c

CLIENT_SRC = client/client.c

# Output executables
NM_EXEC = naming_server/main
SS_EXEC = storage_server/ss
CLIENT_EXEC = client/client

# Default target to build all executables
all: $(NM_EXEC) $(SS_EXEC) $(CLIENT_EXEC)

# Build Naming Server
$(NM_EXEC): $(NM_SRC)
	$(CC) $(NM_SRC) -o $(NM_EXEC) $(CFLAGS)

# Build Storage Server
$(SS_EXEC): $(SS_SRC)
	$(CC) $(SS_SRC) -o $(SS_EXEC) $(CFLAGS)

# Build Client
$(CLIENT_EXEC): $(CLIENT_SRC)
	$(CC) $(CLIENT_SRC) -o $(CLIENT_EXEC) $(LDFLAGS)

# Clean up compiled files
clean:
	rm -f $(NM_EXEC) $(SS_EXEC) $(CLIENT_EXEC)

# Run Naming Server
run_nm: $(NM_EXEC)
	./$(NM_EXEC)

# Run Storage Server with command-line arguments
run_ss: $(SS_EXEC)
	./$(SS_EXEC) <nm_server_port> <client_port> <nm_ip>

# Run Client with command-line argument for the Naming Server IP
run_client: $(CLIENT_EXEC)
	./$(CLIENT_EXEC) <naming_server_ip>

# Phony targets
.PHONY: all clean run_nm run_ss run_client
