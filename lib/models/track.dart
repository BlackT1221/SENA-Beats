class Track{
  final String id;
  final String title;
  final String artist;
  final String image;

  Track({required this.id, required this.title, required this.artist, required this.image,});

  // Logica para la persistencia

  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'artist': artist, 'image': image};

  factory Track.fromMap(Map<String, dynamic> map)=> Track(
    id: map['id'], title: map['title'], artist: map['artist'], image: map['image']
  );
}