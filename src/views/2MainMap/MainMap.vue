<template>
  <section id="main-map-section">
    <div
      class="text-content"
    >
      <div id="main-map-header">
        <h2>Wildfires pose a <span class="lowlight">growing risk</span> to our Nation’s water supplies</h2>
        <p>
          Wildfires are a natural process in many ecosystems, playing an important role in nutrient cycling and other ecological interactions. But the size, <a
            href="https://www.usgs.gov/centers/eros/science/monitoring-trends-burn-severity?qt-science_center_objects=0#qt-science_center_objects"
            target="_blank"
          >severity</a>, and the length of the fire season have increased substantially in the western U.S. over the past few decades, and these trends are predicted to continue.
        </p>
        <p>
          The year 2020 provided stark evidence that wildfires are changing the landscape of America. Over 8 million acres – almost the size of Connecticut and New Jersey combined – were ablaze this year, including the largest recorded fires in California and Colorado history. Wildfires burned watersheds on the western side of the Cascade Mountains in Oregon, a region that is typically very wet and where fires are rare. Over $3.2 billion has been spent to suppress these fires nationally, and thousands of people have evacuated their homes.
        </p>
      </div>
    </div>
    <div id="mappy">
      <div
        id="map-container"
        role="figure"
        aria-label="Bar chart showing acres burned by wildfires in the western United States each year from 1984 to 2020, with a trend of increasing burn area over time"
      >
        <div class="chart-title-container ">
          <p class="chart-title">
            Wildfire in the Western U.S. in relation to Important Watersheds
          </p>
          <p>1984 - 2020</p>
        </div>
        <div class="caption-container">
          <p class="caption ">
            <span class="lowlight">Click or hover</span> to view areas burned by wildfire in each year.
          </p>
          <p class="caption">
            <span class="lowlight">Click the play button</span> to replay the animation.
          </p>
        </div>     
        <svg
          id="map-legend"
          xmlns="http://www.w3.org/2000/svg"
          xmlns:xlink="http://www.w3.org/1999/xlink"
          viewBox="0 0 596.56 58.31"
          role="img"
          aria-label="Map legend showing symbols for area burned by wildfire and important water supply watersheds"
        >
          <g id="map-legend-group">
            <text
              transform="translate(190 13.21)"
              class="legend-text"
            >Area burned <tspan
              x="0"
              y="14"
            >by wildfire</tspan></text>
            <g
              id="icon_fire"
              transform="translate(140 0) scale(.7, .7)"
            >
              <path
                d="M22.8 8.8c.3 0 .7.1 1-.4-.6-.2-.7-.3-.5-1s-.1-1.6.1-2.4c.1-.4 0-.8.5-.9s.6.4.9.6a1.7 1.7 0 01.3.9c0 .5.1 1 .7.7.4-.2 1.2-.3.5-1-.3-.4 0-.7.3-1a2 2 0 011.8-.4c1 .3 1.7 1 2.7 1.2a.6.6 0 01.5.6 1.8 1.8 0 00.9 1.6c.4.3.3.6.2 1s-.3 1.3.3 1.3c.8-.1 1.9.7 2.3-.6A1.9 1.9 0 0137 7.7c.8 0 .6-.4.5-1-.3-1.4.1-2 1.6-2a1.8 1.8 0 001.7-1c.4-.9 1-.7 1.3-.1a1.4 1.4 0 002 .4c1.1-.6 2-1.1 3.3-.3h.7c2-.2 1.8-.5 2.8 1.4.1.3.2.6.5.6v2.1c-1.3.8-2 .8-2.8-.3a2.1 2.1 0 00-2.1-.9c-.5 0-1 .1-1-.7 0-.1.3-1.1-.6-1s-.2.7-.2 1c0 .8-.2 1.5.3 2.1-.2.3-.5.2-.7.4h.3l.4-.4c.5 0 1 0 1 .8a1.4 1.4 0 01-1 1.4c-.5.1-1.5.2-.4 1 .4.3 0 .4-.2.6s-.8 0-.8.4c0 .9-1 1.6-.7 2.4.4 1-.3.9-.8 1.1s-.3-.5-.7-.4c.3.1.5.3.2.6-.7 0-1.4.1-1.8-.5-.9.8-.2 2-.7 2.8 0 .2.2.3.4.3l1.2.1c.4 0 .5.4.6.7.5.4.5 1.1.2 1.3-1.4.4-.2 1.6-.8 2.3-.2.2.3.5.5.4a1.5 1.5 0 012.1.5 1.3 1.3 0 002 .1c.7-.5.7-.2 1 .4.4 1 .4 2.4 2 2.5.2 0 .2.2.2.4s-.1.5-.3.4c-.6-.5-1.4.3-2-.3-.4-.5-.9-.1-1.3-.1-1.7 0-1.7 0-1.5-1.7h-2a.7.7 0 00-.7.5c0 .4.3.4.6.4.4 0 .5.3.8.6.4.4.5.8-.3 1-1.1.3-2.4.3-3.6.7-.8.4-1.5-.2-2.2-.8.6 1.3-.3 1.4-1 1.5s-.7-.5-.8-1l-.8-1.8a1.2 1.2 0 010-.8c.1-.7.5-1.3-.6-1.4-.4 0-.2-.4-.2-.6.2-1.2-.5-1.8-1.6-2s-.8-.3-.5-1.3 1.1-1.1 1.8-1.5l.4-.2c1 1.2 1.3-.3 2-.4l.3-.3c-.4-1.1.9-1.8.8-2.8 0-.7-.4-1.2-1.2-1.2-.5 0-.7-.1-.9-.7a2 2 0 00-1.6-1.7c-.8 0-1 .8-1.3 1.4-.7 1.2-1.3 2.6-3.2 2.3a1.6 1.6 0 00-.8.2c-1.5.7-2.6.4-3.2-1-.3-.8-.5-.5-1-.2s-1.1.6-1.5.2c-.7-1-1.8-.7-2.8-.7s-1.7-.4-2.6-.4c-.7 0-.8-2-.2-2.7.4-.5.5-1.2 1-1.7a.3.3 0 000-.5c-.3-.2-.5-.5-.2-.8a1 1 0 011-.2c.5.2 1.1.4 1.2.7.8 2 2.2 1 3.4 1 .3-.5.4-1 1-.5z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M34.8 4.7l-.8.5a1 1 0 01-1.6-.7l-.5-3h.5a8.5 8.5 0 003.6.7c1.4 0 .8 1.2.9 1.7a.9.9 0 01-1.4.5 1.2 1.2 0 00-.4 0c-.3 0-.2.2-.3.3z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M51.4 12.3h-2c-.6 0-.8-.4-.4-.8a2.3 2.3 0 012.4-1z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M32.4 52.9v.2h-6.7v-.3c1.3-.6 2.7-.2 4.1-.3a3.7 3.7 0 012.6.4z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M19 53.1c0-.2 0-.4.2-.5a23.3 23.3 0 015.5.1c.3 0 .2.2.3.4z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M40.3 53.1c0-.3 0-.6.3-.7a3.7 3.7 0 00.9.2c1.5 0 1.6 0 1.5-1.4 1.4.2.5 1.3.7 2z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M16 52.9v.2h-3.5V53a4 4 0 013.6 0z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M24.7 52.7a13.8 13.8 0 01-5.5 0c.8-1 .3-2 0-3-.2-.6-.3-1 .1-1.6s-.3-.7-.2-1c.2-1.1-1-2-.5-3.1.3-.6-.7-.9-.8-1.4 0-.1-.1-.2 0-.2v-.1a1.9 1.9 0 001-2.7l.1-.4c.3-.1.5-.6 1-.4 1 .4 1 .3 1.7-.4-1-.2-1.1-1-1.6-1.6.2-1.6 1.7-1.8 2.8-2.4-1.1-.8-1.1-.8-2.4.2-.4-1.6-.2-2.3.8-3.2s1.9 0 2.6.3 1.9.4 2.2 1.4c.8-.5 1.7.1 2.5-.4s1.1-.3 1.2.6c.1.7.5.8 1.1.5a.9.9 0 011.3.6c.2.8.5 1 1.2 1a.5.5 0 01.6.4c.2.8.7 1.3.7 2.1 0 .6.6 1.4 0 1.7a2.4 2.4 0 01-2-.1 2.4 2.4 0 00-3.4 1.5 1.5 1.5 0 01-.5.8c-.6.4-1.2.7-1.2 1.6 0 .5-.8.5-1.3.6 1 1.5 1 2.2-.2 3.4-.5.5.3.6.2 1.2 0 .1-1-.4-.6.5.2.5-.8 0-1.1.6s-.4.3 0 .6c.2.1.5.4.2.6-.7.6-.3 1.2 0 1.8zM5.7 23.8l-1.6-1c-.2-.1-.7-.2-.5-.6s.5-1 1.1-.6a4.3 4.3 0 004 .2c1.7 1 1.7-.7 2-1.5a1.7 1.7 0 011-.7c1-.5 1.4-2 2.8-1.9.3 0 .7 0 .8.4s-.3.4-.4.6c-.4.7-1.2 1.2-1 2.3.1.5-.6 1 .2 1.5a1.8 1.8 0 001.8.2c.6-.2.8.1.6.6a4.3 4.3 0 00.7 3.8c.2.3.1.5-.4.6a6.7 6.7 0 00-1.3.3c-1 .4-1.7.9-1.6 2a.9.9 0 01-.3.8c-.9.8-2.2 1-3.2 1.6-1 .5-2.2-.2-3.1-.8a1.1 1.1 0 00-1.8.2 1.3 1.3 0 01-1.9.4 5.8 5.8 0 01-2.8-3.4c-.1-.7.3-1.2.7-1.2 1.2 0 1.6-1.2 2.6-1.5a1 1 0 00.4-.3c-.8-1.4 1-1 1.2-2z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M32.4 52.9h-6.7c.2-.8 1-.9 1.4-1.3-.8-.3-.5-1.2-.9-1.7-.1-.2 0-.4.3-.4.6 0 .8-.5 1.2-.8 1.4-1.2 3.2-1.2 4.8-1.7a.5.5 0 01.7.4c0 .4.2 1-.3 1.2-.4 0-.4.3-.5.7a9.1 9.1 0 000 3.6z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M38.2 36.3c1.1 0 1.3 1 1.3 1.7a3 3 0 001.4 2.5c1 .6-.5 1.3.2 1.8.1.1-.6.3-.9.3a19.9 19.9 0 01-3-.2c-.7-.1-.7-.3-.6-.8a11 11 0 00.2-4.4c0-.5-.2-1 .4-1.1.5-.6.8-.2 1 .2z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M38.2 36.3a.9.9 0 00-1-.2c-.2-.5 0-1.2-1-1.2-.5 0-.3-.7-.6-1.2a1.7 1.7 0 01-2.3.1 11 11 0 00-3.1-.8 6 6 0 002-1.6c.2-.4 1-.3 1.2.1.6.7 1 .7 1.4 0 .2-.4.6-.5 1-.7a1.7 1.7 0 01.7-.2 1.6 1.6 0 01.8.6c.2.4.4.8.8 1 .1.2.3.3.1.6z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M37 31.3c-.2 0-.3-.4-.5-.5a2.2 2.2 0 01-.5-.5c.1-.7.7-.4 1-.5 1.8-.3 3.4.7 5.4.5-.8.8-1.3 1.6.1 2 .5.1.3.5.2.7-.2.5-.9 1-1 1-1-1-2.2-.7-3.2-1l-.3-.3-.3-.6c-.5 0-.4-.7-.8-.8z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M49.2 43c-.2.6-.7.8-1.4.8a4.5 4.5 0 00-2.4.7c-.7.5-1.3 0-1.4-.6a3 3 0 00-1.9-2c-.1 0-.4-.1-.3-.3.3-.7 1.2-.8 1.5-1.6.2-.3.7 0 1 .4a12.4 12.4 0 005 2.6z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M16 52.9h-3.5a1.6 1.6 0 00-.6-1.2 1.6 1.6 0 01.1-2.4 1.4 1.4 0 012-.3c.2.1.5.2.4.5-.5 1.3.5.8 1 .8s1-.3 1 .2c.1.6.6 1.4-.1 2l-.2.4z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M41 43.6a1 1 0 011.2 1 2.3 2.3 0 01-1.8 2.2 4.3 4.3 0 01-2.8-1.2c-.2-.5.5-1.6 1.3-1.7a14.1 14.1 0 002.1-.3z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M43 51.2a1.1 1.1 0 01.4 1.4c-.2.5-.8.3-1.1.3-.6-.1-1.4.4-1.7-.5.3-.3 1-.4 0-.9s-1-1.2-.2-1.8c.4-.3.3-1.4 1.2-1s.4 1 .4 1.5c0 .8.9.4 1 1z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M9.4 5.2a1.5 1.5 0 01-1.8-1.3c-.1-.6 1-1.4 2-1.4s1.2 1 1.3 1.7c.2 1.2-.8.9-1.5 1z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M20.4 34.6c.4-1.3 1-1.8 2.2-.7.2.2.7 0 1 .5-.5.3-1 .7-1.6.6-.3 0-.5 0-.5.4s-.2.5-.5.4c-.8-.1-.9.5-1 1 0-.3 0-.7-.3-1 0-.5.9 0 .7-.6z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M17.1 15.6c0 .4 0 .7-.5 1s-.7-.2-1-.4c-.6-.5-.4-1.4-.9-2-.1-.2.2-.3.4-.3a2.1 2.1 0 012 1.7z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M41.2 19.3c-.4 0-.2-.6-.6-.7.5 0 .6-.5.9-.8a1.3 1.3 0 011.5-.4c.4 0 .2.5.2.8 0 .6-.5.6-.9.7s-1-.3-1 .4z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M30.1 24.1a3.2 3.2 0 001.6.6c.2 0 .2.2.2.4a.6.6 0 01-.5.4 2.5 2.5 0 01-1.8-1c0-.3.1-.4.5-.4z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M47 18.6c-1 .8-1.7.7-2.4-.2.7-.6 1.5 0 2.2-.4.2.1 0 .4.3.6z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M47.2 2.7c.4-.3.8-.8 1.3-.5a.5.5 0 010 .4c-.4.4-.9.2-1.3 0z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M17.8 42.3v.3c-.6-.4-.5-1-.5-1.7.5.4.4 1 .5 1.4z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M41.5 16c.1-.8-.6-.4-.8-.6.7-.7 1-.3 1.3.4a.4.4 0 01-.5.1z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M18.7 37.7c-.4.2-.8.4-1.2 0 .4-.6.8 0 1.2-.1h.2z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M22.8 8.8c-.4-.1-.7.2-1 .4.2-.3-.2-.4-.3-.7a1.8 1.8 0 011.3.3z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M16.3 39.4c.3.1.5.2.5.7-.4-.1-.7-.2-.6-.7z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M47 18.6c-.2-.1-.2-.4-.2-.6a.3.3 0 01.5 0c.2.2-.2.3-.2.6z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M36 30.3a.5.5 0 01.5.5h-.8z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M20.4 35.1c.4.3.4.4 0 .5l-.7.1c0-.5.6-.2.7-.6z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M18.7 37.7a.5.5 0 000-.1 1.7 1.7 0 011 0 1.7 1.7 0 01-1 .1z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M34.8 4.7c0-.3-.5-.4-.2-.7s.3.2.4.4z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M41.4 12.8a1.4 1.4 0 01-.8 2.1c-.4.1-.7-.6-.7-.9.1-1 1-.8 1.5-1.2z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M39.8 23.5c-.7.7-1.2.5-1.7-.3.6 0 1.1.4 1.6.3z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M38.8 20a3.9 3.9 0 01-1.8 0 2.9 2.9 0 011.8 0z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M44.1 8.6l-.4-.4c0-.3.3-.1.5-.2h.7l-.2.6a1.7 1.7 0 00-.6 0z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M44.1 8.6c.2-.4.4-.3.6 0-.2.3-.4.5-.6 0z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M23 45.7c-1.2 2.1-1.1 2-2.6 1 1-.2 1.5-1.3 2.6-1.2.2 0 .2 0 0 .2z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M23 45.7a.4.4 0 010-.2 3 3 0 001.3-.3v.1c-.3.6-.8.3-1.2.4z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M24.3 45.4a.4.4 0 000-.2l.6-.3v.3c0 .3-.3.2-.6.2z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M24.4 34.8l-.2-.1c0-.1 0-.3.2-.2a.4.4 0 01.2.1c0 .1 0 .2-.2.2z"
                fill="rgb(245,169,60)"
              />
              <path
                d="M37 31.3c.6 0 .6.6.9.9-1 .3-.6-.6-.8-1z"
                fill="rgb(245,169,60)"
              />
            </g>
            <text
              transform="translate(315.9 13)"
              class="legend-text"
            >Important water <tspan
              x="0"
              y="14"
            >supply watersheds</tspan></text>
            <polygon
              transform="translate(136 0) scale(.7, .7)" 
              points="234.74 7.93 234.95 7.93 235.56 8.11 236.18 8.47 236.8 8.47 236.8 9.02 237.62 9.02 238.03 9.38 238.44 9.38 238.44 9.93 238.03 10.47 238.24 10.47 238.24 11.56 237.83 12.1 237.83 12.65 237.62 12.65 237.62 13.01 237.21 13.55 237.21 13.92 236.8 14.46 236.8 14.64 236.39 15.01 235.97 15.37 235.97 15.73 235.77 15.73 235.77 16.28 235.36 16.28 235.36 16.82 234.95 17.18 234.95 17.91 234.53 18.09 234.12 18.09 234.12 19.36 234.74 19.36 235.15 19.72 235.36 19.91 235.97 19.91 236.39 20.09 236.39 20.99 235.97 20.99 235.97 21.72 235.77 22.08 235.77 22.81 236.59 22.81 237 23.17 236.59 23.53 236.59 23.9 237 23.9 237 24.44 237.62 24.98 238.03 24.98 238.03 25.71 238.44 26.07 238.86 26.25 239.27 26.25 239.47 26.62 240.09 26.44 240.71 26.44 240.71 27.34 241.12 27.34 241.12 27.89 241.53 27.89 241.53 28.07 242.15 28.07 242.36 28.43 242.36 28.8 242.77 28.8 242.77 29.52 242.36 29.7 241.74 30.43 241.33 30.61 241.33 31.15 241.12 31.34 241.12 31.7 240.5 31.88 240.3 31.88 239.68 32.6 239.47 32.97 239.27 33.33 238.86 33.33 238.65 33.51 237.83 33.51 237.83 34.42 237.42 34.6 237.21 34.6 236.8 35.15 236.39 35.51 236.39 35.87 236.18 35.87 235.77 36.96 235.77 38.23 235.15 38.23 234.74 38.05 234.12 38.05 233.3 38.41 232.89 38.23 232.68 38.23 232.27 37.87 231.03 37.68 230.42 37.68 230.42 37.87 229.8 38.23 229.18 38.59 228.56 38.95 228.15 38.95 227.74 39.14 227.33 39.5 226.71 39.68 226.09 40.04 225.68 40.59 226.3 40.77 226.92 40.59 227.74 40.22 228.56 40.22 228.98 40.04 231.65 40.04 232.27 39.86 232.48 39.86 233.3 40.04 233.5 40.59 233.92 40.95 234.12 41.31 234.74 41.31 234.74 41.68 233.92 42.22 233.3 42.4 232.68 42.95 232.06 43.13 231.86 43.67 231.45 44.03 231.45 44.4 231.03 44.58 231.03 44.94 230.62 45.3 230.01 45.3 229.59 45.67 229.18 45.67 228.77 46.03 228.77 46.57 229.18 46.94 229.39 47.3 230.01 48.21 230.01 49.48 230.42 49.66 230.42 50.02 230.21 50.57 230.21 50.93 229.59 50.93 229.18 50.38 228.56 50.2 228.56 49.66 228.15 49.48 228.15 48.21 227.74 48.02 227.74 47.66 227.33 46.94 227.33 46.57 226.92 46.21 226.92 45.12 227.33 44.22 227.74 43.85 226.71 43.85 225.89 44.22 225.89 44.4 225.48 44.94 225.48 45.85 225.07 46.57 224.45 47.3 223.42 47.84 222.8 48.57 222.8 48.93 222.6 49.11 222.6 50.02 222.39 50.2 222.39 50.75 222.18 50.75 222.18 50.93 221.77 51.29 221.36 51.29 221.36 52.56 220.95 52.56 220.95 52.92 220.54 53.29 220.13 52.92 219.92 52.74 219.3 52.74 219.1 52.56 219.1 52.02 218.68 51.65 218.27 51.65 218.07 51.47 217.66 51.11 217.66 50.75 216.83 50.75 216.42 50.38 216.21 50.56 215.8 50.56 215.8 50.02 215.19 49.66 214.57 49.48 214.57 49.66 214.16 49.66 214.16 49.48 213.54 49.48 213.54 50.2 212.92 50.2 212.51 50.56 212.3 50.93 212.1 50.93 212.1 50.56 211.69 50.2 211.27 50.2 211.07 49.84 211.07 48.93 210.66 48.75 210.66 47.12 210.25 46.94 209.42 46.94 209.22 46.03 209.22 45.85 209.42 45.85 209.42 45.12 207.98 45.12 207.36 44.76 207.36 44.58 207.16 44.22 206.13 44.22 205.92 44.03 205.72 43.67 205.51 43.67 205.1 43.49 205.1 43.13 204.89 42.95 204.89 42.04 205.1 41.68 205.31 41.86 205.92 41.86 205.92 40.95 206.75 40.59 207.57 40.59 207.57 39.86 207.78 39.86 207.78 38.95 207.36 38.77 207.36 37.68 207.78 37.5 207.36 36.78 207.36 36.6 207.16 36.05 207.16 35.51 206.75 35.14 206.75 34.42 206.95 34.06 206.95 33.51 206.75 33.69 206.34 33.69 206.13 33.33 206.13 32.42 206.54 32.42 206.54 31.52 206.95 31.33 206.95 30.06 206.75 29.7 205.92 29.7 205.72 29.34 205.1 28.98 204.89 28.79 204.89 28.43 204.48 28.25 203.87 27.34 203.87 26.25 202.22 26.25 201.81 26.44 201.81 26.07 201.4 26.07 200.98 25.53 200.98 25.17 200.57 24.62 200.16 24.62 200.16 24.44 199.75 23.9 199.75 23.17 200.16 22.81 200.37 22.81 200.37 22.45 199.95 21.72 199.95 20.45 200.37 20.45 200.78 20.27 201.4 20.27 201.4 20.09 202.01 19.72 202.63 19.72 202.63 19.36 203.04 19.36 203.45 19 203.87 19 203.87 18.64 204.48 18.64 204.48 18.27 204.89 18.09 205.1 17.73 205.72 17.73 205.92 17.36 207.36 17.36 207.78 17 208.39 16.28 209.22 15.91 210.25 15.91 210.45 15.37 211.07 15.37 211.69 14.82 212.72 14.82 213.13 14.46 213.54 14.1 214.36 13.37 214.77 13.19 215.8 12.1 216.01 12.1 216.42 11.74 217.04 11.38 218.27 10.83 218.69 10.47 219.3 9.74 219.71 9.38 220.54 8.47 220.33 8.47 220.33 7.93 220.95 7.57 220.95 7.02 221.36 6.48 221.57 6.3 221.57 5.75 221.98 5.03 221.98 3.76 222.39 3.4 222.6 3.4 223.21 3.76 223.01 4.12 223.21 4.12 224.04 4.67 224.65 4.85 224.65 5.39 224.86 5.39 225.89 5.93 226.92 6.12 227.12 6.3 227.74 6.66 228.98 6.66 228.98 6.48 230.42 6.48 230.42 6.12 231.03 6.12 231.03 5.75 231.24 5.75 231.86 5.39 232.89 5.39 233.3 5.03 233.5 5.03 233.5 5.39 233.92 5.57 234.33 5.75 234.12 6.12 234.33 6.3 234.33 6.66 234.74 6.84 234.74 7.75 234.74 7.93"
              style="fill: #97c4cf; stroke: #82b1bd;"
            />

          </g>
          
        </svg>

        <!-- Fire map SVG loaded at runtime to reduce bundle size -->
        <div
          id="firemap-container"
          role="figure"
          aria-label="Interactive map of the western United States showing wildfire burn perimeters from 1984 to 2020, overlaid on important water supply watersheds. Total burned area has generally increased over time, with 2020 being the largest on record at over 8 million acres."
          v-html="fireMapSvg"
        />
      </div>
      <div class="caption-container flex-container">
        <p class="caption">
          Fire perimeter data from <a
            href="https://data-nifc.opendata.arcgis.com/datasets/wildfire-perimeters"
            target="_blank"
          >National Interagency Fire Center,</a> 1984-2020.<br>
          Important water supply watersheds, based on amount of surface water supply generated and withdrawn (Importance >= 50), from <a
            href="https://new.cloudvault.usda.gov/index.php/s/GKDoTosMaC2BeNn"
            target="_blank"
          >U.S. Department of Agriculture's Forest to Faucets.</a>
        </p>
      </div>        
    </div>
    <div class="text-content">
      <p>However, financial and societal costs don’t stop when the flames go out.  Wildfires can have enormous impacts on human lives, property, and infrastructure – as well as to our water supplies. Over 50% of the Nation’s drinking water comes from forested areas. Wildfires are natural in many ecosystems, but have increased in size, severity, and frequency.  These hotter, bigger fires increase the risk of flood hazards, erosion, and impaired water quality.</p>
    </div>   
  </section>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue';
