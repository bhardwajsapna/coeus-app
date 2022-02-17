class SensorsData {
  int timestamps = -1;
  // ignore: non_constant_identifier_names
  int sample_Nos = -1;
  int ledc1_pd1s = -1; //LEDC1_PD1s;
  int ledc1_pd2s = -1; //LEDC1_PD2s;
  int ledc2_pd1s = -1; //LEDC2_PD1s;
  int ledc2_pd2s = -1; //LEDC2_PD2s;
  int ledc3_pd1s = -1; //LEDC3_PD1s;
  int ledc3_pd2s = -1; //LEDC3_PD2s;
  int accxs = -1; //ACCXs;
  int accys = -1; //ACCYs;
  int acczs = -1; //ACCZs;
  int temperatures = -1;
  int hrs = -1; //HRs=-1;heart rate
  int rrs = -1; //RRs;
  int activity_classs = -1; //Activity_Classs;
  int scd_states = -1; //SCD_states;
  int spo2s = -1; //Spo2s;
  int starts = -1;

  /* SensorsData(
      {required this.timestamps,
      required this.sample_Nos,
      required this.ledc1_pd1s,
      required this.ledc1_pd2s,
      required this.ledc2_pd1s,
      required this.ledc2_pd2s,
      required this.ledc3_pd1s,
      required this.ledc3_pd2s,
      required this.accxs,
      required this.accys,
      required this.acczs,
      required this.temperatures,
      required this.hrs,
      required this.rrs,
      required this.activity_classs,
      required this.scd_states,
      required this.spo2s,
      required this.starts});
*/
  SensorsData(List data) {
    this.timestamps = data[0];
    this.sample_Nos = data[1];
    this.ledc1_pd1s = data[2];
    this.ledc1_pd2s = data[3];
    this.ledc2_pd1s = data[4];
    this.ledc2_pd2s = data[5];
    this.ledc3_pd1s = data[6];
    this.ledc3_pd2s = data[7];
    this.accxs = data[8];
    this.accys = data[9];
    this.acczs = data[10];
    this.temperatures = data[11];
    this.hrs = data[12];
    this.rrs = data[13];
    this.activity_classs = data[14];
    this.scd_states = data[15];
    this.spo2s = data[16];
    this.starts = data[17];
  }

  factory SensorsData.fromJson(Map<String, dynamic> json) => SensorsData([
        json['timestamps'] as int,
        json['sample_Nos'] as int,
        json['ledc1_pd1s'] as int,
        json['ledc1_pd2s'] as int,
        json['ledc2_pd1s'] as int,
        json['ledc2_pd2s'] as int,
        json['ledc3_pd1s'] as int,
        json['ledc3_pd2s'] as int,
        json['accxs'] as int,
        json['accys'] as int,
        json['acczs'] as int,
        json['temperatures'] as int,
        json['hrs'] as int,
        json['rrs'] as int,
        json['activity_classs'] as int,
        json['scd_states'] as int,
        json['spo2s'] as int,
        json['starts'] as int
      ]);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'timestamps': timestamps,
        'sample_Nos': sample_Nos,
        'ledc1_pd1s': ledc1_pd1s,
        'ledc1_pd2s': ledc1_pd2s,
        'ledc2_pd1s': ledc2_pd1s,
        'ledc2_pd2s': ledc2_pd2s,
        'ledc3_pd1s': ledc3_pd1s,
        'ledc3_pd2s': ledc3_pd2s,
        'accxs': accxs,
        'accys': accys,
        'acczs': acczs,
        'temperatures': temperatures,
        'hrs': hrs,
        'rrs': rrs,
        'activity_classs': activity_classs,
        'scd_states': scd_states,
        'spo2s': spo2s,
        'starts': starts,
      };
}
