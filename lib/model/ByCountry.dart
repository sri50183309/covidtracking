class COVIDByCountry {
  final String country; //country
  final String total_cases; //total_cases
  final String new_cases; //new_cases
  final String total_deaths; //total_deaths
  final String new_deaths; //new_deaths
  final String flag; //flag

  COVIDByCountry({
    this.country,
    this.total_cases,
    this.new_cases,
    this.total_deaths,
    this.new_deaths,
    this.flag,
  });

//  factory COVIDByCountry.fromMap(Map<String, dynamic> map) {
//    return COVIDByCountry(
//      id: map['id'],
//      title: map['snippet']['title'],
//      profilePictureUrl: map['snippet']['thumbnails']['default']['url'],
//      subscriberCount: map['statistics']['subscriberCount'],
//      videoCount: map['statistics']['videoCount'],
//      uploadPlaylistId: map['contentDetails']['relatedPlaylists']['uploads'],
//    );
//  }
}
