cmake_minimum_required(VERSION 3.16)
project(io-benchmark LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if (MSVC)
  add_compile_options(/W4 /permissive-)
else()
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

set(SRC main.cpp)

add_executable(io_benchmark_slow ${SRC})

add_executable(io_benchmark_fast ${SRC})
target_compile_definitions(io_benchmark_fast PRIVATE FAST_IO=1)

# Default to Release if not specified
if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()
