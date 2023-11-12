import {createRouter, createWebHistory} from 'vue-router'
import {RoutePath} from '@/constants/RoutePath'
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: RoutePath.HOME,
      name: 'home',
      component: () => import('../views/LoginView.vue')
    },
    {
      path: RoutePath.ABOUT,
      name: 'about',
      component: () => import('../views/AboutView.vue')
    },
    {
      path:RoutePath.LOGIN,
      name: 'login',
      component: () => import('../views/LoginView.vue')
    },
    {
      path:RoutePath.DASHBOARD,
      name: 'dashboard',
      meta: { requiresStore: true },
      component: () => import('../views/DashboardView.vue')
    },
    {
      path:RoutePath.USER_MANAGEMENT,
      name: 'user-management',
      meta: { requiresStore: true },
      component: () => import('../views/UsersManagement.vue')
    },
    {
      path:RoutePath.WORKING_TIME,
      name: 'working-time',
      meta: { requiresStore: true },
      component: () => import('../views/WortingTimes.vue')
    },
    {
      path:RoutePath.TEAMS,
      name: 'teams',
      meta: { requiresStore: true },
      component: () => import('../views/Teams.vue')
    },
    {
      path: `${RoutePath.TEAMS}/:id`,
      name: 'team-details',
      meta: { requiresStore: true },
      component: () => import('../views/TeamDetails.vue'),
    }
  ]
})

export default router
