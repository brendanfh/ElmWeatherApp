var path = require("path");

module.exports = {
    entry: {
        app: [
            './src/index.js'
        ]
    },

    output: {
        path: path.resolve(__dirname + '/dist'),
        filename: "[name].js"
    },

    module: {
        rules: [
            { // How to handle a css or scss file
                test: /\.(css|scss)$/,
                use: [
                    'style-loader',
                    'css-loader'
                ]
            },
            { // How to handle a html file
                test: /\.html$/,
                exclude: /node_modules/,
                loader: 'file-loader?name=[name].[ext]'
            },
            { // How to handle elm files
                test: /\.elm$/,
                exclude: [/elm_stuff/, /node_modules/],
                loader: 'elm-webpack-loader?verbose=true&warn=true&debug=true'
            },
            {
                test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
                loader: 'file-loader',
            },
        ],

        noParse: /\.elm$/
    },

    devServer: {
        inline: true,
        stats: { colors: true },
        headers: { "Access-Control-Allow-Origin": "*" },
        proxy: {
            "/api": "http://localhost:8081/"
        }
    }
};