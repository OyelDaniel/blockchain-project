const{
    PORT = 8080,
    HOST_URI = 'localhost8000',

    MONGO_URI = '',

    ETHEREUM_RPC = '',

    CONTRACT_ADDRESS = ''
} = process.env;

module.exports = {
    port: PORT,
    hostUri: HOST_URI,

    mongoUri: MONGO_URI,

    ethereumRpc: ETHEREUM_RPC,
    
    address: CONTRACT_ADDRESS
};