import * as d3 from 'd3';

const publicPath = import.meta.env.BASE_URL;
const fireMapSvg = ref('');

// chart dimensions
const chart_margin = {top: 5, right: 5, bottom: 40, left: 120};
const chart_height = 216.00 - chart_margin.top - chart_margin.bottom;
const chart_width = 720.00 - chart_margin.right - chart_margin.left;
const y = d3.scaleLinear().range([chart_height, 0]);

let isPlaying = false;
let tooltip = null;
const yearList = [];

onMounted(async () => {
  // Load fire map SVG at runtime to avoid bundling ~1.5MB of path data
  const response = await fetch(publicPath + 'data/fire_map.svg');
  fireMapSvg.value = await response.text();

  // Wait for DOM update then initialize D3
  await nextTick();
  setPanels();
});

function setPanels() {
  let promises = [d3.csv(publicPath + "data/fire_timeseries.csv")];
  Promise.all(promises).then(callback);
}

function callback(data) {
  let csv_burn = data[0];
  makeYearList(csv_burn);
  addTooltip();
  createBarChart(csv_burn);
  makeFireInteractive(csv_burn);
  animateChart_Map();
}

function makeYearList(csv_burn) {
  for (let i = 0; i < csv_burn.length; i++) {
    yearList.push(csv_burn[i]['YEAR']);
  }
}

