# - Try to find Utils
# Once done this will define
# Utils_FOUND - System has Utils
# Utils_INCLUDE_DIRS - The Utils include directories

message(STATUS "second level Utils path arg: ${myUtils_DIR}")
find_path (Utils_PLATFORM_INCLUDE_DIR NAMES "platform.h"
                            HINTS "${myUtils_DIR}/platforms/" )

find_path (Utils_STOPWATCH_INCLUDE_DIR NAMES "Stopwatch.h"
                            HINTS "${myUtils_DIR}/stopwatch/" )                    

message(STATUS "Utils platform include dir: ${Utils_PLATFORM_INCLUDE_DIR}")
message(STATUS "Utils stopwatch include dir: ${Utils_STOPWATCH_INCLUDE_DIR}")

if(Utils_PLATFORM_INCLUDE_DIR)
    message(STATUS "found Utils locally")
    list (APPEND Utils_INCLUDE_DIRS ${Utils_PLATFORM_INCLUDE_DIR} 
                                    ${Utils_STOPWATCH_INCLUDE_DIR})
else()
    message(STATUS "Utils was not found locally, attempting to fetch it online")
    # ExternalProject_Add(Utils        
    #     GIT_REPOSITORY "https://github.com/zeromq/libUtils"
    #     GIT_TAG "master"
    #     DOWNLOAD_DIR "${CMAKE_SOURCE_DIR}/download/Utils/"
    #     SOURCE_DIR "${EXTERNAL_INSTALL_LOCATION}/Utils"
    #     #INSTALL_DIR ""  
    #     BUILD_COMMAND "make"      
    #     CMAKE_ARGS -DCMAKE_INSTALL_PREFIX="${EXTERNAL_INSTALL_LOCATION}/Utils"
    #     #INSTALL_COMMAND "make install" #--build --target install
    #     ENABLED_DEFAULT ON
    #     )
        
        # set(Utils_DIR "${EXTERNAL_INSTALL_LOCATION}/Utils")

        # find_path ( Utils_INCLUDE_DIR NAMES "Utils.h"
        #                     HINTS "${Utils_DIR}/include/" )

        # set ( Utils_INCLUDE_DIRS ${Utils_INCLUDE_DIR} )
endif(Utils_PLATFORM_INCLUDE_DIR)


include ( FindPackageHandleStandardArgs )
# handle the QUIETLY and REQUIRED arguments and set Utils_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args ( Utils DEFAULT_MSG Utils_PLATFORM_INCLUDE_DIR 
                                                        Utils_STOPWATCH_INCLUDE_DIR)
