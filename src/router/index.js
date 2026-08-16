import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'Visualization',
      component: () => import('@/views/Visualization.vue')
    },
    {
      path: '/index.html',
      name: 'Index',
      component: () => import('@/views/Visualization.vue')
    },
    {
      path: '/404',
      name: 'Error404',
      component: () => import('@/views/customErrorPages/Error404.vue')
    },
    {
      path: '/:pathMatch(.*)*',
      redirect: { name: 'Error404' }
    }
  ]
})

export default router