function addTooltip() {
  tooltip = d3.selectAll(".tooltip")
    .attr("class", "tooltip")
    .attr('text-anchor', 'end')
    .attr('text-align', 'right')
    .attr('x', 636)
    .attr('y', 75);
}

function createBarChart(csv_burn) {
  var chart = d3.select("#map-container")
    .append("svg")
    .attr("viewBox", [0, 0, (chart_width + chart_margin.right + chart_margin.left),
          (chart_height + chart_margin.top + chart_margin.bottom)].join(' '))
    .attr("class", "fire-timeseries-2");
  let g = chart.append("g")
    .attr("class", "transformedBarChart")
    .attr("transform", "translate(" + chart_margin.left + "," + chart_margin.top + ")");

  var x = d3.scaleBand()
    .range([0, chart_width])
    .domain(csv_burn.map(function(d) { return d.YEAR; }))
    .padding(0.1);

  var domainArrayY = [];
  for (let i = 0; i < csv_burn.length; i++) {
    domainArrayY.push(parseFloat(csv_burn[i]['area_acres']));
  }

  let dataMax = Math.round(Math.max(...domainArrayY));
  y.domain([0, dataMax]);

  g.append("g")
    .attr("class", "chartAxis bottom")
    .attr("transform", "translate(0," + chart_height + ")")
    .call(d3.axisBottom(x).tickValues(['1990', '2000', '2010', '2020']).tickSize(3))
    .select(".domain").remove();

  chart.selectAll(".tick line").attr("stroke", "#ffffff");

  g.append("g")
    .attr("class", "chartAxis left")
    .attr("transform", "translate(0,0)")
    .call(d3.axisLeft(y).ticks(10, "s").tickSize(-chart_width))
    .select(".domain").remove();

  chart.selectAll(".tick line").attr("stroke-width", 1).attr("stroke-dasharray", "1, 15").attr("opacity", "0.5");

  chart.select(".chartAxis.bottom")
    .append('text')
    .attr('transform', 'translate(' + chart_width / 2 + ', 30)')
    .attr("text-anchor", "middle")
    .attr("class", "chartAxisText bottom")
    .text("Year");

  chart.select(".chartAxis.left")
    .append('text')
    .attr("y", -30)
    .attr("x", -chart_height / 2)
    .attr("text-anchor", "middle")
    .attr("class", "chartAxisText left")
    .text("Acres burned in the West")
    .attr("transform", "rotate(-90)");

  // D3 v7: event handlers receive (event, d) instead of (d)
  g.selectAll(".fire-bars")
    .data(csv_burn)
    .enter()
    .append("rect")
    .attr("class", function(d) { return "fire-bars bar year" + d.YEAR; })
    .attr("width", x.bandwidth())
    .attr("x", function(d) { return x(d.YEAR); })
    .on("click", function(event, d) { highlight_year(d, isPlaying); })
    .style("fill", "rgb(250,109,49)")
    .style("stroke", "rgb(235,98,40)")
    .on("mouseover", function(event, d) { highlight_year(d, isPlaying); })
    .on("mousemove", function(event, d) { mousemove(d, isPlaying); })
    .on("mouseout", function(event, d) { dehighlight_year(d, isPlaying); });

  createPlayButton(chart);
}

