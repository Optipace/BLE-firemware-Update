
class payload_class_data {
  String _mac_id;
  String device_ADVname;

  String payload;
  String _payload1;
  String _payload2;
  String protocolId;
  String payloadId;
  String serialNumber;
  int batterySerialNumber;
  double maximumBattery;
  String notificationStatus;
  double liveBattery;
  int masterTimer;
  int lastChargeTime;
  int lastDischargeTime;
  String batteryLifeCycles;

  // Constructor
  payload_class_data(
      this._mac_id,
      this.device_ADVname,
      this.payload,
      this._payload1,
      this._payload2,
      this.protocolId,
      this.payloadId,
      this.serialNumber,
      this.batterySerialNumber,
      this.maximumBattery,
      this.notificationStatus,
      this.liveBattery,
      this.masterTimer,
      this.lastChargeTime,
      this.lastDischargeTime,
      this.batteryLifeCycles);

  // Getter and Setter for mac_id
  String get mac_id => _mac_id;

  set mac_id(String value) {
    _mac_id = value;
  }

  // Getter and Setter for device_name
  String get device_name => device_ADVname;

  set device_name(String value) {
    device_ADVname = value;
  }

  // Getter and Setter for payload1
  String get payload1 => _payload1;

  set payload1(String value) {
    _payload1 = value;
  }

  // Getter and Setter for payload2
  String get payload2 => _payload2;

  set payload2(String value) {
    _payload2 = value;
  }

  @override
  String toString() {
    return 'payload_class_data{_mac_id: $_mac_id, device_ADVname: $device_ADVname, payload: $payload, _payload1: $_payload1, _payload2: $_payload2, protocolId: $protocolId, payloadId: $payloadId, serialNumber: $serialNumber, batterySerialNumber: $batterySerialNumber, maximumBattery: $maximumBattery, notificationStatus: $notificationStatus, liveBattery: $liveBattery, masterTimer: $masterTimer, lastChargeTime: $lastChargeTime, lastDischargeTime: $lastDischargeTime, batteryLifeCycles: $batteryLifeCycles}';
  }

// Optional: Override toString() for easier debugging
}

Map<String, dynamic> deviceDataList = {};
