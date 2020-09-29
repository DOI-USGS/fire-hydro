<template>
  <div
    id="resources-section"
    class="text-content"
  >
    <h2><a /><span class="lowlight">Resources</span></h2>
    <div class="usa-accordion usa-accordion--bordered">
      <div>
        <h3 class="usa-accordion__heading">
          <button
            class="usa-accordion__button"
          >
            Resource 1
          </button>
        </h3>
        <div
          class="usa-accordion__content usa-prose target"
        >
          <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Tellus pellentesque eu tincidunt tortor. Blandit massa enim nec dui nunc mattis enim. Non arcu risus quis varius. Tellus mauris a diam maecenas sed enim ut sem. Nulla facilisi cras fermentum odio eu feugiat pretium nibh. Fringilla urna porttitor rhoncus dolor purus non enim. Fusce id velit ut tortor pretium viverra suspendisse potenti nullam.</p>
        </div>
      </div>
      <div>
        <h3 class="usa-accordion__heading">
          <button
            class="usa-accordion__button"
          >
            Resource 2
          </button>
        </h3>
        <div
          class="usa-accordion__content usa-prose target"
        >
          <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Tellus pellentesque eu tincidunt tortor. Blandit massa enim nec dui nunc mattis enim. Non arcu risus quis varius. Tellus mauris a diam maecenas sed enim ut sem. Nulla facilisi cras fermentum odio eu feugiat pretium nibh. Fringilla urna porttitor rhoncus dolor purus non enim. Fusce id velit ut tortor pretium viverra suspendisse potenti nullam.</p>
        </div>
      </div>
      <div>
        <h3 class="usa-accordion__heading">
          <button
            class="usa-accordion__button"
          >
            Resource 3
          </button>
        </h3>
        <div
          class="usa-accordion__content usa-prose target"
        >
          <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Tellus pellentesque eu tincidunt tortor. Blandit massa enim nec dui nunc mattis enim. Non arcu risus quis varius. Tellus mauris a diam maecenas sed enim ut sem. Nulla facilisi cras fermentum odio eu feugiat pretium nibh. Fringilla urna porttitor rhoncus dolor purus non enim. Fusce id velit ut tortor pretium viverra suspendisse potenti nullam.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
    export default {
        name: 'Resources',
        //  mounted() {
        //     // This is a fix for the weird USWDS glitch that causes the Methods section accordion menus to be open on page load
        //     const targetAccordionDivs = document.querySelectorAll('div.target');
        //     targetAccordionDivs.forEach((div) => {
        //         div.setAttribute('hidden', '""');
        //     });
        // }
    }
</script>

<style lang="scss" scoped>
$chevronLeft: '~@/assets/images/chevron-left.png';
$chevronDown: '~@/assets/images/chevron-down.png';

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


  h2{
    margin-bottom: 10px;
  }
  button:not([disabled]):focus{
    outline: none;
  }
  .usa-accordion__button{
    background-image: url($chevronDown);
    background-size: 15px 10px;
    background-color: $fireYellow;
    color: $darkGray;
  }
  .usa-accordion__button[aria-expanded=false]{
    background-image: url($chevronLeft);
    background-size: 10px 15px;
    background-color: $darkGray;
    color: $fireYellow;
  }

#app h2.usa-accordion__heading {
  margin: 0;
}
</style>
