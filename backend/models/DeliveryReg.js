const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const bcrypt = require('bcryptjs')

const foodDeliverySchema = new Schema({
    name:String,
    email:String,
    password:String,
    status: {Boolean,default:false},
    vehicleNum:String,
    licenseNum:String,
    address:String,
    token:String
});

foodDeliverySchema.pre('save',async function(){
    var delivery = this;

    if(delivery.isModified('password')){

        const salt = await bcrypt.genSalt(10);
       const hash = await bcrypt.hash(delivery.password,salt);

       delivery.password = hash;

    };

});


const DeliveryReg = mongoose.model('DeliveryReg', foodDeliverySchema);

module.exports = DeliveryReg;
