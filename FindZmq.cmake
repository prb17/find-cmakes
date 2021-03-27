# - Try to find ZMQ
# define Zmq_ROOT as your local zmq build directory
# Once done this will define
# Zmq_FOUND - System has ZMQ
# Zmq_INCLUDE_DIRS - The ZMQ include directories
# Zmq_LIBRARIES - The libraries needed to use ZMQ
# or
# Zmq_LIBRARIES_DIR if no local installation provided


find_path ( Zmq_INCLUDE_DIR NAMES "zmq.h"
                            HINTS "${Zmq_ROOT}/include/" )

find_library ( Zmq_LIBRARY  NAMES "zmq"
                            HINTS "${Zmq_ROOT}/lib/")


if( Zmq_INCLUDE_DIR AND Zmq_LIBRARY )
    message(STATUS "found Zmq locally")
    message(VERBOSE "Zmq include dir: ${Zmq_INCLUDE_DIR}")
    message(VERBOSE "Zmq lib: ${Zmq_LIBRARY} ")
    set ( Zmq_LIBRARIES ${Zmq_LIBRARY} )
    set ( Zmq_INCLUDE_DIRS ${Zmq_INCLUDE_DIR} )
else( Zmq_INCLUDE_DIR AND Zmq_LIBRARY )
    message(STATUS "Zmq was not found locally, attempting to fetch it online")
    FetchContent_Declare(Zmq        
		        GIT_REPOSITORY "https://github.com/zeromq/libzmq.git"
        	    GIT_TAG "master"
        	)

	FetchContent_MakeAvailable(Zmq)
    FetchContent_GetProperties(Zmq)
    if(NOT Zmq_POPULATED)
        FetchContent_Populate(Zmq)
    endif()
        
    set(Zmq_ROOT "${Zmq_SOURCE_DIR}")
    message(VERBOSE "downloaded Zmq src dir: ${Zmq_ROOT}")

    find_path ( Zmq_INCLUDE_DIR NAMES "zmq.h"
                        HINTS "${Zmq_ROOT}/include" )

    set ( Zmq_INCLUDE_DIRS ${Zmq_INCLUDE_DIR} )
    set ( Zmq_LIBRARIES_DIR "${Zmq_BINARY_DIR}")
endif( Zmq_INCLUDE_DIR AND Zmq_LIBRARY)


include ( FindPackageHandleStandardArgs )
# handle the QUIETLY and REQUIRED arguments and set ZMQ_FOUND to TRUE
# if all listed variables are TRUE
if( Zmq_LIBRARY )
    find_package_handle_standard_args ( Zmq DEFAULT_MSG Zmq_LIBRARY Zmq_INCLUDE_DIR )
else( Zmq_LIBRARY )
    find_package_handle_standard_args ( Zmq DEFAULT_MSG Zmq_LIBRARIES_DIR Zmq_INCLUDE_DIR )
endif( Zmq_LIBRARY )