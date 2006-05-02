
FIND_PATH(ACE_INCLUDE_DIR ACE.h /usr/include/ace /usr/local/include/ace $ENV{ACE_ROOT}/ace $ENV{ACE_ROOT})

FIND_LIBRARY(ACE_LIBRARY NAMES ACE PATH /usr/lib /usr/local/lib $ENV{ACE_ROOT}/lib $ENV{ACE_ROOT})

IF (ACE_INCLUDE_DIR AND ACE_LIBRARY)
	SET(ACE_FOUND TRUE)
ELSE (ACE_INCLUDE_DIR AND ACE_LIBRARY)
	SET(ACE_FOUND FALSE)
ENDIF (ACE_INCLUDE_DIR AND ACE_LIBRARY)

IF (Ace_FOUND)
	IF (NOT Ace_FIND_QUIETLY)
		MESSAGE(STATUS "Found ACE library: ${ACE_LIBRARY}")
		MESSAGE(STATUS "Found ACE include: ${ACE_INCLUDE_DIR}")
	ENDIF (NOT Ace_FIND_QUIETLY)
ELSE (Ace_FOUND)
	IF (Ace_FIND_REQUIRED)
		MESSAGE(FATAL_ERROR "Could not find ACE")
	ENDIF (Ace_FIND_REQUIRED)
ENDIF (Ace_FOUND)