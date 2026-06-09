# CMake del banco de pruebas. Compila el codigo nativo inseguro dentro de libbadpractices.so
# para que UnsafeCAPIRule (y UnusedCode en C++) se prueben tambien sobre el binario.
cmake_minimum_required(VERSION 3.22.1)
project("badpractices")

add_library(badpractices SHARED
    native-lib.c
    unsafe_capi.c
    unsafe_buffers.cpp)

find_library(log-lib log)
target_link_libraries(badpractices ${log-lib})
