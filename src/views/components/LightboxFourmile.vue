<template>
    <div>
        <!-- <div v-for="image in images" v-bind:key="image.id">
            <img 
                v-img:group1 
                :src="image.src" 
                :title="image.caption" 
                :alt="image.caption" 
            />
            <div class="caption">{{ image.caption }}</div>
        </div> -->
        <div id="lightbox-fourmile" class="flex-container">
            <img
                v-img:group-1
                src="@/assets/images/NASAEO/boulder_ali_2011158_swir_lrg.jpg" 
                alt="NASA Aerial photography of the Fourmile fire's smoke plume"
            >
            <img 
                v-img:group-1
                src="@/assets/images/NASAEO/boulder_ali_2011158_lrg_ai-01.jpg" 
                alt="NASA Aerial photography of the Fourmile burn scar"
            >
            <img
                v-img:group-1
                src="@/assets/images/NASAEO/fourmile_tmo_2010249_lrg.jpg" 
                alt="NASA false-color Aerial photography of the Fourmile burn scar"
            >
        </div>       
    </div>
</template>

<script>    

    export default {
        name: 'LightboxFourmile',
        // data: () => {
        //     return{
        //         images: [
        //             {id: "0", src: '../assets/images/NASAEO/fourmile_tmo_2010249_lrg.jpg', caption: "NASA false-color Aerial photography of the Fourmile burn scar"},
        //             {id: "1", src: '../assets/images/NASAEO/boulder_ali_2011158_lrg_ai-01.jpg', caption: "NASA Aerial photography of the Fourmile burn scar"},
        //             {id: "2", src: '../assets/images/NASAEO/boulder_ali_2011158_swir_lrg.jpg', caption: "NASA Aerial photography of the Fourmile fire's smoke plume"}
        //         ]
        //     }
        // }
    };

        

</script>

<style lang="scss" scoped>
    img{
        padding: 10px;
        height: 400px;
        width: auto;
        @media screen and (max-width: 600px) {
            padding: 10px 0;
            width: 100%;
            height: auto;
        }
    }
    #lightbox-fourmile{
        margin: 5em 0;
    }
</style>>
