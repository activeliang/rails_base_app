/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: 'class',
  content: ['./app/frontend/entrypoints/components/*/*.{vue,js,ts,jsx,tsx}'],
  theme: {
    extend: {},
  },
  plugins: ["tailwindcss ,autoprefixer"]
}
