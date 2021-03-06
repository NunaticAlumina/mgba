if(NOT PROJECT_NAME)
	set(PROJECT_NAME "mGBA")
endif()
set(LIB_VERSION_MAJOR 0)
set(LIB_VERSION_MINOR 5)
set(LIB_VERSION_PATCH 1)
set(LIB_VERSION_ABI 0.5)
set(LIB_VERSION_STRING ${LIB_VERSION_MAJOR}.${LIB_VERSION_MINOR}.${LIB_VERSION_PATCH})
set(SUMMARY "${PROJECT_NAME} Game Boy Advance Emulator")

execute_process(COMMAND git describe --always --abbrev=40 --dirty OUTPUT_VARIABLE GIT_COMMIT ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND git describe --always --dirty OUTPUT_VARIABLE GIT_COMMIT_SHORT ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND git symbolic-ref --short HEAD OUTPUT_VARIABLE GIT_BRANCH ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND git rev-list HEAD --count OUTPUT_VARIABLE GIT_REV ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND git describe --tag --exact-match OUTPUT_VARIABLE GIT_TAG ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)

if(GIT_REV STREQUAL "")
	set(GIT_REV -1)
endif()
if(NOT GIT_TAG STREQUAL "")
	set(VERSION_STRING ${GIT_TAG})
elseif(GIT_BRANCH STREQUAL "")
	set(VERSION_STRING ${LIB_VERSION_STRING})
else()
	if(GIT_BRANCH STREQUAL "master")
		set(VERSION_STRING ${GIT_REV}-${GIT_COMMIT_SHORT})
	else()
		set(VERSION_STRING ${GIT_BRANCH}-${GIT_REV}-${GIT_COMMIT_SHORT})
	endif()

	if(NOT LIB_VERSION_ABI STREQUAL GIT_BRANCH)
		set(VERSION_STRING ${LIB_VERSION_ABI}-${VERSION_STRING})
	endif()
endif()

if(NOT GIT_COMMIT)
	set(GIT_COMMIT "(unknown)")
endif()
if(NOT GIT_COMMIT_SHORT)
	set(GIT_COMMIT_SHORT "(unknown)")
endif()
if(NOT GIT_BRANCH)
	set(GIT_BRANCH "(unknown)")
endif()

if(NOT VERSION_STRING_CACHE OR NOT VERSION_STRING STREQUAL VERSION_STRING_CACHE)
	set(VERSION_STRING_CACHE ${VERSION_STRING} CACHE STRING "" FORCE)

	if(CONFIG_FILE AND OUT_FILE)
		configure_file("${CONFIG_FILE}" "${OUT_FILE}")
	endif()
endif()
