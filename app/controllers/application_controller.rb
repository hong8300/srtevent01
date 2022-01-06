class ApplicationController < ActionController::Base
    before_action :prevent_page_caching
    before_action :basic_auth

    def prevent_page_caching
      response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    end

    private

    def basic_auth
      authenticate_or_request_with_http_basic do |username, password|
        username == "photron" && password == "Y2ZBKNrv" 
      end
    end
end