function createPlayButton(chart) {
  let button = chart.append("g")
    .attr("transform", "translate(0,0)")
    .attr("class", "play_button");

  button.append("rect")
    .attr("width", 50)
    .attr("height", 50)
    .attr("rx", 4)
    .style("fill", 'rgb(250,109,49)');

  button.append("path")
    .attr("d", "M15 10 L15 40 L35 25 Z")
    .style("fill", "#ffffff");

  button.append("title")
    .text("replay animation");

  button.on("mousedown", function() {
    pressButton(isPlaying);
  });
}

function pressButton(playing) {
  if (playing === false) {
    animateChart_Map();
  }
}

function resetPlayButton() {
  isPlaying = false;
  d3.selectAll(".play_button").selectAll("rect")
    .style("fill", 'rgb(250,109,49)');
}

function makeFireInteractive(csv_burn) {
  // D3 v7: event handlers receive (event, d)
  d3.selectAll(".firemap").selectAll(".fire")
    .data(csv_burn)
    .on("click", function(event, d) { highlight_year(d, isPlaying); })
    .on("mouseover", function(event, d) { highlight_year(d, isPlaying); })
    .on("mousemove", function(event, d) { mousemove(d, isPlaying); })
    .on("mouseout", function(event, d) { dehighlight_year(d, isPlaying); });
}

