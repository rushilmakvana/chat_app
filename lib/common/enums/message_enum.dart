enum MessageEnum {
  text('text'),
  image('image'),
  audio('audio'),
  gif('gif'),
  video('video');

  const MessageEnum(this.type);
  final String type;
}

extension ConvertMessage on String {
  MessageEnum toEnum() {
    switch (this) {
      case 'text':
        return MessageEnum.text;
      case 'audio':
        return MessageEnum.audio;
      case 'video':
        return MessageEnum.video;
      case 'gif':
        return MessageEnum.gif;
      case 'image':
        return MessageEnum.image;
      default:
        return MessageEnum.text;
    }
  }
}
