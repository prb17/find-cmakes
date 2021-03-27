# - Try to find CZMQ
# define Czmq_ROOT as your local zmq build directory
# Once done this will define
# Czmq_FOUND - System has CZMQ
# Czmq_INCLUDE_DIRS - The CZMQ include directories
# Czmq_LIBRARIES - The libraries needed to use CZMQ
# or
# Czmq_LIBRARIES_DIR if no local installation provided


find_path ( Czmq_INCLUDE_DIR NAMES "czmq.h"
                            HINTS "${Czmq_ROOT}/include/" )

find_library ( Czmq_LIBRARY  NAMES "czmq"
                            HINTS "${Czmq_ROOT}/lib/")


if( Czmq_INCLUDE_DIR AND Czmq_LIBRARY )
    message(STATUS "found Czmq locally")
    message(VERBOSE "Czmq include dir: ${Czmq_INCLUDE_DIR}")
    message(VERBOSE "Czmq lib: ${Czmq_LIBRARY} ")
    set ( Czmq_LIBRARIES ${Czmq_LIBRARY} )
    set ( Czmq_INCLUDE_DIRS ${Czmq_INCLUDE_DIR} )
else()
    message(STATUS "Czmq was not found locally, attempting to fetch it online")
    FetchContent_Declare(Czmq        
		        GIT_REPOSITORY "https://github.com/zeromq/czmq.git"
        	    GIT_TAG "master"
        	)
	FetchContent_MakeAvailable(Czmq)
        
    set(Czmq_ROOT "${czmq_SOURCE_DIR}")
    message(VERBOSE "downloaded Czmq src dir: ${Czmq_ROOT}")

    find_path ( Czmq_INCLUDE_DIR NAMES "czmq.h"
                        HINTS "${Czmq_ROOT}/include" )

    set ( Czmq_INCLUDE_DIRS ${Czmq_INCLUDE_DIR} )
    set ( Czmq_LIBRARIES_DIR "${czmq_BINARY_DIR}/lib")
endif( Czmq_INCLUDE_DIR AND Czmq_LIBRARY)


include ( FindPackageHandleStandardArgs )
# handle the QUIETLY and REQUIRED arguments and set Czmq_FOUND to TRUE
# if all listed variables are TRUE
if( Czmq_LIBRARY )
    find_package_handle_standard_args ( Czmq DEFAULT_MSG Czmq_LIBRARY Czmq_INCLUDE_DIR )
else( Czmq_LIBRARY )
    find_package_handle_standard_args ( Czmq DEFAULT_MSG Czmq_LIBRARIES_DIR Czmq_INCLUDE_DIR )
endif( Czmq_LIBRARY )