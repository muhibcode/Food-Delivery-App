const express = require("express");
const app = express();
const server = require("http").createServer(app);
const io = require("socket.io").listen(server);

// const server = require("http").Server(app);
const cors = require("cors");
// const multer = require('multer');
// const upload = multer({ dest: 'uploads/' })
// const expressServer = app.listen(5000)
// const socketIo = require("socket.io");
const mongoose = require("mongoose");
const bodyParser = require("body-parser");
// const io = socketIo(expressServer);
const FoodDeliver = require("./models/FoodDelivery");
const Customer = require("./models/customer");
const HotelFood = require("./models/HotelFood");
const HotelFoods = require("./models/HotelFoods");
const FoodTypes = require("./models/FoodTypes");

// const Chinese = require('./models/ChineseFood');
const CustomerOrder = require("./models/CustomerOrder");
const Foods = require("./models/Foods");
const Deals = require("./models/Deals");
const HotelReg = require("./models/HotelRegister");
const ReqReject = require("./models/ReqReject");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("./models/User");
const { auth } = require("./middleware/auth");
const cookieParser = require("cookie-parser");
// const { strict } = require("assert");

const port = 5000;

let hId = "";

io.on("connection", (socket) => {
  console.log("a user connected :D");
  socket.emit("msgToClient", "server Connected");
  // io.emit(hId + 'reply', 'some one loooking for delivery');

  socket.on("foodRequest", (msg) => {
    console.log(msg);
    //     // name = msg;
    io.emit("requestReceived", msg);
  });

  socket.on("orderFood", (data) => {
    // console.log('food orederd is ',data);
    io.emit(data.hotelID._id + "requestFood", data);
  });

  socket.on("deliveryReply", (data) => {
    // console.log('id is ',hId);
    // name = msg;
    io.emit(data.hotelID + "replyDelivery", data);
  });

  socket.on("foodDelievered", (data) => {
    // console.log('id is ',hId);
    // name = msg.id;
    io.emit(data.dId + "reply", data);
    // io.emit(data.cusID + 'deliveryStatus', 'Delivery boy pick the food and now on its way');
  });

  socket.on("deliveryRestoCus", (data) => {
    // console.log('id is ',hId);
    // name = msg.id;
    io.emit(data.val + "reply", data);
  });

  socket.on("hotelReply", (data) => {
    // console.log('id is ',hId);
    // name = msg.id;
    io.emit(data.customerID + "reply", data);
  });

  socket.on("delivered", (data) => {
    // console.log('id is ',hId);
    // name = msg.id;
    io.emit(data.deliveryID + "deliveryRes", data);
  });

  socket.on("reqrejected", (data) => {
    // console.log('id is ',hId);
    // name = msg.id;
    io.emit(data.cusID + "reply", data);
  });
});

mongoose.connect("mongodb://localhost:27017/food_app", {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  useFindAndModify: false,
});

app.use(cookieParser());

app.use(express.json({ limit: "50mb" }));
app.use(express.urlencoded({ extended: true, limit: "50mb" }));

// app.use(cors({credentials:true, origin: 'http://localhost:19000'}));
// app.use(cors({credentials:true, origin: 'http://196.152.22.100:19000'}));

// const storage = multer.diskStorage({
//     destination: function (req, file, cb) {
//       cb(null, '/uploads')
//     },
//     filename: function (req, file, cb) {
//       cb(null, file.fieldname + '-' + Date.now())
//     }
//   })

//   const upload = multer({ storage: storage })

app.get("/get_driver", async (req, res) => {
  const { deliveryID } = req.query;

  const driver = await FoodDeliver.findOne({ _id: deliveryID });

  res.send(driver);
});

app.get("/logcustomer", async (req, res) => {
  const driver = await Customer.findOne({ _id: req.body.id });

  res.send(driver);
});
app.post("/loghotel", async (req, res) => {
  // const {hotelId,cName,cAddress,cusID} = req.query;
  // const {hotelId,cName,cAddress,cusID} = req.query;
  // console.log('query string is ',req.query);
  //     const result = await Hotel.findOne({'_id':hotelId});
  //     const {name,address} = result
  // if (result._id) {
  //     io.emit(result._id + 'requestFood',{hName:name,hAddress:address,cName,cAddress,cusID,hotelId}
  // {hotelName:result.name,
  //  hotelAddress:result.address,
  //  msg:`Someone name ${cName} looing for food`,
  // customerName:cName,
  // customerAddress:cAddress
  //     );
  // }
  // console.log('hotel is ',req.query);
  //  `Some one name ${customer} looking for Food`
  // res.send(result);
});

