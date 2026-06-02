import '../models/models.dart';

class MockData {
  // ── Current User ──────────────────────────────────────────
  static final UserModel currentUser = UserModel(
    id: 'u001',
    name: 'Juan dela Cruz',
    email: 'juan@email.com',
    phone: '+63 912 345 6789',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
    rating: 4.8,
    reviewCount: 14,
    isVerified: true,
    location: 'Cebu City',
    memberSince: _date2023,
    role: UserRole.both,
  );

  static final DateTime _date2023 = DateTime(2023, 6, 1);

  // ── Vehicles ──────────────────────────────────────────────
  static const List<VehicleModel> vehicles = [
    VehicleModel(
      id: 'v001',
      ownerId: 'u002',
      ownerName: 'Carlo Reyes',
      ownerAvatar: 'https://i.pravatar.cc/150?img=3',
      ownerRating: 4.9,
      ownerVerified: true,
      name: 'Honda Click 125i',
      description:
          'Well-maintained Honda Click perfect for city commutes and short trips around Cebu. Fuel-efficient and easy to handle. Full tank provided on pickup. Helmet included.',
      category: VehicleCategory.personal,
      type: 'Scooter',
      imageUrls: [
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
        'https://images.unsplash.com/photo-1568772585407-9f9d95d94b5d?w=800',
        'https://images.unsplash.com/photo-1502877338535-766e1452684a?w=800',
      ],
      pricePerDay: 500,
      pricePerHour: 80,
      location: 'Lahug, Cebu City',
      latitude: 10.3348,
      longitude: 123.9075,
      distanceKm: 1.2,
      rating: 4.8,
      reviewCount: 32,
      isAvailable: true,
      isVerified: true,
      features: ['Helmet Included', 'Full Tank', 'GPS Tracker', 'Clean'],
      plateNumber: 'CCU 1234',
      year: 2022,
      color: 'Red',
    ),
    VehicleModel(
      id: 'v002',
      ownerId: 'u003',
      ownerName: 'Maria Santos',
      ownerAvatar: 'https://i.pravatar.cc/150?img=5',
      ownerRating: 4.7,
      ownerVerified: true,
      name: 'Toyota Vios 1.3 E',
      description:
          'Comfortable and fuel-efficient Vios perfect for family trips or business travel. Air-conditioned, clean interior. Pick-up at SM City Cebu.',
      category: VehicleCategory.personal,
      type: 'Sedan',
      imageUrls: [
        'https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=800',
        'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800',
      ],
      pricePerDay: 1800,
      pricePerHour: 250,
      location: 'SM City Cebu',
      latitude: 10.3119,
      longitude: 123.9182,
      distanceKm: 2.8,
      rating: 4.7,
      reviewCount: 18,
      isAvailable: true,
      isVerified: true,
      features: ['Air Conditioned', 'Fuel Efficient', 'Clean Interior', 'Insured'],
      plateNumber: 'CCE 5678',
      year: 2021,
      color: 'White',
    ),
    VehicleModel(
      id: 'v003',
      ownerId: 'u004',
      ownerName: 'Pedro Villanueva',
      ownerAvatar: 'https://i.pravatar.cc/150?img=7',
      ownerRating: 4.6,
      ownerVerified: false,
      name: 'Mitsubishi L300 FB Van',
      description:
          'Spacious FB Van for deliveries, events, or moving. Can carry up to 12 passengers or heavy cargo. Driver available for additional fee.',
      category: VehicleCategory.commercial,
      type: 'Van',
      imageUrls: [
        'https://images.unsplash.com/photo-1566473965997-3de9c817e938?w=800',
        'https://images.unsplash.com/photo-1572993803456-66e7e7a7a7a7?w=800',
      ],
      pricePerDay: 3500,
      pricePerHour: 500,
      location: 'Mandaue City',
      latitude: 10.3239,
      longitude: 123.9613,
      distanceKm: 5.4,
      rating: 4.5,
      reviewCount: 9,
      isAvailable: true,
      isVerified: false,
      features: ['Driver Available', 'High Capacity', 'Cargo Space', 'AC'],
      plateNumber: 'MCM 9012',
      year: 2019,
      color: 'White',
    ),
    VehicleModel(
      id: 'v004',
      ownerId: 'u005',
      ownerName: 'Ana Flores',
      ownerAvatar: 'https://i.pravatar.cc/150?img=9',
      ownerRating: 5.0,
      ownerVerified: true,
      name: 'E-Bike City Cruiser',
      description:
          'Eco-friendly electric bike for short city trips. Zero emission, quiet, and fun to ride. Includes charger. Perfect for exploring Cebu downtown.',
      category: VehicleCategory.personal,
      type: 'E-bike',
      imageUrls: [
        'https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=800',
        'https://images.unsplash.com/photo-1594495894542-a46cc73e081a?w=800',
      ],
      pricePerDay: 400,
      pricePerHour: 60,
      location: 'Colon Street, Cebu City',
      latitude: 10.2936,
      longitude: 123.9010,
      distanceKm: 3.1,
      rating: 5.0,
      reviewCount: 7,
      isAvailable: true,
      isVerified: true,
      features: ['Eco-Friendly', 'Helmet Included', 'Charger Included', 'Lightweight'],
      plateNumber: 'N/A',
      year: 2023,
      color: 'Blue',
    ),
    VehicleModel(
      id: 'v005',
      ownerId: 'u006',
      ownerName: 'Roberto Cruz',
      ownerAvatar: 'https://i.pravatar.cc/150?img=11',
      ownerRating: 4.4,
      ownerVerified: true,
      name: 'CAT 320 Excavator',
      description:
          'Heavy-duty excavator available for construction and excavation projects. Operator available. Suitable for large-scale earthworks and site preparation.',
      category: VehicleCategory.construction,
      type: 'Excavator',
      imageUrls: [
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
        'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800',
      ],
      pricePerDay: 15000,
      pricePerHour: 2000,
      location: 'Consolacion, Cebu',
      latitude: 10.3720,
      longitude: 123.9620,
      distanceKm: 12.5,
      rating: 4.4,
      reviewCount: 5,
      isAvailable: false,
      isVerified: true,
      features: ['Operator Available', 'Heavy Duty', 'Insured', 'GPS Tracked'],
      plateNumber: 'N/A (Equipment)',
      year: 2020,
      color: 'Yellow',
    ),
    VehicleModel(
      id: 'v006',
      ownerId: 'u007',
      ownerName: 'Lorna Bautista',
      ownerAvatar: 'https://i.pravatar.cc/150?img=13',
      ownerRating: 4.8,
      ownerVerified: true,
      name: 'Ford Ranger Wildtrak 4x4',
      description:
          'Powerful pickup truck perfect for off-road adventures, beach trips, or hauling. 4WD capability. Clean and well-maintained. Great for provincial trips.',
      category: VehicleCategory.personal,
      type: 'Pickup',
      imageUrls: [
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
        'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=800',
      ],
      pricePerDay: 3200,
      pricePerHour: 450,
      location: 'Talisay City, Cebu',
      latitude: 10.2442,
      longitude: 123.8486,
      distanceKm: 8.7,
      rating: 4.8,
      reviewCount: 21,
      isAvailable: true,
      isVerified: true,
      features: ['4WD', 'Off-Road Ready', 'Large Cargo Bed', 'GPS'],
      plateNumber: 'TCE 3456',
      year: 2022,
      color: 'Silver',
    ),
  ];

