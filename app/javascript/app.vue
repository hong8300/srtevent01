<template>
  <div>
    <nav class="navbar navbar-dark bg-primary">
    <div class="container-fluid">
      <span class="navbar-brand mb-0 h1">SRT-MXF Recorder</span>
    </div>
    </nav>
    <div class="container-fluid">
      <div class="row">
        <router-view></router-view>
      </div>
    </div>
  <footer class="footer">
  <div class="container-fluid">
    <p class="text-muted">Cloud Solution Dep., Tech.nology Development Division - &copy; 2022 Photron Inc, All Rights Reserved.</p>
  </div>
</footer>

  </div>
</template>

<script>
import Vue from 'vue'
import VueRouter from 'vue-router'

import EventListPage from 'EventListPage.vue'
import EventTopPage from 'EventTopPage.vue'
import EventDetailPage from 'EventDetailPage.vue'
import EventNewPage from 'EventNewPage.vue'
import EventEditPage from 'EventEditPage.vue'
                          
import 'bootstrap-icons/font/bootstrap-icons.css'

const router = new VueRouter({
  mode: 'hash',
  routes: [
    { path: '/list',
      name: 'EventListPage',
      component: EventListPage  },
    { path: '/',
      name: 'EventTopPage',
      component: EventTopPage  },
    { path: '/events/:id(\\d+)',  // :id は数値のみに制限する
      name: 'EventDetailPage',  // ルートに名前を付けている ref. https://router.vuejs.org/ja/guide/essentials/named-routes.html#%E5%90%8D%E5%89%8D%E4%BB%98%E3%81%8D%E3%83%AB%E3%83%BC%E3%83%88
      component: EventDetailPage  },
    { path: '/events/new',
      name: 'EventNewPage',
      component: EventNewPage    },
    { path: '/events/:id(\\d+)/edit',
      name: 'EventEditPage',
      component: EventEditPage   }
  ]
})

// ref. https://jp.vuejs.org/v2/guide/plugins.html#%E3%83%97%E3%83%A9%E3%82%B0%E3%82%A4%E3%83%B3%E3%81%AE%E4%BD%BF%E7%94%A8
Vue.use(VueRouter)

export default {
  router
}
</script>

<style scoped>
.wrapper{
    min-height: 100vh;
    position: relative;/*←相対位置*/
}

.footer {
    position: absolute;
    bottom: 0;
    width: 100%;
    height: 60px;
    text-align: center;
     padding:20px 0;

    background-color: #f5f5f5;
}
</style>
