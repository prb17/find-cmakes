# - Try to find Utils
# define SimpleLogger_ROOT to your local SimpleLogger build directory
# Once done this will define
# SimpleLogger_FOUND - System has SimpleLogger
# SimpleLogger_INCLUDE_DIRS - The SimpleLogger include directories
# SimpleLogger_LIBRARIES - The SimpleLogger library files

find_path (SimpleLogger_INCLUDE_DIR NAMES "SimpleLogger.h"
	HINTS "${SimpleLogger_ROOT}/include/" )

find_path (SimpleLogger_LIBRARY NAMES "SimpleLogger.so"
	HINTS "${SimpleLogger_ROOT}/lib/")

if(SimpleLogger_INCLUDE_DIR AND SimpleLogger_LIBRARY)
	message(STATUS "found SimpleLogger locally")
    message(VERBOSE "SimpleLogger dir: ${SimpleLogger_ROOT}")
	set(SimpleLogger_INCLUDE_DIRS ${SimpleLogger_INCLUDE_DIR})
	set(SimpleLogger_LIBRARIES ${SimpleLogger_LIBRARY})
else(SimpleLogger_INCLUDE_DIR AND SimpleLogger_LIBRARY)
	message(STATUS "SimpleLogger was not found locally, attempting to fetch it online")
	FetchContent_Declare(
			simplelogger        
			GIT_REPOSITORY "git@github.com:prb17/SimpleLogger.git"
        	GIT_TAG "main"
        	)
	FetchContent_MakeAvailable(simplelogger)
    
    set(SimpleLogger_DIR "${simplelogger_SOURCE_DIR}")
    message(STATUS "downloaded SimpleLogger src dir: ${SimpleLogger_DIR}")

    find_path (SimpleLogger_INCLUDE_DIR NAMES "SimpleLogger.h"
        HINTS "${SimpleLogger_DIR}/include/" )
    set(SimpleLogger_INCLUDE_DIRS ${SimpleLogger_INCLUDE_DIR})
    set(SimpleLogger_LIBRARIES_DIR "${simplelogger_BINARY_DIR}/src/")
	message(VERBOSE "SimpleLogger incs: ${SimpleLogger_INCLUDE_DIRS}")
	message(VERBOSE "SimpleLogger libs dir: ${SimpleLogger_LIBRARIES_DIR}")
endif(SimpleLogger_INCLUDE_DIR AND SimpleLogger_LIBRARY)


include ( FindPackageHandleStandardArgs )
# handle the QUIETLY and REQUIRED arguments and set SimpleLogger_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args (SimpleLogger DEFAULT_MSG SimpleLogger_LIBRARIES_DIR)

