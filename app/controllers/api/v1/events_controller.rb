class Api::V1::EventsController < ApiController
    before_action :set_event, only: [:show, :update, :destroy]
  
    # 拾えなかったExceptionが発生したら500 Internal server errorを応答する
    rescue_from Exception, with: :render_status_500

    # ActiveRecordのレコードが見つからなければ404 not foundを応答する
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render json: { error: '404 not found' }, status: 404
    end
  
    def index
      # events = Event.all
      events = Event.select(:id, :name, :description, :rec_starttime, :status, :sdata1)
      render json: events
    end

    def create
      event = Event.new(event_params)
      pp "DEBUG"
      event.status = 1
      event.server_url = "http://srtserv.unohana.co.jp"
      event.server_port = 9800
      event.passphrase = SecureRandom.alphanumeric(16)
      event.output_filename = "hogehoge.mxf"
      event.sdata2 = 'NON'
      event.idata1 = 0
      event.idata2 = 0
      if event.save
        render json: event, status: :created
      else
        render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      # if @event.update_attributes(event_params)
      if  @event.update(event_params)
        head :no_content
      else
        render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show
      render json: @event
    end

    def destroy
      @event.destroy!
      head :no_content
    end

  private
  
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.fetch(:event, {}).permit(:name, :description, :rec_starttime, :status, :output_filename, :passphrase, :server_url, :server_port,
        :sdata1, :sdata2, :idata1, :idata2)
    end

    def render_status_404(exception)
      render json: { errors: [exception] }, status: 404
    end

    def render_status_500(exception)
      render json: { errors: [exception] }, status: 500
    end

  end
  