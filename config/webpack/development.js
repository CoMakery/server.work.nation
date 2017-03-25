// Note: You must restart bin/webpack-watcher for changes to take effect

let webpack = require('webpack')
let merge = require('webpack-merge')

let sharedConfig = require('./shared.js')

module.exports = merge(sharedConfig.config, {
  devtool: 'sourcemap',

  stats: {
    errorDetails: true
  },

  output: {
    pathinfo: true
  },

  plugins: [
    new webpack.LoaderOptionsPlugin({
      debug: true
    })
  ]
})
