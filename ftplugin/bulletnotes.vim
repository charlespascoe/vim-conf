let b:sleuth_automatic=0

call QuickSearchMap('s', 'Sections', '^:: .\+ ::$')

setlocal spell

call bulletnotes#InitBuffer()
