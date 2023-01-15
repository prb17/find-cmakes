# - File to specify how to find the JsconCpp library
#
# CONFIUGRING FindJsonCpp.cmake
# Define JsonCpp_ROOT to your local jsoncpp build directory
#   If cmake cannot find jsoncpp, this file defines the rules to find jsoncpp and set JsonCpp_ROOT
# Specify a JsonCpp_FIND_VERSION by
#   find_package(JsonCpp VERSION 1.9.5)
# Sepcify the JsonCpp_FIND_COMPONENTS by:
#   find_package(JsonCpp COMPONENTS jsoncpp_lib)
#   NOTE: jsoncpp is the only library available with this package
# Specify both by:
#   find_package(JsonCpp VERSION 1.9.5 COMPONENTS jsconcpp_lib)
#
# 
# Once done this will define
# JsonCpp_FOUND - System has the requested version of JsconCpp
# JsonCpp_INCLUDE_DIRS - The JsconCpp include directories
# JsonCpp_LIBRARIES - The libraries needed to use JsconCpp
# JsonCpp_LIBRARIES_DIR - The directory which holds JsonCpp_LIBRARIES
# JsonCpp_EXTERNAL_LIB_NAME - The name of the jsoncpp target (needed if running parrallel make build)

#####Finds json include dir and lib files########
function(FindJsonCpp ROOT_DIR)
    message(STATUS "Attempting to find jsoncpp at root: ${ROOT_DIR}")
    
    find_path ( JsonCpp_INCLUDE_DIR NAMES "json/json.h"
                                HINTS "${ROOT_DIR}/include/")
    set(JsonCpp_INCLUDE_DIR ${JsonCpp_INCLUDE_DIR} PARENT_SCOPE)
    message(DEBUG "JsonCpp_INCLUDE_DIR: ${JsonCpp_INCLUDE_DIR}")

    # todo: Do a for loop to find all components in JsonCpp_FIND_COMPONENTS
    find_library ( JsonCpp_LIBRARY  NAMES jsoncpp
                                HINTS "${ROOT_DIR}/lib/")
    set(JsonCpp_LIBRARY ${JsonCpp_LIBRARY} PARENT_SCOPE)
    message(DEBUG "JsonCpp_LIBRARY: ${JsonCpp_LIBRARY}")   
    
    if(JsonCpp_LIBRARY)
        get_filename_component(JsonCpp_LIBRARY_DIR "${JsonCpp_LIBRARY}../.." ABSOLUTE)
    else(JsonCpp_LIBRARY)
        set(JsonCpp_LIBRARY_DIR ${ROOT_DIR}/lib)
    endif(JsonCpp_LIBRARY) 
    set(JsonCpp_LIBRARY_DIR ${JsonCpp_LIBRARY_DIR} PARENT_SCOPE)
    message(DEBUG "JsonCpp_LIBRARY_DIR: ${JsonCpp_LIBRARY_DIR}")      
    
    if(JsonCpp_INCLUDE_DIR AND (JsonCpp_LIBRARY OR JsonCpp_LIBRARY_DIR) ) 
        set(JsonCpp_INCLUDE_DIRS ${JsonCpp_INCLUDE_DIR})
        set(JsonCpp_INCLUDE_DIRS ${JsonCpp_INCLUDE_DIR} PARENT_SCOPE)
        message(DEBUG "JsonCpp_INCLUDE_DIRS: ${JsonCpp_INCLUDE_DIRS}")   
        set(JsonCpp_LIBRARIES ${JsonCpp_FIND_COMPONENTS})
        set(JsonCpp_LIBRARIES ${JsonCpp_FIND_COMPONENTS} PARENT_SCOPE)  
        message(DEBUG "JsonCpp_LIBRARIES: ${JsonCpp_LIBRARIES}")         
        set(JsonCpp_LIBRARIES_DIR ${JsonCpp_LIBRARY_DIR})       
        set(JsonCpp_LIBRARIES_DIR ${JsonCpp_LIBRARY_DIR} PARENT_SCOPE)
        message(DEBUG "JsonCpp_LIBRARIES_DIR: ${JsonCpp_LIBRARIES_DIR}")         
        set(JsonCpp_EXTERNAL_LIB_NAME ${JsonCpp_FIND_COMPONENTS}) # TODO: how to get this target name from FetchContent? If even possible?
        set(JsonCpp_EXTERNAL_LIB_NAME ${JsonCpp_EXTERNAL_LIB_NAME} PARENT_SCOPE)
        message(DEBUG "JsonCpp_EXTERNAL_LIB_NAME: ${JsonCpp_EXTERNAL_LIB_NAME}")      
   
        message(DEBUG "Setting JsonCpp_ROOT as: '${ROOT_DIR}'")
        set(JsonCpp_ROOT CACHE INTERNAL "Hardcoded root for 'jsoncpp'" "${ROOT_DIR}")
        set(JsonCpp_ROOT ${JsonCpp_ROOT} PARENT_SCOPE)
    endif(JsonCpp_INCLUDE_DIR AND (JsonCpp_LIBRARY OR JsonCpp_LIBRARY_DIR) )
