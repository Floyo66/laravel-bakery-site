// vite.config.js (or .ts)
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
            manifest: true,           // ensure manifest is generated
        }),
    ],
    build: {
        manifest: 'manifest.json',   // ← force name & location (no .vite subfolder)
        outDir: 'public/build',
        rollupOptions: {
            // optional but safe
        },
    },
});
