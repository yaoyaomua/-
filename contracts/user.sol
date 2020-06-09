pragma solidity >=0.4.22 <0.7.0;

contract UserContract{
    
    address admin;
    
    
    //存储user
    mapping(address => User) registeredUser;
    //user addr->ID
    mapping(uint => address) uIDtoAddress;
    //user注册状态
    mapping(uint => bool) isResteredUser;
    
    
    //普通用户结构
    struct User{
        address uAccount;
        uint uID;
        string uName;
        string uGender;
        string uBirth;
        string uNation;
        bool uisActive;
    }
    
    
    //管理员通过普通用户address返回普通用户详细信息
    event e_getAddedUserbyAddr(
        address uAccount,
        uint uID,
        string uName,
        string uGender,
        string uBirth,
        string uNation);
    //管理员通过普通用户唯一的ID返回普通用户详细信息   
    event e_getAddedUserbyuID(
        address uAccount,
        uint uID,
        string uName,
        string uGender,
        string uBirth,
        string uNation);
    
    
    //普通用户注册账号
    event e_addUser(
        address newUserAddress,
        uint uID, 
        string uName, 
        string uGender, 
        string uBirth,
        string uNation);
    //普通用户查看自己个人信息
    event e_addUser(
        uint uID, 
        string uName, 
        string uGender, 
        string uBirth,
        string uNation);
    
    //权限控制，接下来的激活或冻结主办方机构只有管理员才能执行
    modifier onlyAdmin{
        require(msg.sender == admin);
        _;
    }
    
    
    //只有管理员才能查看user信息
    function getAddedUserbyAddr(address UserAddress) public  onlyAdmin  returns(
        address uAccount,
        uint uID,
        string memory uName,
        string memory uGender,
        string memory uBirth,
        string memory uNation) {
        
        //要求该主办方机构实例已经注册
        require(registeredUser[UserAddress].uisActive == true);
        //实例化主办方机构
        User storage user = registeredUser[UserAddress];
        
        //调用event事件监听
        emit e_getAddedUserbyAddr(
            UserAddress,
            user.uID,
            user.uName,
            user.uGender,
            user.uBirth,
            user.uNation);
        
        //返回所需要的详细信息
        return(
            UserAddress,
            user.uID,
            user.uName,
            user.uGender,
            user.uBirth,
            user.uNation);
    }
    
    //只有管理员才能查看user信息
    function getAddedUserbyuID(uint userID) public onlyAdmin returns(
        address uAccount,
        uint uID,
        string memory uName,
        string memory uGender,
        string memory uBirth,
        string memory uNation) {
        
        //要求该主办方机构实例已经注册
        require(registeredUser[uIDtoAddress[userID]].uisActive == true);
        //实例化主办方机构
        address UserAddressbyuID = uIDtoAddress[userID];
        User storage user = registeredUser[UserAddressbyuID];
        
        //调用event事件监听
        emit e_getAddedUserbyuID(
            UserAddressbyuID,
            user.uID,
            user.uName,
            user.uGender,
            user.uBirth,
            user.uNation);
        
        //返回所需要的详细信息
        return(
            UserAddressbyuID,
            user.uID,
            user.uName,
            user.uGender,
            user.uBirth,
            user.uNation);
    }
    
    
    ////User操作
    //User注册账号
    function addUser(
        address newUserAddress,
        uint uID, 
        string memory uName, 
        string memory uGender, 
        string memory uBirth,
        string memory uNation) public{
            
        //判断未注册过
        require(!isResteredUser[uID]);
        require(newUserAddress == msg.sender);
        //添加从ID到address的映射
        uIDtoAddress[uID] = newUserAddress;
        //注册新的普通用户账户，并激活注册
        registeredUser[newUserAddress] = User({
            uAccount : newUserAddress, 
            uID : uID,
            uName : uName, 
            uGender : uGender, 
            uBirth : uBirth,
            uNation : uNation,
            uisActive : true});
        isResteredUser[uID] = true;
        //调用event
        emit e_addUser(
            newUserAddress, 
            uID, uName, 
            uGender, 
            uBirth,
            uNation);
    }
    
    
    
    //User查看个人信息
    function getUserInfo(uint _uID) public returns(
        uint uID, 
        string memory uName, 
        string memory uGender, 
        string memory uBirth,
        string memory uNation) {
        
        //判断是否是该用户查看自己信息，否则不允许查看
        require(uIDtoAddress[_uID] == msg.sender);
        //实例化user
        User storage user = registeredUser[msg.sender];
        //调用event
        emit e_addUser(
            user.uID, 
            user.uName, 
            user.uGender, 
            user.uBirth,
            user.uNation);
        //返回个人信息    
        return(
            user.uID, 
            user.uName, 
            user.uGender, 
            user.uBirth,
            user.uNation);
    }
     
}