app.get("/getcustomer", async (req, res) => {
  const driver = await Customer.find();

  res.send(driver);
});

app.get("/gethotel", async (req, res) => {
  const driver = await Hotel.find();

  // io.emit('hotels',driver)
  console.log("request arive");
  res.send(driver);
});

app.delete("/deldeals", async (req, res) => {
  const result = await Deals.deleteMany();

  // const delItem = result.save();
  console.log("request", result);
  res.send(result);
});

// app.get('/getdeals', async(req, res) => {
//
//     const driver = await Deals.find()
//     .populate('chineseFood')
//     .populate('desiFood')
//     .populate('fastFood')
//     .exec();
//     // io.emit('hotels',driver)
//     console.log('aa gayi request',driver);
//     res.send(driver);

//
// });

app.post("/food_order", async (req, res) => {
  const order = new CustomerOrder(req.body);
  //    console.log('oredered food is ',req.body);

  const data = await order.save();

  io.emit(data.hotelID + "requestFood", {
    hotelID: data.hotelID,
    foodID: data._id,
  });

  res.send(data);
});

app.get("/logout", (req, res) => {
  res.clearCookie("w_auth");

  res.send("cookies cleared");
});

app.post("/update_food", async (req, res) => {
  const { id, mainID, foodName, price, quantity, index } = req.body;

  // const items = await HotelFood.findOne({'_id':mainID});
  const items = await HotelFood.findOne({ _id: mainID });

  console.log("update body is ", items);

  const val = {
    image: "",
    foodName: id,
    foodPrice: price,
    foodQuantity: quantity,
  };

  items.foods.splice(index, 1, val);

  // items.foods.forEach(n => {
  //     if(n._id === id ){

  //         // n.food = food,
  //         n.foodPrice= price,
  //         n.foodQuantity= quantity

  //        return n.save();
  //         // return
  //     }
  // });

  await items.save();
  res.send(items);
});

app.get("/del_food", async (req, res) => {
  const { id, mainID, index } = req.query;

  // const items = await HotelFood.findOne({'_id':mainID});
  const item = await HotelFood.findOne({ _id: mainID });

  item.foods.remove({ _id: id });

  await item.save();

  const items = await HotelFood.find();

  // filetr the food items with empty arrays

  const filterd = items.filter((n, i) => n.foods.length === 0);

  let ids = [];

  filterd.forEach((n, i) => ids.push(n._id));

  // now del one by one each
  for (let index = 0; index < ids.length; index++) {
    await HotelFood.findByIdAndDelete({ _id: ids[index] });
  }

  // HotelFood.fi

  // if(filterd){

  //     filterd.remove();

  // }
  // await items.save();

  console.log("filters are ", ids);
  // const itemsLength = items.foods.length;

  // items.foods[index].remove()
  // if (itemsLength === 0) {
  //     items.remove({'_id':mainID})

  // }
  // await items.save();

  // console.log('length is ',len);
  // items.update({$pull:{"foods.0":{"foodPrice":id}}})

  // {$pull : { "someObjects.name1.someNestedArray" : ...
  // { _id : "777" },
  // {$pull : {"someArray.0.someNestedArray" : {"name":"delete me"}}}

  // const del  = await HotelFoods.findOneAndDelete({'trackingID':id});
  // const del  = await HotelFoods.find({'hotelID':id,'typeOfFood':type})
  // .populate('food')
  // .populate('hotelID')
  // .populate('typeOfFood');

  // del.map(async(n,i)=>{

  //     n.food.splice(index,1);
  //     n.images.splice(index,1)
  //     n.foodPrice.splice(index,1)
  //     n.foodQuantity.splice(index,1)

  //     await n.save()
  // })

  // console.log('query id is ',items.foods);

  // del.forEach(n => {

  //     n.food.splice(index,1);
  //     n.images.splice(index,1)
  //     n.foodPrice.splice(index,1)
  //     n.foodQuantity.splice(index,1)

  //     // return del.save();

  // });

  // if(del){
  // const data = await del.save();

  // }

  // const delIndex = del[index]
  // const data = await del.save();

  res.send(item);
});