function mousemove(data, playing) {
  if (playing === false) {
    let acres_burned = d3.format(',')(Math.round(data.area_acres / 1000000 * 10) / 10) + ' million acres';
    tooltip.text(acres_burned);
  }
}

function highlight_year(data, playing) {
  if (playing === false) {
    tooltip.style("opacity", 1);

    d3.selectAll(".fire.year" + data.YEAR)
      .style("fill", "rgb(250,109,49)")
      .style("stroke", "rgb(235,98,40)")
      .raise();

    d3.selectAll(".bar.year" + data.YEAR)
      .style("fill", "rgb(250,109,49)")
      .style("stroke", "rgb(235,98,40)");

    d3.selectAll(".label" + data.YEAR)
      .style("fill", "rgb(250,109,49)")
      .style("opacity", 1)
      .raise();
  }
}

function dehighlight_year(data, playing) {
  if (playing === false) {
    tooltip.style("opacity", 0);

    for (let i = 0; i < yearList.length; i++) {
      let current_year = parseFloat(data.YEAR);
      let selected_year = parseFloat(yearList[i]);
      if (current_year > selected_year) {
        d3.selectAll(".fire.year" + selected_year).raise();
        d3.selectAll(".label" + selected_year).raise();
      }
    }

    d3.selectAll(".bar.year" + data.YEAR)
      .style("fill", "rgba(245,169,60,0.8)")
      .style("stroke", "rgba(235,156,42,0.8)");

    d3.selectAll(".fire.year" + data.YEAR)
      .style("fill", "rgba(245,169,60,0.6)")
      .style("stroke", "rgba(235,156,42,0.6)")
      .raise();

    d3.selectAll(".label" + data.YEAR)
      .style("fill", "#ffffff")
      .raise();

    for (let i = 0; i < yearList.length; i++) {
      let current_year = parseFloat(data.YEAR);
      let selected_year = parseFloat(yearList[i]);
      if (current_year < selected_year) {
        d3.selectAll(".fire.year" + selected_year).raise();
        d3.selectAll(".label" + selected_year).raise();
      }
    }
  }
}

