const express = require('express');
const cors = require('cors');
const authRouter = require('./routes/user');
const { default: mongoose } = require('mongoose');
const documentRouter = require('./routes/document');

const app  = express();
app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);
const PORT = 3001 | process.env.PORT

const DB = "mongodb+srv://Amanpatel:amanpatel@cluster0.ktstebb.mongodb.net/?retryWrites=true&w=majority";

mongoose.connect(DB).then(()=>{
    console.log("Database is connected");
}).catch((error)=>{
    console.log("This is the error");
    console.log(error);
})


app.listen(PORT, ()=>{
    console.log(`connected at the port ${PORT}`);
})