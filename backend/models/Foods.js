const mongoose = require('mongoose');
const Schema = mongoose.Schema;
// const ObjectId = Schema.Types.ObjectId;

const FoodSchema = new Schema({

    type:{
        type:Schema.Types.ObjectId,
        ref:'FoodTypes'
    },
     name: String
    
});

const Foods = mongoose.model('FoodSchema', FoodSchema);

module.exports = Foods;
