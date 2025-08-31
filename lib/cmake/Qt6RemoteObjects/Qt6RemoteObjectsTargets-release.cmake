#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "Qt6::RemoteObjects" for configuration "Release"
set_property(TARGET Qt6::RemoteObjects APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(Qt6::RemoteObjects PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libQt6RemoteObjects.so.6.5.2"
  IMPORTED_SONAME_RELEASE "libQt6RemoteObjects.so.6"
  )

list(APPEND _cmake_import_check_targets Qt6::RemoteObjects )
list(APPEND _cmake_import_check_files_for_Qt6::RemoteObjects "${_IMPORT_PREFIX}/lib/libQt6RemoteObjects.so.6.5.2" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