// Dleivery Man can also be find through some other method;

app.post("/lookdriver", async (req, res) => {
  const foodInfo = req.body;
  // hId = req.query.hId;

  // console.log('query is ',req.body);
  // Select Random Delivery Man
  const count = await FoodDeliver.countDocuments({
    status: "active",
    //  _id: {
    //      $nin: '5efe17dc146fd712a4d13c5a'
    //  }
  });
  const random = Math.floor(Math.random() * count);
  const foodDelivery = await FoodDeliver.findOne({
    status: "active",
    // _id: {
    //     $nin: '5efe17dc146fd712a4d13c5a'
    // }
  }).skip(random);

  //  let ids = [];

  //   ids.push(foodDelivery._id);

  //  const reject = new ReqReject({

  //     dId:ids
  //  });
  const data = {
    foodInfo,
    dId: foodDelivery._id,
  };
  //  const result = await reject.save();

  console.log("array is ", foodDelivery);

  // details = driver;
  if (foodDelivery) {
    io.emit(foodDelivery._id + "requestFoodDelivery", data);
  }

  // console.log('driver id is ',driver);

  res.json(foodDelivery);
});

app.post("/rejected", async (req, res) => {
  const { foodInfo, dId } = req.body;

  const result = await ReqReject.findOne({ trackingID: foodInfo.trackingID });

  //logic for send the request to all other active delivery men except this one!!

  //if same tracking ID then we just update and send request to other delivery person
  let array = [];

  if (result) {
    let driverId = result.dId;
    const index = driverId.indexOf(dId);

    if (index === -1) {
      driverId.push(dId);
    } else {
      driverId.splice(index, 1, dId);
    }

    const deliverRes = await result.save();

    const count = await FoodDeliver.countDocuments({
      status: "active",
      _id: {
        $nin: deliverRes.dId,
      },
    });
    const random = Math.floor(Math.random() * count);

    const deliveryMan = await FoodDeliver.findOne({
      status: "active",
      _id: {
        $nin: deliverRes.dId,
      },
    }).skip(random);
    console.log("1st delivery is ", deliveryMan);

    if (deliveryMan) {
      const data = {
        foodInfo,
        dId: deliveryMan._id,
      };

      io.emit(deliveryMan._id + "requestFoodDelivery", data);
    }
  } else {
    //if diferent tracking ID then we add another doc and send request to delivery person other than this

    array.push(dId);

    const reject = new ReqReject({
      dId: array,
      trackingID: foodInfo.trackingID,
    });

    const deliveryRes = await reject.save();

    const count = await FoodDeliver.countDocuments({
      status: "active",
      _id: {
        $nin: deliveryRes.dId,
      },
    });
    const random = Math.floor(Math.random() * count);
    const deliveryMan = await FoodDeliver.findOne({
      status: "active",
      _id: {
        $nin: deliveryRes.dId,
      },
    }).skip(random);

    if (deliveryMan) {
      const data = {
        foodInfo,
        dId: deliveryMan._id,
      };

      console.log("2nd delivery is ", deliveryMan);

      io.emit(deliveryMan._id + "requestFoodDelivery", data);
    }
  }

  // res.json(deliveryMan);
});

app.put("/update", async (req, res) => {
  const { deliverID, status } = req.body;

  const delivery = await FoodDeliver.findOneAndUpdate(
    { _id: deliverID },
    { status }
  );

  // console.log('update driver is ',driver);

  const data = await delivery.save();
  res.send(data);
});

app.put("/food_delivery_order", async (req, res) => {
  const { deliveryID, id } = req.body;

  const delivery = await CustomerOrder.findOneAndUpdate(
    { _id: id },
    { deliveryID }
  );

  // console.log('update driver is ',driver);

  const data = await delivery.save();
  res.send(data);
});

