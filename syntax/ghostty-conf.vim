syntax clear

" Required for ghosttyConfProp keyword matching
setlocal iskeyword+=-

syntax match   ghosttyComment   /^#.*/

syntax match   ghosttyPropStart /^\ze\w/ nextgroup=ghosttyConfProp

syntax match   ghosttyColour    /#[a-fA-F0-9]\{6\}/
syntax keyword ghosttyBool      true false
syntax match   ghosttyNumber    /\d\+\(\.\d+\)\?/
syntax match   ghosttyAssign    / =/ contained

syntax keyword ghosttyConfProp contained abnormal-command-exit-runtime
  \ adjust-box-thickness adjust-cell-height adjust-cell-width adjust-cursor-height
  \ adjust-cursor-thickness adjust-font-baseline adjust-icon-height
  \ adjust-overline-position adjust-overline-thickness adjust-strikethrough-position
  \ adjust-strikethrough-thickness adjust-underline-position
  \ adjust-underline-thickness alpha-blending app-notifications async-backend
  \ auto-update auto-update-channel background background-blur background-image
  \ background-image-fit background-image-opacity background-image-position
  \ background-image-repeat background-opacity background-opacity-cells
  \ bell-audio-path bell-audio-volume bell-features bold-color Chained Actions class
  \ click-repeat-interval clipboard-codepoint-map clipboard-paste-bracketed-safe
  \ clipboard-paste-protection clipboard-read clipboard-trim-trailing-spaces
  \ clipboard-write command command-palette-entry config-default-files config-file
  \ confirm-close-surface copy-on-select cursor-click-to-move cursor-color
  \ cursor-opacity cursor-style cursor-style-blink cursor-text custom-shader
  \ custom-shader-animation desktop-notifications enquiry-response env faint-opacity
  \ focus-follows-mouse font-codepoint-map font-family font-family-bold
  \ font-family-bold-italic font-family-italic font-feature font-shaping-break
  \ font-size font-style font-style-bold font-style-bold-italic font-style-italic
  \ font-synthetic-style font-thicken font-thicken-strength font-variation
  \ font-variation-bold font-variation-bold-italic font-variation-italic foreground
  \ freetype-load-flags fullscreen grapheme-width-method gtk-custom-css
  \ gtk-opengl-debug gtk-quick-terminal-layer gtk-quick-terminal-namespace
  \ gtk-single-instance gtk-tabs-location gtk-titlebar
  \ gtk-titlebar-hide-when-maximized gtk-titlebar-style gtk-toolbar-style
  \ gtk-wide-tabs image-storage-limit initial-command initial-window input Key
  \ Tables key-remap keybind language link link-previews link-url linux-cgroup
  \ linux-cgroup-hard-fail linux-cgroup-memory-limit linux-cgroup-processes-limit
  \ macos-applescript macos-auto-secure-input macos-custom-icon
  \ macos-dock-drop-behavior macos-hidden macos-icon macos-icon-frame
  \ macos-icon-ghost-color macos-icon-screen-color macos-non-native-fullscreen
  \ macos-option-as-alt macos-secure-input-indication macos-shortcuts
  \ macos-titlebar-proxy-icon macos-titlebar-style macos-window-buttons
  \ macos-window-shadow maximize minimum-contrast mouse-hide-while-typing
  \ mouse-reporting mouse-scroll-multiplier mouse-shift-capture
  \ notify-on-command-finish notify-on-command-finish-action
  \ notify-on-command-finish-after osc-color-report-format palette palette-generate
  \ palette-harmonious progress-style quick-terminal-animation-duration
  \ quick-terminal-autohide quick-terminal-keyboard-interactivity
  \ quick-terminal-position quick-terminal-screen quick-terminal-size
  \ quick-terminal-space-behavior quit-after-last-window-closed
  \ quit-after-last-window-closed-delay resize-overlay resize-overlay-duration
  \ resize-overlay-position right-click-action scroll-to-bottom scrollback-limit
  \ scrollbar search-background search-foreground search-selected-background
  \ search-selected-foreground selection-background selection-clear-on-copy
  \ selection-clear-on-typing selection-foreground selection-word-chars
  \ shell-integration shell-integration-features split-divider-color
  \ split-inherit-working-directory split-preserve-zoom
  \ tab-inherit-working-directory term theme title title-report undo-timeout
  \ unfocused-split-fill unfocused-split-opacity vt-kam-allowed wait-after-command
  \ window-colorspace window-decoration window-height window-inherit-font-size
  \ window-inherit-working-directory window-new-tab-position window-padding-balance
  \ window-padding-color window-padding-x window-padding-y window-position-x
  \ window-position-y window-save-state window-show-tab-bar window-step-resize
  \ window-subtitle window-theme window-title-font-family window-titlebar-background
  \ window-titlebar-foreground window-vsync window-width working-directory
  \ x11-instance-name
  \ nextgroup=ghosttyAssign

hi link ghosttyConfProp Identifier
hi link ghosttyAssign   Operator
hi link ghosttyComment  Comment
hi link ghosttyColour   String
hi link ghosttyBool     Boolean
hi link ghosttyNumber   Number