function animateChart_Map() {
  isPlaying = true;

  let button_rect = d3.selectAll(".play_button").selectAll("rect");
  button_rect.style("fill", "#d6d6d6");

  let animationInterval = 800;
  let colorDuration = 200;
  let appearDuration = animationInterval - colorDuration;
  let num_years = 37;

  let bars = d3.selectAll("g").selectAll(".fire-bars");

  bars.attr("y", chart_height).attr("height", 0);

  bars.transition()
    .duration(appearDuration)
    .delay(function(d, i) { return i * animationInterval; })
    .attr("height", function(d) { return chart_height - y(d.area_acres); })
    .attr("y", function(d) { return y(d.area_acres); })
    .style("fill", "rgb(250,109,49)")
    .style("stroke", "rgb(235,98,40)")
    .transition()
    .duration(colorDuration)
    .style("fill", "rgba(245,169,60,0.8)")
    .style("stroke", "rgba(235,156,42,0.8)");

  let fires = d3.selectAll(".firemap").selectAll(".fire");

  fires.style("fill", "None").style("stroke", "None");

  fires.transition()
    .duration(0)
    .delay(function(d, i) { return i * animationInterval; })
    .style("fill", "rgb(250,109,49)")
    .style("stroke", "rgb(235,98,40)")
    .transition()
    .duration(colorDuration)
    .delay(function(d, i) { return animationInterval - colorDuration; })
    .style("fill", "rgba(245,169,60,0.8)")
    .style("stroke", "rgba(235,156,42,0.8)");

  let yearText = d3.selectAll(".text-year");

  yearText
    .attr("font-size", "40px")
    .attr('x', 550)
    .attr('y', 50)
    .style("fill", "rgba(0,0,0,0)");

  yearText.transition()
    .duration(300)
    .delay(function(d, i) { return i * animationInterval; })
    .style("fill", "rgb(250,109,49)")
    .transition()
    .duration(500)
    .delay(function(d, i) { return animationInterval - 500; })
    .style("fill", "rgba(0,0,0,0)");

  button_rect.transition()
    .delay(animationInterval * num_years)
    .on("end", resetPlayButton);
}
</script>

