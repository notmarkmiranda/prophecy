const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        primary: {
          50: '#f0f9ff',
          100: '#e0f2fe',
          200: '#bae6fd',
          300: '#7dd3fc',
          400: '#38bdf8',
          500: '#1e90ff',  // Your provided color
          600: '#1a7fd6',  // Darker shade
          700: '#1666ad',  // Even darker
          800: '#124f84',  // Much darker
          900: '#0e3a5c',  // Darkest
          950: '#0a2744',  // Nearly black
        },
        secondary: {
          50: '#f5f5f5',
          100: '#e0e0e0',
          200: '#bdbdbd',
          300: '#9e9e9e',
          400: '#757575',
          500: '#616161',  // Base secondary color
          600: '#424242',  // Darker shade
          700: '#303030',  // Even darker
          800: '#212121',  // Much darker
          900: '#121212',  // Darkest
          950: '#0a0a0a',  // Nearly black
        },
        tertiary: {
          50: '#fff7e6',
          100: '#ffedcc',
          200: '#ffd9a3',
          300: '#ffc47a',
          400: '#ffaf52',
          500: '#ff9a29',  // Base tertiary color
          600: '#e68a25',  // Darker shade
          700: '#cc7a21',  // Even darker
          800: '#b36a1d',  // Much darker
          900: '#995a19',  // Darkest
          950: '#804a15',  // Nearly black
        },
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