app.post("/hotel", async (req, res) => {
  const result = new Hotel(req.body);

  const data = await result.save();

  console.log("hotel added ", data);

  res.send(data);
});

app.get("/get_type", async (req, res) => {
  const type = await FoodTypes.find();

  res.send(type);
});

app.get("/get_food", async (req, res) => {
  const { id } = req.query;
  const food = await Foods.find({ type: id }).populate("type");

  console.log("get food is ", food);

  res.send(food);
});

app.get("/get_all_orders", async (req, res) => {
  const { id } = req.query;
  const order = await CustomerOrder.find({ hotelID: id })
    .populate("customerInfo")
    .populate("hotelID")
    .populate({ path: "deliveryID", populate: { path: "user" } });

  // console.log('get order is ',order);

  res.send(order);
});

app.get("/get_deliveryOrders", async (req, res) => {
  const { id } = req.query;
  const order = await CustomerOrder.find({ deliveryID: id })
    .populate("customerInfo")
    .populate({ path: "deliveryID", populate: { path: "user" } });

  // console.log('get order is ',order);

  res.send(order);
});

app.post("/add_type", async (req, res) => {
  const type = new FoodTypes(req.body);

  const data = await type.save();

  // console.log('type added ', data);

  res.send(data);
});

app.post("/customer", async (req, res) => {
  const result = new Customer(req.body);

  const data = await result.save();

  console.log("customer added ", data);

  res.send(data);
});

// app.post('/desi', async (req, res) => {

//     const result = new DesiFood(req.body);

//      const data = await result.save();

//     console.log('desi food added ', data);

//     res.send(data);

// });

// app.post('/chinese', async (req, res) => {

//     const result = new Chinese(req.body);

//      const data = await result.save();

//     console.log('customer added ', data);

//     res.send(data);

// });

// app.post('/fastfood', async (req, res) => {

//     const result = new FastFood(req.body);

//      const data = await result.save();

//     console.log('fastfood added ', data);

//     res.send(data);

// });

app.post("/deals", async (req, res) => {
  const result = new Deals(req.body);

  const data = await result.save();

  console.log("deal added ", data);

  res.send(data);
});

app.post("/add_delivery_man", async (req, res) => {
  const delivery = new FoodDeliver(req.body);
  const data = await delivery.save();

  console.log("driver added ", data);

  res.send(data);
});

app.post("/register", async (req, res) => {
  const user = new User(req.body);
  const data = await user.save();

  console.log("user added ", data);

  res.send(data);
});
// const cpUpload = upload.fields([{name:'desiFoodImage'},{name:'fastFoodImage'},{name:'chineseFoodImage'}])
app.post("/add_food", async (req, res) => {
  const food = new Foods(req.body);
  const data = await food.save();

  // console.log('food added ',req.body);

  res.send(data);
});

app.post("/hotel_food", async (req, res) => {
  console.log("food added ", req.body);

  const food = new HotelFood(req.body);
  const data = await food.save();

  res.send(data);
});

app.post("/hotel_foods", async (req, res) => {
  const isExist = await HotelFoods.findOne({
    typeOfFood: req.body.typeOfFood,
  }).populate("typeOfFood");
  //if foodtype already exist then first do this other add new food item
  if (isExist) {
    console.log("food added is ", req.body);

    // console.log('is exist is ',isExist);

    for (let index = 0; index < req.body.food.length; index++) {
      isExist.trackingID.push(`abc${index}`);
      isExist.food.push(req.body.food[index]);
      isExist.images.push(req.body.images[index]);
      isExist.foodPrice.push(req.body.foodPrice[index]);
      isExist.foodQuantity.push(req.body.foodQuantity[index]);
    }

    await isExist.save();
    res.send(isExist);
  } else {
    // add new food here
    let trackIds = [];
    for (let index = 0; index < req.body.food.length; index++) {
      trackIds.push(`xyz${index}`);
    }
    const { food, typeOfFood, hotelID, images, foodPrice, foodQuantity } =
      req.body;

    const foods = new HotelFoods({
      trackingID: trackIds,
      food: food,
      typeOfFood: typeOfFood,
      hotelID: hotelID,
      images: images,
      foodPrice: foodPrice,
      foodQuantity: foodQuantity,
    });

    const data = await foods.save();

    res.send(data);
  }
});