<style scoped lang="scss">

  // Import Colors
  $white: rgb(255,255,255);
  $black: rgb(0,0,0);  
  $lightGray:rgb(237,237,237);
  $mediumGray: rgb(100,100,100);
  $darkGray: rgb(51,51,51);
  $usgsGreen: rgb(51,120,53);
  $usgsBlue: rgb(0,38,76);
  $fireRed: rgb(250,109,49);
  $fireRedlight: rgba(250,109,49,0.5);
  $fireYellow: rgb(245,169,60);
  $fireYellowlight: rgba(245,169,60,0.5);

#main-map-section   {
  position: relative;
}

#map-legend-group {
  @media screen and (max-width: 600px) {
    transform: translate(-140px) scale(1.6)
  }
}
.legend-text {
  fill: #4f4f4f;
  font-size:  12px;
  font-family: 'Source Sans Pro', Helvetica, Arial, sans-serif;
  font-weight: lighter;

}
#basemap  {

  fill: none;
  stroke: none; 
  stroke-linecap: round; 
  stroke-linejoin: round; 
  stroke-width: 1;

  #states {
    stroke-width: 1.75;
    stroke: #fcfcfc; 
    fill: #f0f0f0;
  }

}
#map-container {
  padding: 4em 0 0 0;
  width: 90%;
  margin: auto;
  @media screen and (min-width: 800px) {
    width: 80%;
    margin: auto;
  }
  svg { 
    fill: none;
    width: 100%;
  }
}

