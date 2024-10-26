const mongoose = require('mongoose');
const Schema = mongoose.Schema;
// const ObjectId = Schema.ObjectId;

const customerSchema = new Schema({
    name: String,
    address: String,
    socketID: String
});

const Driver = mongoose.model('Customer', customerSchema);

module.exports = Driver;
