// Note: You must restart bin/webpack-watcher for changes to take effect

let webpack = require('webpack')
let merge = require('webpack-merge')

let sharedConfig = require('./shared.js')

module.exports = merge(sharedConfig.config, {
  output: { filename: '[name]-[hash].js' },

  plugins: [
    new webpack.LoaderOptionsPlugin({
      minimize: true
    })
  ]
})
