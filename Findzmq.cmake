# - Try to find ZMQ
# Once done this will define
# ZMQ_FOUND - System has ZMQ
# ZMQ_INCLUDE_DIRS - The ZMQ include directories
# ZMQ_LIBRARIES - The libraries needed to use ZMQ
# ZMQ_DEFINITIONS - Compiler switches required for using ZMQ

message(STATUS "second level zmq path arg: ${zmq_DIR}")
find_path ( ZMQ_INCLUDE_DIR NAMES "zmq.h"
                            HINTS "${zmq_DIR}/include/" )

find_library ( ZMQ_LIBRARY  NAMES "zmq"
                            HINTS "${zmq_DIR}/lib/")

message(STATUS "zmq include dir: ${ZMQ_INCLUDE_DIR}")
message(STATUS "zmq lib: ${ZMQ_LIBRARY} ")

if( ZMQ_INCLUDE_DIR AND ZMQ_LIBRARY )
    message(STATUS "found zmq locally")
    set ( ZMQ_LIBRARIES ${ZMQ_LIBRARY} )
    set ( ZMQ_INCLUDE_DIRS ${ZMQ_INCLUDE_DIR} )
else()
    message(STATUS "zmq was not found locally, attempting to fetch it online")
    # ExternalProject_Add(zmq        
    #     GIT_REPOSITORY "https://github.com/zeromq/libzmq"
    #     GIT_TAG "master"
    #     DOWNLOAD_DIR "${CMAKE_SOURCE_DIR}/download/zmq/"
    #     SOURCE_DIR "${EXTERNAL_INSTALL_LOCATION}/zmq"
    #     #INSTALL_DIR ""  
    #     BUILD_COMMAND "make"      
    #     CMAKE_ARGS -DCMAKE_INSTALL_PREFIX="${EXTERNAL_INSTALL_LOCATION}/zmq"
    #     #INSTALL_COMMAND "make install" #--build --target install
    #     ENABLED_DEFAULT ON
    #     )ExternalProject_Add(zmq        
    #     GIT_REPOSITORY "https://github.com/zeromq/libzmq"
    #     GIT_TAG "master"
    #     DOWNLOAD_DIR "${CMAKE_SOURCE_DIR}/download/zmq/"
    #     SOURCE_DIR "${EXTERNAL_INSTALL_LOCATION}/zmq"
    #     #INSTALL_DIR ""  
    #     BUILD_COMMAND "make"      
    #     CMAKE_ARGS -DCMAKE_INSTALL_PREFIX="${EXTERNAL_INSTALL_LOCATION}/zmq"
    #     #INSTALL_COMMAND "make install" #--build --target install
    #     ENABLED_DEFAULT ON
    #     )
        
        set(zmq_DIR "${EXTERNAL_INSTALL_LOCATION}/zmq")

        find_path ( ZMQ_INCLUDE_DIR NAMES "zmq.h"
                            HINTS "${zmq_DIR}/include/" )
        find_library ( ZMQ_LIBRARY  NAMES "zmq"
                            HINTS "${zmq_DIR}/lib/")

        set ( ZMQ_LIBRARIES ${ZMQ_LIBRARY} )
        set ( ZMQ_INCLUDE_DIRS ${ZMQ_INCLUDE_DIR} )
endif( ZMQ_INCLUDE_DIR AND ZMQ_LIBRARY)


include ( FindPackageHandleStandardArgs )
# handle the QUIETLY and REQUIRED arguments and set ZMQ_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args ( ZMQ DEFAULT_MSG ZMQ_LIBRARY ZMQ_INCLUDE_DIR )
