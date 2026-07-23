# Powerlevel10k config rendered by chezmoi.

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  typeset -g POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_ICON_PADDING=none

  typeset -g DOT_PROFILE='default'
  typeset -g DOT_THEME='harbor'
  typeset -ga DOT_SSH_PALETTE=(45 81 109 141 171 178 )

  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    remote_badge
    dir
    vcs
    newline
    prompt_char
  )
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status
    command_execution_time
    background_jobs
    newline
  )

  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR='  '
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=45
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''

  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=56
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=36
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=109
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=244
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=109
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_DIR_CONTENT_EXPANSION='%B${P9K_CONTENT}%b'
  typeset -g POWERLEVEL9K_DIR_CLASSES=(
    '~/dev(|/*)'                        DEV     ''
    '~/Cloud(|/*)'                      CLOUD   ''
    '~/.config(|/*)'                    CONFIG  ''
    '~'                                 HOME    ''
    '/etc(|/*)'                         ETC     ''
    '*'                                 DEFAULT ''
  )
  typeset -g POWERLEVEL9K_DIR_DEV_VISUAL_IDENTIFIER_EXPANSION='󰲋'
  typeset -g POWERLEVEL9K_DIR_DEV_FOREGROUND=109
  typeset -g POWERLEVEL9K_DIR_DEV_ANCHOR_FOREGROUND=109
  typeset -g POWERLEVEL9K_DIR_CLOUD_VISUAL_IDENTIFIER_EXPANSION='󰅧'
  typeset -g POWERLEVEL9K_DIR_CLOUD_FOREGROUND=109
  typeset -g POWERLEVEL9K_DIR_CLOUD_ANCHOR_FOREGROUND=109
  typeset -g POWERLEVEL9K_DIR_CONFIG_VISUAL_IDENTIFIER_EXPANSION=''
  typeset -g POWERLEVEL9K_DIR_CONFIG_FOREGROUND=109
  typeset -g POWERLEVEL9K_DIR_CONFIG_ANCHOR_FOREGROUND=109
  typeset -g POWERLEVEL9K_DIR_HOME_VISUAL_IDENTIFIER_EXPANSION=''
  typeset -g POWERLEVEL9K_DIR_HOME_FOREGROUND=109
  typeset -g POWERLEVEL9K_DIR_HOME_ANCHOR_FOREGROUND=109
  typeset -g POWERLEVEL9K_DIR_HOME_CONTENT_EXPANSION='%B●%b'
  typeset -g POWERLEVEL9K_DIR_ETC_VISUAL_IDENTIFIER_EXPANSION=''
  typeset -g POWERLEVEL9K_DIR_ETC_FOREGROUND=178
  typeset -g POWERLEVEL9K_DIR_ETC_ANCHOR_FOREGROUND=178
  typeset -g POWERLEVEL9K_DIR_DEFAULT_VISUAL_IDENTIFIER_EXPANSION=''

  typeset -g POWERLEVEL9K_REMOTE_BADGE_DEFAULT_BACKGROUND=
  typeset -g POWERLEVEL9K_REMOTE_BADGE_DEFAULT_FOREGROUND=109
  typeset -g POWERLEVEL9K_REMOTE_BADGE_PROD_BACKGROUND=
  typeset -g POWERLEVEL9K_REMOTE_BADGE_PROD_FOREGROUND=45
  typeset -g POWERLEVEL9K_REMOTE_BADGE_STAGE_BACKGROUND=
  typeset -g POWERLEVEL9K_REMOTE_BADGE_STAGE_FOREGROUND=178
  typeset -g POWERLEVEL9K_REMOTE_BADGE_DEV_BACKGROUND=
  typeset -g POWERLEVEL9K_REMOTE_BADGE_DEV_FOREGROUND=76
  typeset -g POWERLEVEL9K_REMOTE_BADGE_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_REMOTE_BADGE_CONTENT_EXPANSION='%B${P9K_CONTENT}%b'
  typeset -g POWERLEVEL9K_REMOTE_BADGE_LEFT_LEFT_WHITESPACE=' '
  typeset -g POWERLEVEL9K_REMOTE_BADGE_LEFT_RIGHT_WHITESPACE=' '
  typeset -g POWERLEVEL9K_REMOTE_BADGE_PREFIX=' '
  typeset -g POWERLEVEL9K_REMOTE_BADGE_SUFFIX=' '

  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=45
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=45
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=45
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION=

  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=244
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION=

  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=178

  function prompt_remote_badge() {
    [[ -n ${SSH_CONNECTION:-}${SSH_CLIENT:-} ]] || return
    [[ -z ${WAYLAND_DISPLAY:-}${DISPLAY:-} ]] || return

    if [[ -n ${_P10K_SSH_LABEL:-} ]]; then
      p10k segment -s HOST -t "${_P10K_SSH_ICON} ${_P10K_SSH_LABEL}"
      return
    fi

    local host=${HOST%%.*}
    local state=DEFAULT
    case ${host:l} in
      *prod*|*prd*|*live*) state=PROD ;;
      *stage*|*stg*|*test*) state=STAGE ;;
      *dev*|*lab*) state=DEV ;;
    esac
    p10k segment -s $state -t "${USER}@${host}"
  }

  function my_git_formatter() {
    emulate -L zsh

    if [[ -n $P9K_CONTENT ]]; then
      typeset -g my_git_format=$P9K_CONTENT
      return
    fi

    local branch=${VCS_STATUS_LOCAL_BRANCH:-${VCS_STATUS_TAG:-${VCS_STATUS_COMMIT[1,8]}}}
    [[ -n $branch ]] || return

    local state='%76F'
    local mark=''
    if (( VCS_STATUS_NUM_CONFLICTED )); then
      state='%45F'
      mark=' ~'
    elif (( VCS_STATUS_NUM_STAGED || VCS_STATUS_NUM_UNSTAGED || VCS_STATUS_NUM_UNTRACKED )); then
      state='%178F'
      mark=' ±'
    fi

    local ahead_behind=''
    (( VCS_STATUS_COMMITS_AHEAD )) && ahead_behind+=" ⇡${VCS_STATUS_COMMITS_AHEAD}"
    (( VCS_STATUS_COMMITS_BEHIND )) && ahead_behind+=" ⇣${VCS_STATUS_COMMITS_BEHIND}"

    typeset -g my_git_format="${state} ${(V)branch}${mark}${ahead_behind}%f"
  }
  functions -M my_git_formatter 2>/dev/null

  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)
  typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter(1)))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((my_git_formatter(0)))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1

  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
  (( ! $+functions[p10k] )) || p10k reload
}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
