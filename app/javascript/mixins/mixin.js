
export default {
    data () {
      return {
        greeting: '',
        world: 'World',
        status_str: {
          0: "0:配信設定 登録待機(WAIT)", 
          1: "1:配信設定 登録完了(Setup completed)",
          5: "5:配信開始待 (Waiting for server start)",
         10: "10:サーバースタート (server is running, Waiting SRT Stream)",
         20: "15:配信録画/ファイル生成中(Receiving and recording)",
         30: "30:配信完了(completed)",
         99: "50:配信削除済"
        }
      }
    },

    methods: {
        // datetime型から 日付部分を切り出す
        g_dd_date: function(x) {
          let tmpstr = new String(x);
          return tmpstr.substring(0,10);
          // return tmpstr.substr(0,10);
        },
        // datetime型から 時刻部分を切り出す
        g_dd_time: function(x) {
          let tmpstr = new String(x);
          return tmpstr.substring(11,16);
          // return x.substr(11,5);
        },
        g_get_status: function(x) {
          return this.status_str[x];
        },
        g_sleep: function(waitMsec) {
          var startMsec = new Date();
          while (new Date() - startMsec < waitMsec);
        }
 
    },
    computed: {
      hello: function () {
        return this.greeting + ' ' + this.world + '!'
      }
    }
}