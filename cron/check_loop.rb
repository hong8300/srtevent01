

SRTMXF_CRON = "kick_ffmpeg.sh"                  # shell for srt to mxf

## cron ディレクトリ
dir = ARGV[0] 
ffmpeg = ARGV[1]
write_dir = ARGV[2]
api_url = ARGV[3]
# api_url = "http://0.0.0.0:3000/api/v1/events"
# http://0.0.0.0:3000/api/v1/events

## ステータスファイル、情報ファイルのディレクトリ
sdir = dir + "/status"
## ステータスファイル
sdir_glob = sdir + "/*.status"

CRON_ORIGINAL_FILE = sdir + "/srtmxf_crontab"
CRON_BACKUP_FILE   = sdir + "/srtmxf_crontab.bk"     
CRON_NEW_FILE      = sdir + "/srtmxf_crontab.new"
CRON_TMP_FILE      = sdir + "/srtmxf_crontab.tmpd"

# system(sprintf("echo sdir:%s sdir_glob:%s >> /tmp/check_loop.log",sdir,sdir_glob))

### main loop
status_list = Dir.glob(sdir_glob)
status_list.each  do |each_file|
    status_number = 0
    p "----------" + each_file + "------------"
    File.open(each_file, "r") do |fs|
        status_number = fs.read.to_i
    end
    case status_number
        when 1
            p "STATUS:1"
            p "CRON へ登録します"
            event_id = File.basename(each_file, ".status") 
            info_filename = sdir + "/" + event_id + ".info" 
            status_filename = sdir + "/" + event_id + ".status"
            # 情報ファイル .info の内容を crontab に登録する
            File.open(info_filename, "r") do |fi|
                rec_starttime = fi.gets.chomp
                cron_time = rec_starttime[0,11] # 先頭から 11 文字
                server_url = fi.gets.chomp
                server_port = fi.gets.chomp
                passphrase = fi.gets.chomp
                output_filename = fi.gets.chomp

                # system("echo infofile OPEN OK >> /tmp/check_loop.log")

                # p cron_time
                # p server_url
                # p server_port
                # p passphrase
                # p output_filename

                # オリジナルファイルの有無確認
                if File.exist?(CRON_ORIGINAL_FILE) == false then
                    system(sprintf("touch %s",CRON_ORIGINAL_FILE))    
                end
                # オリジナル crontab 読み込み
                system(sprintf("cp %s %s",CRON_ORIGINAL_FILE,CRON_BACKUP_FILE))
                fc = File.open(CRON_BACKUP_FILE, "r")
                    cron_text = fc.read
                fc.close

                # 書き込み用 buffer 初期化
                wbuffer = []

                # 1行ずつ読み込む
                cron_text.each_line { |line| 
                    wbuffer.push(line.chomp)
                }
                
                # cron の内容を 複製し、最終行に新たに追加する
                fc = File.open(CRON_NEW_FILE, "w")
                    # 一行つづ処理する
                    for var in wbuffer do
                        fc.puts(var)
                    end
                    cron_line = sprintf("%s * %s/%s %d %d %s %s/%s %s",
                        cron_time,dir,
                        SRTMXF_CRON,
                        event_id,
                        server_port,
                        passphrase,
                        write_dir,
                        output_filename,
                        ffmpeg)
                    fc.puts(cron_line)
                fc.close

                # オリジナル crontab 更新
                system(sprintf("cp %s %s",CRON_NEW_FILE,CRON_ORIGINAL_FILE))

                # STATUS を 5に変更
                event_status = 5
                system(sprintf("echo #{event_status} > %s",status_filename))
                curl_cmd = "curl -X PUT -H \'Content-Type:application/json\' -d \'{ \"status\":#{event_status} }\' #{api_url}/#{event_id}"
                system(curl_cmd)
            end
        when 5
            p "5がでました"
        when 99
            p "99がでました"
            p "関連ファイルを削除します"
            event_id = File.basename(each_file, ".status") 
            info_filename = sdir + "/" + event_id + ".info" 
            status_filename = sdir + "/" + event_id + ".status"
            outfile = ""
            File.open(info_filename, "r") do |fi|
                rec_starttime = fi.gets.chomp
                # cron_time = rec_starttime[0,11] # 先頭から 11 文字
                server_url = fi.gets.chomp
                server_port = fi.gets.chomp
                passphrase = fi.gets.chomp
                outfile = fi.gets.chomp
            end
            p "------- output.filename -------"
            outfile_fullpath = write_dir + "/" + outfile
            p outfile_fullpath
            File.exist?(info_filename) ? File.delete(info_filename) : false
            File.exist?(status_filename) ? File.delete(status_filename) : false
            File.exist?(outfile_fullpath) ? File.delete(outfile_fullpath) : false
            # cron の該当行をコメントアウトする
            # オリジナル crontab ファイルを読み込む
            f = File.open(CRON_ORIGINAL_FILE, "r")
                cron_text = f.read
            f.close
            # 更新用 tmp ファイル
            fw = File.open(CRON_TMP_FILE, "w")
            update_cron = false
            # 一行ずつ処理
            cron_text.each_line { |line| 
                one_line = line.chomp.strip
                file_event_id = one_line.split[6]
                if one_line[0] == "#" then
                    fw.puts(one_line)
                elsif file_event_id == event_id  then
                    # イベント番号が一致したので その行をコメントアウトする
                    fw.puts("# "+one_line)
                    update_cron = true
                else
                    fw.puts(one_line)
                end
            }   
            fw.close
            if update_cron == true then
                system(sprintf("cp %s %s",CRON_TMP_FILE,CRON_ORIGINAL_FILE))
            end
        else
            p "それ以外でした"
            p status_number
        end
end
