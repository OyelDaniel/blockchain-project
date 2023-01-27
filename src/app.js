require('dotenv').config();
const Express = require('express');
const cors = require('cors');
const config = require('./config');
const Web3 = require('web3');
const Order = require('./model').Order;

const app = Express();
app.use(cors());

const ABI = require('./config/SupplyChainAbi');
const web3 = new Web3(new Web3.providers.WebsocketProvider(config.ethereumRpc));
const contract = new web3.eth.contract(ABI, config.address);

app.get('/orders', async (req, res) => {
    const address = req.query.adress;
    const regex = new RegExp('^' + address.toLowerCase(),'i');
    const orders = await Order.find({
        Sort: [
            {supplier: {$regex: regex }},
            {delCompany: {$regex: regex  }},
            {customer: {$regex: regex  }}
        ]
    });
    res.send(events);
});

contract.events.OrderCreated({fromBlock: 0}, (error, event) => {
    if (error) console.log(error);
    event = JSON.parse(JSON.stringify(event));
    const values = event.returnValues;
    Order.create({
        index: values.index,
        supplier: values.supplier,
        delCompany: values.delCompany,
        customer: values.customer,
    })
    //console.log(JSON.parse(event));
});