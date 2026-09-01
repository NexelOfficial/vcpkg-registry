set(VCPKG_BUILD_TYPE release)

if(NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
  message(FATAL_ERROR "dmn currently supports only the x64 architecture")
endif()

if(VCPKG_TARGET_IS_WINDOWS)
  set(DMN_PLATFORM "Windows-AMD64")
  set(DMN_EXTENSION "zip")
  set(DMN_SHA512 "54cb2258c434382e927d17af4c62cf0ae58a4d7461a4eae8f8fa1ea267beec935cc41a335b3eb6c8ec56dd5b476b91dfa5794b745024413399fe1734d63d595f")
elseif(VCPKG_TARGET_IS_LINUX)
  set(DMN_PLATFORM "Linux-x86_64")
  set(DMN_EXTENSION "tar.gz")
  set(DMN_SHA512 "cf0e14a41963d21b1f7c47c4752f7df7c8c12ec4af2737e8f435acb3f875aac636ab211112c181baf7162b201f7d145696751caa46a92494624352deba42362e")
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