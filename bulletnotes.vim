" This file just loads the bulletnotes file in the autoload directory when necessary

if exists('$BN_PROJ') && $BN_PROJ == '1'
  call bulletnotes#InitProject()
endif
