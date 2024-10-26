const mongoose= require('mongoose');
const Schema = mongoose.Schema;


const foodTypes = new Schema({

    title:String 
});

module.exports = mongoose.model('FoodTypes',foodTypes);