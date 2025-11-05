class categoryModel{
  String categoryId;
  String categoryName;
  String categoryDescription;
  String categoryDropdownType;
  List<categoryVideoModel> videoList;

  categoryModel(this.categoryId, this.categoryName, this.categoryDescription,
      this.categoryDropdownType, this.videoList);
}
class categoryVideoModel{
  String videoId;
  String videoName;
  String videoDescription;
  String videoDuration;
  String videoCategoryId;
  String videoLevel;
  String videoCoverImage;
  String video;
  bool isExclusive;
  String createdAt;
  String instructorName;
  String instructorEmail;
  String instructorId;
  String instructorPhone;

  categoryVideoModel(
      this.videoId,
      this.videoName,
      this.videoDescription,
      this.videoDuration,
      this.videoCategoryId,
      this.videoLevel,
      this.videoCoverImage,
      this.video,
      this.isExclusive,
      this.createdAt,
      this.instructorName,
      this.instructorEmail,
      this.instructorId,
      this.instructorPhone);
}