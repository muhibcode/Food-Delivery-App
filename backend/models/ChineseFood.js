const mongoose = require('mongoose');
const Schema = mongoose.Schema;
// const ObjectId = Schema.ObjectId;

const ChineseSchema = new Schema({
    name: String
    
});

const Food = mongoose.model('ChineseFood', ChineseSchema);

module.exports = Food;

