const mongoose = require('mongoose');
const bcrypt = require('bcryptjs')
const Schema = mongoose.Schema;

const userSchema = new Schema({
    name:  String,
    email: String,
    password: String,
    // address:String,
    // password2:String,
    token:String

  });

  userSchema.pre('save',async function(){
    var user = this;

    if(user.isModified('password')){

        const salt = await bcrypt.genSalt(10);
       const hash = await bcrypt.hash(user.password,salt);

       user.password = hash;

    };


    // if(user.isModified('password')){
    //     bcrypt.genSalt(10,function(err,salt){
    //         if(err) return next(err);
    
    //         bcrypt.hash(user.password,salt,function(err,hash){
    //             if(err) return next(err);
    //             user.password = hash;
    //             next();
    //         });
    //     })
    // } else{
    //     next()
    // }
    // userSchema.statics.methods = ()=>{

    //   const user = this;

    //   user

    // } 
});


  module.exports = mongoose.model('User', userSchema);
