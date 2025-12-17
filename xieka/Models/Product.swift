import Foundation

struct Product: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let price: Double
    let originalPrice: Double
    let description: String
    let imageName: String
    let tags: [String]
    
    // Helper to generate mock data
    static func mockProducts() -> [Product] {
        var products: [Product] = []
        
        products.append(Product(id: UUID(), name: "Golden King Crab", price: 9999.0, originalPrice: 12888.0, description: "The ultimate gift of the season. Top luxury enjoyment, limited edition.", imageName: "黄金帝王蟹", tags: ["Limited", "Luxury", "Featured"]))
        products.append(Product(id: UUID(), name: "Supreme King Crab Gift", price: 2999.0, originalPrice: 3500.0, description: "The ultimate gift for seafood lovers. Redeemable for 5kg of premium King Crab.", imageName: "至尊帝王蟹礼品卡", tags: ["Hot", "Limited", "Selected"]))
        products.append(Product(id: UUID(), name: "Classic Snow Crab", price: 888.0, originalPrice: 1000.0, description: "Perfect taste enjoyment. Redeemable for 2kg of fresh Snow Crab.", imageName: "经典雪蟹兑换券", tags: ["Popular", "Family"]))
        products.append(Product(id: UUID(), name: "Family Crab Feast", price: 1588.0, originalPrice: 1800.0, description: "Deliciousness shared by the whole family! Contains King Crab and Snow Crab.", imageName: "家庭全蟹宴套餐", tags: ["Family", "Selected"]))
        products.append(Product(id: UUID(), name: "Luxury Seafood Gift Pack", price: 5888.0, originalPrice: 6666.0, description: "A luxurious collection of top seafood, centered around our giant crabs.", imageName: "奢华海鲜大礼包", tags: ["Luxury", "Gift", "Selected"]))
        products.append(Product(id: UUID(), name: "Fresh Crab Taster", price: 388.0, originalPrice: 450.0, description: "A touch of sweetness from the ocean. First choice for trying.", imageName: "鲜蟹尝鲜装", tags: ["New"]))
        
        products.append(Product(id: UUID(), name: "Yangcheng Lake Crab 8-Pack", price: 688.0, originalPrice: 888.0, description: "Must-have for autumn, rich in roe and fat, comes with crab vinegar and tools.", imageName: "阳澄湖大闸蟹8只装", tags: ["Hot", "Family"]))
        products.append(Product(id: UUID(), name: "Imported Dungeness Crab Box", price: 999.0, originalPrice: 1200.0, description: "Delicious meat, rich taste, suitable for high-end banquets.", imageName: "进口珍宝蟹礼券", tags: ["Gift", "Selected"]))
        products.append(Product(id: UUID(), name: "Alaska Red King Crab", price: 1288.0, originalPrice: 1588.0, description: "Rare deep-sea delicacy, sweet aftertaste, extreme enjoyment.", imageName: "阿拉斯加红毛蟹", tags: ["Limited", "New"]))
        products.append(Product(id: UUID(), name: "Mid-Autumn Crab Gift", price: 498.0, originalPrice: 598.0, description: "Top choice for Mid-Autumn Festival gifts, beautiful packaging, respectful and practical.", imageName: "中秋蟹礼·团圆版", tags: ["Gift", "Family"]))
        products.append(Product(id: UUID(), name: "Clearwater Crab Pair Card", price: 588.0, originalPrice: 688.0, description: "Male 4 tael Female 3 tael, 8 pieces, full of roe and fat.", imageName: "清水大闸蟹公母对卡", tags: ["New", "Popular"]))
        
        products.append(Product(id: UUID(), name: "Premium Drunken Crab Box", price: 568.0, originalPrice: 688.0, description: "Soaked in aged Huadiao wine, rich wine aroma, endless aftertaste.", imageName: "极品醉蟹礼盒", tags: ["Selected", "Gift"]))
        products.append(Product(id: UUID(), name: "Crab Roe Soup Dumplings Box", price: 88.0, originalPrice: 108.0, description: "Thin skin and large filling, full of soup, first choice for breakfast and afternoon tea.", imageName: "蟹粉小笼包提货券", tags: ["New", "Family"]))
        products.append(Product(id: UUID(), name: "Seafood Hot Pot Platter", price: 458.0, originalPrice: 520.0, description: "Contains flower crabs, prawns, scallops and other seafood, essential for warm winter.", imageName: "海鲜火锅拼盘", tags: ["Family", "Popular"]))
        products.append(Product(id: UUID(), name: "Business Exclusive Crab Gift A", price: 1888.0, originalPrice: 2288.0, description: "High-end business gift, showing noble status.", imageName: "商务尊享蟹卡A款", tags: ["Gift", "Luxury"]))
        products.append(Product(id: UUID(), name: "Business Exclusive Crab Gift B", price: 2888.0, originalPrice: 3288.0, description: "Top specifications, customized packaging, first choice for corporate procurement.", imageName: "商务尊享蟹卡B款", tags: ["Gift", "Luxury", "Limited"]))
        
        products.append(Product(id: UUID(), name: "Frozen Snow Crab Legs", price: 328.0, originalPrice: 398.0, description: "Flash frozen to lock freshness, ready to eat after thawing or for hot pot.", imageName: "松叶蟹腿冷冻装", tags: ["Family", "New"]))
        products.append(Product(id: UUID(), name: "Spicy Crab Pre-cooked", price: 99.0, originalPrice: 129.0, description: "Stir-fried flavor, heat and eat, perfect for late night snack.", imageName: "香辣蟹预制菜", tags: ["Popular", "New"]))
        products.append(Product(id: UUID(), name: "Crab Roe Noodles Gift Box", price: 68.0, originalPrice: 88.0, description: "A bowl of noodles, half a bowl of crab, rich and fragrant, super value experience.", imageName: "蟹黄面兑换券", tags: ["New"]))
        products.append(Product(id: UUID(), name: "Premium Crab Roe Butter Box", price: 688.0, originalPrice: 888.0, description: "Supreme crab roe butter, perfect for rice, rich and fragrant.", imageName: "crab_roe_butter_gift_box", tags: ["Luxury", "Gourmet"]))
        products.append(Product(id: UUID(), name: "Crab Stuffed Orange", price: 128.0, originalPrice: 168.0, description: "Song Dynasty elegant dish, orange fragrance and crab fat, unique flavor.", imageName: "crab_stuffed_orange_dish", tags: ["Culture", "Gourmet"]))


        
        return products
    }
}
