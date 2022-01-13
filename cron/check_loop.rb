

SRTMXF_CRON = "srtmxf_cron.sh"                  # shell for srt to mxf

## cron ディレクトリ
dir = ARGV[0] 
ffmpeg = ARGV[1]
write_dir = ARGV[2]

## ステータスファイル、情報ファイルのディレクトリ
sdir = dir + "/status"
## ステータスファイル
sdir_glob = sdir + "/*.status"

CRON_ORIGINAL_FILE = sdir + "/srtmxf_crontab"
CRON_BACKUP_FILE   = sdir + "/srtmxf_crontab.bk"     
CRON_NEW_FILE      = sdir + "/srtmxf_crontab.new"

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


                # STATUS を 2に変更
                system(sprintf("echo 2 > %s",status_filename))
            end

        when 2
            p "２がでました"
            system("echo case 2 >> /tmp/check_loop.log")
        else
            p "それ以外でした"
            p status_number
        end
end
