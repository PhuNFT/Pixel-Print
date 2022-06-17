const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        VT323: ['VT323', ...defaultTheme.fontFamily.mono],
      },
      colors: {
        'brand-pink': 'var(--clr-pink)',
        'brand-yellow': 'var(--clr-yellow)',
        'brand-blue': 'var(--clr-blue)',
        'brand-navy': 'var(--clr-navy)',
        'brand-light': 'var(--clr-light)',
        'brand-background': 'var(--clr-background)'
      }
    }
  },
  plugins: [],
};

