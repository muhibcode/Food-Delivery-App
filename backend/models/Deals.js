const mongoose = require('mongoose');
const Schema = mongoose.Schema;
// const ObjectId = Schema.Types.ObjectId;

const DealsSchema = new Schema({
    chineseFood:[{
       type:Schema.Types.ObjectId,
       ref:'ChineseFood',
       price:Number,
       quatity:Number
    }],

    desiFood:[{
        type:Schema.Types.ObjectId,
        ref:'DesiFood',
        price:Number,
        quatity:Number
 
     }],

     fastFood:[{
        type:Schema.Types.ObjectId,
        ref:'FastFood',
        price:Number,
        quatity:Number
 
     }]
 
    // quantity:Number,

    // price:Number,

    // user:{type:Schema.Types.ObjectId,
    //     ref:'User'
        
    // },
    // onModel: {
    //     type: String,
    //     required: true,
    //     // food_id:'ChineseFood'
    //     enum: ['FastFood','DesiFood','ChineseFood']
    //   }
    
});

const Deals = mongoose.model('Deals', DealsSchema);

module.exports = Deals;
