// SPDX-License-Identifier: MIT
pragma solidity 0.7.0;

import "./2_Owner.sol";

library SafeMath {
    int256 constant private INT256_MIN = -2**255;

    /**
    * @dev Multiplies two unsigned integers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Multiplies two signed integers, reverts on overflow.
    */
    function mul(int256 a, int256 b) internal pure returns (int256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below

        int256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
    */
    function div(int256 a, int256 b) internal pure returns (int256) {
        require(b != 0); // Solidity only automatically asserts when dividing by 0
        require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow

        int256 c = a / b;

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Subtracts two signed integers, reverts on overflow.
    */
    function sub(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a));

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Adds two signed integers, reverts on overflow.
    */
    function add(int256 a, int256 b) internal pure returns (int256) {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));

        return c;
    }

    /**
    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

contract CYNOTokenContract is Owner {
    using SafeMath for uint256;
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowance;

    mapping(address => Unlock[]) public frozenAddress;
    mapping(address => uint256) public unlock_amount_transfered;
    struct Unlock {
        uint256 unlock_time;
        uint256 amount;
    }

    mapping (address => bool) private _isExcludedFromFee;
    uint public totalSupply = 10000000 * 10**9;
    string public constant name = "Crypto Casino NFT";
    string public constant symbol = "CYNO";
    uint public constant decimals = 9;
    
    uint256 public liquidityFeePercentage = 0; // 100 = 1%
    
    // fees wallets
    address public constant liquidityWallet = 0x5f08a10c86486e5366ebFf03A21B3cDaDf9A2300;
    address public constant aditionalFeeWallet = 0x5f08a10c86486e5366ebFf03A21B3cDaDf9A2300;

    // tokenomics wallets
    address public constant inversionesGenesis_wallet = 0xf9F7A0d2b8cD315b368A2F0AB08f5d57337178cc;
    address public constant staking_wallet = 0x8c8ED0e195660eaCC77Bd369ecbce33130Db227e;
    address public constant preventaDonadores_wallet = 0xFc80A790E4d9ebA4bdAb8d3D6a8daB9667Fd3167;
    address public constant preventaPublica1_wallet = 0x442fE5055Ca9a739d289FCA2027c469321a992eE;
    address public constant preventaPublica2_wallet = 0x2Cc3f224683808bb184DeC4163A74942ECF0CDcB;
    address public constant plataforma_wallet = 0xf394BE5547cE6A151647087AAbda0E902107B738;
    address public constant marketing_wallet = 0xC77e93ED8654a198F2d1982B7545fA815deA4747;
    address public constant liquidez_wallet = 0x5f08a10c86486e5366ebFf03A21B3cDaDf9A2300;
    address public constant equipo_wallet = 0x380f11e66de37E726C71177c6b3dA4bbBEBa5cca;
    address public constant playToEarn_wallet = 0x1355f9F9D9431199C5C69Ff4484717B81a8058AE;

    // tokenomics supply
    uint public constant inversionesGenesis_supply = 200000 * 10**9;
    uint public constant staking_supply = 251000 * 10**9;
    uint public constant preventaDonadores_supply = 297570 * 10**9;
    uint public constant preventaPublica1_supply = 276430 * 10**9;
    uint public constant preventaPublica2_supply = 500000 * 10**9;
    uint public constant plataforma_supply = 500000 * 10**9;
    uint public constant marketing_supply = 600000 * 10**9;
    uint public constant liquidez_supply = 375000 * 10**9;
    uint public constant equipo_supply = 1000000 * 10**9;
    uint public constant playToEarn_supply = 6000000 * 10**9;
    
    event SetLiquidityFee(uint256 oldValue, uint256 newValue);
    event SetAditionalFeePercentage_1(uint256 oldValue, uint256 newValue);
    event SetAditionalFeePercentage_2(uint256 oldValue, uint256 newValue);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    
    constructor() {
        // set tokenomics balances
        balances[inversionesGenesis_wallet] = inversionesGenesis_supply;
        emit Transfer(address(0), inversionesGenesis_wallet, inversionesGenesis_supply);

        balances[staking_wallet] = staking_supply;
        emit Transfer(address(0), staking_wallet, staking_supply);

        balances[preventaDonadores_wallet] = preventaDonadores_supply;
        emit Transfer(address(0), preventaDonadores_wallet, preventaDonadores_supply);

        balances[preventaPublica1_wallet] = preventaPublica1_supply;
        emit Transfer(address(0), preventaPublica1_wallet, preventaPublica1_supply);

        balances[preventaPublica2_wallet] = preventaPublica2_supply;
        emit Transfer(address(0), preventaPublica2_wallet, preventaPublica2_supply);

        balances[plataforma_wallet] = plataforma_supply;
        emit Transfer(address(0), plataforma_wallet, plataforma_supply);

        balances[marketing_wallet] = marketing_supply;
        emit Transfer(address(0), marketing_wallet, marketing_supply);

        balances[liquidez_wallet] = liquidez_supply;
        emit Transfer(address(0), liquidez_wallet, liquidez_supply);

        balances[equipo_wallet] = equipo_supply;
        emit Transfer(address(0), equipo_wallet, equipo_supply);

        balances[playToEarn_wallet] = playToEarn_supply;
        emit Transfer(address(0), playToEarn_wallet, playToEarn_supply);

        // lock tokenomics balances
        // tge_time = 4/04/2022 14:00:00
        uint256 tge_time = 1649095200;
        // 2592000 = 30 days
        uint256 month_time = 2592000;

        // inversionesGenesis
        frozenAddress[inversionesGenesis_wallet].push(Unlock(tge_time + 1, 20000 * 10**9));
        frozenAddress[inversionesGenesis_wallet].push(Unlock(tge_time + (month_time * 1), 20000 * 10**9));
        frozenAddress[inversionesGenesis_wallet].push(Unlock(tge_time + (month_time * 2), 20000 * 10**9));
        frozenAddress[inversionesGenesis_wallet].push(Unlock(tge_time + (month_time * 3), 20000 * 10**9));
        frozenAddress[inversionesGenesis_wallet].push(Unlock(tge_time + (month_time * 4), 20000 * 10**9));
        frozenAddress[inversionesGenesis_wallet].push(Unlock(tge_time + (month_time * 5), 20000 * 10**9));
        frozenAddress[inversionesGenesis_wallet].push(Unlock(tge_time + (month_time * 6), 20000 * 10**9));
        frozenAddress[inversionesGenesis_wallet].push(Unlock(tge_time + (month_time * 7), 20000 * 10**9));
        frozenAddress[inversionesGenesis_wallet].push(Unlock(tge_time + (month_time * 8), 20000 * 10**9));
        frozenAddress[inversionesGenesis_wallet].push(Unlock(tge_time + (month_time * 9), 20000 * 10**9));

        // plataforma
        frozenAddress[plataforma_wallet].push(Unlock(tge_time + 1, 50000 * 10**9));
        frozenAddress[plataforma_wallet].push(Unlock(tge_time + (month_time * 1), 50000 * 10**9));
        frozenAddress[plataforma_wallet].push(Unlock(tge_time + (month_time * 2), 50000 * 10**9));
        frozenAddress[plataforma_wallet].push(Unlock(tge_time + (month_time * 3), 50000 * 10**9));
        frozenAddress[plataforma_wallet].push(Unlock(tge_time + (month_time * 4), 50000 * 10**9));
        frozenAddress[plataforma_wallet].push(Unlock(tge_time + (month_time * 5), 50000 * 10**9));
        frozenAddress[plataforma_wallet].push(Unlock(tge_time + (month_time * 6), 50000 * 10**9));
        frozenAddress[plataforma_wallet].push(Unlock(tge_time + (month_time * 7), 50000 * 10**9));
        frozenAddress[plataforma_wallet].push(Unlock(tge_time + (month_time * 8), 50000 * 10**9));
        frozenAddress[plataforma_wallet].push(Unlock(tge_time + (month_time * 9), 50000 * 10**9));

        // marketing
        frozenAddress[marketing_wallet].push(Unlock(tge_time + 1, 60000 * 10**9));
        frozenAddress[marketing_wallet].push(Unlock(tge_time + (month_time * 1), 60000 * 10**9));
        frozenAddress[marketing_wallet].push(Unlock(tge_time + (month_time * 2), 60000 * 10**9));
        frozenAddress[marketing_wallet].push(Unlock(tge_time + (month_time * 3), 60000 * 10**9));
        frozenAddress[marketing_wallet].push(Unlock(tge_time + (month_time * 4), 60000 * 10**9));
        frozenAddress[marketing_wallet].push(Unlock(tge_time + (month_time * 5), 60000 * 10**9));
        frozenAddress[marketing_wallet].push(Unlock(tge_time + (month_time * 6), 60000 * 10**9));
        frozenAddress[marketing_wallet].push(Unlock(tge_time + (month_time * 7), 60000 * 10**9));
        frozenAddress[marketing_wallet].push(Unlock(tge_time + (month_time * 8), 60000 * 10**9));
        frozenAddress[marketing_wallet].push(Unlock(tge_time + (month_time * 9), 60000 * 10**9));

        // equipo
        frozenAddress[equipo_wallet].push(Unlock(tge_time + 1, 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 1), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 2), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 3), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 4), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 5), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 6), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 7), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 8), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 9), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 10), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 11), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 12), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 13), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 14), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 15), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 16), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 17), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 18), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 19), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 20), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 21), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 22), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 23), 40000 * 10**9));
        frozenAddress[equipo_wallet].push(Unlock(tge_time + (month_time * 24), 40000 * 10**9)); 
    }

    function checkFrozenAddress(address _account, uint256 _amount) private returns(bool){
        bool allowed_operation = false;
        uint256 amount_unlocked = 0;
        bool last_unlock_completed = false;
        if(frozenAddress[_account].length > 0){

            for(uint256 i=0; i<frozenAddress[_account].length; i++){
                if(block.timestamp >= frozenAddress[_account][i].unlock_time){
                    amount_unlocked = amount_unlocked.add(frozenAddress[_account][i].amount);
                }
                if(i == (frozenAddress[_account].length-1) && block.timestamp >= frozenAddress[_account][i].unlock_time){
                    last_unlock_completed = true;
                }
            }

            if(last_unlock_completed == false){
                if(amount_unlocked.sub(unlock_amount_transfered[_account]) >= _amount){
                    allowed_operation = true;
                }else{
                    allowed_operation = false;
                }
            }else{
                allowed_operation = true;
            }

            if(allowed_operation == true){
                unlock_amount_transfered[_account] = unlock_amount_transfered[_account].add(_amount);
            }
        }else{
            allowed_operation = true;
        }

        return allowed_operation;
    }

    function excludeFromFee(address[] memory accounts) public isOwner {
        for (uint256 i=0; i<accounts.length; i++) {
            _isExcludedFromFee[accounts[i]] = true;
        }
    }
    function includeInFee(address[] memory accounts) public isOwner {
        for (uint256 i=0; i<accounts.length; i++) {
            _isExcludedFromFee[accounts[i]] = false;
        }
    }
    function isExcludedFromFee(address account) public view returns(bool) {
        return _isExcludedFromFee[account];
    }

    function modifyLiquidityFeePercentage(uint256 _newVal) external isOwner {
        require(_newVal <= 1000, "the new value should range from 0 to 1000");
        emit SetLiquidityFee(liquidityFeePercentage, _newVal);
        liquidityFeePercentage = _newVal;
    }
    
    function balanceOf(address owner) public view returns(uint) {
        return balances[owner];
    }

    function getLiquidityFee(uint256 _value) public view returns(uint256){
        return _value.mul(liquidityFeePercentage).div(10**4);
    }
    
    function getAdditionalFee(uint256 _value) private pure returns(uint256){
        uint256 aditionalFee = 0;
        if(_value >= 3001 * 10**9){
            aditionalFee = _value.mul(1000).div(10**4); // 1000 = 10%
        }
        if(_value >= 5001 * 10**9){
            aditionalFee = _value.mul(2000).div(10**4); // 2000 = 20%
        }
        if(_value >= 8001 * 10**9){
            aditionalFee = _value.mul(3500).div(10**4); // 3500 = 35%
        }
        if(_value >= 10001 * 10**9){
            aditionalFee = _value.mul(6000).div(10**4); // 6000 = 60%
        }
        if(_value >= 12001 * 10**9){
            aditionalFee = _value.mul(8000).div(10**4); // 8000 = 80%
        }
        return aditionalFee;
    }
    
    function transfer(address to, uint value) external returns(bool) {
        require(checkFrozenAddress(msg.sender, value) == true, "the amount is greater than the amount available unlocked");
        require(balanceOf(msg.sender) >= value, 'balance too low');

        //if any account belongs to _isExcludedFromFee account then remove the fee
        if(_isExcludedFromFee[msg.sender] || _isExcludedFromFee[to]){
            balances[to] += value;
            emit Transfer(msg.sender, to, value);
        }else{
            balances[liquidityWallet] += getLiquidityFee(value);
            balances[aditionalFeeWallet] += getAdditionalFee(value);
            balances[to] += value.sub(getLiquidityFee(value).add(getAdditionalFee(value)));
            emit Transfer(msg.sender, liquidityWallet, getLiquidityFee(value));
            emit Transfer(msg.sender, aditionalFeeWallet, getAdditionalFee(value));
            emit Transfer(msg.sender, to, value.sub(getLiquidityFee(value).add(getAdditionalFee(value))));
        }
        balances[msg.sender] -= value;
        return true;
    }

    function transferFrom(address from, address to, uint value) external returns(bool) {
        require(checkFrozenAddress(from, value) == true, "the amount is greater than the amount available unlocked");
        require(balanceOf(from) >= value, 'balance too low');
        require(allowance[from][msg.sender] >= value, 'allowance too low');

        //if any account belongs to _isExcludedFromFee account then remove the fee
        if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
            balances[to] += value;
            emit Transfer(from, to, value);
        }else{
            balances[liquidityWallet] += getLiquidityFee(value);
            balances[aditionalFeeWallet] += getAdditionalFee(value);
            balances[to] += value.sub(getLiquidityFee(value).add(getAdditionalFee(value)));
            emit Transfer(from, liquidityWallet, getLiquidityFee(value));
            emit Transfer(from, aditionalFeeWallet, getAdditionalFee(value));
            emit Transfer(from, to, value.sub(getLiquidityFee(value).add(getAdditionalFee(value))));
        }

        balances[from] -= value;
        allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
        return true;
    }
    
    function approve(address spender, uint value) external returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;   
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) private {
        require(account != address(0), "ERC20: burn from the zero address");
        uint256 accountBalance = balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        balances[account] = accountBalance.sub(amount);
        totalSupply = totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function burn(uint256 amount) public isOwner {
        _burn(msg.sender, amount);
    }
}