<template>
  <div id="app">
    <p></br></p>    
    <h2><i class="bi bi-file-bar-graph"></i>&nbsp;イベント詳細</h2>
    <p></br></p>

    <div class="row"><!--- メッセージ -->
      <div class="col-1"></div>
        <div class="col-10">
        イベントの内容を確認してください。  
        </div>
      <div class="col-1"></div>
    </div>

    <div class="row"> <!--- オペレーションボタン -->
      <div class="col-1"></div>
      <div class="col-10">
        <table class="table">
          <tr>
          <td></td>
          <td style="text-align:right;">
            <router-link :to="{ name: 'EventTopPage'  }" tag="button"><i class="bi bi-house"></i>&nbsp;HOME</router-link>&nbsp;
            <router-link :to="{ name: 'EventListPage' }" tag="button"><i class="bi bi-card-list"></i>&nbsp;イベント一覧</router-link>&nbsp;
            <router-link :to="{ name: 'EventEditPage', params: { id: event.id } }" tag="button"><i class="bi bi-pencil"></i>&nbsp;イベント修正</router-link>&nbsp;
          </td>
          </tr>
        </table>
      </div>
    </div>

    <div class="row"> <!-- データ内容 --->
      <div class="col-1"></div>
      <div class="col-10">
        <table class="table">
          <tr>
            <td><b>イベントID</b></td>
            <td>{{ event.id }}</td>
          </tr>
          <tr>
            <td><b>イベント名</b></td>
            <td>{{ event.name }}</td>
          </tr>
          <tr>
            <td><b>概要</b></td>
            <td>{{ event.description }}</td>
          </tr>
          <tr>
            <td><b>配信/録画開始時刻</b></td>
            <td>{{ g_dd_date(event.rec_starttime) }} {{ g_dd_time(event.rec_starttime) }} </td>
          </tr>
          <tr>
            <td><b>担当者</b></td>
            <td>{{ event.sdata1 }}</td>
          </tr>
          <tr>
            <td><b>ステータス</b></td>
            <td>{{ g_get_status(event.status) }}</td>
          </tr>
          <tr>
            <td><b>MXFファイル名</b></td>
            <td>{{ event.output_filename }}</td>
          </tr>
          <tr>
            <td><b>サーバー</b></td>
            <td>{{ event.server_url }}</td>
          </tr>
          <tr>
            <td><b>ポート</b></td>
            <td>{{ event.server_port }}</td>
          </tr>
          <tr>
            <td><b>パスフェーズ</b></td>
            <td>{{ event.passphrase }}</td>
          </tr>
        </table>
      </div>
    </div>
    </br>

    <div class="row"><!--- メッセージ -->
      <div class="col-1"></div>
        <div class="col-10">
        <h5><font color="red">注意事項</font></h5>
        <div class="border border-danger" style="padding:10px;">
          イベントの録画、ファイル生成は <b>{{g_dd_date(event.rec_starttime)}}</b> の <b>{{g_dd_time(event.rec_starttime)}}</b> に開始されます。</br>
          サーバー側は SRT Listener モードで上記時間に待機しますので、SRT配信機器側（映像打ち上げ）はこの時刻よりあとに配信を開始(CALLER)してください。</br>
          </br>
          SRT配信機器では以下の設定で ストリームをサーバーに配信してください。</br>
          サーバーアドレスおよびポート: <b>srt://{{event.server_url}}:{{event.server_port}}</b></br>
          配信モード: <b>CALLER モード</b></br>
          パスワード(AES128): <b>{{event.passphrase}}</b></br>
        </div>
        </br>
        <h5><font color="blue">サンプル</font></h5>
        <div class="border border-primary" style="padding:10px;">
          ffmpeg 打ち上げサンプル(AWS):</br>
          &nbsp;&nbsp;&nbsp;&nbsp;<b>ffmpeg -re -f lavfi -i testsrc=s=1920x1080:r=29.96 -vcodec h264 -pix_fmt yuv420p -f mpegts "srt://{{event.server_url}}:{{event.server_port}}?mode=caller&passphrase={{event.passphrase}}"</b><br>
          ffmpeg 打ち上げサンプル(Mac):</br>
          &nbsp;&nbsp;&nbsp;&nbsp;<b>ffmpeg -re -f lavfi -i testsrc=s=1920x1080:r=29.96 -vcodec h264 -pix_fmt yuv420p -f mpegts "srt://:{{event.server_port}}?mode=caller&passphrase={{event.passphrase}}"</b><br>
        </div>
        </br></br>
        </div>
      <div class="col-1"></div>
    </div>


    <div class="row"> <!--- オペレーションボタン -->
      <div class="col-1"></div>
      <div class="col-10">
        <table class="table">
          <tr>
          <td></td>
          <td style="text-align:right;">
            <router-link :to="{ name: 'EventTopPage'  }" tag="button"><i class="bi bi-house"></i>&nbsp;HOME</router-link>&nbsp;
            <router-link :to="{ name: 'EventListPage' }" tag="button"><i class="bi bi-card-list"></i>&nbsp;イベント一覧</router-link>&nbsp;
            <router-link :to="{ name: 'EventEditPage', params: { id: event.id } }" tag="button"><i class="bi bi-pencil"></i>&nbsp;イベント修正</router-link>&nbsp;
          </td>
          </tr>
        </table>
      </div>
    </div>


  </div> <!-- end of id="app" -->
</template>

<script>
import axios from 'axios';
import Mixin from './mixins/mixin';

export default {
  mixins: [Mixin],
  data: function () {
    return {
      event: {}
    }
  },
  mounted () {
    axios
      .get(`/api/v1/events/${this.$route.params.id}.json`)
      .then(response => (this.event = response.data))
  }
}
</script>

<style scoped>

</style>