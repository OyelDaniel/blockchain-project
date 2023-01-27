#!/usr/bin/env node

const app = require('../src/app.js');
const mongoose = require('../src/config/mongoose');
const port = require('../src/config').port;

mongoose.connection.on('connected', function() {
    app.listen(port, () => {
        console.log('Started on port ${port}')
    });
});

function graceful() {
    mongoose.connection.close(function() {
        process.exit(0);
    })
}

process.on('SIGTERM', graceful);
process.on('SIGINT', graceful);