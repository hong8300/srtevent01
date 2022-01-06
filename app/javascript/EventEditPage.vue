<template>
  <div id="app">
    <p></br></p>    
    <h2><i class="bi bi-pencil"></i>&nbsp;イベント修正</h2>
    <p></br></p>

    <div class="row">  <!--- MESSAGE --->
        <div class="col-1"></div>
        <div class="col-11">
            イベント名、概要を修正してください。</br>
            配信/録画開始時刻を修正する場合は、イベントを一度削除してから再度設定してください。
        </div>
    </div>

    </br>

    <div class="row"> <!--- オペレーションボタン -->
      <div class="col-2"></div>
      <div class="col-10">
        <table class="table">
          <tr>
          <td></td>
          <td style="text-align:right;">
            <router-link :to="{ name: 'EventTopPage'  }" tag="button"><i class="bi bi-house"></i>&nbsp;HOME</router-link>&nbsp;
            <router-link :to="{ name: 'EventListPage' }" tag="button"><i class="bi bi-card-list"></i>&nbsp;イベント一覧</router-link>&nbsp;
          </td>
          </tr>
        </table>
      </div>
    </div>

    <form @submit.prevent="updateEvent">

        <div class="row">  <!--- ERROR MESSAGE AREA --->
            <div class="col-4"></div>
            <div class="col-8">
                <div v-if="errors.length != 0">
                    <ul v-for="e in errors" :key="e">
                    <li><font color="red">{{ e }}</font></li>
                    </ul>
                </div>
            </div>
        </div>
        </br>

        <div class="row">
            <div class="col-1"></div>
            <div class="col-3"><b>イベントID</b></div>
            <div class="col-8">{{ event.id }}</div>
        </div>
        </br>

        <div class="row"> 
            <div class="col-1"></div>
            <div class="col-3"><b>イベント名</b></div>
            <div class="col-8"><input v-model="event.name" type="text"></div>
        </div>
        </br>
        <div class="row"> 
            <div class="col-1"></div>
            <div class="col-3"><b>イベント概要</b></div>
            <div class="col-8"><input v-model="event.description" type="text"></div>
        </div>
        </br>
        <div class="row">  
            <div class="col-1"></div>
            <div class="col-3"><b>配信/録画開始時刻</b></div>
            <div class="col-8">{{ g_dd_date(event.rec_starttime) }} {{ g_dd_time(event.rec_starttime) }} </div>
        </div>
        </br>
        <div class="row"> 
            <div class="col-1"></div>
            <div class="col-3"><b>担当者</b></div>
            <div class="col-8"><input v-model="event.sdata1" type="text"></div>
        </div>
        </br>
        <div class="row">
            <div class="col-1"></div>
            <div class="col-3"><b>ステータス</b></div>
            <div class="col-8">{{ g_get_status(event.status) }} </div>
        </div>
        </br>
        <div class="row"> 
            <div class="col-1"></div>
            <div class="col-3"><b>MXFファイル名尾</b></div>
            <div class="col-8">{{ event.output_filename }} </div>
        </div>
        </br>
        <div class="row"> 
            <div class="col-1"></div>
            <div class="col-3"><b>サーバーアドレス、ポート</b></div>
            <div class="col-8">{{ event.server_url }}:{{ event.server_port}} </div>
        </div>
        </br>
        <div class="row"> 
            <div class="col-1"></div>
            <div class="col-3"><b>パスフレーズ</b></div>
            <div class="col-8">{{ event.passphrase }}</div>
        </div>
        </br>

        <div class="row"> <!--- SUBMIT ---> 
            <div class="col-4"></div>
            <div class="col-8"><button type="submit">修正を反映させる</button></div>
       </div>
  </form>

    <div class="row"> <!--- オペレーションボタン -->
      <div class="col-2"></div>
      <div class="col-10">
        <table class="table">
          <tr>
          <td></td>
          <td style="text-align:right;">
            <router-link :to="{ name: 'EventTopPage'  }" tag="button"><i class="bi bi-house"></i>&nbsp;HOME</router-link>&nbsp;
            <router-link :to="{ name: 'EventListPage' }" tag="button"><i class="bi bi-card-list"></i>&nbsp;イベント一覧</router-link>&nbsp;
          </td>
          </tr>
        </table>
      </div>
    </div>

  </div> <!--- end of <div class="app" --->
</template>

<script>
import axios from 'axios';
import Mixin from './mixins/mixin';

export default {
  mixins: [Mixin],
  data: function () {
    return {
      event: {},
      errors: ''
    }
  },
  mounted () {
    axios
      .get(`/api/v1/events/${this.$route.params.id}.json`)
      .then(response => (this.event = response.data))
  },
  methods: {
    updateEvent: function() {
      axios
        .patch(`/api/v1/events/${this.event.id}`, this.event)
        .then(response => {
          this.$router.push({ name: 'EventDetailPage', params: { id: this.event.id } });
        })
        .catch(error => {
          console.error(error);
          if (error.response.data && error.response.data.errors) {
            this.errors = error.response.data.errors;
          }
        });
    }
  }



}
</script>

<style scoped>
</style>