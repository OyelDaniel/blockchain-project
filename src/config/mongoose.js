const mongoose = require('mongoose');
const config = require('./index.js');

mongoose.Promise = global.Promise;
mongoose.connect(config.mongoUri, {useNewUrlParser: true});

module.exports = mongoose;