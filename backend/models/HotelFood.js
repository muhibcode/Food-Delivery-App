// const { Schema } = require('mongoose');
const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const ObjectId = Schema.ObjectId;

const hotelSchema = new Schema({
  
     typeOfFood:{
       type: Schema.Types.ObjectId,
       ref:'FoodTypes'
     },

     
      hotelID:{
        type:Schema.Types.ObjectId,
        ref:'HotelReg'
     },
   foodInfo:[{
    foodName:{
      type: Schema.Types.ObjectId,
      ref: 'FoodSchema'
    },


   // image:String,
     // image:{
     //   type:String,
     //   default:''
     // },

    foodPrice:String,

  foodQuantity:String

   }

]

});
 

const Hotel = mongoose.model('HotelFood', hotelSchema);

module.exports = Hotel;
