const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const OrderSchema = Schema({
    index: {type: Number},
    supplier: {type: String},
    delCompany: {type: String},
    customer: {type: String},
});

module.exports = mongoose.model('Order', OrderSchema);