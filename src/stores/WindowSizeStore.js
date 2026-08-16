import { defineStore } from 'pinia'

export const useWindowSizeStore = defineStore('WindowSizeStore', {
  state: () => ({
    usgsHeaderRendered: false,
    windowWidth: 0,
    windowHeight: 0,
  })
})
