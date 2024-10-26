const mongoose = require('mongoose');
const Schema = mongoose.Schema;
// const ObjectId = Schema.ObjectId;
const bcrypt = require('bcryptjs')

const hotelSchema = new Schema({
    
    hotelName:String,
    email:String,
    password:String,
    hotelAddress:String,
    token:String
      
 });

 hotelSchema.pre('save',async function(){
    var hotel = this;

    if(hotel.isModified('password')){

        const salt = await bcrypt.genSalt(10);
       const hash = await bcrypt.hash(hotel.password,salt);

       hotel.password = hash;

    };

});

const HotelReg = mongoose.model('HotelReg', hotelSchema);

module.exports = HotelReg;