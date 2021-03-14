# - Try to find Utils
# Once done this will define
# Utils_FOUND - System has Utils
# Utils_INCLUDE_DIRS - The Utils include directories

find_path (utils_PLATFORM_INCLUDE_DIR NAMES "platform.h"
                            HINTS "${myUtils_DIR}/platforms/" )

find_path (utils_STOPWATCH_INCLUDE_DIR NAMES "Stopwatch.h"
                            HINTS "${myUtils_DIR}/stopwatch/" )

list (APPEND Utils_DIRS ${utils_PLATFORM_INCLUDE_DIR} 
                        ${utils_STOPWATCH_INCLUDE_DIR})

message(STATUS "Utils platform include dir: ${utils_PLATFORM_INCLUDE_DIR}")
message(STATUS "Utils stopwatch include dir: ${utils_STOPWATCH_INCLUDE_DIR}")

if(Utils_DIRS)
    message(STATUS "found Utils locally")
    message(STATUS "utils dirs: ${Utils_DIRS}")
    set(Utils_INCLUDE_DIRS ${Utils_DIRS})
else(Utils_IDIRS)
    message(STATUS "Utils was not found locally, attempting to fetch it online")
    FetchContent_Declare(utils        
        GIT_REPOSITORY "git@github.com:prb17/Utils.git"
        GIT_TAG "main"
        )

    FetchContent_MakeAvailable(utils)
    FetchContent_GetProperties(utils)
    if(NOT utils_POPULATED)
        FetchContent_Populate(utils)
    endif()
    
    set(myUtils_DIR "${utils_SOURCE_DIR}")
    message(STATUS "other test message")
    message(STATUS "downloaded utils src dir: ${myUtils_DIR}")

    find_path (utils_PLATFORM_INCLUDE_DIR NAMES "platform.h"
                        HINTS "${myUtils_DIR}/platforms" )

    find_path (utils_STOPWATCH_INCLUDE_DIR NAMES "Stopwatch.h"
                        HINTS "${myUtils_DIR}/stopwatch" )

    list (APPEND Utils_INCLUDE_DIRS ${utils_PLATFORM_INCLUDE_DIR} 
                                    ${utils_STOPWATCH_INCLUDE_DIR})

    message(STATUS "utils include dirs: ${Utils_INCLUDE_DIRS}")
endif(Utils_DIRS)


include ( FindPackageHandleStandardArgs )
# handle the QUIETLY and REQUIRED arguments and set Utils_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args (Utils DEFAULT_MSG Utils_INCLUDE_DIRS)
