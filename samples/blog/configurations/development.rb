module Blog

  module Configurations

    class Development < Default

      database :adapter => 'sqlite', :database => 'blog.db'
      reloadable [ Blog ]
      log :level => :debug
      session :duration => 45.minutes, :path => 'tmp/sessions'
      host '127.0.0.1'
      port 4000

      application do
        use ::Rack::ShowExceptions
        use ::Rack::Static, :urls => [ '/images/', '/css/', '/javascript/', '/favicon.ico' ], :root => 'public'
        run ::Waves::Dispatchers::Default.new
      end



    end

  end

end
