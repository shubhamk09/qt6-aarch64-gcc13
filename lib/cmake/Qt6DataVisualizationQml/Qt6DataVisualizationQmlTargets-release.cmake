#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "Qt6::DataVisualizationQml" for configuration "Release"
set_property(TARGET Qt6::DataVisualizationQml APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(Qt6::DataVisualizationQml PROPERTIES
  IMPORTED_LINK_DEPENDENT_LIBRARIES_RELEASE "Qt6::Core;Qt6::Gui;Qt6::OpenGL;Qt6::Qml;Qt6::Quick"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libQt6DataVisualizationQml.so.6.5.2"
  IMPORTED_SONAME_RELEASE "libQt6DataVisualizationQml.so.6"
  )

list(APPEND _cmake_import_check_targets Qt6::DataVisualizationQml )
list(APPEND _cmake_import_check_files_for_Qt6::DataVisualizationQml "${_IMPORT_PREFIX}/lib/libQt6DataVisualizationQml.so.6.5.2" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
