extension DateTimeExtension on Duration {
  timeAgo(bool numericDates) {
    var difference = this;

    if (difference.inDays / 365 > 1) {
      return '${difference.inDays ~/ 365} years ago';
    } else if (difference.inDays / 365 == 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    } else if (difference.inDays / 30 >= 1 ) {
      return '${(difference.inDays ~/ 30)} months ago';
    } else if (difference.inDays / 7 == 4) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if (difference.inDays / 7 > 1) {
      return '${difference.inDays ~/ 7} weeks ago';
    } else if (difference.inDays / 7 == 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}
