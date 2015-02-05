    _self = this
    if exports?
     BROWSER = false
    else
     BROWSER = true

    TYPE =
     'debug': 'DEBUG'
     'stat' : 'STAT '
     'info' : 'INFO '
     'warn' : 'WARN '
     'error': 'ERROR'

    TYPE_COLOR  =
     'debug': ''
     'stat' : 'green'
     'info' : 'blue'
     'warn' : 'yellow'
     'error': 'red'

    _NODE_RESET = "\x1B[0"
    _NODE_BOLD = ";1"
    _NODE_COLOR = #https://wiki.archlinux.org/index.php/Color_Bash_Prompt
     'green': ';32'
     'red': ';31'
     'blue': ";34"
     'yellow': ";33"
     '': ''

    _twoDigit = (n) ->
     s = "0#{n}"
     s.substr s.length - 2


##LOG

'''
LOG type, id, text, params, options

###Example
'''coffeescript
LOG 'info', 'connector_startup', 'Connector starting', {user: 'varuna'}, {color: false}

    class Logger
     constructor: ->
      @_log = console.log
      @separator = '\t'
      @lineBreak = '\n'
      @indent = '\t\t'
      @color = true

     dateToString: (date) ->
      s = "#{date.getFullYear()}-#{_twoDigit date.getMonth() + 1}-#{_twoDigit date.getDate()}"
      s += " #{_twoDigit date.getHours()}:#{_twoDigit date.getMinutes()}:#{_twoDigit date.getSeconds()}"
      return s

     log: (type, id, text, params, options) ->
      unless TYPE[type]
       throw new Error 'Unknown type'

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
       s += "#{@indent}#{k}:#{JSON.stringify v}#{@lineBreak}"

      @_log s

     logNode: (type, id, text, params, options) ->
      color = _NODE_COLOR[TYPE_COLOR[type]]
      s = "#{_NODE_RESET}#{color}m#{TYPE[type]}#{_NODE_RESET}m#{@separator}"
      s += "#{@dateToString new Date}#{@separator}"
      s += "#{_NODE_RESET}#{_NODE_BOLD}m#{id}#{_NODE_RESET}m#{@separator}"
      s += "#{text}#{@lineBreak}"
      for k, v of params
       s += "#{@indent}#{k}:#{JSON.stringify v}#{@lineBreak}"

      @_log s

     logBrowser: (type, id, text, params, options) ->
      s = "#{TYPE[type]}#{@separator}"
      s += "#{@dateToString new Date}#{@separator}"
      s += "#{id}#{@separator}#{text}#{@lineBreak}"
      for k, v of params
       s += "#{@indent}#{k}:#{JSON.stringify v}#{@lineBreak}"

      @_log s




    LOG = new Logger

    if not BROWSER
     exports.log = LOG.log.bind LOG
     exports.Logger = Logger
    else
     self.Logger =
      Logger: Logger
      log: LOG.log.bind LOG

