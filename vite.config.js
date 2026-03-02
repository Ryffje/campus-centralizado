import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  server: {
    host: true,              // escucha en 0.0.0.0 dentro del container
    port: 5173,
    hmr: {
      host: 'localhost',     // PERO le dice al browser que use localhost
      port: 5173,
    },
  },
  plugins: [
    tailwindcss(),
    laravel({
      input: ['resources/css/app.css', 'resources/js/app.js'],
      refresh: true,
    }),
  ],
});