endfunction(FindJsonCpp ROOT_DIR)

########Main############
message(DEBUG "##############################FindJsonCpp.cmake#########################")

# Determine which version of jsoncpp to find
set(JsonCpp_DEFAULT_FIND_VERSION "master")
if(NOT JsonCpp_FIND_VERSION)
    message(DEBUG "JsonCpp_FIND_VERSION NOT SPECIFIED (using default)")
    set(JsonCpp_FIND_VERSION ${JsonCpp_DEFAULT_FIND_VERSION})
else(NOT JsonCpp_FIND_VERSION)
    message(DEBUG "JsonCpp_FIND_VERSION SPECIFIED")
endif(NOT JsonCpp_FIND_VERSION)
message(STATUS "Finding JsonCpp Version: '${JsonCpp_FIND_VERSION}'")

# Determine which which components to find
set(JsonCpp_DEFUALT_FIND_COMPONENTS jsoncpp_lib)
if(NOT JsonCpp_FIND_COMPONENTS)
    message(DEBUG "JsonCpp_FIND_COMPONENTS NOT SPECIFIED (using default)")
    set(JsonCpp_FIND_COMPONENTS ${JsonCpp_DEFUALT_FIND_COMPONENTS})
else(NOT JsonCpp_FIND_COMPONENTS)
    message(DEBUG "JsonCpp_FIND_COMPONENTS SPECIFIED")
endif(NOT JsonCpp_FIND_COMPONENTS)
message(STATUS "Finding JsonCpp_FIND_COMPONENTS: (${JsonCpp_FIND_COMPONENTS})")

# Attempt to find jsoncpp package
if(JsonCpp_ROOT)
    FindJsonCpp("${JsonCpp_ROOT}")
endif()

# Check found jsoncpp found project (if found)
message(STATUS "Checking the found jsoncpp files")
if( JsonCpp_INCLUDE_DIR AND JsonCpp_LIBRARY )
    message(STATUS "Found JsonCpp locally")
