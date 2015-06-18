    _self = this
    if exports?
     BROWSER = false
    else
     BROWSER = true

    TYPE =
     'debug': 'DEBUG'
     'stat': 'STAT '
     'info': 'INFO '
     'warn': 'WARN '
     'error': 'ERROR'

    TYPE_COLOR  =
     'debug': ''
     'stat': 'green'
     'info': 'blue'
     'warn': 'yellow'
     'error': 'red'

    _NODE_RESET = "\x1B[0"
    _NODE_BOLD = ";1"
    _NODE_UNDERLINE = ";4"
    _NODE_COLOR = #https://wiki.archlinux.org/index.php/Color_Bash_Prompt
     'green': ';32'
     'red': ';31'
     'blue': ';34'
     'yellow': ';33'
     '': ''

    _BROWSER_BOLD = 'font-weight: bold;'
    _BROWSER_UNDERLINE = 'text-decoration: underline'
    _BROWSER_COLOR =
     'green': 'color: green;'
     'red': 'color: red;'
     'blue': 'color: blue;'
     'yellow': 'color: yellow'

    _twoDigit = (n) ->
     s = "0#{n}"
     s.substr s.length - 2


    CONSOLE = {}
    if console?
     CONSOLE = console

    JSON_STRINGIFY = (v) ->
     try
      s = JSON.stringify v
     catch e
      s = e.message

     return s

##LOG

'''
LOG type, id, text, params, options

###Example
'''coffeescript
LOG 'info',
 'connector_startup'
 'Connector starting'
 {user: 'varuna'}
 {color: false}

    class Logger
     constructor: ->
      if CONSOLE?.log?
       @_log = CONSOLE.log.bind CONSOLE
      else
       @_log = -> null
      @separator = '\t'
      @lineBreak = '\n'
      @indent = '\t\t'
      @color = true

     dateToString: (date) ->
      return "
       #{date.getFullYear()}-\
       #{_twoDigit date.getMonth() + 1}-\
       #{_twoDigit date.getDate()}
       #{_twoDigit date.getHours()}:\
       #{_twoDigit date.getMinutes()}:\
       #{_twoDigit date.getSeconds()}"

     stackText: ->
      try
       throw new Error ''
      catch e
       return '' unless e.stack?
       stack = e.stack

      stack = stack.split '\n'
      stack = stack.slice 4
      s = "#{@lineBreak}"
      for line, i in stack
       s += "#{@indent}#{line.trim()}#{@lineBreak}"

      return s

     log: (type, id, text, params, options) ->
      unless TYPE[type]
       throw new Error 'Unknown type'

      options ?= {}
      params ?= {}
      text ?= ''

      if not @color
       @logPlain type, id, text, params, options
      else if BROWSER
       @logBrowser type, id, text, params, options
      else
       @logNode type, id, text, params, options

     logPlain: (type, id, text, params, options) ->
      s = "#{TYPE[type]}#{@separator}"
      s += "#{@dateToString new Date}#{@separator}"
      s += "#{id}#{@separator}#{text}#{@lineBreak}"
      for k, v of params
       s += "#{@indent}#{k}: #{JSON_STRINGIFY v}#{@lineBreak}"
      if options.stack
       s += @stackText()

      s = s.substr 0, s.length - @lineBreak.length
      @_log s

     logNode: (type, id, text, params, options) ->
      color = _NODE_COLOR[TYPE_COLOR[type]]
      s = "#{_NODE_RESET}#{color}m#{TYPE[type]}#{_NODE_RESET}m#{@separator}"
      s += "#{@dateToString new Date}#{@separator}"
      s += "#{_NODE_RESET}#{_NODE_BOLD}m#{id}#{_NODE_RESET}m#{@separator}"
      s += "#{text}#{@lineBreak}"
      for k, v of params
       s += "#{@indent}#{_NODE_RESET}#{_NODE_UNDERLINE}m#{k}#{_NODE_RESET}m"
       s += ": #{JSON_STRINGIFY v}#{@lineBreak}"

      if options.stack
       s += @stackText()

      s = s.substr 0, s.length - @lineBreak.length
      @_log s

     logBrowser: (type, id, text, params, options) ->
      color = _BROWSER_COLOR[TYPE_COLOR[type]]
      styles = []
      s = "%c#{TYPE[type]}%c#{@separator}"
      s += "#{@dateToString new Date}#{@separator}"
      s += "%c#{id}%c#{@separator}#{text}#{@lineBreak}"
      styles = [color, '', _BROWSER_BOLD, '']
      for k, v of params
       s += "#{@indent}%c#{k}%c: #{JSON_STRINGIFY v}#{@lineBreak}"
       styles.push _BROWSER_UNDERLINE
       styles.push ''

      if options.stack
       s += @stackText()

      s = s.substr 0, s.length - @lineBreak.length
      args = [s].concat styles
      @_log.apply CONSOLE, args




    LOG = new Logger

    if not BROWSER
     exports.log = LOG.log.bind LOG
     exports.Logger = Logger
    else
     self.Logger =
      Logger: Logger
      log: LOG.log.bind LOG

