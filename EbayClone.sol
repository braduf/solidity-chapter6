pragma solidity ^0.4.23;

contract EBayClone {
    struct Product {
        uint id;
        address seller;
        address buyer;
        string name;
        string description;
        uint price;
    }

    uint productCounter;
    mapping (uint => Product) public products;

    event ProductForSale(uint indexed id, address indexed seller, uint indexed price, address buyer, string name, string description);
    event ProductSold(uint indexed id, address indexed seller, address indexed buyer, string name, string description, uint price);       

    function sellProduct(string _name, string _description, uint _price) public{
        
        Product memory newProduct = Product({
            id: productCounter,
            seller: msg.sender,
            buyer: 0x0,
            name: _name,
            description: _description,
            price: _price
        });
                
        products[productCounter] = newProduct;
        productCounter++;

        emit ProductForSale(productCounter, msg.sender, _price, 0x0, _name, _description);
    }

    function getNumberOfProducts() public view returns (uint) {
        return productCounter;
    }
   
    function buyProduct (uint _id) payable public{
        Product storage product = products[_id];
        //require(product.seller != 0x0);
        require(product.buyer == 0x0); // article has not been bought
        require(msg.sender != product.seller); // buyer cannot be same as seller
        require(msg.value == product.price);
        product.buyer = msg.sender;
        product.seller.transfer(msg.value);

        emit ProductSold(_id, product.seller, msg.sender, product.name, product.description, msg.value);
    }
}
