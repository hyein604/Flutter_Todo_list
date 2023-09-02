// 서버로부터 가져온 값을 flutter에서 사용할 class로 바꿔주기도 하며
// class로 사용되던 값을 JSON형태로 바꾸어 서버로도 넘겨줘야 한다.

class Task{
  int id;
  String work;
  bool isComplete;

// 생성자
  Task({required this.id, required this.work, required this.isComplete});
// JSON으로 바꿔줄 toJson() 함수
  Map<String, dynamic> toJson() =>
      {'id':id, 'work':work, 'isComplete':isComplete};
}