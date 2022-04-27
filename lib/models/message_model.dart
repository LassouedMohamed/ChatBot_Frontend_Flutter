class MessageModel {
  
  int? id;
  String? body;
  String? read;
  int? userId;
  int? conversationId;
  String? createdAt;
  String? updatedAt;

  MessageModel(
    {this.id,
    this.body,
    this.read,
    this.userId,
    this.conversationId,
    this.createdAt,
    this.updatedAt});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    body = json['body'];
    read = json['read'].toString() ;
    userId = json['user_id'];
    conversationId = int.parse(json['conversation_id'].toString());
    createdAt = "${json['created_at']}";
    updatedAt = "${json['updated_at']}";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] =id;
    data['body'] =body;
    data['read'] =read;
    data['user_id'] =userId;
    data['conversation_id'] =conversationId;
    return data;
  }
}