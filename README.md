# **NetFileX** 🌐  
![Language](https://img.shields.io/badge/Language-C-blue?style=flat-square)
![Platform](https://img.shields.io/badge/Platform-Linux-green?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)

> A distributed network file system implementing a Naming Server architecture with fault tolerance, data replication, and concurrent client access.

---
## **Overview** 📝

| | |
|---|---|
| **Project Type** | Distributed Network File System |
| **Duration** | 3 weeks |
| **Course** | Operating Systems and Networks (OSN) |
| **Institution** | IIIT Hyderabad |

NetFileX is a distributed file system that implements a **Naming Server architecture** to facilitate efficient communication between **Clients** and **Storage Servers**. The Naming Server acts as the central mediator for managing metadata, routing requests, and ensuring high performance, scalability, and fault tolerance.

### **System Architecture**

1. **`Naming Server`** 🗄️:
   - **Primary Role**: Acts as the central directory for the system, managing the metadata of files and mapping them to appropriate storage servers.
   - **Responsibilities**:
     - Receives client requests for file access and retrieves necessary metadata.
     - Maintains a registry of available **`Storage Servers`** and their resources.
     - Routes requests from clients to the appropriate storage server based on metadata.
     - Handles caching of frequently accessed data using an **`LRU`** cache for improved performance.
     - Coordinates the addition or removal of **`Storage Servers`** in the network.

2. **`Storage Servers`** 💾:
   - **Primary Role**: Stores the actual data and provides storage capabilities to the distributed system.
   - **Responsibilities**:
     - Store the data requested by clients.
     - Send metadata information (e.g., location, size) to the **`Naming Server`** during registration.
     - Handle read and write requests directed to them by the **`Naming Server`**.
     - Respond to the **`Naming Server`** with the data requested by clients.

3. **`Clients`** 👥:
   - **Primary Role**: Initiates requests for data stored in the distributed system and interacts with the **`Naming Server`** to retrieve file metadata.
   - **Responsibilities**:
     - Send requests to the **`Naming Server`** for file information.
     - Receive metadata from the **`Naming Server`** to determine which **`Storage Server`** holds the requested data.
     - Retrieve data from the appropriate **`Storage Server`**.
     - Handle user interface or application logic that interacts with the distributed storage system.

### **How It All Fits Together**:
The **`Naming Server`** provides an essential role in the distributed system by serving as the point of interaction between **`Clients`** and **`Storage Servers`**. Clients query the **`Naming Server`** to get file metadata and the location of the storage. Once the location is determined, the **`Naming Server`** routes the client request to the correct **`Storage Server`**. This architecture ensures that file access is efficient and that clients can scale their requests across multiple servers.

This system also uses caching mechanisms, such as an **`LRU`** (Least Recently Used) cache in the **`Naming Server`**, to reduce lookup times for frequently accessed files. The **`Storage Servers`** remain lightweight, focused on data storage and retrieval, while the **`Naming Server`** handles the coordination and routing of requests, making the system more organized and performant.

---

## **File Structure** 📂

```
NetFileX/
├── README.md                            # Project documentation
├── Makefile                             # Build instructions for the entire project
├── color.h                              # Terminal color formatting
├── client/                              # Client-side implementation
│   ├── client.c                         # Client implementation in C
│   └── client.h                         # Client header file
├── naming_server/                       # Naming Server implementation
│   ├── Makefile                         # Build instructions
│   ├── globals.h                        # Global constants and configurations
│   ├── errors.h                         # Error handling definitions
│   ├── return_struct.h                  # Struct definitions for return values
│   ├── app.py                           # Testing utility for multiple storage servers
│   ├── namingServer/                    # Core naming server logic
│   │   ├── namingServer.c               # Main naming server implementation
│   │   └── namingServer.h               # Naming server header
│   ├── caching/                         # Caching module
│   │   ├── caching.c                    # Caching implementation
│   │   └── caching.h                    # Caching header
│   ├── lru/                             # LRU cache implementation
│   │   ├── lru.c                        # LRU cache logic
│   │   └── lru.h                        # LRU cache header
│   ├── log/                             # Logging functionality
│   │   ├── log.c                        # Logging implementation
│   │   └── log.h                        # Logging header
│   ├── path/                            # Path management
│   │   ├── path.c                       # Path handling logic
│   │   └── path.h                       # Path header
│   └── tries/                           # Trie data structure
│       ├── tries.c                      # Trie implementation
│       └── tries.h                      # Trie header
└── storage_server/                      # Storage Server implementation
    ├── storage_server.c                 # Main storage server implementation
    ├── storage_server.h                 # Storage server header
    ├── file.c                           # File operations
    ├── file.h                           # File header
    ├── network.c                        # Network communication
    ├── network.h                        # Network header
    └── lib.h                            # Utility library
```

---

## **Key Features** 🚀

| Feature | Description |
|---------|-------------|
| **Concurrent Access** | Multiple readers with single writer lock per file using mutex-based synchronization |
| **Asynchronous Writes** | Non-blocking writes for files over 8KB using chunked transfer |
| **Trie-Based Indexing** | O(k) file path lookups where k is path length |
| **LRU Caching** | Frequently accessed metadata cached for performance |
| **Data Replication** | Automatic backup to 2 additional storage servers for fault tolerance |
| **Audio Streaming** | Real-time MP3 streaming via mpv integration |
| **Dynamic Scaling** | Support for up to 100 storage servers and 100 concurrent clients |

---

## **Technical Implementation** ⚙️

### **Concurrency Model**
- **Readers-Writers Lock**: Multiple concurrent readers allowed, exclusive writer access
- **Thread Pool**: Each client connection handled by a dedicated pthread
- **Mutex Protection**: Critical sections protected using `pthread_mutex_t`

### **Data Structures**
- **Trie**: Hierarchical path storage with O(k) lookup complexity
- **LRU Cache**: Doubly-linked list with hash map for O(1) cache operations

### **Fault Tolerance**
- Data automatically replicated to SS[n+1] and SS[n+2]
- Heartbeat-based failure detection with PING/PONG protocol
- Automatic failover to backup servers on primary failure

---

## **Detailed Functionality** ⚙️

### **1. Write Operations** ✍️
- **Interactive Writes**: Input a single line up to **8192 bytes** for smaller file writes.
- **Large Writes**: Transfer large files using `LARGE.txt`.
- **Asynchronous Writes**: For files over **`8192 bytes`**, the system acknowledges the client immediately while the file is written asynchronously in chunks.

### **2. Naming Server (NM)** 🗂️  
- **Concurrency**: Handles multiple client requests with **`non-blocking`** acknowledgments.
- **Efficient Search**: Uses **`Trie-based`** structures to rapidly identify the correct **Storage Server** for each request.
- **Error Handling**: Returns detailed error codes for different failure scenarios.

### **3. Copy Command Behavior** 📂
- **File-to-File**: Supports copying files up to **`1024 bytes`**.
- **Directory-to-Directory**: Only the contents of the directory are copied, not the directory itself.

### **4. Audio Streaming** 🎧  
- Once streaming begins, it cannot be stopped until completion.

### **5. Data Structure** 📊  
- **`Trie`** ensures unique paths for all files and directories, enhancing search speed and file management.

### **6. Multiple Clients Handling** 🤝  
- **`Concurrent Client Access`**: Allows multiple clients to read files concurrently, while only one client can write at a time.
- **Client Timeouts**: Handles client timeouts when the **Naming Server** fails to respond promptly.

### **7. Error Codes** ⚠️  
- Defined error codes for **`file not found`**, **`write conflicts`**, and **`server failures`**.

### **8. Search in Naming Server** 🔍  
- **Trie-Based Search** and **LRU Caching** for fast and efficient data retrieval.

### **9. Backing up Data** 🔄  
- **Replication** ensures availability in case of failures.
- **Asynchronous Duplication** for data redundancy.

### **10. Redundancy** 💾  
- Ensures **storage server recovery** with synchronization of data after failure.

### **11. Bookkeeping** 📜  
- **Logging** of all requests and communications, aiding in debugging and monitoring.


## **Future Enhancements** ⏳  
- **Scalability**: Future updates will support **`horizontal scaling`** of both the **Naming Server** and **Storage Servers**.
- **Security**: Implement **`encryption`** for file transfers.
- **Data Integrity**: Incorporate **`checksum validation`** to ensure data integrity.



## **Installation & Build Instructions** 💾

1. **Clone the repository**:
   ```bash
   git clone https://github.com/ShreyasMehta05/NetFileX.git
   ```

2. **Navigate to the project directory**:
   ```bash
   cd NetFileX
   ```

3. **Install dependencies**:
   - Install `gcc` for C compilation.
   - Install `mpv` for audio functionality:
     ```bash
     sudo apt install gcc mpv
     ```

---


## **Build Instructions** 🛠️

### **1. Naming Server (NM) Build**  
To compile the **Naming Server**, run the following command in named `naming_server` directory:

```bash
gcc namingServer.c lru/lru.c log/log.c caching/caching.c path/path.c tries/tries.c -o main -pthread -g
```

- **Explanation**:  
  This command compiles all the necessary source files for the Naming Server and links them together. The `-pthread` flag enables multi-threading, and the `-g` flag is used for debugging.

#### **Alternative Build Command**  
Alternatively, you can use `make` to compile the Naming Server with a pre-configured `Makefile` in the `NETFILEX` directory:

```bash
make naming_server
```

### **2. Storage Server (SS) Build**  
To compile the **Storage Server**, navigate to the `storage_server` directory and run:

```bash
gcc *.c -o ss -pthread -g
```

- **Explanation**:  
  This command compiles all the `.c` files in the `storage_server` directory and generates an executable named `ss`. The `-pthread` flag enables multi-threading support.

#### **Alternative Build Command**  
To use `make` for building the Storage Server in the `NETFILEX` directory:

```bash
make storage_server
```

### **3. Client Build**  
To compile the **Client**, run the following command in the `client` directory:

```bash
gcc client.c -o client -lmpv
```

- **Explanation**:  
  This command compiles the client-side code and links the `libmpv` library for audio functionality.

#### **Alternative Build Command**  
Alternatively, to use `make` to compile the Client in the `NETFILEX` directory:

```bash
make client
```

---

## **Running the Executables** 💻

After compiling the project, you can run the respective components with the following commands. You must supply the necessary command-line arguments.
Here’s the corrected and refined version of your documentation:

---

### **1. Running the Naming Server (NM)**  
To run the **Naming Server**, execute the following command:

```bash
./main
```

If you wish to modify the configuration, update the global variables in the `globals.h` file accordingly, and then run the command again as shown above.

---

## **Configuration and Assumptions** 📡

The **Naming Server** runs with the following default configuration parameters:

### **Global Constants** 🛠️
These constants are defined in the `globals.c` file of the **Naming Server** and can be adjusted as needed for your network setup.

```c
#define __NAMING_SS_PORT__ 8080              // Default port for Storage Server connections
#define __NAMING_CLIENT_PORT__ 8081          // Default port for Client connections
#define __NAMING_SERVER_IP__ "192.168.16.138" // Default IP address for the Naming Server
#define __MAX_STORAGE_SERVERS__ 100          // Maximum number of Storage Servers supported
#define __MAX_CLIENTS__ 100                  // Maximum number of clients that can connect concurrently
#define __BUFFER__ 5                         // Buffer size for handling requests
#define __BUFFER_SIZE__ 4096                 // Maximum buffer size for data storage/transfer
#define __MAX_LRU_CACHE_SIZE__ 10            // Maximum size of Least Recently Used (LRU) cache
```

- **Port Numbers**:  
  The **Naming Server** listens on port `8080` by default for Storage Server connections and port `8081` for Client connections. These port values can be modified by changing the `__NAMING_SS_PORT__` and `__NAMING_CLIENT_PORT__` definitions in `globals.h`.

- **IP Address**:  
  The **Naming Server** uses the default IP `192.168.16.138`. In a production environment, you should replace this IP with the actual IP address of your **Naming Server** machine. Modify the `__NAMING_SERVER_IP__` definition in `globals.h` as needed.

- **Maximum Storage Servers**:  
  The system supports a maximum of `100` **Storage Servers**, as specified by the `__MAX_STORAGE_SERVERS__` constant. You can adjust this value based on the scale of your setup.

- **Maximum Clients**:  
  The **Naming Server** can handle up to `100` concurrent client connections, as specified by `__MAX_CLIENTS__`. Adjust this value as needed to support more clients.

- **Buffer Sizes**:  
  The system uses a buffer size of `5` for handling requests (`__BUFFER__`) and `4096` bytes for data storage/transfer (`__BUFFER_SIZE__`). These values can be tuned to optimize memory and processing based on system requirements.

- **LRU Cache Size**:  
  The **Naming Server** uses an LRU (Least Recently Used) caching strategy with a default cache size of `10` entries (`__MAX_LRU_CACHE_SIZE__`). This helps improve access times for frequently requested data.

### **Assumptions** 🔧

1. **Naming Server IP and Port**:  
   The **Naming Server** listens on IP `192.168.16.138` by default and port `8080` for Storage Server communication. Clients should connect to port `8081`. Modify these values in `globals.h` if a different setup is required.

2. **Multi-Server Setup**:  
   The system can handle up to `100` **Storage Servers** and up to `100` concurrent client connections, as defined by `__MAX_STORAGE_SERVERS__` and `__MAX_CLIENTS__`.

3. **System Buffer**:  
   The system uses a buffer size of `4096` bytes (`__BUFFER_SIZE__`) to handle incoming requests efficiently. You can adjust this buffer size in `globals.h` for optimized memory usage.

4. **LRU Cache**:  
   The **Naming Server** utilizes an LRU caching strategy to store the most frequently accessed data. The cache can hold up to `10` entries by default, and this can be modified by adjusting `__MAX_LRU_CACHE_SIZE__` in `globals.h`.

---



### **2. Running the Storage Server (SS)**  
To run the Storage Server, execute the following command, passing in the required arguments:

```bash
./ss <nm_server_ip> <nm_server_port> <client_port>
```

- **Arguments**:  
  - `<nm_server_ip>`: IP address of the Naming Server.
  - `<nm_server_port>`: Port of the Naming Server.
  - `<client_port>`: Port for the Storage Server to listen for incoming client connections.

For example:

```bash
./ss 192.168.1.10 8080 9090
```

### **3. Running the Client**  
To run the Client, provide the **Naming Server IP** as a command-line argument:

```bash
./client <naming_server_ip>
```

- **Arguments**:  
  - `<naming_server_ip>`: IP address of the Naming Server.

For example:

```bash
./client 192.168.1.10
```

The client will now interact with the **Naming Server** and allow you to perform operations like listing files, reading, writing, and more.

--- 

## **Client Functionality** 🎮

- **LIST**: List available files.
- **READ**: Read file content.
- **WRITE**: Write data to a file.
- **DELETE**: Delete a file or folder.
- **CREATE**: Create a new file or folder.
- **COPY**: Copy a file to a different path.
- **AUDIO**: Stream an audio file.
- **EXIT**: Exit the client application.

---
### **Dependencies** 📦
The **Naming Server** requires the following dependencies:

- **GCC**: The GNU Compiler Collection (for compiling C programs).
- **POSIX Threads (pthreads)**: For multi-threading support.
- **Libraries**: (e.g., any network-related libraries if used).

### Troubleshooting:

- **Error: "Unable to bind to port"**  
  This error typically means the specified port is already in use. Try changing the port number in `globals.h` and recompile.

- **Error: "Connection Refused"**  
  Ensure the server is running and that the correct IP and port are used by the client.

- **Memory Allocation Issues**  
  If you run into memory-related issues, check that your buffer sizes and cache settings in `globals.h` are configured correctly.
---

---

## **Contributors** 👥

| Name | Role | Contributions |
|------|------|---------------|
| **Shreyas Mehta** | Naming Server Lead | System architecture, Naming Server implementation, project coordination |
| **Inesh Dheer** | Client Developer | Client-side functionality, system testing |
| **Shubham Goel** | Storage Server Developer | Storage Server implementation, file operations, data integrity |
| **Swam Singla** | Storage Server Developer | Async writes, audio streaming, heartbeat polling |

---

## **License** 📄

This project was developed as part of the Operating Systems and Networks course at IIIT Hyderabad.

---

## **Acknowledgments** 🙏

- Course instructors at IIIT Hyderabad for guidance on distributed systems concepts
- POSIX threading and socket programming documentation

