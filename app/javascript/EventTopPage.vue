<template>
  <div id="app">
    <center> <!--// Title --->
      <p></br></p>    
      <img src="/assets/srt_icon.png" alt="SRT" width="150px" >
      <p></br></p>    
      <h2><i class="bi bi-camera-reels"></i>&nbsp;SRT-MXF Recorder.Prototype v0.11</h2>
      <p></br></p> 
    </center>

    <!--- ROW 1 --->
    <div class="row"> 
        <div class="col-1"></div>
        <div class="col-3">
            <a class="btn btn-outline-primary btn-lg  w-fixs" href="/#/list" role="button">イベント一覧&nbsp;(LIST)</a>
        </div>
        <div class="col-8 d-flex align-items-center menu-msg">
            イベント一覧を表示します。イベント内容確認、修正、削除ができます
        </div>
    </div>
    </br>
    <!--- ROW 2 --->
    <div class="row"> 
        <div class="col-1"></div>
        <div class="col-3">
            <a class="btn btn-outline-primary btn-lg  w-fixs" href="/#/events/new" role="button">イベント作成&nbsp;(CREATE)</a>
        </div>
        <div class="col-8 d-flex align-items-center menu-msg">
            イベントを新規に作成します
        </div>
    </div>
    </br>
    <!--- ROW 3 --->
    <div class="row"> 
        <div class="col-1"></div>
        <div class="col-3">
            <a class="btn btn-outline-primary btn-lg  w-fixs" href="/#/setting" role="button">設定&nbsp;(SETTINGS)</a>
        </div>
        <div class="col-8 d-flex align-items-center menu-msg">
            各種設定を行います
        </div>
    </div>
    </br>



  </div> <!--// end of id="app" -->
</template>

<script>
// import axios from 'axios';

export default {
  data: function () {
    return {
      message00: "オペレーションしてください",
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