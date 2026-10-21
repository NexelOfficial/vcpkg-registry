set(VCPKG_BUILD_TYPE release)

if(NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
  message(FATAL_ERROR "dmn currently supports only the x64 architecture")
endif()

if(VCPKG_TARGET_IS_WINDOWS)
  set(DMN_PLATFORM "Windows-AMD64")
  set(DMN_EXTENSION "zip")
  set(DMN_SHA512 "918691730fe139b0c22b9152eed3cb4c7f1f6b3f39424597d33323f02dc75dbcd15c89d26f09d5bdb107d28e120acfda2b6a04a41208e3f0a077c9a0685be77b")
elseif(VCPKG_TARGET_IS_LINUX)
  set(DMN_PLATFORM "Linux-x86_64")
  set(DMN_EXTENSION "tar.gz")
  set(DMN_SHA512 "8d529ee1622c0e785b0d24b45fe2a3f7082360a55d19635af4e30b71701c73caeff38346222a54165d6ed34dd6819681f2a606367891fe035d4a8d9c703883ae")
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