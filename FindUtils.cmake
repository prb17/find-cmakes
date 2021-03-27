# - Try to find Utils
# define Utils_ROOT to your local Utils build directory
# Once done this will define
# Utils_FOUND - System has Utils
# Utils_INCLUDE_DIRS - The Utils include directories

find_path (Utils_DIR NAMES "utils.h"
                            HINTS "${Utils_ROOT}" )

message(STATUS "Utils include dir: ${Utils_DIR}")

if(Utils_DIR)
    message(STATUS "found Utils locally")
    message(VERBOSE "Utils dirs: ${utils_ROOT}")
    set(Utils_INCLUDE_DIRS ${Utils_DIRS})
else(Utils_DIR)
    message(STATUS "Utils was not found locally, attempting to fetch it online")
    FetchContent_Declare(
        utils        
        GIT_REPOSITORY "git@github.com:prb17/Utils.git"
        GIT_TAG "main"
        )
    FetchContent_MakeAvailable(utils)
    
    set(Utils_ROOT "${utils_SOURCE_DIR}")
    message(STATUS "downloaded utils src dir: ${Utils_ROOT}")

    find_path (Utils_INCLUDE_DIRS NAMES "utils.h"
                        HINTS "${Utils_ROOT}" )

    message(STATUS "utils include dirs: ${Utils_INCLUDE_DIRS}")
endif(Utils_DIR)


include ( FindPackageHandleStandardArgs )
# handle the QUIETLY and REQUIRED arguments and set Utils_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args (Utils DEFAULT_MSG Utils_INCLUDE_DIRS)