  // ── Featured Vehicles (subset) ────────────────────────────
  static List<VehicleModel> get featuredVehicles =>
      vehicles.where((v) => v.isAvailable && v.isVerified).take(4).toList();

  // ── Nearby Vehicles ───────────────────────────────────────
  static List<VehicleModel> get nearbyVehicles {
    final list = [...vehicles];
    list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return list.take(4).toList();
  }

  // ── Bookings ──────────────────────────────────────────────
  static final List<BookingModel> bookings = [
    BookingModel(
      id: 'b001',
      vehicleId: 'v002',
      vehicleName: 'Toyota Vios 1.3 E',
      vehicleImage: 'https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=800',
      renterId: 'u001',
      renterName: 'Juan dela Cruz',
      ownerId: 'u003',
      ownerName: 'Maria Santos',
      startDate: DateTime.now().add(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 4)),
      totalPrice: 3600,
      status: BookingStatus.confirmed,
      notes: 'Will pick up at 9AM sharp.',
    ),
    BookingModel(
      id: 'b002',
      vehicleId: 'v001',
      vehicleName: 'Honda Click 125i',
      vehicleImage: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
      renterId: 'u001',
      renterName: 'Juan dela Cruz',
      ownerId: 'u002',
      ownerName: 'Carlo Reyes',
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().subtract(const Duration(days: 8)),
      totalPrice: 1000,
      status: BookingStatus.completed,
    ),
    BookingModel(
      id: 'b003',
      vehicleId: 'v006',
      vehicleName: 'Ford Ranger Wildtrak 4x4',
      vehicleImage: 'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=800',
      renterId: 'u001',
      renterName: 'Juan dela Cruz',
      ownerId: 'u007',
      ownerName: 'Lorna Bautista',
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 9)),
      totalPrice: 6400,
      status: BookingStatus.pending,
    ),
  ];

  // ── Reviews ───────────────────────────────────────────────
  static final List<ReviewModel> sampleReviews = [
    ReviewModel(
      id: 'r001',
      reviewerId: 'u001',
      reviewerName: 'Juan dela Cruz',
      reviewerAvatar: 'https://i.pravatar.cc/150?img=12',
      rating: 5.0,
      comment: 'Excellent vehicle! Very clean and well-maintained. Owner was very responsive and accommodating. Highly recommend!',
      createdAt: DateTime(2024, 3, 15), // ignore: prefer_const_constructors
    ),
    ReviewModel(
      id: 'r002',
      reviewerId: 'u008',
      reviewerName: 'Marites Gonzales',
      reviewerAvatar: 'https://i.pravatar.cc/150?img=20',
      rating: 4.0,
      comment: 'Good vehicle overall. Minor scratches noted upon pickup but owner was transparent about it. Smooth transaction.',
      createdAt: DateTime(2024, 2, 28), // ignore: prefer_const_constructors
    ),
    ReviewModel(
      id: 'r003',
      reviewerId: 'u009',
      reviewerName: 'Ricky Domingo',
      reviewerAvatar: 'https://i.pravatar.cc/150?img=25',
      rating: 5.0,
      comment: 'Super sarap mag-drive! Maayos yung sasakyan, on time ang owner. Will rent again for sure!',
      createdAt: DateTime(2024, 1, 10), // ignore: prefer_const_constructors
    ),
  ];

  // ── Conversations ─────────────────────────────────────────
  static final List<ConversationModel> conversations = [
    ConversationModel(
      id: 'c001',
      otherUserId: 'u003',
      otherUserName: 'Maria Santos',
      otherUserAvatar: 'https://i.pravatar.cc/150?img=5',
      vehicleName: 'Toyota Vios 1.3 E',
      lastMessage: 'Sure! You can pick it up at 9AM. I\'ll be there.',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 2,
    ),
    ConversationModel(
      id: 'c002',
      otherUserId: 'u002',
      otherUserName: 'Carlo Reyes',
      otherUserAvatar: 'https://i.pravatar.cc/150?img=3',
      vehicleName: 'Honda Click 125i',
      lastMessage: 'Thank you for renting! Hope you enjoyed it.',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 8)),
      unreadCount: 0,
    ),
  ];

  // ── Category Info ─────────────────────────────────────────
  static const List<Map<String, dynamic>> categories = [
    {
      'label': 'Motorcycle',
      'icon': '🏍️',
      'category': VehicleCategory.personal,
      'filter': 'Motorcycle',
    },
    {
      'label': 'Car',
      'icon': '🚗',
      'category': VehicleCategory.personal,
      'filter': 'Sedan',
    },
    {
      'label': 'Van / Truck',
      'icon': '🚐',
      'category': VehicleCategory.commercial,
      'filter': 'Van',
    },
    {
      'label': 'E-Bike',
      'icon': '⚡',
      'category': VehicleCategory.personal,
      'filter': 'E-bike',
    },
    {
      'label': 'Construction',
      'icon': '🏗️',
      'category': VehicleCategory.construction,
      'filter': 'Excavator',
    },
    {
      'label': 'Agricultural',
      'icon': '🚜',
      'category': VehicleCategory.agricultural,
      'filter': 'Tractor',
    },
  ];

  // ── Incoming Booking Requests (owner-side) ─────────────────
  static final List<BookingModel> ownerIncomingRequests = [
    BookingModel(
      id: 'r001',
      vehicleId: 'v001',
      vehicleName: 'Honda Click 125i',
      vehicleImage: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
      renterId: 'u010',
      renterName: 'Bea Mendoza',
      ownerId: 'u001',
      ownerName: 'Juan dela Cruz',
      startDate: DateTime.now().add(const Duration(days: 3)),
      endDate: DateTime.now().add(const Duration(days: 5)),
      totalPrice: 1000,
      status: BookingStatus.pending,
      notes: 'Will pick up early morning. Is helmet included?',
    ),
    BookingModel(
      id: 'r002',
      vehicleId: 'v001',
      vehicleName: 'Honda Click 125i',
      vehicleImage: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
      renterId: 'u011',
      renterName: 'Dante Reyes',
      ownerId: 'u001',
      ownerName: 'Juan dela Cruz',
      startDate: DateTime.now().add(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 11)),
      totalPrice: 500,
      status: BookingStatus.pending,
      notes: null,
    ),
    BookingModel(
      id: 'r003',
      vehicleId: 'v002',
      vehicleName: 'Toyota Vios 1.3 E',
      vehicleImage: 'https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=800',
      renterId: 'u012',
      renterName: 'Carla Villanueva',
      ownerId: 'u001',
      ownerName: 'Juan dela Cruz',
      startDate: DateTime.now().add(const Duration(days: 6)),
      endDate: DateTime.now().add(const Duration(days: 8)),
      totalPrice: 3600,
      status: BookingStatus.confirmed,
      notes: 'Need the car for a beach trip to Moalboal.',
    ),
  ];

  // ── Renter Avatar Map ─────────────────────────────────────
  static const Map<String, String> renterAvatars = {
    'u010': 'https://i.pravatar.cc/150?img=47',
    'u011': 'https://i.pravatar.cc/150?img=52',
    'u012': 'https://i.pravatar.cc/150?img=44',
  };

  // ── Notifications ──────────────────────────────────────────
  static final List<NotificationItem> notifications = [
    NotificationItem(
      id: 'n001',
      type: NotificationType.bookingConfirmed,
      title: 'Booking Confirmed! ✅',
      body: 'Maria Santos confirmed your booking for Toyota Vios 1.3 E on Jun 12–14.',
      time: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
    ),
    NotificationItem(
      id: 'n002',
      type: NotificationType.newMessage,
      title: 'New message from Carlo Reyes',
      body: 'Thank you for renting! Hope you enjoyed the ride 😊',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
    ),
    NotificationItem(
      id: 'n003',
      type: NotificationType.bookingRequest,
      title: 'New Booking Request',
      body: 'Bea Mendoza wants to rent your Honda Click 125i for Jun 15–17.',
      time: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
    ),
    NotificationItem(
      id: 'n004',
      type: NotificationType.reviewReceived,
      title: 'You received a new review ⭐',
      body: 'Ricky Domingo left a 5-star review on your Honda Click 125i.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: 'n005',
      type: NotificationType.bookingCancelled,
      title: 'Booking Cancelled',
      body: 'Your booking for Ford Ranger Wildtrak 4x4 has been cancelled by the owner.',
      time: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      isRead: true,
    ),
    NotificationItem(
      id: 'n006',
      type: NotificationType.system,
      title: 'Complete your verification',
      body: 'Upload a valid ID to unlock all features and start renting with confidence.',
      time: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
    NotificationItem(
      id: 'n007',
      type: NotificationType.newMessage,
      title: 'New message from Lorna Bautista',
      body: 'Hi! Just checking if you’re still interested in the Ford Ranger booking.',
      time: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
    ),
  ];

  // ── Saved Vehicle IDs ─────────────────────────────────────
  static const List<String> savedVehicleIds = [
    'v001', // Honda Click
    'v002', // Toyota Vios
    'v004', // E-Bike
    'v006', // Ford Ranger
    'v003', // L300 Van
  ];

  static List<VehicleModel> get savedVehicles =>
      vehicles.where((v) => savedVehicleIds.contains(v.id)).toList();

  // ── Owner Stats ───────────────────────────────────────────
  static const Map<String, dynamic> ownerStats = {
    'totalEarnings': 24500.0,
    'totalRentals': 18,
    'activeListings': 2,
    'avgRating': 4.8,
    'thisMonth': 8500.0,
    'pendingApprovals': 3,
  };
}
