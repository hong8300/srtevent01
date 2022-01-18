<template>
  <div id="app">
    <center> <!--// Title --->
      <p></br></p>    
      <img src="/assets/srt_icon.png" alt="SRT" width="150px" >
      <p></br></p>    
      <h2><i class="bi bi-camera-reels"></i>&nbsp;Settings</h2>
      <p></br></p> 
    </center>

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

    <!--- ROW 1 --->
    <div class="row"> 
        <div class="col-1"></div>
        <div class="col-3">
            <a class="btn btn-outline-primary btn-lg  w-fixs" href="/" role="button">HOME&nbsp;(TOP)</a>
        </div>
        <div class="col-8 d-flex align-items-center menu-msg">
            {{ message }}
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

  </div> <!--// end of id="app" -->
</template>

<script>
export default {
  data: function () {
    return {
      message: "トップページにもどります",
      event: {}
    }
  },
  mounted () {
  }
}
</script>

<style scoped>

.menu-msg {
  font-size: 1.4em;
}

.w-fixs {
  width: 98% !important;
}
</style>