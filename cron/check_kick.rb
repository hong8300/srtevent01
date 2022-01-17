

p "Now in check_kick.rb"



## cron ディレクトリ
dir = ARGV[0] 

## ステータスファイル、情報ファイルのディレクトリ
sdir = dir + "/status"

CRON_ORIGINAL_FILE = sdir + "/srtmxf_crontab"

# オリジナル crontab ファイルを読み込む
f = File.open(CRON_ORIGINAL_FILE, "r")
    cron_text = f.read
f.close

# 現在の時刻を取得
now = Time.now # 2016-6-21 20:17:42 +0900
now_str = sprintf("%02d %02d %02d %02d",now.min,now.hour,now.day,now.month)

# 一行ずつ処理
cron_text.each_line { |line| 
    p now_str
    p line.chomp
}