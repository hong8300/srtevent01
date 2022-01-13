# README

SRT MXF 変換 WEBアプリケーション
UPDATE

## GITHUB
git clone 

## CRONTAB
```
*/1 * * * * /Users/hong/RAILS/srtevent/cron/check_loop.sh 
*/1 * * * * /Users/hong/RAILS/srtevent/cron/exec_ffmpeg.sh
```

## CRON
- cron/check_loop.sh  
フロントで生成する statusファイルをチェックし バックエンドに情報を渡す  
MAC m1/ AWS EC2 の環境を判断しディレクトリを変更
- cron/cehck_loop.rb  
check_loop.shから呼び出される  
cron/status/srtmxf_crontab に情報を登録する
- cron/exec_ffmpeg.sh  
cron/status/srtmxf_crontab の情報に基づいて ffmpeg を実行する
- cron/staus/srtmxf_crontab    
アプリ用 crontab ファイル  
ffmpeg をキックすると exec_ffmpeg によってコメント対象行をコメントアウトする  


