//SPDX-License-Identifier:MIT
pragma solidity ^0.8.28;

import {Token} from "./Token.sol";

contract Factory{
    //State variables
    uint256 public constant TARGET = 3 ether;
    uint256 public constant TOKEN_LIMIT = 500000 ether;
    uint256 public immutable fee;
    address public owner;
    uint256 public totalTokens;

    //Storage variables
    struct TokenSale{
        address token;
        string name;
        address creator;
        uint256 sold;
        uint256 raised;
        bool isOpen;
    }
    //A mapping to access struct template
    mapping(address => TokenSale) public tokenToSale;
  //An array to store tokens
    address[] public tokens;
    //Events
    event Created(address indexed token);
    event Buy(address indexed token,uint256 amount);
    

    constructor(uint256 _fee){
        fee = _fee;
        owner=msg.sender;
    }

    function create(string memory _name,string memory _symbol) external payable{
        //Fee must be paid
        require(msg.value >= fee," Creator fee required!");
        //Create a new token
        Token token = new Token(msg.sender,_name,_symbol,1_000_000 ether);
        //Save the token for later usage
        tokens.push(address(token));
        totalTokens++;
       TokenSale memory sale =  TokenSale(address(token),_name,msg.sender,0,0,true);
       tokenToSale[address(token)] = sale;
       //Emitting CReated event
       emit Created(address(token));

    }
    function getCost(uint256 _sold) public pure returns(uint256){
       uint256 floor = 0.0001 ether;
       uint256 step = 0.001 ether;
       uint256 increment = 10000 ether;

       uint cost = (step*(_sold/increment))+floor;
       return cost;
    }
    function buy(address _token,uint256 _amount)external payable{
        TokenSale storage sale = tokenToSale[_token];
        //Sale must be open
        require(sale.isOpen == true);
        require(_amount >= 1 ether);
        require(_amount <= 10000 ether);
        //Calculation of a token
        uint256 cost = getCost(sale.sold);
        uint256 price= cost*(_amount/10 ** 18);
        //Make sure enough eth is sent
        require(msg.value >= price,"Insufficient Eth recevied");
        //Updating the sale
        sale.sold = sale.sold +_amount;
        sale.raised += price;
        //Make sure func raising goal isnt met
        if(sale.sold >= TOKEN_LIMIT || sale.raised >= TARGET){
            sale.isOpen = false;

        }

        Token(_token).transfer(msg.sender,_amount);
        //Emitting Buy event
        emit Buy(_token,_amount);
    }
    function deposit(address _token) external{
        Token token  = Token(_token);
        TokenSale memory sale =tokenToSale[_token];
                bool targetReached = !sale.isOpen;
        require(targetReached,"Target not reached");
        token.transfer(sale.creator, token.balanceOf(address(this)));
         (bool s, )= payable(sale.creator).call{value: sale.raised}("");
         require(s);
    }
    function withdraw(uint256 _amount) external{
        require(msg.sender == owner);
       (bool s, )= payable(owner).call{value: _amount}("");
        require(s);
    }

}