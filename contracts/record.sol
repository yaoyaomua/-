pragma solidity >=0.4.22 <0.7.0;

contract ContestRecord {
    
    address admin;
    //存储已授权sponsor
    mapping(address => bool) authedSponer;
    //存储已授权team
    mapping(address => bool) authedTeam;
    
    //存储sponsor
    mapping(address => Sponsor) registeredSponor;
    //sponsor addr->ID
    mapping(uint => address) sIDtoAddress;
    //sponsor注册状态
    mapping(uint => bool) isResteredSponor;

    //存储team
    mapping(address => Team) registeredTeam;
    //team addr->ID
    mapping(uint => address) tIDtoAddress;
    //team注册状态
    mapping(uint => bool) isResteredTeam;


    //存储临时record
    Record tempRecord;
    //根据rID存储record
    mapping(uint => Record) rIDtoRecord;
    //根据sID存储record
    mapping(uint => Record[]) sIDtoRecord;
    //根据tID存储record
    mapping(uint => Record[]) tIDtoRecord;
    
    //存储临时match
    Match tempMatch;
    //根据mID存储match
    mapping(uint => Match) mIDtoMatch;
    //根据rID存储match
    mapping(uint => Match[]) rIDtoMatch;
    //根据tID存储match
    mapping(uint => Match[]) tIDtoMatch;
    
    
    //sponsor结构
    struct Sponsor{
        address sAccount;
        uint sID;
        string sName;
        string sNation;
        string sLocation;
        string sEmail;
        string sWeb;
        bool sisActive;
    }
    
    //team结构
    struct Team{
        address tAccount;
        uint tID;
        string tName;
        string tNation;
        string tLocation;
        string tEmail;
        string tWeb;
        bool tisActive;
    }
    
    
    //record结构
    struct Record {
        uint rID;
        string rGameName;
        string rContestName;
        string rTime;
        string rLocation;
        uint tIDa;
        uint tIDb;
        string rResult;
        uint sID;
        bool risActive;
    }
    
    //match结构
    struct Match{
        uint mID;
        uint rID;
        uint tID;
        string player;
        string KDA;
        string mResult;
        string other;
        bool misActive;
        
    }
    
    
    
    
    //event事件声明
    
    //管理员操作 
    //激活sponsor权限
    event e_activeSponor(
        uint sID, 
        address SponsorAddress);
    
    //冻结sponsor权限
    event e_freezeSponor(
        uint sID, 
        address SponsorAddress);
    
    //激活team权限
    event e_activeTeam(
        uint tID,
        address TeamAddress);

    //冻结team权限
    event e_freezeTeam(
        uint tID,
        address TeamAddress);
    
     
    //查询返回操作
    //spons address返回信息
    event e_getAddedSponorbyAddr(
        address sAccount,
        uint sID,
        string sName,
        string sNation,
        string sLocation,
        string sEmail,
        string sWeb,
        bool sisActive);
        
    //team address返回信息
    event e_getAddedTeambyAddr(
        address tAccount, 
        uint tID, 
        string tName, 
        string tNation, 
        string tLocation,
        string tEmail, 
        string tWeb,
        bool tisActive);
        
    
    //通过sID返回address
    event e_getAddedSponorbysID(
        address sAccount,
        uint sID);
        
        
    //通过tID返回address
    event e_getAddedTeambytID(
        address tAccount,
        uint tID);
    
    
    //通过rID返回信息
    event e_getAddedRecordbyrID(
        uint rID, 
        string rGameName, 
        string rContestName, 
        string rTime, 
        string rLocation,
        uint tIDa, 
        uint tIDb, 
        string rResult, 
        uint sID);
    
    //通过mID返回参赛记录
    event e_getAddedMatchbymID(
        uint mID,
        uint rID,
        uint tID,
        string player,
        string KDA,
        string mResult,
        string other);
    
    
    
    
    //添加主办方机构账户并注册实例
    event e_addSponorInstance(
        address newSponsorAddress, 
        uint sID, 
        string sName, 
        string sNation,
        string sLocation,
        string sEmail, 
        string sWeb);
    //主办方添加赛事纪录
    event e_addRecord(
        uint rID, 
        string rGameName, 
        string rContestName, 
        string rTime, 
        string rLocation,
        uint tIDa, 
        uint tIDb, 
        string rResult, 
        uint sID);
       

    //添加team
    event e_addTeamInstance(
        address newTeamAddress, 
        uint tID, 
        string tName, 
        string tNation, 
        string tLocation,
        string tEmail, 
        string tWeb);
    //team添加参赛纪录
    event e_addMatch(
        uint mID,
        uint rID,
        uint tID,
        string player,
        string KDA,
        string mResult,
        string other);
    
    
    
    
    
    
    
    //权限控制
    modifier onlyAdmin{
        require(msg.sender == admin);
        _;
    }
    
    
    
    
    
    
    ////管理员操作
    
    //管理员授予主办方机构权限
    function activeSponor(uint sID) public onlyAdmin{
        //要求被执行的地址不为零
        require(sIDtoAddress[sID] != address(0));
        //激活权限
        authedSponer[sIDtoAddress[sID]] = true;
        //调用event事件监听
        emit e_activeSponor(sID, sIDtoAddress[sID]);
    }
    
    
    //管理员撤销主办方机构权限
    function freezeSponor(uint sID) public onlyAdmin{
        //要求被执行的地址不为零
        require(sIDtoAddress[sID] != address(0));
        //冻结权限
        authedSponer[sIDtoAddress[sID]] = false;
        //调用event事件监听
        emit e_activeSponor(sID, sIDtoAddress[sID]);
    }
    
    
    //管理员授予主队伍权限
    function activeTeam(uint tID) public onlyAdmin{
        //要求被执行的地址不为零
        require(tIDtoAddress[tID] != address(0));
        //激活权限
        authedTeam[tIDtoAddress[tID]] = true;
        //调用event
        emit e_activeTeam(tID, tIDtoAddress[tID]);
    }
    
    
    //管理员撤销队伍权限
    function freezeTeam(uint tID) public onlyAdmin{
        //要求被执行的地址不为零
        require(tIDtoAddress[tID] != address(0));
        //冻结权限
        authedTeam[tIDtoAddress[tID]] = false;
        //调用event
        emit e_freezeTeam(tID, tIDtoAddress[tID]);
    }
    
    
    
    
    
    
    
    
    ////相关的查询返回操作
    //通过主办方机构address返回主办方机构详细信息
    function getAddedSponorbyAddr(address SponsorAddress) public returns(
        address sAccount, 
        uint sID, 
        string memory sName,
        string memory sNation, 
        string memory sLocation,
        string memory sEmail, 
        string memory sWeb, 
        bool sisActive){
        
        //要求sponsor已注册
        require(registeredSponor[SponsorAddress].sisActive == true);
        //实例化sponsor
        Sponsor storage sponsor = registeredSponor[SponsorAddress];
        
        //调用event事件监听
        emit e_getAddedSponorbyAddr(
            SponsorAddress, 
            sponsor.sID, 
            sponsor.sName, 
            sponsor.sNation, 
            sponsor.sLocation,
            sponsor.sEmail, 
            sponsor.sWeb, 
            sponsor.sisActive);
        
        //返回所需要的详细信息
        return(
            SponsorAddress, 
            sponsor.sID, 
            sponsor.sName, 
            sponsor.sNation, 
            sponsor.sLocation,
            sponsor.sEmail, 
            sponsor.sWeb,
            sponsor.sisActive);
    }
    
    //通过队伍address返回队伍详细信息
    function getAddedTeambyAddr(address TeamAddress) public returns(
        address tAccount, 
        uint tID, 
        string memory tName, 
        string memory tNation, 
        string memory tLocation,
        string memory tEmail, 
        string memory tWeb, 
        bool tisActive)  {
            
        //要求该队伍已经注册
        require(registeredTeam[TeamAddress].tisActive == true);
        
        //实例化队伍
        Team storage team = registeredTeam[TeamAddress];
        
        //调用event
        emit e_getAddedTeambyAddr(
            TeamAddress, 
            team.tID, 
            team.tName, 
            team.tNation, 
            team.tLocation,
            team.tEmail, 
            team.tWeb, 
            team.tisActive);
        
        //返回详细信息
        return(
            TeamAddress, 
            team.tID,
            team.tName, 
            team.tNation, 
            team.tLocation,
            team.tEmail, 
            team.tWeb, 
            team.tisActive);
    }
    
    
    ////通过sID返回address
    function getAddedSponorbysID(uint _sID) public returns(
        address sAccount,
        uint sID){
        require(sIDtoAddress[_sID] != address(0));
        emit e_getAddedSponorbysID(
            sIDtoAddress[_sID],
            _sID);
        return(
            sIDtoAddress[_sID],
            _sID);
        }

        
        
    //通过tID返回address
    function getAddedTeambytID(uint _tID) public returns(
        address tAccount,
        uint tID){
        require(tIDtoAddress[_tID] != address(0));
        emit e_getAddedTeambytID(
            tIDtoAddress[_tID],
            _tID);
        return(
            tIDtoAddress[_tID],
            _tID);
        }
    
    
    //通过rID返回record
    function getAddedRecordbyrID(uint _rID) public returns(
        uint rID, 
        string memory rGameName, 
        string memory rContestName,
        string memory rTime, 
        string memory rLocation,
        uint tIDa, 
        uint tIDb, 
        string memory rResult, 
        uint sID){
        //要求所查询的record存在 
        require(rIDtoRecord[_rID].risActive == true);
        //实例化所查询的record
        Record storage record = rIDtoRecord[_rID];
        //调用event
        emit e_getAddedRecordbyrID(
            record.rID,
            record.rGameName,
            record.rContestName,
            record.rTime,
            record.rLocation,
            record.tIDa,
            record.tIDb,
            record.rResult,
            record.sID);
        //返回所需要的详细信息
        return(
            record.rID,
            record.rGameName,
            record.rContestName,
            record.rTime,
            record.rLocation,
            record.tIDa,
            record.tIDb,
            record.rResult,
            record.sID);    
        }
    
    //通过mID返回参赛记录
    function getAddedMatchbymID(uint _mID) public returns(
        uint mID,
        uint rID,
        uint tID,
        string memory player,
        string memory KDA,
        string memory mResult,
        string memory other){
        //要求所查询的赛事纪录存在 
        require(mIDtoMatch[_mID].misActive == true);
        //实例化所查询的match
        Match storage m = mIDtoMatch[_mID];
        //调用event
        emit e_getAddedMatchbymID(
            m.mID,
            m.rID,
            m.tID,
            m.player,
            m.KDA,
            m.mResult,
            m.other);
        //返回所需要的详细信息
        return(
            m.mID,
            m.rID,
            m.tID,
            m.player,
            m.KDA,
            m.mResult,
            m.other);    
        }
    
    
    
   ////主办方操作
    //添加主办方机构账户并注册实例
    function addSponorInstance(
        address newSponsorAddress, 
        uint sID, 
        string memory sName, 
        string memory sNation,
        string memory sLocation,
        string memory sEmail, 
        string memory sWeb) public {
            
        //判断未注册过
        require(!isResteredSponor[sID]);
        //要求注册账号和发送请求账号一致
        require(newSponsorAddress == msg.sender);
        //添加从主办方ID到主办方address的映射
        sIDtoAddress[sID] = newSponsorAddress;
        //注册新的主办方机构账户，并激活注册
        registeredSponor[newSponsorAddress] = Sponsor({
            sAccount : newSponsorAddress,
            sID : sID, 
            sName : sName, 
            sNation : sNation, 
            sLocation : sLocation,
            sEmail : sEmail, 
            sWeb :sWeb, 
            sisActive : true});
        isResteredSponor[sID] = true;
        //调用event事件监听
        emit e_addSponorInstance(
            newSponsorAddress, 
            sID, 
            sName, 
            sNation, 
            sLocation,
            sEmail, 
            sWeb);
    }


    //主办方添加赛事纪录
    function addRecord(
        uint rID, 
        string memory rGameName, 
        string memory rContestName,
        string memory rTime, 
        string memory rLocation,
        uint tIDa, 
        uint tIDb, 
        string memory rResult, 
        uint sID) public{
        //要求添加赛事纪录的主办方机构已经被管理员授权已经注册，且未被注销
        require(registeredSponor[msg.sender].sisActive == true);
        //要求添加赛事纪录的主办方机构已经被管理员授权
        require(authedSponer[msg.sender] == true);
        
        //通过输入的信息生成一个赛事纪录
        tempRecord = Record({
            rID : rID, 
            rGameName : rGameName, 
            rContestName :rContestName, 
            rTime : rTime, 
            rLocation : rLocation,
            tIDa : tIDa, 
            tIDb : tIDb, 
            rResult : rResult, 
            sID : sID, 
            risActive : true});
        //根据赛事纪录唯一的编号rID存储记录
        rIDtoRecord[rID] = tempRecord;
        //根据主办方机构的唯一编号sID存储记录
        sIDtoRecord[sID].push(tempRecord);
        //根据比赛记录的队伍的唯一tID存储记录
        tIDtoRecord[tIDa].push(tempRecord);
        tIDtoRecord[tIDb].push(tempRecord);
        
        emit e_addRecord(
            rID, 
            rGameName, 
            rContestName, 
            rTime, 
            rLocation,
            tIDa,
            tIDb, 
            rResult, 
            sID);
    }
        
        
        
    ////Team操作
    //添加队伍账户并注册实例
    function addTeamInstance(
        address newTeamAddress, 
        uint tID, 
        string memory tName, 
        string memory tNation, 
        string memory tLocation,
        string memory tEmail, 
        string memory tWeb) public {
        //判断未注册过
        require(!isResteredTeam[tID]);
        //要求注册账号和发送请求账号一致
        require(newTeamAddress == msg.sender);
        //添加从队伍ID到队伍address的映射
        tIDtoAddress[tID] = newTeamAddress;
        //注册新的队伍账户，并激活注册
        registeredTeam[newTeamAddress] = Team({
            tAccount : newTeamAddress,
            tID : tID, 
            tName : tName, 
            tNation : tNation, 
            tLocation : tLocation,
            tEmail : tEmail, 
            tWeb :tWeb, 
            tisActive : true});  
        isResteredTeam[tID] = true;
        //调用event事件监听
        emit e_addTeamInstance(
            newTeamAddress, 
            tID, 
            tName ,
            tNation, 
            tLocation,
            tEmail, 
            tWeb);
        }
        
    
    //team添加参赛记录
    function addMatch(
        uint mID,
        uint rID,
        uint tID,
        string memory player,
        string memory KDA,
        string memory mResult,
        string memory other) public{
        //要求添加赛事纪录的team已经被管理员授权
        require(registeredTeam[msg.sender].tisActive == true);
        require(authedTeam[msg.sender] == true);
        
        //通过输入的信息生成一个赛事纪录
        tempMatch = Match({
            mID : mID,
            rID : rID,
            tID : tID,
            player : player,
            KDA : KDA,
            mResult : mResult,
            other : other,
            misActive : true});
        //根据赛事纪录唯一的编号mID存储记录
        mIDtoMatch[mID] = tempMatch;
        //根据team的唯一编号tID存储记录
        tIDtoMatch[tID].push(tempMatch);
        //根据比赛记录唯一rID存储记录
        rIDtoMatch[rID].push(tempMatch);
        
        emit e_addMatch(
            mID,
            rID,
            tID,
            player,
            KDA,
            mResult,
            other);
    }    


}