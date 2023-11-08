import adapter from '@sveltejs/adapter-auto';
import preprocess from 'svelte-preprocess';
import autoprefixer from 'autoprefixer';
const filesPath = (path) => `${path}`;

const config = {
    preprocess: preprocess({
        postcss: {
        plugins: [autoprefixer],
        },
    }),
    kit: {
        adapter: adapter(),
        files: {
            assets: filesPath('static'),
            lib: filesPath('src/lib'),
            routes: filesPath('src/routes'),
            appTemplate: filesPath('src/app.html')
        }
    }
};

export default config;
