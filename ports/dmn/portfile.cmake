set(VCPKG_BUILD_TYPE release)

if(NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
  message(FATAL_ERROR "dmn currently supports only the x64 architecture")
endif()

if(VCPKG_TARGET_IS_WINDOWS)
  set(DMN_PLATFORM "Windows-AMD64")
  set(DMN_EXTENSION "zip")
  set(DMN_SHA512 "0ab61f51225367502556e0cba2912805fbac13da5d25a40002cee9308fbf62aa55edfc06358345839739ce5b2c64fe04e2fd048fded0332d82311ff8c1fe2027")
elseif(VCPKG_TARGET_IS_LINUX)
  set(DMN_PLATFORM "Linux-x86_64")
  set(DMN_EXTENSION "tar.gz")
  set(DMN_SHA512 "6f8f4c128be7126ac860283a807a6ea00ecc123ec530b4e0ba3d642cddaf6676fbe9058a418f781b269ea0bb103a60a0ddd27d71314817b339279467c09e061d")
else()
  message(FATAL_ERROR "dmn currently supports only Windows and Linux")
endif()

set(DMN_ARCHIVE_NAME "dmn-${VERSION}-${DMN_PLATFORM}.${DMN_EXTENSION}")

vcpkg_download_distfile(
  DMN_ARCHIVE
  URLS
    "https://github.com/NexelOfficial/dmn-cpp/releases/download/v${VERSION}/${DMN_ARCHIVE_NAME}"
  FILENAME
    "${DMN_ARCHIVE_NAME}"
  SHA512
    "${DMN_SHA512}"
)

vcpkg_extract_source_archive(
  DMN_PACKAGE_ROOT
  ARCHIVE
    "${DMN_ARCHIVE}"
)

if(NOT EXISTS
  "${DMN_PACKAGE_ROOT}/lib/cmake/dmn/dmnConfig.cmake")
  message(FATAL_ERROR
    "The DMN release archive does not contain "
    "lib/cmake/dmn/dmnConfig.cmake"
  )
endif()

if(EXISTS "${DMN_PACKAGE_ROOT}/include")
  file(
    INSTALL
    "${DMN_PACKAGE_ROOT}/include/"
    DESTINATION
    "${CURRENT_PACKAGES_DIR}/include"
  )
endif()

if(EXISTS "${DMN_PACKAGE_ROOT}/bin")
  file(
    INSTALL
    "${DMN_PACKAGE_ROOT}/bin/"
    DESTINATION
    "${CURRENT_PACKAGES_DIR}/bin"
  )
endif()

file(
  INSTALL
  "${DMN_PACKAGE_ROOT}/lib/"
  DESTINATION
  "${CURRENT_PACKAGES_DIR}/lib"
)

vcpkg_cmake_config_fixup(
  PACKAGE_NAME dmn
  CONFIG_PATH lib/cmake/dmn
)

file(
  INSTALL
  "${CMAKE_CURRENT_LIST_DIR}/usage"
  DESTINATION
  "${CURRENT_PACKAGES_DIR}/share/${PORT}"
)

file(
  INSTALL
  "${CMAKE_CURRENT_LIST_DIR}/copyright"
  DESTINATION
  "${CURRENT_PACKAGES_DIR}/share/${PORT}"
)

set(VCPKG_POLICY_MISMATCHED_NUMBER_OF_BINARIES enabled)

if(VCPKG_TARGET_IS_WINDOWS)
  set(VCPKG_POLICY_ONLY_RELEASE_CRT enabled)
endif()