else( JsonCpp_INCLUDE_DIR AND JsonCpp_LIBRARY )
    message(STATUS "JsonCpp was not found locally, attempting to fetch it online")
    unset(JsonCpp_INCLUDE_DIR)
    unset(JsonCpp_LIBRARY)
    unset(JsonCpp_LIBRARY_DIR)

    # Declare where to find and version of jsoncpp to find
    FetchContent_Declare(jsoncpp        
                GIT_REPOSITORY "https://github.com/open-source-parsers/jsoncpp.git"
                GIT_TAG "${JsonCpp_FIND_VERSION}"
            )

    # Generate jsoncpp properties
    FetchContent_GetProperties(jsoncpp)
    if(NOT jsoncpp_POPULATED)
        #populate jsoncpp properties
        FetchContent_Populate(jsoncpp)

        #################-custom stuff-###########################
        #Specific options used to configure jsoncpp
        set(JSONCPP_WITH_TESTS OFF)
        set(JSONCPP_WITH_POST_BUILD_UNITTEST OFF)
        set(JSONCPP_WITH_WARNING_AS_ERROR OFF)
        set(JSONCPP_WITH_STRICT_ISO ON)
        set(JSONCPP_WITH_PKGCONFIG_SUPPORT OFF)
        set(JSONCPP_WITH_CMAKE_PACKAGE OFF)
        set(JSONCPP_WITH_EXAMPLE OFF)
        set(JSONCPP_STATIC_WINDOWS_RUNTIME OFF)
        set(BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS})
        set(BUILD_STATIC_LIBS ${BUILD_STATIC_LIBS})
        set(BUILD_OBJECT_LIBS ${BUILD_OBJECT_LIBS})

        #specify where jsoncpp will be built
        # set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${UTILS_DEPS_BUILD_DIR}/jsoncpp/lib" CACHE PATH "Archive output dir." FORCE)
        # set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${UTILS_DEPS_BUILD_DIR}/jsoncpp/lib" CACHE PATH "Library output dir." FORCE)
        # set(CMAKE_PDB_OUTPUT_DIRECTORY     "${UTILS_DEPS_BUILD_DIR}/jsoncpp/bin" CACHE PATH "PDB (MSVC debug symbol)output dir." FORCE)
        # set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${UTILS_DEPS_BUILD_DIR}/jsoncpp/bin" CACHE PATH "Executable/dll output dir." FORCE)
        set(CMAKE_INSTALL_LIBDIR "${UTILS_DEPS_INSTALL_DIR}/jsoncpp/lib/")
        set(CMAKE_INSTALL_INCLUDEDIR "${UTILS_DEPS_INSTALL_DIR}/jsoncpp/include/")
        #################-end custom stuff-###########################

        #add jsoncpp project to my project
        add_subdirectory(${jsoncpp_SOURCE_DIR} ${jsoncpp_BINARY_DIR})

        #set values back to the original
        # set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib" CACHE PATH "Archive output dir." FORCE)
        # set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib" CACHE PATH "Library output dir." FORCE)
        # set(CMAKE_PDB_OUTPUT_DIRECTORY     "${CMAKE_BINARY_DIR}/bin" CACHE PATH "PDB (MSVC debug symbol)output dir." FORCE)
        # set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin" CACHE PATH "Executable/dll output dir." FORCE)
        unset(CMAKE_INSTALL_LIBDIR)
        unset(CMAKE_INSTALL_INCLUDEDIR)
    endif(NOT jsoncpp_POPULATED)
    # FetchContent_MakeAvailable(jsoncpp)

    set(JsonCpp_ROOT_DIR ${UTILS_DEPS_BUILD_DIR}/jsoncpp)
    file(COPY "${jsoncpp_SOURCE_DIR}/include/" DESTINATION "${JsonCpp_ROOT_DIR}/include")
    FindJsonCpp("${JsonCpp_ROOT_DIR}")   
endif( JsonCpp_INCLUDE_DIR AND JsonCpp_LIBRARY)


include ( FindPackageHandleStandardArgs )
# handle the QUIETLY and REQUIRED arguments and set JsonCpp_FOUND to TRUE
# if all listed variables are TRUE
if( JsonCpp_LIBRARY )  
    find_package_handle_standard_args ( JsonCpp DEFAULT_MSG JsonCpp_LIBRARY JsonCpp_INCLUDE_DIR JsonCpp_LIBRARY_DIR)
else( JsonCpp_LIBRARY )    
    find_package_handle_standard_args ( JsonCpp DEFAULT_MSG JsonCpp_INCLUDE_DIR JsonCpp_LIBRARY_DIR)
endif( JsonCpp_LIBRARY )
message(DEBUG "##############################FindJsonCpp.cmake#########################")
