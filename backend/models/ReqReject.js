const mongoose = require('mongoose');
const Schema = mongoose.Schema;
// const ObjectId = Schema.ObjectId;

const rejectSchema = new Schema({
    dId: [String],
    trackingID:String

    // pickUp: String,

    // hName:String,
    // dropOff: String,

    // cName:String,

    // socketID: String
});

const ReqReject = mongoose.model('ReqReject', rejectSchema);

module.exports = ReqReject;
