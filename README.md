## portable gcc toolchains

### 1. 从release下载

### 2. 直接编译生成

```
./build.sh 14.1.0

./stage/gcc-14.1.0/bin/gcc --version

```

### 3. 使用方法

#### 3.1 设置环境
```
source /path/to/gcc-13.2.0/activate
# or
export PATH="/path/to/gcc-13.2.0/bin:$PATH"

which gcc
gcc --version

```

#### 3.2 设置编译选项(可选)

```
# 0. commandline
gcc -static-libgcc -o test test.c
g++ -static-libgcc -static-libstdc++ -o test test.cpp
g++ -fsanitize=address -static-libasan -static-libgcc -static-libstdc++ -o test test.cpp

# 1. for make and other buildsystem
/path/to/configure ... \
  LDFLAGS="-static-libstdc++ -static-libasan ..." \
  CC=/path/to/gcc-13.2.0/bin/gcc \
  CXX=/path/to/gcc-13.2.0/bin/g++


# 2. for cmake
cmake -DCMAKE_EXE_LINKER="-static-libstdc++ -static-libasan ..." \
  -DCMAKE_C_COMPILER=/path/to/gcc-13.2.0/bin/gcc \
  -DCMAKE_CXX_COMPILER=/path/to/gcc-13.2.0/bin/g++
```
