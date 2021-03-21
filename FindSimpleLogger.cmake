# - Try to find Utils
# Once done this will define
# SimpleLogger_FOUND - System has SimpleLogger
# SimpleLogger_INCLUDE_DIRS - The SimpleLogger include directories
# SimpleLogger_LIBRARIES - The SimpleLogger library files

find_path (SimpleLogger_INCLUDE_DIR NAMES "SimpleLogger.h"
	HINTS "${SimpleLogger_DIR}/include/" )
find_path (SimpleLogger_LIBRARY NAMES "SimpleLogger.so"
	HINTS "${SimpleLogger_DIR}/lib/")

if(SimpleLogger_INCLUDE_DIR)
	message(STATUS "found SimpleLogger locally")
    	message(STATUS "SimpleLogger dir: ${SimpleLogger_DIR}")
	set(SimpleLogger_INCLUDE_DIRS ${SimpleLogger_INCLUDE_DIR})
	set(SimpleLogger_LIBRARIES ${SimpleLogger_LIBRARY})
else(SimpleLogger_INCLUDE_DIR)
	message(STATUS "SimpleLogger was not found locally, attempting to fetch it online")
	FetchContent_Declare(simplelogger        
		GIT_REPOSITORY "git@github.com:prb17/SimpleLogger.git"
        	GIT_TAG "v1.0.0"
        	)

	FetchContent_MakeAvailable(simplelogger)
    FetchContent_GetProperties(simplelogger)
    if(NOT simplelogger_POPULATED)
        FetchContent_Populate(simplelogger)
    endif()
    
    set(SimpleLogger_DIR "${simplelogger_SOURCE_DIR}")
    message(STATUS "downloaded SimpleLogger src dir: ${SimpleLogger_DIR}")

    find_path (SimpleLogger_INCLUDE_DIR NAMES "SimpleLogger.h"
        HINTS "${SimpleLogger_DIR}/include/" )
    set(SimpleLogger_INCLUDE_DIRS ${SimpleLogger_INCLUDE_DIR})
    set(SimpleLogger_LIBRARIES "${simplelogger_BINARY_DIR}/*.so")
endif(Utils_DIRS)


include ( FindPackageHandleStandardArgs )
# handle the QUIETLY and REQUIRED arguments and set SimpleLogger_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args (SimpleLogger DEFAULT_MSG SimpleLogger_INCLUDE_DIRS
	SimpleLogger_LIBRARIES)

