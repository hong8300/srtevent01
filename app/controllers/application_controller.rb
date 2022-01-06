class ApplicationController < ActionController::Base
    before_action :prevent_page_caching

    def prevent_page_caching
      response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    end
end
