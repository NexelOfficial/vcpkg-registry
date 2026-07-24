set(VCPKG_BUILD_TYPE release)

if(NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
  message(FATAL_ERROR "dmn currently supports only the x64 architecture")
endif()

if(VCPKG_TARGET_IS_WINDOWS)
  set(DMN_PLATFORM "Windows-AMD64")
  set(DMN_EXTENSION "zip")
  set(DMN_SHA512 "A981CF68FDB6045F89D9F9AAACB6D1EEADFE792A0B5BA7BCA8C0F7C7D13246BE5949BE13E0A45443E784E53640BD187813E16D699515E71FED3493B578215ED2")
elseif(VCPKG_TARGET_IS_LINUX)
  set(DMN_PLATFORM "Linux-x86_64")
  set(DMN_EXTENSION "tar.gz")
  set(DMN_SHA512 "0CF3B76310233128C577957E253CE95669B1227617D5B79A1292F6CEB9A4C2C97630ACF4CA5D1D97AA87D290D411848FE4AD0F0CA567DC5146A3BCF5C38E26C8")
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