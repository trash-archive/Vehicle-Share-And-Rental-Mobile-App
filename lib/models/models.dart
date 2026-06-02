// ============================================================
// MOVANA - Mock Data Models
// ============================================================

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final String location;
  final DateTime memberSince;
  final UserRole role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
    required this.location,
    required this.memberSince,
    required this.role,
  });
}

enum UserRole { renter, owner, both, admin }

class VehicleModel {
  final String id;
  final String ownerId;
  final String ownerName;
  final String ownerAvatar;
  final double ownerRating;
  final bool ownerVerified;
  final String name;
  final String description;
  final VehicleCategory category;
  final String type;
  final List<String> imageUrls;
  final double pricePerDay;
  final double pricePerHour;
  final String location;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final bool isVerified;
  final List<String> features;
  final String plateNumber;
  final int year;
  final String color;

  const VehicleModel({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.ownerAvatar,
    required this.ownerRating,
    required this.ownerVerified,
    required this.name,
    required this.description,
    required this.category,
    required this.type,
    required this.imageUrls,
    required this.pricePerDay,
    required this.pricePerHour,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.rating,
    required this.reviewCount,
    required this.isAvailable,
    required this.isVerified,
    required this.features,
    required this.plateNumber,
    required this.year,
    required this.color,
  });
}

enum VehicleCategory {
  personal,
  commercial,
  construction,
  agricultural,
  water,
}

class BookingModel {
  final String id;
  final String vehicleId;
  final String vehicleName;
  final String vehicleImage;
  final String renterId;
  final String renterName;
  final String ownerId;
  final String ownerName;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final BookingStatus status;
  final String? notes;

  const BookingModel({
    required this.id,
    required this.vehicleId,
    required this.vehicleName,
    required this.vehicleImage,
    required this.renterId,
    required this.renterName,
    required this.ownerId,
    required this.ownerName,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    this.notes,
  });

  int get durationDays => endDate.difference(startDate).inDays;
}

enum BookingStatus { pending, confirmed, ongoing, completed, cancelled }

class ReviewModel {
  final String id;
  final String reviewerId;
  final String reviewerName;
  final String reviewerAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.reviewerId,
    required this.reviewerName,
    required this.reviewerAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}

class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.isRead,
  });
}

class ConversationModel {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String otherUserAvatar;
  final String vehicleName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  const ConversationModel({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.vehicleName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });
}

enum NotificationType {
  bookingConfirmed,
  bookingRequest,
  bookingCancelled,
  newMessage,
  reviewReceived,
  system,
}

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime time;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
  });
}
