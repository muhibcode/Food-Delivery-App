const mongoose = require('mongoose');
const Schema = mongoose.Schema;
// const ObjectId = Schema.Types.ObjectId;

const FastFoodSchema = new Schema({
    name: String
    
});

const Food = mongoose.model('FastFood', FastFoodSchema);

module.exports = Food;
