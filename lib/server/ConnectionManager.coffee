# Licensed under the Apache License. See footer for details.

path   = require "path"
events = require "events"

_ = require "underscore"

#-------------------------------------------------------------------------------
# moved to the bottom to avoid recursive requires
#-------------------------------------------------------------------------------
utils                  = require "../common/utils"
BasicConnectionManager = require "../common/BasicConnectionManager"

#-------------------------------------------------------------------------------
module.exports = class ConnectionManager extends BasicConnectionManager

    #---------------------------------------------------------------------------
    constructor: (@opts) ->
        super

        @tracer = @logger.tracer __filename

    #---------------------------------------------------------------------------
    sendEvent: (event, body) ->

        for own id, client of @attachedClients
            client.sendEvent event, body

#-------------------------------------------------------------------------------
# Copyright 2013 I.B.M.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-------------------------------------------------------------------------------

