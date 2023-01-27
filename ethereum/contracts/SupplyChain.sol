pragma solidity ^0.8.0;

contract SupplyChain{

    enum Status{Created, Delivering, Delivered, Accepted, Declined}

    Order[] orders;
    
    mapping(address => uint256[]) public selfOrders; //user can check the indexes

    struct Order{
        string title;
        string desc;
        address supplier;
        address delCompany;
        address customer;
        Status status;
    }

    event OrderCreated(
        uint256 index,
        address indexed delCompany,
        address indexed customer
    );

    event OrderDelivering(
        uint256 index,
        address indexed supplier,
        address indexed customer
    );

    event OrderDelivered(
        uint256 index,
        address indexed supplier,
        address indexed customer
    );

    event OrderAccepted(
        uint256 index,
        address indexed supplier,
        address indexed delCompany
    );

    event OrderDeclined(
        uint256 index,
        address indexed supplier,
        address indexed delCompany
    );

    modifier onlyOrderDelCompany(uint256 _index){
        require(orders[_index].delCompany == msg.sender);
        _; 
    }

    modifier onlyCustomer(uint256 _index){
        require(orders[_index].customer == msg.sender);
        _;
    }

    modifier orderCreated(uint256 _index){
        require(orders[_index].status == Status.Created);
        _; 
    }

    modifier orderDelivering(uint256 _index){
        require(orders[_index].status == Status.Delivered);
        _; 
    }

    modifier orderDelivered(uint256 _index){
        require(orders[_index].status == Status.Delivered);
        _; 
    }

    function getOrdersLength() public view returns (uint256){
        return orders.length;
    }

    function getOrder(
        uint256 _index
    ) public view returns(string memory title, string memory desc, address, address, address, Status){
        Order memory order = orders[_index];
        return (
            order.title, 
            order.desc, 
            order.supplier,
            order.delCompany,
            order.customer,
            order.status
        ); 
    }

    function getSelfOrdersLength(
        address _address
    ) public view returns(uint256){
        return selfOrders[_address].length;
    }
    function createOrder(
        string memory _title,
        string memory _desc,
        address _delCompany,
        address _customer
    ) public returns (uint256){
        Order memory order = Order({
            title: _title,
            desc: _desc,
            supplier: msg.sender,
            delCompany: _delCompany,
            customer: _customer,
            status: Status.Created
        });
        uint256 index = orders.length;
        emit OrderCreated(orders.length, _delCompany, _customer);
        orders.push(order);
        selfOrders[msg.sender].push(index);
        selfOrders[_delCompany].push(index);
        selfOrders[_customer].push(index);
    }

    function startDeliveringOrder(
        uint256 _index
    ) public onlyOrderDelCompany(_index) orderCreated(_index){
        Order storage order = orders[_index];
        emit OrderDelivering(_index, order.supplier, order.customer);
        order.status = Status.Delivering;
    }

    function stopDeliveringOrder(
        uint256 _index
    ) public onlyOrderDelCompany(_index){
        Order storage order = orders[_index];
        emit OrderDelivered(_index, order.supplier, order.customer);
        order.status = Status.Delivered;
    }

    function acceptOrder(
        uint256 _index
    ) public onlyCustomer(_index) orderDelivered(_index){
        Order storage order = orders[_index];
        emit OrderAccepted(_index, order.supplier, order.delCompany);
        orders[_index].status = Status.Accepted;
    }

    function declineOrder(
        uint256 _index
    ) public onlyCustomer(_index) orderDelivered(_index){
         Order storage order = orders[_index];
        emit OrderDeclined(_index, order.supplier, order.delCompany);
        orders[_index].status = Status.Declined;
    }
}