app.post("/hotel_reg", async (req, res) => {
  const hotel = new HotelReg(req.body);
  const data = await hotel.save();

  console.log("food added ", req.body);

  res.send({
    data,
    msg: "Congratulations You have registered successfully now click on the link to visit your profile ",
  });
});

app.post("/all_food", async (req, res) => {
  let filter = {};
  const filters = req.body.filters;
  for (let key in filters) {
    if (filters[key].length > 0) {
      filter[key] = filters[key];
    }
  }
  console.log("filters are ", filter);

  const foods = await HotelFoods.find(filter)
    .populate("food")
    .populate("typeOfFood")
    .populate("hotelID");

  // console.log('added food is ',foods);
  // const chinese = await Chinese.find();
  // const desi = await DesiFood.find();
  // const fast = await FastFood.find();

  res.send(foods);
});

app.get("/hotelFood", async (req, res) => {
  const foods = await HotelFood.find()
    .populate("typeOfFood")
    .populate("hotelID")
    //  .populate({path:'foodName',populate:{path:('type')}});
    .populate("foods.foodName")
    .exec();

  //     const hotel_id = req.query.hotelID;
  // const foods = await HotelFoods.find({'hotelID':hotel_id})
  // .populate('typeOfFood')
  // .populate('food')
  // .populate('hotelID');

  // console.log('hotel id is ',hotel_id);
  // const chinese = await Chinese.find();
  // const desi = await DesiFood.find();
  // const fast = await FastFood.find();

  res.send(foods);
});

app.get("/food", async (req, res) => {
  const chinese = await Chinese.find();
  const desi = await DesiFood.find();
  const fast = await FastFood.find();

  res.send({ chinese, desi, fast });
});
// let cooks = {};
let tokens = [];
app.post("/login", async (req, res) => {
  const user = await User.findOne({ email: req.body.email });
  if (!user)
    return res.json({
      loginSuccess: false,
      message: "Auth failed, email not found",
    });

  // user.comparePassword(req.body.password,(err,isMatch)=>{
  // if(!isMatch) return res.json({loginSuccess:false,message:'Wrong password'});
  const isMatch = await bcrypt.compare(req.body.password, user.password);
  if (!isMatch) {
    console.log("wrong paasword");
    return res.json({ loginSuccess: false, message: "Wrong password" });
  }

  const secret = "abc12345";
  // res.cookie('user',secret);
  let token = jwt.sign(user._id.toHexString(), secret);
  user.token = token;
  await user.save();

  const isDeliver = await FoodDeliver.findOne({ user: user._id }).populate(
    "user"
  );
  const isHotel = await HotelReg.findOne({ user: user._id }).populate("user");

  console.log("res is ", req.body);
  if (isDeliver === null && isHotel === null) {
    res.cookie("w_auth", token).status(200).json({
      loginSuccess: true,
      isDeliver: false,
      isHotel: false,
      //  cooks:req.cookies
    });
  } else {
    if (isHotel !== null && isDeliver === null) {
      res.cookie("w_auth", token).status(200).json({
        loginSuccess: true,
        isDeliver: false,
        isHotel: true,
        //  cooks:req.cookies
      });
    }

    if (isDeliver !== null && isHotel === null) {
      res.cookie("w_auth", token).status(200).json({
        loginSuccess: true,
        isDeliver: true,
        isHotel: false,
        //  cooks:req.cookies
      });
    }
  }
});
//  97644796985

app.get("/auth", auth, (req, res) => {
  res.send({
    // isAdmin: req.user.role === 0 ? false : true,
    isAuth: true,
    user: req.user,
    hotel: req.hotel,
    deliveryMan: req.foodDelivery,
    // email: req.user.email,
    // name: req.user.name,
    // lastname: req.user.lastname,
    // role: req.user.role,
    // cart: req.user.cart,
    // history: req.user.history
  });
});

server.listen(port, () => console.log("server running on port:" + port));
