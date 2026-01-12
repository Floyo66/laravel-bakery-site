import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
    ],
    server: {
        host: '0.0.0.0',          // ← crucial: allows access from host machine
        port: 5173,
        hmr: {
            host: 'localhost',    // or your machine IP if needed
        },
        // Optional but helps a lot in Docker/WSL:
        watch: {
            usePolling: true,     // important on Windows/WSL/Docker
        },
    },
});
