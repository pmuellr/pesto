#-------------------------------------------------------------------------------
class Debugger

    #---------------------------------------------------------------------------
    constructor: ->

    #---------------------------------------------------------------------------
    # Tells whether enabling debugger causes scripts recompilation.
    #---------------------------------------------------------------------------
    causesRecompilation: (request) ->
       request.response null

    #---------------------------------------------------------------------------
    # Tells whether debugger supports native breakpoints.
    #---------------------------------------------------------------------------
    supportsNativeBreakpoints: (request) ->
       request.response null

