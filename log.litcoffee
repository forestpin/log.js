    _self = this

    TYPE =
     'debug': 'DEBUG'
     'stat' : 'STAT '
     'info' : 'INFO '
     'warn' : 'WARN '
     'error': 'ERROR'

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

     dateToString: (date) ->
      s = "#{date.getFullYear()}-#{_twoDigit date.getMonth() + 1}-#{_twoDigit date.getDate()}"
      s += " #{_twoDigit date.getHours()}:#{_twoDigit date.getMinutes()}:#{_twoDigit date.getSeconds()}"
      return s

     log: (type, id, text, params, options) ->
      unless TYPE[type]
       throw new Error 'Unknown type'

      s = "#{TYPE[type]}#{@separator}"
      s += "#{@dateToString new Date}#{@separator}"
      s += "#{id}#{@separator}#{text}#{@lineBreak}"
      for k, v of params
       s += "#{@indent}#{k}:#{v}#{@lineBreak}"

      @_log s


    LOG = new Logger

    if exports?
     exports.log = LOG.log.bind LOG
     exports.Logger = Logger
    else
     self.Logger =
      Logger: Logger
      log: LOG.log.bind LOG

