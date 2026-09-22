set(VCPKG_BUILD_TYPE release)

if(NOT VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
  message(FATAL_ERROR "dmn currently supports only the x64 architecture")
endif()

if(VCPKG_TARGET_IS_WINDOWS)
  set(DMN_PLATFORM "Windows-AMD64")
  set(DMN_EXTENSION "zip")
  set(DMN_SHA512 "a40481d700f36830965bef1a201d86bdefbe9ab3aac1a11952f8dded9e26f989320ea3fcdcd691872bbc2e50cdb571c7f69e23f1a783598e7070d58e19edfd76")
elseif(VCPKG_TARGET_IS_LINUX)
  set(DMN_PLATFORM "Linux-x86_64")
  set(DMN_EXTENSION "tar.gz")
  set(DMN_SHA512 "48080856e021cfab2220a99a157ddbb1e74a62be07125ab2b37ac11fcfac532d8c921353f5450d0806ce2f001514b8cb3f416c2b5fceb56a3e422b31c0d0a945")
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