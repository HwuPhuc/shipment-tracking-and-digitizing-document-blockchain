// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Logistics {
    // ===================== ENUM =====================

    // Vai trò trong hệ thống
    enum Role {
        Admin,
        Shipper,
        Forwarder,
        Carrier,
        Customs,
        Consignee
    }

    // Trạng thái vận chuyển
    enum State {
        Created,
        Packed,
        PickedUp,
        Booked,
        ExportCleared,
        InTransit,
        Arrived,
        ImportCleared,
        Delivered
    }

    // ===================== STRUCT =====================

    // Thông tin người tham gia
    struct Participant {
        address account;
        string name;
        Role role;
        bool isActive;
    }

    // Đơn hàng vận chuyển
    struct Shipment {
        uint256 id;
        address shipper;
        address consignee;
        State state;
        uint256 createdAt;
    }

    // Chứng từ
    struct Document {
        uint256 id;
        uint256 shipmentId;
        string docType; // Invoice, B/L, CO, CQ...
        string hash; // HASH của file
        address owner; // ai upload
        bool approved; // đã được duyệt chưa
    }

    // ===================== STORAGE =====================

    address public admin;

    uint256 public shipmentCounter;
    uint256 public documentCounter;

    mapping(address => Participant) public participants;
    mapping(uint256 => Shipment) public shipments;
    mapping(uint256 => Document) public documents;
    mapping(uint256 => State[]) public shipmentHistory;

    // mapping shipment -> list document
    mapping(uint256 => uint256[]) public shipmentDocuments;

    // ===================== EVENTS =====================

    event ParticipantAdded(address account, Role role);
    event ShipmentCreated(uint256 shipmentId);
    event StateUpdated(uint256 shipmentId, State newState);
    event DocumentUploaded(uint256 docId, uint256 shipmentId);
    event DocumentApproved(uint256 docId);

    // ===================== MODIFIERS =====================

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier onlyRole(Role _role) {
        require(participants[msg.sender].role == _role, "Wrong role");
        require(participants[msg.sender].isActive, "Inactive user");
        _;
    }

    modifier shipmentExists(uint256 _id) {
        require(_id > 0 && _id <= shipmentCounter, "Invalid shipment");
        _;
    }

    // ===================== CONSTRUCTOR =====================

    constructor() {
        admin = msg.sender;
    }

    // ===================== PARTICIPANT =====================

    // Admin thêm người dùng
    function addParticipant(
        address _account,
        string memory _name,
        Role _role
    ) public onlyAdmin {
        participants[_account] = Participant({
            account: _account,
            name: _name,
            role: _role,
            isActive: true
        });

        emit ParticipantAdded(_account, _role);
    }
    // Vô hiệu hóa người dùng
    function deactivateParticipant(address _account) public onlyAdmin {
        participants[_account].isActive = false;
    }
    // ===================== SHIPMENT =====================

    // Shipper tạo đơn hàng
    function createShipment(address _consignee) public onlyRole(Role.Shipper) {
        shipmentCounter++;

        shipments[shipmentCounter] = Shipment({
            id: shipmentCounter,
            shipper: msg.sender,
            consignee: _consignee,
            state: State.Created,
            createdAt: block.timestamp
        });
        shipmentHistory[shipmentCounter].push(State.Created);
        emit ShipmentCreated(shipmentCounter);
    }

    // ===================== DOCUMENT =====================

    /**
     * Upload document
     * _hash = hash của file (lấy từ IPFS)
     */
    function uploadDocument(
        uint256 _shipmentId,
        string memory _type,
        string memory _hash
    ) public shipmentExists(_shipmentId) {
        documentCounter++;

        documents[documentCounter] = Document({
            id: documentCounter,
            shipmentId: _shipmentId,
            docType: _type,
            hash: _hash,
            owner: msg.sender,
            approved: false
        });

        shipmentDocuments[_shipmentId].push(documentCounter);

        emit DocumentUploaded(documentCounter, _shipmentId);
    }

    // Hải quan duyệt document
    function approveDocument(uint256 _docId) public onlyRole(Role.Customs) {
        documents[_docId].approved = true;

        emit DocumentApproved(_docId);
    }

    // ===================== STATE MACHINE =====================

    function updateState(
        uint256 _shipmentId,
        State _newState
    ) public shipmentExists(_shipmentId) {
        Shipment storage s = shipments[_shipmentId];

        if (!participants[msg.sender].isActive) {
            require(
                participants[msg.sender].isActive == true,
                "Deactivated account couldn't perform this action"
            );
        }
        if (_newState == State.Packed) {
            require(
                participants[msg.sender].role == Role.Shipper,
                "Only Shipper can mark Packed"
            );
        }

        if (_newState == State.PickedUp) {
            require(
                participants[msg.sender].role == Role.Forwarder,
                "Only Forwarder can mark PickedUp"
            );
        }

        if (_newState == State.InTransit) {
            require(
                participants[msg.sender].role == Role.Carrier,
                "Only Carrier can mark InTransit"
            );
        }

        if (
            _newState == State.ExportCleared || _newState == State.ImportCleared
        ) {
            require(
                participants[msg.sender].role == Role.Customs,
                "Only Customs can mark ExportCleared and ImportCleared"
            );
        }

        if (_newState == State.Delivered) {
            require(
                participants[msg.sender].role == Role.Consignee,
                "Only Consignee can mark Delivered"
            );
        }

        s.state = _newState;

        shipmentHistory[_shipmentId].push(_newState);
        emit StateUpdated(_shipmentId, _newState);
    }

    // ===================== VIEW FUNCTIONS =====================

    function getShipmentDocuments(
        uint256 _shipmentId
    ) public view returns (uint256[] memory) {
        return shipmentDocuments[_shipmentId];
    }

    function getShipmentHistory(
        uint256 _shipmentId
    ) public view returns (State[] memory) {
        return shipmentHistory[_shipmentId];
    }
}
