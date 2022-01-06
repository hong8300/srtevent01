<template>
  <div id="app">
    <p></br></p>    
    <h2><i class="bi bi-calendar-event"></i>&nbsp;イベント作成</h2>
    <p></br></p>

    <div class="row">  <!--- MESSAGE --->
        <div class="col-1"></div>
        <div class="col-11">
            イベント名、概要を設定し、配信録画開始時刻を設定してください。
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
          </td>
          </tr>
        </table>
      </div>
    </div>

    <form @submit.prevent="createEvent">

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

        <div class="row"> <!--- INPUT AREA 1---> 
            <div class="col-1"></div>
            <div class="col-3"><b>イベント名</b></div>
            <div class="col-8"><input v-model="event.name" type="text"></div>
        </div>
        </br>
        <div class="row"> <!--- INPUT AREA 2---> 
            <div class="col-1"></div>
            <div class="col-3"><b>イベント概要</b></div>
            <div class="col-8"><input v-model="event.description" type="text"></div>
        </div>
        </br>
        <div class="row"> <!--- INPUT AREA 3---> 
            <div class="col-1"></div>
            <div class="col-3"><b>配信/録画開始時刻</b></div>
            <div class="col-8"><input v-model="event.rec_starttime" type="datetime-local"></div>
        </div>
        </br>
        <div class="row"> <!--- INPUT AREA 4---> 
            <div class="col-1"></div>
            <div class="col-3"><b>担当者</b></div>
            <div class="col-8"><input v-model="event.sdata1" type="text"></div>
        </div>
        </br>
        <div class="row"> <!--- SUBMIT ---> 
            <div class="col-4"></div>
            <div class="col-8"><button type="submit">イベントを登録する</button></div>
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
          </td>
          </tr>
        </table>
      </div>
    </div>

  </div> <!--- end of <div class="app" --->
</template>

<script>
import axios from 'axios';

export default {
  data: function () {
    return {
      event: {
        name: '',
        description: '',
        rec_starttime: '',
        status: 0,
        output_filename: '',
        passphrase: '',
        server_url: '',
        server_port: 0,
        sdata1: '',
        sdata2: '',
        idata1: 0,
        idata2: 0
      },
      errors: ''
    }
  },
  methods: {
    createEvent: function() {
      axios
        .post('/api/v1/events', this.event)
        .then(response => {
          let e = response.data;
          this.$router.push({ name: 'EventDetailPage', params: { id: e.id } });
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