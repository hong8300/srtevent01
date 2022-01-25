<template>
  <div id="app">
    <p></br></p>    
    <!-- https://icons.getbootstrap.jp/ -->
    <h2><i class="bi bi-card-list"></i>&nbsp;イベント一覧</h2>
    <p></br></p>
    <p>イベントの詳細を確認するには「イベント詳細」からご確認ください。</br></p>
    <div class="row"> <!--- オペレーションボタン -->
      <div class="col-2"></div>
      <div class="col-10">
        <table class="table">
          <tr>
          <td></td>
          <td style="text-align:right;">
            <button @click="reloadPage()">表示リセット</button>
            <router-link :to="{ name: 'EventTopPage'  }" tag="button"><i class="bi bi-house"></i>&nbsp;HOME</router-link>&nbsp;
          </td>
          </tr>
        </table>
      </div>
    </div>

    <div v-if="errors.length != 0">
      <ul v-for="e in errors" :key="e">
        <li><font color="red">{{ e }}</font></li>
      </ul>
    </div>
    <table class="table table-striped">
      <tbody>
        <tr>
          <th>イベントID</th>
          <th>イベント名</th>
          <th>概要</th>
          <th>配信/録画開始時刻</th>
          <th>担当者</th>
          <th>ステータス</th>
          <th>オペレーション</th>          
        </tr>
        <tr v-for="e in events" :key="e.id">
          <td>{{ e.id }}</td>
          <td>{{ e.name }}</td>
          <td>{{ e.description }}</td>
          <td>{{ g_dd_date(e.rec_starttime) }} {{ g_dd_time(e.rec_starttime) }} </td>
          <td>{{ e.sdata1 }}</td>

          <!-- 1: "1:配信設定 登録完了(Setup completed)",
          5: "5:配信開始待 (Waiting for server start)",
         10: "10:サーバースタート (server is running, Waiting SRT Stream)",
         20: "15:配信録画/ファイル生成中(Receiving and recording)",
         30: "30:配信完了(completed)", -->

          <td v-if = "e.status == 1">
            <font color="Gray">
              <b>  {{ g_get_status(e.status) }}</b>
            </font>
          <td v-else-if = "e.status == 5">
            <font color="Blue">
              <b>  {{ g_get_status(e.status) }}</b>
            </font>
          <td v-else-if = "e.status == 10">
            <font color="Orange">
              <b>  {{ g_get_status(e.status) }}</b>
            </font>
          <td v-else-if = "e.status == 20">
            <font color="RED">
              <b>  {{ g_get_status(e.status) }}</b>
            </font>
          <td v-else-if = "e.status == 30">
            <font color="Skyblue">
              <b>  {{ g_get_status(e.status) }}</b>
            </font>
          <td v-else-if = "e.status == 40">
            <font color="Darkkhaki">
              <b>  {{ g_get_status(e.status) }}</b>
            </font>
          <td v-else-if = "e.status == 50">
            <font color="Green">
              <b>  {{ g_get_status(e.status) }}</b>
            </font>
          <td v-else>
            <font color="PINK">
              <b>  {{ g_get_status(e.status) }}</b>
            </font>
          </td>
          <td>
              <router-link :to="{ name: 'EventDetailPage', params: { id: e.id } }" tag="button"><i class="bi bi-file-bar-graph"></i>&nbsp;イベント詳細</router-link>&nbsp;
              <button @click="deleteTarget = e.id; showModal = true">{{e.id}}: 削除</button>
              <!-- <button v-if = "e.status == 50" onclick="location.href='/downloads/mxfrec-file-00002.mp4'">{{ e.id }}:プレビューPROXY</button> -->
              <button v-if = "e.status == 50" @click="g_jurl(e.id)"> プレビューMP4 PROXY </button> 
          </td>
        </tr>
      </tbody>
    </table>
    <modal v-if="showModal" @cancel="showModal = false" @ok="deleteEvent(); showModal = false;">
      {{ deleteTarget }}
      <div slot="body"><b>イベントID:{{deleteTarget}}</b></br>本当に削除してもよろしいですか？  </div>
    </modal>

    <div class="row"> <!--- オペレーションボタン -->
      <div class="col-2"></div>
      <div class="col-10">
        <table class="table">
          <tr>
          <td></td>
          <td style="text-align:right;">
            <button @click="reloadPage()">表示リセット</button>
            <router-link :to="{ name: 'EventTopPage'  }" tag="button"><i class="bi bi-house"></i>&nbsp;HOME</router-link>&nbsp;
          </td>
          </tr>
        </table>
      </div>
    </div>

  </div>
</template>

<script>
import axios from 'axios';
import Mixin from './mixins/mixin';
import Modal from 'Modal.vue'

export default {
  mixins: [Mixin],
  components: {
    Modal
  },
  data: function () {
    return {
      events: [],
      testmessage: "Vue.js メッセージ",
      showModal: false,
      deleteTarget: -1,
      errors: '',
      rerolad_timer: ''
    }
  },
  methods: {
    jurl: function(id) {      
        console.log(id)
        var ret = ( '00000' + id ).slice( -5 );
        var urls = "/downloads/mxfrec-file-"+ ret + ".mp4"
        console.log(urls)
        // location.href='/downloads/mxfrec-file-00003.mp4'
        location.href=urls
    },
    // dd_date: function(x) {
    //     return x.substr(0,10);
    // },
    // dd_time: function(x) {
    //     return x.substr(11,5);
    // },
    // reset: function () {
    //   this.$router.go({path: this.$router.currentRoute.path, force: true})
    // },

    deleteEvent: function() {
      if (this.deleteTarget <= 0) {
        console.warn('deleteTarget should be grater than zero.');
        return;
      } 


      axios
        .delete(`/api/v1/events/${this.deleteTarget}`)
        .then(response => {
          this.deleteTarget = -1;
          this.updateEvents();
        })
        .catch(error => {
          console.error(error);
          if (error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        });
    },
    updateEvents: function() {
      // console.log("Now in updateEvents()")
      axios
        .get('/api/v1/events.json')
        .then(response => (this.events = response.data))
    },
    reloadPage: function () {
      // console.log(this.$router.currentRoute.path)
      // this.g_sleep(5000) 
      if ( this.$router.currentRoute.path == "/list") {
        this.$router.go({path: this.$router.currentRoute.path, force: true})
      }
    }



  },
  mounted () {
    this.reload_timer = this.updateEvents();
    setInterval(this.reloadPage, 20000); 

  },
  destroyed() {
    clearInterval(this.reload_timer);
  }

}
</script>

<style scoped>
p {
  font-size: 1em;
  /* text-align: center; */
}
</style>