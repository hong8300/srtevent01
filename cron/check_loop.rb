
require "open3"

SRTMXF_CRON = "kick_ffmpeg.sh"                  # shell for srt to mxf

## cron ディレクトリ
base_dir = ARGV[0]
dir = base_dir  + "/cron"

ffmpeg = ARGV[1]
write_dir = ARGV[2]
api_url = ARGV[3]
ps_option = ARGV[4]
ps_event_index = ARGV[5].to_i

## ステータスファイル、情報ファイルのディレクトリ
sdir = dir + "/status"
## ステータスファイル
sdir_glob = sdir + "/*.status"

CRON_ORIGINAL_FILE = sdir + "/srtmxf_crontab"
CRON_BACKUP_FILE   = sdir + "/srtmxf_crontab.bk"     
CRON_NEW_FILE      = sdir + "/srtmxf_crontab.new"
CRON_TMP_FILE      = sdir + "/srtmxf_crontab.tmpd"

#
# FUNCTION:
# Get output filename 
#
def get_outfilename(fname)
    # p "now in get_outfilename()"
    outfilename = ""
    File.open(fname, "r") do |f|
        f.gets
        f.gets
        f.gets
        f.gets
        outfilename = f.gets.chomp
    end
    return outfilename
end

def update_status( p_event_id, p_event_status,p_status_filename, p_api_url )
#    p_event_status = 20
    system(sprintf("echo #{p_event_status} > %s",p_status_filename)) 
    curl_cmd = "curl -X PUT -H \'Content-Type:application/json\' -d \'{ \"status\":#{p_event_status} }\' #{p_api_url}/#{p_event_id}"
    system(curl_cmd)     
end
#
# Main Process
#
status_list = Dir.glob(sdir_glob)
status_list.each  do |each_file|
    status_number = 0
    p "----------" + each_file + "------------"
    File.open(each_file, "r") do |fs|
        status_number = fs.read.to_i
    end

    # イベントID
    event_id = File.basename(each_file, ".status") 
    # 情報ファイル名
    info_filename = sdir + "/" + event_id + ".info" 
    # ステータスファイル名
    status_filename = sdir + "/" + event_id + ".status"

    case status_number
        when 1
            p "Status is 1"
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
                    outimage = sprintf("%s/public/downloads/out%d.jpg",base_dir,event_id)
                    cron_line = sprintf("%s * %s/%s %d %d %s %s/%s %s %s",
                        cron_time,dir,
                        SRTMXF_CRON,
                        event_id,
                        server_port,
                        passphrase,
                        write_dir,
                        output_filename,
                        ffmpeg,
                        outimage)
                    fc.puts(cron_line)
                fc.close

                # オリジナル crontab 更新
                system(sprintf("cp %s %s",CRON_NEW_FILE,CRON_ORIGINAL_FILE))

                # STATUS を 5に変更
                update_status( event_id, 5, status_filename, api_url )
            end
        when 5
            p "Status is 5"
        when 10 # ストリームwait 
            p "Status is 10"
            # OUTPUTファイルが存在すれば ステータスを Rec にする
            outfile_fullpath = write_dir + "/" + get_outfilename(info_filename)
            if File.exist?(outfile_fullpath) then
                # STATUS を 20 に変更
                update_status( event_id, 20, status_filename, api_url )     
            end
        when 20 # Rec中
            p "Status is 20"

            # プロセスが存在しなければ ステータスを プロキシー生成(30)にする
            # MAC: cmd_str = "ps -a | grep kick_ffmpeg.sh | grep -v grep"
            # AWS: cmd_str = "ps -def | grep kick_ffmpeg.sh | grep -v grep"
            cmd_str = "ps #{ps_option} | grep kick_ffmpeg.sh | grep -v grep"
            # p cmd_str 
            process_exec = false
            result, err, status = Open3.capture3("#{cmd_str}")
            result.each_line { |line| 
                p "------------ check kick_ffmpeg.sh process --------"
                p line
                # p line.chomp.split(' ')[4]
                # Mac: comp_event_id = line.chomp.split(' ')[5]
                # AWS: comp_event_id = line.chomp.split(' ')[9]
                comp_event_id = line.chomp.split(' ')[ps_event_index]
                p comp_event_id
                p event_id
                if comp_event_id == event_id then
                    p "--- Recording PROCESS FOUND - status not change ---"
                    process_exec = true
                    break
                end
            }
            if process_exec == false then
                p "---- Recording ROCESS NOT FOUND - next status 30 -->"
                # STATUS を 30 に変更
                update_status( event_id, 30, status_filename, api_url )     
            end
        when 30
            p "Status is 30"
            # ファイル変換をキック
            # ffmpeg をキックして MXF を MP4 に変換する（非同期起動）
            outfile_fullpath = write_dir + "/" + get_outfilename(info_filename)
            cmd_str = sprintf("%s -y -i %s %s/public/downloads/%s.mp4",ffmpeg,outfile_fullpath,base_dir,File.basename(outfile_fullpath,".mxf"))
            p cmd_str 
            Open3.popen3("#{cmd_str} > /dev/null 2>&1")
            # STATUS を 40 に変更
            update_status( event_id, 40, status_filename, api_url )   
        when 40
            p "Status is 40"
            # 40:変換完了チェック
            # ffmpeg が起動されていなかったら ステータスを 40 　にする

            # 変換プロセスチェック
            # Mac: cmd_str = "ps -a | grep ffmpeg | grep -v grep | grep mxf | grep mp4 "
            # AWS: cmd_str = "ps -def | grep ffmpeg | grep -v grep | grep mxf | grep mp4 "
            cmd_str = "ps #{ps_option} | grep ffmpeg | grep -v grep | grep mxf | grep mp4 "
            # p cmd_str 
            process_exec = false
            result, err, status = Open3.capture3("#{cmd_str}")
            result.each_line { |line| 
                p line
                process_exec = true              
            }
            if process_exec == false then
              p "----CONVERT PROCESS NOT FOUND"
              # STATUS を 50 に変更
              update_status( event_id, 50, status_filename, api_url )     
            else 
              p "----CONVERT PROCESS FOUND"
            end
        when 50
            p "Status is 50"
            # 50:完了(All Completed)

        when 99
            p "Status is 99"
            p "関連ファイルを削除します"
            # event_id = File.basename(each_file, ".status") 
            # info_filename = sdir + "/" + event_id + ".info" 
            # status_filename = sdir + "/" + event_id + ".status"
            # outfile = ""
            # p get_outfilename(info_filename)
            # File.open(info_filename, "r") do |fi|
            #     rec_starttime = fi.gets.chomp
            #     # cron_time = rec_starttime[0,11] # 先頭から 11 文字
            #     server_url = fi.gets.chomp
            #     server_port = fi.gets.chomp
            #     passphrase = fi.gets.chomp
            #     outfile = fi.gets.chomp
            # end
            # p "------- output.filename -------"
            outfile_fullpath = write_dir + "/" + get_outfilename(info_filename)
            p outfile_fullpath
            mp4_proxy  = sprintf("%s/public/downloads/%s.mp4",base_dir,File.basename(outfile_fullpath,".mxf"))
            jpg_proxy  = sprintf("%s/public/downloads/out%d.jpg",base_dir,event_id)
            File.exist?(info_filename) ? File.delete(info_filename) : false
            File.exist?(status_filename) ? File.delete(status_filename) : false
            File.exist?(outfile_fullpath) ? File.delete(outfile_fullpath) : false
            File.exist?(mp4_proxy) ? File.delete(mp4_proxy) : false
            File.exist?(jpg_proxy) ? File.delete(jpg_proxy) : false

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

