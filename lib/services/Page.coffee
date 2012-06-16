#-------------------------------------------------------------------------------
class Page

    #---------------------------------------------------------------------------
    constructor: ->

    #---------------------------------------------------------------------------
    # Reloads given page optionally ignoring the cache.
    #---------------------------------------------------------------------------
    reload: (request, ignoreCache, scriptToEvaluateOnLoad) ->
       request.response null

    #---------------------------------------------------------------------------
    # Checks whether <code>setDeviceMetricsOverride</code> can be invoked.
    #---------------------------------------------------------------------------
    canOverrideDeviceMetrics: (request) ->
       request.response null

