pragma solidity >=0.4.22 <0.7.0;

contract trace {
    struct Point {
        uint256 longitude;
        uint256 latitude;
        uint64 timestamp;
    }

    struct Camera {
        address Address;
        uint256 speed_limit;
        uint256 speed_accuracy;
    }

    struct CameraReport {
        address camera;
        Point point;
        uint256 speed;
    }

    struct Track {
        Point[] points;
        uint[] fine_ids;
    }

    struct Fine {
        uint fine_id;
        string reason;
        FineStatus status;
    }

    address public admin;

    mapping(address => bool) public authorities; // list of authorities

    mapping(bytes32 => address) public cars; // gosnomer -> address
    mapping(address => Camera) public cameras; // address of the camera object
    mapping(address => bool) public cameras_exist; // object exists in mapping

    // Camera reports
    mapping(address => CameraReport[]) camera_reports;
    // User info (sequence of points & fines)
    mapping(address => Track) tracks;

    // FINES
    uint fine_id;
    enum FineStatus {NOT_EXIST, CREATED, APPEAL, CLOSED, PAYED}
    mapping(uint => Fine) public fines;

    // EVENTS
    event user_traced(address);
    event camera_reported(address, bytes32);
    event car_registered(bytes32);
    event camera_registered(address);
    event authority_registered(address);
    event fine_appealed(uint);
    event fine_registered(address, address);

    function store_trace(address owner, uint256 longitude, uint256 latitude, uint64 timestamp) public {
        tracks[owner].points.push(Point(longitude, latitude, timestamp));
        emit user_traced(owner);
    }

    function greet() public returns(string memory) {
        return "da";
    }

    function store_camera_report(bytes32 gosnomer, uint256 longitude, uint256 latitude, uint64 timestamp, uint256 speed) public {
        address camera_source = msg.sender;
        address target = cars[gosnomer];

        if (cameras_exist[camera_source] != false) {
            camera_reports[target].push(CameraReport({
                camera: msg.sender,
                point: Point(longitude, latitude, timestamp),
                speed: speed
            }));
            emit camera_reported(camera_source, gosnomer);
        }
    }

    function get_trace_length(address owner) public view returns(uint256) {
        return tracks[owner].points.length;
    }

    function get_trace_point(address owner, uint64 idx) public view returns (uint256, uint256, uint64)  {

        Point memory p = tracks[owner].points[idx];
        return (p.longitude, p.latitude, p.timestamp);
    }

    function register_car(address owner, bytes32 gosnomer) public {
        cars[gosnomer] = owner;
        emit car_registered(gosnomer);
    }

    function register_camera(address owner, uint256 speed_limit, uint256 speed_accuracy) public {
        cameras_exist[owner] = true;
        cameras[owner] = Camera({
           Address: owner,
           speed_limit: speed_limit,
           speed_accuracy: speed_accuracy
        });
        emit camera_registered(owner);
    }

    function register_authority(address target) public {
        if (msg.sender == admin) {
            authorities[target] = true;
            emit authority_registered(target);
        }
    }

    function register_fine(address target, string memory reason) public {
        if (authorities[msg.sender] == true) {
            tracks[target].fine_ids.push(fine_id);
            fines[fine_id] = Fine({
                reason: reason,
                status: FineStatus.CREATED,
                fine_id: fine_id
            });

            fine_id++;
            emit fine_registered(msg.sender, target);
        }
    }

    function appeal_fine(uint _fine_id) public { // no check user
        fines[_fine_id].status = FineStatus.APPEAL;
        emit fine_appealed(_fine_id);
    }

    function get_fines(address owner, uint64 idx) view public returns(string memory, uint8) {
        Fine memory fine = fines[tracks[owner].fine_ids[idx]];
        return (fine.reason, uint8(fine.status));

    }

    constructor(address chef) public {
        admin = chef;
        authorities[admin] = true;
    }
}
