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
      # logger.debug("DEBUG MESSAGE----------------")
      # logger.debug(event.id)

      event.status = 1
      event.server_url = "srtserve.unohana.co.jp"
      event.server_port = 9800 
      event.passphrase = SecureRandom.alphanumeric(16)
      event.output_filename = "test.mxf"
      event.sdata2 = 'NON'
      event.idata1 = 0
      event.idata2 = 0
      if event.save
        # logger.debug("DEBUG 2")
        # logger.debug(event.id)
 
        # サーバーポート生成
        event.server_port = 9800 + ( event.id % 100)
        # ファイル名生成
        event.output_filename = "mxfrec-file-"+sprintf("%05d",event.id)+".mxf"
        # ステータスファイル作成
        # インフォメーションファイルの作成
        filename_body = Rails.root.to_s + "/cron/status/" + event.id.to_s
        status_filename = filename_body + ".status"
        info_filename = filename_body + ".info"

        # logger.debug("-----------------------------------------")
        # logger.debug(status_filename)
        
        File.open(status_filename,"w") do |f|
          f.printf("%d",1)
        end
        s = event.rec_starttime.to_s 
        File.open(info_filename,"w") do |f|
          # f.puts(sprintf("MDHM %s %s %s %s",s[5,2],s[8,2],s[11,2],s[14,2]))
          f.puts(sprintf("%s %s %s %s MHDM",s[14,2],s[11,2],s[8,2],s[5,2]))
          f.puts(event.server_url)
          f.puts(event.server_port)
          f.puts(event.passphrase)
          f.puts(event.output_filename)
        end

        event.save
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
      # logger.debug("------- DELETE 1----------------------------------")
      event = @event
      @event.destroy!

      # ステータスファイル 99セット（削除要求）
      filename_body = Rails.root.to_s + "/cron/status/" + event.id.to_s
      status_filename = filename_body + ".status"
      info_filename = filename_body + ".info"
      # File.delete(status_filename)
      # File.delete(info_filename)
      File.open(status_filename,"w") do |f|
        f.printf("%d",99)
      end
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
  