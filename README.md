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
### cron/check_loop.sh  
##### 1分毎起動,AWS/Mac での動作環境を環境変数にて設定
- mode: exec_check  
cron/check_loop.rb を起動  
ステータスファイルを見て status/srtmxf_crontab を生成  
- mode: exec_kick  
cron/check_kick.rb を起動  
job管理ファイルを参照し、ffmpeg をキックする

### cron/check_loop.rb  
- check_loop.shから呼び出される
- cron/status/srtmxf_crontab に情報を登録する
  
### cron/check_kick.rb  
- cron/status/srtmxf_crontab の情報に基づいて ffmpeg を実行する
- cron/kick_ffmpeg.sh を非同期モードで呼び出す
- ffmpeg をキックが完了するおと srtmxf_crotab の該当行をコメントアウトする
  
### cron/staus/srtmxf_crontab (.bk,.new,.tmp)
- アプリ用 crontab ファイル  
- .bk .new .tmp ファイルはワークファイル

## ffmpeg listener モード（配信側） サンプル
```
ffmpeg -re -f lavfi -i testsrc=s=1920x1080:r=29.96 -vcodec h264 -pix_fmt yuv420p -f mpegts "srt://:9807?mode=caller&passphrase=FFdPhosmHZvNqPlQ"
```

## Rails API　によるアクセス方法 (curl)
- イベント情報（リスト）
```
curl -X GET -H 'Content-Type:application/json' http://0.0.0.0:3000/api/v1/events
```
- イベント情報取得（個別）
```
curl -X GET -H 'Content-Type:application/json' http://0.0.0.0:3000/api/v1/events/1
```
- イベント情報更新（個別）
```
curl -X PUT -H 'Content-Type:application/json' -d '{ "status":2 }' http://0.0.0.0:3000/api/v1/events/1
```

## 対応済
- Reload バグ
- Setting 画面
- AWS UDP/9000ポート開放
- 削除処理で cron 登録も削除
- 過去のイベントを登録できないようにする(バリデート)
- 録画開始、終了のステータス確認方法
- AWS での動作確認
- ダウンロード機能
- Preview 機能

## 残作業
- AWS:FSx 接続

### Mac 初期化して開始（手順)
#### cron を動作させる
```
crontab -l
*/1 * * * * /Users/hong/RAILS/srtevent/cron/check_loop.sh 
*/1 * * * * /Users/hong/RAILS/srtevent/cron/exec_ffmpeg.sh
```

#### 初期化・開始
```
cd /Users/hong/RAILS/srtevent
rails db:migirate:reset
rm cron/status/*
rails s
```
#### ffmpeg 監視 sh
```
cron/ctest.sh
```
#### 配信開始方法：Webイベント詳細ページから テストパターン送出コマンドを発行
```
ffmpeg -re -f lavfi -i testsrc=s=1920x1080:r=29.96 -vcodec h264 -pix_fmt yuv420p -f mpegts "srt://:9802?mode=caller&passphrase=OrEOFv52v2mUf7cI"
```
#### 配信終了方法：送出した上記コマンドを停止させる
