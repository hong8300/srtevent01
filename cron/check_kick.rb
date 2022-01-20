
require "open3"

## cron ディレクトリ
dir = ARGV[0] + "/cron"
api_url = ARGV[1]

## ステータスファイル、情報ファイルのディレクトリ
sdir = dir + "/status"

CRON_ORIGINAL_FILE = sdir + "/srtmxf_crontab"
CRON_TMP_FILE = sdir + "/srtmxf_crontab.tmp"

# オリジナル crontab ファイルを読み込む
f = File.open(CRON_ORIGINAL_FILE, "r")
    cron_text = f.read
f.close

# 現在の時刻を取得
now = Time.now # 2016-6-21 20:17:42 +0900
now_str = sprintf("%02d %02d %02d %02d",now.min,now.hour,now.day,now.month)

# 更新用 tmp ファイル
fw = File.open(CRON_TMP_FILE, "w")
update_cron = false

# 一行ずつ処理
cron_text.each_line { |line| 
    one_line = line.chomp.strip
    event_id = one_line.split[6]
#    p now_str[0,11]
#    p one_line[0,11]
#    cmd_str = one_line[14,512]
#    p cmd_str
#    Open3.popen3("#{cmd_str} > /dev/null 2>&1")

    # 時刻の比較
    if one_line[0] == "#" then
        fw.puts(one_line)
    elsif now_str[0,11] == one_line[0,11] then
        # ffmpeg の非同期実行
        cmd_str = one_line[14,512]
        p cmd_str    
        Open3.popen3("#{cmd_str} > /dev/null 2>&1")
        # オリジナル crontab をコメントアウトとする
        fw.puts("# "+one_line)
        # STATUS を 10 に変更
        event_status = 10
        sdir = dir + "/status"
        status_filename = sdir + "/" + event_id + ".status"
        system(sprintf("echo #{event_status} > %s",status_filename))
        curl_cmd = "curl -X PUT -H \'Content-Type:application/json\' -d \'{ \"status\":#{event_status} }\' #{api_url}/#{event_id}"
        system(curl_cmd)
        update_cron = true
    else
        fw.puts(one_line)
        
    end
}

fw.close
if update_cron == true then
    system(sprintf("cp %s %s",CRON_TMP_FILE,CRON_ORIGINAL_FILE))
end
