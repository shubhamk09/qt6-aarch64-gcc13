# Qt 6 Cross-Compilation Guide for Raspberry Pi (aarch64)

This guide covers setting up Qt 6 cross-compilation for Raspberry Pi (aarch64) and creating Qt applications that can be deployed to Raspberry Pi.

## Table of Contents
1. [Host Machine Setup](#1-host-machine-setup)
2. [Building Qt for Host](#2-building-qt-for-host)
3. [Raspberry Pi Setup](#3-raspberry-pi-setup)
4. [Sysroot Creation](#4-sysroot-creation)
5. [Qt Cross-Compilation](#5-qt-cross-compilation)
5. [Project Configuration](#5-project-configuration)
6. [Deployment](#6-deployment)

## 1. Host Machine Setup

### Install Required Packages
```bash
# Install build essentials and required tools
sudo apt-get update
sudo apt-get install build-essential cmake ninja-build python3 pkg-config git

# Install cross-compiler for aarch64
sudo apt-get install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

# Install additional Qt build dependencies
sudo apt-get install \
    libfontconfig1-dev libfreetype6-dev libx11-dev libx11-xcb-dev libxext-dev \
    libxfixes-dev libxi-dev libxrender-dev libxcb1-dev libxcb-glx0-dev \
    libxcb-keysyms1-dev libxcb-image0-dev libxcb-shm0-dev libxcb-icccm4-dev \
    libxcb-sync-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-randr0-dev \
    libxcb-render-util0-dev libxcb-xinerama0-dev libxkbcommon-dev \
    libxkbcommon-x11-dev libclang-dev perl python3 ninja-build cmake \
    '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev \
    libxkbcommon-dev libxkbcommon-x11-dev
```

## 2. Building Qt for Host

### Clone Qt Repository
```bash
# Create directory for Qt source
mkdir -p ~/qt-build
cd ~/qt-build

# Clone the Qt repository
git clone git://code.qt.io/qt/qt5.git
cd qt5

# Initialize repository (get all submodules)
perl init-repository --module-subset=qtbase,qtdeclarative,qtshadertools

# Checkout the desired branch (e.g., 6.6)
git checkout 6.6
```

### Configure Qt for Host Build
```bash
# Create and enter build directory
mkdir build && cd build

# Configure Qt with basic setup
../qt6//configure -prefix $HOME/qt6-host-install
```

### Build and Install Qt for Host
```bash
# Build Qt (replace 8 with your desired number of CPU cores)
cmake --build . --parallel 8

# Install Qt to the prefix directory
cmake --install .
```

### Verify Installation
```bash
# Add Qt binaries to PATH
export PATH=$HOME/qt6-host-install/bin:$PATH

# Verify qmake version
qmake --version
```

## 3. Raspberry Pi Setup

### Install Qt Dependencies
```bash
sudo apt install libxcb1 libxcb-util1 libxcb-icccm4 libxcb-image0 \
    libxcb-keysyms1 libxcb-render-util0 libxcb-xinerama0 libxcb-xinput0 \
    libxcb-randr0 libxcb-shape0 libxcb-sync1 libxcb-xfixes0 \
    libgles2-mesa-dev libegl1-mesa-dev libx11-dev libxext-dev \
    libxrender-dev libxkbcommon-dev libxkbcommon-x11-dev
```

### Verify OpenGL ES Support
```bash
pkg-config --exists egl glesv2 && echo "Found"
```

## 3. Sysroot Creation

### Create Sysroot Directory
```bash
sudo mkdir -p /mnt/c/rpi-sysroot/rpi/sysroot
```

### Sync Raspberry Pi Files to Sysroot
```bash
# Replace <user> and <ip> with your Raspberry Pi credentials
rsync -avz --rsync-path="sudo rsync" <user>@<ip>:/lib /mnt/c/rpi-sysroot/rpi/sysroot
rsync -avz --rsync-path="sudo rsync" <user>@<ip>:/usr/include /mnt/c/rpi-sysroot/rpi/sysroot/usr
rsync -avz --rsync-path="sudo rsync" <user>@<ip>:/usr/lib /mnt/c/rpi-sysroot/rpi/sysroot/usr
rsync -avz --rsync-path="sudo rsync" <user>@<ip>:/opt/vc /mnt/c/rpi-sysroot/rpi/sysroot/opt
```

## 4. Qt Cross-Compilation

### Environment Setup
```bash
export ARCH=aarch64
export TRIPLET=aarch64-linux-gnu
export SYSROOT=/mnt/c/rpi-sysroot/rpi/sysroot
export PREFIX=$HOME/qt-rpi/qt6-$ARCH
```

### Configure Qt
```bash
./configure -release -nomake tests -nomake examples \
    -prefix $PREFIX \
    -qt-host-path $HOME/qt6-host-install/qtbase \
    -platform linux-g++ \
    -device-option CROSS_COMPILE=$TRIPLET- \
    -sysroot $SYSROOT \
    -- \
    -DCMAKE_SYSROOT=$SYSROOT \
    -DCMAKE_SYSTEM_NAME=Linux \
    -DCMAKE_C_COMPILER=$TRIPLET-gcc \
    -DCMAKE_CXX_COMPILER=$TRIPLET-g++ \
    -DCMAKE_FIND_ROOT_PATH=$SYSROOT \
    -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
    -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
    -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY \
    -DFEATURE_gui=ON \
    -DFEATURE_egl=ON \
    -DFEATURE_dbus=OFF \
    -DCMAKE_C_FLAGS="--sysroot=$SYSROOT -D_GLIBCXX_USE_CXX11_ABI=0" \
    -DCMAKE_CXX_FLAGS="--sysroot=$SYSROOT -D_GLIBCXX_USE_CXX11_ABI=0" \
    -DCMAKE_SHARED_LINKER_FLAGS="--sysroot=$SYSROOT" \
    -DCMAKE_EXE_LINKER_FLAGS="--sysroot=$SYSROOT"
```

### Build and Install Qt
```bash
cmake --build . --parallel
cmake --install .
```

### Update the sysroot and target with qt instalation 
```bash
# Replace <user> and <ip> with your Raspberry Pi credentials
rsync -avz $HOME/qt-rpi/qt6-aarch64/ /mnt/c/rpi-sysroot/rpi/sysroot/usr/local/qt6/
rsync -avz /mnt/c/rpi-sysroot/rpi/sysroot/usr/local/qt6/ <user>@<ip>:/usr/local/qt6/ --rsync-path="sudo rsync"
```

## 5. Project Configuration

### CMakePresets.json
Create a `CMakePresets.json` in your project root:

```json
{
  "version": 3,
  "configurePresets": [
    {
      "name": "raspberry-pi",
      "displayName": "Raspberry Pi Build",
      "description": "Build for Raspberry Pi (aarch64)",
      "binaryDir": "${sourceDir}/build/RaspBerryPi-Debug",
      "generator": "Unix Makefiles",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug",
        "CMAKE_INSTALL_PREFIX": "${sourceDir}/install",
        "CMAKE_PREFIX_PATH": "/home/shubham/Qt/6.9.1/gcc_64/lib/cmake",
        "CMAKE_C_COMPILER": "/usr/bin/aarch64-linux-gnu-gcc",
        "CMAKE_CXX_COMPILER": "/usr/bin/aarch64-linux-gnu-g++",
        "CMAKE_EXPORT_COMPILE_COMMANDS": "TRUE"
      }
    }
  ],
  "buildPresets": [
    {
      "name": "raspberry-pi",
      "configurePreset": "raspberry-pi",
      "targets": ["all", "install"]
    }
  ]
}
```

## 6. Deployment

### Deploy Script
Create a `deploy-to-rpi.sh`:

```bash
#!/bin/bash

# Configuration
RPI_IP="your.raspberry.pi.ip"
RPI_USER="pi"
REMOTE_DIR="/home/$RPI_USER/TryRpi"

# Create remote directory
ssh $RPI_USER@$RPI_IP "mkdir -p $REMOTE_DIR"

# Copy the executable and QML files using rsync
rsync -avz --progress install/bin/appTryRpi Main.qml $RPI_USER@$RPI_IP:$REMOTE_DIR/

echo "Deployment complete. To run the application on Raspberry Pi:"
echo "1. SSH into your Raspberry Pi: ssh $RPI_USER@$RPI_IP"
echo "2. Navigate to the directory: cd $REMOTE_DIR"
echo "3. Make the application executable: chmod +x appTryRpi"
echo "4. Run the application: ./appTryRpi"
```

### Sync Qt Libraries to Raspberry Pi
```bash
# Sync built Qt to Raspberry Pi
rsync -avz $HOME/qt-rpi/qt6-aarch64/ /mnt/c/rpi-sysroot/rpi/sysroot/usr/local/qt6/
rsync -avz /mnt/c/rpi-sysroot/rpi/sysroot/usr/local/qt6/ <user>@<ip>:/usr/local/qt6/ --rsync-path="sudo rsync"
```

## Important Notes

1. **Toolchain Compatibility**: Ensure your cross-compiler version matches or is lower than the GCC version on your Raspberry Pi to avoid GLIBC version mismatches.

2. **Qt Version**: This guide assumes Qt 6.x. Adjust paths and commands according to your Qt version.

3. **Sysroot Updates**: Remember to update your sysroot if you install new dependencies on the Raspberry Pi.

4. **Build Directory**: Always use clean build directories when switching between different build configurations.

5. **Deployment Location**: Deploy applications to user-writable locations to avoid permission issues.

## Troubleshooting

1. **GLIBC Version Mismatch**: If you see errors about missing `GLIBC_2.38` or `GLIBCXX_3.4.32`, your cross-compiler is newer than the Raspberry Pi's GCC. Use a matching or older version.

2. **Qt Libraries Not Found**: Ensure Qt libraries are properly installed in `/usr/local/qt6` on the Raspberry Pi.

3. **OpenGL ES Issues**: Verify EGL and GLES libraries are properly installed on the Raspberry Pi.
