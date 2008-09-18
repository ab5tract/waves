# External Dependencies
require 'rubygems'

# Some scripts need to be able to locate items relative to waves source.
WAVES = "#{File.dirname(__FILE__)}/.." unless defined?(WAVES)

require 'rack'
require 'daemons'
require 'live_console'

require 'autocode'

#gem 'dyoder-functor'
$:.unshift('../functor/lib')
require 'functor'

# for mimetypes only or when using as default handler
require 'mongrel'

# a bunch of handy stuff
require 'extensions/io'
require 'extensions/symbol' unless Symbol.instance_methods.include? 'to_proc'
require 'fileutils'
require 'metaid'
require 'forwardable'
require 'date'
require 'benchmark'
require 'base64'
require 'cache/cache-ipi'

# gem 'dyoder-filebase'
$:.unshift('../filebase/lib')
require 'filebase'
require 'filebase/model'

# selected project-specific extensions
require 'ext/module'
require 'ext/string'
require 'ext/symbol'
require 'ext/object'
require 'ext/integer'
require 'ext/inflect'
require 'ext/proc'
require 'ext/hash'
require 'ext/tempfile'
require 'ext/kernel'

# waves Runtime
require 'dispatchers/base'
require 'dispatchers/default'
require 'runtime/logger'
require 'runtime/mime_types'
require 'runtime/runtime'
require 'runtime/console'
require 'runtime/server'
require 'runtime/request'
require 'runtime/response'
require 'runtime/response_mixin'
require 'runtime/session'
require 'runtime/configuration'

# waves URI mapping
require 'matchers/base'
require 'matchers/accepts'
require 'matchers/content_type'
require 'matchers/path'
require 'matchers/query'
require 'matchers/traits'
require 'matchers/uri'
require 'matchers/request'
require 'resources/path'
require 'resources/selector'
require 'resources/mixin'
require 'resources/delegate'

# waves mvc support
require 'controllers/mixin'
require 'views/mixin'
# require 'helpers/tag_helper'
# require 'helpers/url_helper'
require 'helpers/common'
require 'helpers/form'
require 'helpers/formatting'
require 'helpers/model'
require 'helpers/view'
require 'helpers/built_in'
# require 'helpers/asset_helper'
# require 'helpers/number_helper'
require 'renderers/mixin'
require 'renderers/erubis'
require 'renderers/markaby'
#require 'layers/renderers/haml'


# waves foundations / layers
require 'foundations/default'
require 'foundations/simple'

require 'layers/simple'
require 'layers/simple_errors'
require 'layers/mvc'
require 'layers/default_errors'
require 'layers/inflect/english'
require 'foundations/default'
