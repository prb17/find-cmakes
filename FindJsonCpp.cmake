# - Try to find JsconCpp
# define JsonCpp_ROOT to your local jsoncpp build directory
# Once done this will define
# JsonCpp_FOUND - System has JsconCpp
# JsonCpp_INCLUDE_DIRS - The JsconCpp include directories
# JsonCpp_LIBRARIES - The libraries needed to use JsconCpp
# or
# JsonCpp_LIBRARIES_DIR if no local installation provided


find_path ( JsonCpp_INCLUDE_DIR NAMES "json/json.h"
                            HINTS "${JsonCpp_ROOT}/include/jsoncpp" )

find_library ( JsonCpp_LIBRARY  NAMES "jsoncpp"
                            HINTS "${JsonCpp_ROOT}/lib/")


if( JsonCpp_INCLUDE_DIR AND JsonCpp_LIBRARY )
    message(STATUS "found JsonCpp locally")
    message(VERBOSE "JsonCpp include dir: ${JsonCpp_INCLUDE_DIR}")
    message(VERBOSE "JsonCpp lib: ${JsonCpp_LIBRARY} ")
    set ( JsonCpp_LIBRARIES ${JsonCpp_LIBRARY} )
    set ( JsonCpp_INCLUDE_DIRS ${JsonCpp_INCLUDE_DIR} )
else( JsonCpp_INCLUDE_DIR AND JsonCpp_LIBRARY )
    message(STATUS "JsonCpp was not found locally, attempting to fetch it online")
    FetchContent_Declare(jsoncpp        
		        GIT_REPOSITORY "https://github.com/open-source-parsers/jsoncpp.git"
        	    GIT_TAG "master"
        	)
	FetchContent_MakeAvailable(jsoncpp)
        
    set(JsonCpp_ROOT "${jsoncpp_SOURCE_DIR}")
    message(MESSAGE "downloaded JsonCpp src dir: ${JsonCpp_ROOT}")

    find_path ( JsonCpp_INCLUDE_DIR NAMES "json/json.h"
                        HINTS "${JsonCpp_ROOT}/include" )

    set ( JsonCpp_INCLUDE_DIRS ${JsonCpp_INCLUDE_DIR} )
    set ( JsonCpp_LIBRARIES_DIR "${jsoncpp_BINARY_DIR}/lib" )
    file( GLOB JsonCpp_LIBRARIES "${JsonCpp_LIBRARIES_DIR}/*")
endif( JsonCpp_INCLUDE_DIR AND JsonCpp_LIBRARY)


include ( FindPackageHandleStandardArgs )
# handle the QUIETLY and REQUIRED arguments and set JsonCpp_FOUND to TRUE
# if all listed variables are TRUE
if( JsonCpp_LIBRARY )
    find_package_handle_standard_args ( JsonCpp DEFAULT_MSG JsonCpp_LIBRARY JsonCpp_INCLUDE_DIR )
else( JsonCpp_LIBRARY )
    find_package_handle_standard_args ( JsonCpp DEFAULT_MSG JsonCpp_LIBRARIES_DIR JsonCpp_INCLUDE_DIR )
endif( JsonCpp_LIBRARY )