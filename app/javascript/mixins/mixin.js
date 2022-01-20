
export default {
    data () {
      return {
        greeting: '',
        world: 'World',
        status_str: {
          0: "00:配信設定 登録待機(WAIT)", 
          1: "01:配信設定 登録完了(Setup completed)",
          5: "05:配信開始待 (Waiting for server start)",
         10: "10:サーバースタート (server is up, Waiting SRT Stream)",
         20: "20:配信録画/ファイル生成中(Recording MXF)",
         30: "30:配信録画完了(Waitting for convert)",
         40: "40:プロキシー生成中(Converting MP4)",
         50: "50:完了(All Completed)",
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