.caption-container{
  padding: 0 0 4em 0;
}
#mappy {
  width:90vw;
  margin: auto;
}
#firemap  {
  width: 80%;
  height: auto;
  max-height: 60vh;
  @media screen and (min-width: 600px) {
    width: 1000px;
    margin: auto;
    padding: 0 4em 0 4em;
  }
}
.fire {
  stroke-width: 0.5px;
  stroke-linecap: round; 
  stroke-linejoin: round; 
}
.tooltip {
    fill: $fireRed;
    font-family: sans-serif;
    font-size: 20px;
    text-align: right;
    font-weight: bold;
    line-height: 1em;
}
#text-year  {
    font-size: 36px;
    fill: $fireRed;
    font-weight: 500;
}
.IMP  {
  fill: #97c4cf;
  stroke: #82b1bd;
  stroke-width: 0.3px;
  opacity:  0.6;
}

</style>
<style lang="scss">
.chartAxisText {
  fill: #4f4f4f; /* #4f4f4f */
  font-size: 1em;
  font-weight: bold;
}
.tick text{
  fill: #4f4f4f;
  font-size: 12px;
}
.tick {
  fill: #4f4f4f;
}
.caption-container  {
  padding: 2em;
  width: 80vw;
}
.fire-timeseries-2 {
  width: 60vw;
  margin: auto;
  max-height: 25vh;
}
</style>