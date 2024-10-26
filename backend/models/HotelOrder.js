const mongoose = require('mongoose');
const Schema = mongoose.Schema;
// const ObjectId = Schema.Types.ObjectId;

const HotelOrder = new Schema({
    customerInfo:{
        type:Schema.Types.ObjectId,
        ref:'User'
    },
    hotelID:{
        type:Schema.Types.ObjectId,
        ref:'HotelReg'
    },
    // deliveryID:{
    //     type:Schema.Types.ObjectId,
    //     ref:'FoodDelivery'

    // },
    dropOffAddress:String,
    completed:{Boolean,default:false},
    foodInfo:[{
        foodName:String,
        foodPrice:String,
        foodQuantity:String,
    
    }]

});

module.exports = mongoose.model('HotelOrder', HotelOrder);

