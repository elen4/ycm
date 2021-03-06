# find_or_build_package(<package>)

include(CMakeParseArguments)
include(CMakeDependentOption)
include(MacroExtractVersion)

function(FIND_OR_BUILD_PACKAGE _pkg)
    string(TOUPPER "${_pkg}" _PKG)
    string(REGEX REPLACE "[^A-Z0-9]" "_" _PKG "${_PKG}")

# Check arguments
    set(_options REQUIRED QUIET)
    set(_oneValueArgs )
    set(_multiValueArgs )

    cmake_parse_arguments(_${_PGK} "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})

# Arguments for the find_package command
# REQUIRED and QUIET will be set when necessary
    set(_findArgs ${_${_PGK}_UNPARSED_ARGUMENTS})

# Preliminary find_package to enable/disable USE_SYSTEM_${_PKG} option
    find_package(${_pkg} ${_findArgs} QUIET)
    if(${_pkg}_FOUND OR ${_PKG}_FOUND)
        set(HAVE_SYSTEM_${PKG} 1)
    endif()
    cmake_dependent_option(USE_SYSTEM_${_PKG} "Use system installed ${_pkg}" ON "HAVE_SYSTEM_${_PKG}" OFF)
    mark_as_advanced(USE_SYSTEM_${_PKG})


    if(USE_SYSTEM_${_PKG})
        # The system version was found and should be used
        set(HAVE_${_PKG} 1)
    elseif(CMAKE_DISABLE_BUILD_PACKAGE_${_PKG})
        # Building the package was explicitly disabled
        set(HAVE_${_PKG} 0)
    else()
        # The system version was not found or the user chose not to use it,
        # building the package was not disabled, therefore we need to build it.

        # Save variables to restore them at the end
        foreach(_var REQUIRED
                     QUIETLY
                     VERSION
                     VERSION_MAJOR
                     VERSION_MINOR
                     VERSION_PATCH
                     VERSION_TWEAK
                     VERSION_COUNT)
            unset(_${_PGK}_BUILD_${_var})
            if(DEFINED ${_PGK}_BUILD_${_var})
                set(_${_PGK}_BUILD_${_var} ${_PGK}_BUILD_${_var})
                unset(${_PGK}_BUILD_${_var})
            endif()
        endforeach()

        set(${_PGK}_BUILD_REQUIRED ${_${_PGK}_REQUIRED})
        set(${_PGK}_BUILD_QUIETLY ${_${_PGK}_QUIET})
        if(DEFINED ${_${_PGK}_VERSION})
            set(${_PKG}_BUILD_VERSION ${_${_PGK}_VERSION})
            macro_extract_version(${_PGK}_BUILD REVERSE_NAME)
        endif()

        # Include the Build recipe
        include(Build${_pkg} OPTIONAL RESULT_VARIABLE _${_PKG}_RECIPE)
        if(NOT _${_PKG}_RECIPE)
            # We couldn't find the build recipe
            set(HAVE_${_PKG} 0)
        else()
            if(NOT TARGET ${_pkg})
                # Weird. We found the recipe, but this doesn't add a TARGET ${_pkg}
                # Should not happen, let's print an AUTHOR_WARNING
                message(AUTHOR_WARNING "The file ${_${_PKG}_RECIPE} does not define a ${_pkg} target. Assuming that the target has a different name.")
            endif()
            set(HAVE_${_PKG} 1)
        endif()

        # Restore original value for the variables
        foreach(_var REQUIRED
                     QUIETLY
                     VERSION
                     VERSION_MAJOR
                     VERSION_MINOR
                     VERSION_PATCH
                     VERSION_TWEAK
                     VERSION_COUNT)
            if(DEFINED _${_PGK}_BUILD_${_var})
                set(${_PGK}_BUILD_${_var} _${_PGK}_BUILD_${_var})
            else()
                unset(${_PGK}_BUILD_${_var})
            endif()
            unset(_${_PGK}_BUILD_${_var})
        endforeach()
    endif()

    # Display errors/messages
    if(NOT HAVE_${_PKG})
        if(${_${_PGK}_REQUIRED})
            message(SEND_ERROR "Cannot find or build package ${_pkg}")
            set(_runFind 1)
        elseif(NOT ${_${_PGK}_QUIET})
            message(STATUS "Cannot find or build package ${_pkg}")
            set(_runFind 1)
        endif()
    elseif(NOT ${_${_PGK}_QUIET})
        if(USE_SYSTEM_${_PKG})
            set(_runFind 1)
        else()
            message(STATUS "Package ${_pkg} not found. Will be downloaded and built.")
        endif()
    else()
    endif()

    if(_runFind)
        # Rerun find_package with all the arguments to display output
        find_package(${_pkg} ${ARGN})
    endif()

    set(HAVE_SYSTEM_${_PKG} ${HAVE_SYSTEM_${_PKG}} PARENT_SCOPE)
    set(HAVE_${_PKG} ${HAVE_${_PKG}} PARENT_SCOPE)
endfunction()
