
export default {
    data () {
      return {
        greeting: '',
        world: 'World',
        status_str: {
          0: "配信設定 未完了", 
          1: "配信設定 完了",
         10: "配信待機(STREAM-WAIT)",
         20: "録画/ファイル生成中(REC)",
         30: "配信完了(FINISHED)"
        }
      }
    },

    methods: {
        // datetime型から 日付部分を切り出す
        g_dd_date: function(x) {
          return x.substr(0,10);
        },
        // datetime型から 時刻部分を切り出す
        g_dd_time: function(x) {
          return x.substr(11,5);
        },
        g_get_status: function(x) {
          return this.status_str[x];
        }
    },
    computed: {
      hello: function () {
        return this.greeting + ' ' + this.world + '!'
      }
    }
}