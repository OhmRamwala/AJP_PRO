USE ekart;

ALTER TABLE orders
    ADD COLUMN IF NOT EXISTS status VARCHAR(20) NOT NULL DEFAULT 'PENDING' AFTER total;

UPDATE orders
SET status = 'PENDING'
WHERE status IS NULL OR TRIM(status) = '';

ALTER TABLE products
    ADD COLUMN IF NOT EXISTS category VARCHAR(100) NOT NULL DEFAULT 'Accessories' AFTER stock;

UPDATE products
SET category = CASE
    WHEN LOWER(CONCAT(COALESCE(name, ''), ' ', COALESCE(description, ''))) REGEXP 'shoe|shoes|sneaker|sneakers|slide|slides|loafer|loafers|runner|running' THEN 'Footwear'
    WHEN LOWER(CONCAT(COALESCE(name, ''), ' ', COALESCE(description, ''))) REGEXP 'shirt|t-shirt|tshirt|tee|jeans|jacket|hoodie|linen|denim|coord|fashion' THEN 'Fashion'
    WHEN LOWER(CONCAT(COALESCE(name, ''), ' ', COALESCE(description, ''))) REGEXP 'wallet|watch|sunglasses|backpack|necklace|belt|card holder|holder|accessories' THEN 'Accessories'
    WHEN LOWER(CONCAT(COALESCE(name, ''), ' ', COALESCE(description, ''))) REGEXP 'diffuser|mug|cushion|lamp|basket|stand|plant|home|lifestyle|laundry|coffee' THEN 'Home & Lifestyle'
    WHEN LOWER(CONCAT(COALESCE(name, ''), ' ', COALESCE(description, ''))) REGEXP 'phone|iphone|smartphone|headphone|headphones|earbuds|laptop|tv|camera|speaker|keyboard|smart|fitness' THEN 'Electronics'
    ELSE 'Accessories'
END
WHERE category IS NULL
   OR TRIM(category) = ''
   OR category NOT IN ('Electronics', 'Fashion', 'Accessories', 'Footwear', 'Home & Lifestyle', 'Skincare');

UPDATE products
SET image_url = CASE
    WHEN category = 'Electronics' THEN 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=900&q=80'
    WHEN category = 'Fashion' THEN 'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=900&q=80'
    WHEN category = 'Footwear' THEN 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80'
    WHEN category = 'Home & Lifestyle' THEN 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&q=80'
    ELSE 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=900&q=80'
END
WHERE image_url IS NULL
   OR TRIM(image_url) = ''
   OR LOWER(image_url) LIKE '%placehold.co%'
   OR LOWER(image_url) LIKE '%text=ekart%';

-- Refine existing products and legacy starter items
UPDATE products
SET name = 'Classic White Sneakers',
    description = 'Minimal low-top sneakers with cushioned comfort, clean leather-look panels, and an everyday street-ready finish.',
    price = 2699.00,
    category = 'Footwear',
    image_url = 'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&w=900&q=80'
WHERE name = 'Classic White Sneakers';

UPDATE products
SET name = 'Apple iPhone 15 128GB',
    description = 'Flagship Apple smartphone with a bright Super Retina display, smooth day-to-day performance, and dependable all-day battery life.',
    price = 74999.00,
    category = 'Electronics',
    image_url = 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('iPhone 15', 'Apple iPhone 15 128GB');

UPDATE products
SET name = 'Samsung Galaxy Buds Pro ANC Earbuds',
    description = 'Premium true wireless earbuds with active noise cancellation, rich audio tuning, and crystal-clear call pickup.',
    price = 11999.00,
    category = 'Electronics',
    image_url = 'https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Galaxy Buds Pro', 'Samsung Galaxy Buds Pro ANC Earbuds');

UPDATE products
SET name = 'Dell Inspiron 14 FHD Laptop',
    description = 'Portable 14-inch laptop designed for work, browsing, streaming, and everyday multitasking with ease.',
    price = 58999.00,
    category = 'Electronics',
    image_url = 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Dell Inspiron 14', 'Dell Inspiron 14 FHD Laptop');

UPDATE products
SET name = 'Sony Bravia 55-inch 4K Smart TV',
    description = '55-inch 4K smart television with vivid picture quality, built-in streaming apps, and immersive room-filling audio.',
    price = 67999.00,
    category = 'Electronics',
    image_url = 'https://images.unsplash.com/photo-1593784991095-a205069470b6?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Sony 4K Smart TV', 'Sony Bravia 55-inch 4K Smart TV');

UPDATE products
SET name = 'Canon EOS R50 Mirrorless Camera',
    description = 'Compact mirrorless camera built for travel creators, portraits, and crisp 4K videos with quick autofocus.',
    price = 72999.00,
    category = 'Electronics',
    image_url = 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Canon EOS R50', 'Canon EOS R50 Mirrorless Camera');

UPDATE products
SET name = 'Logitech MX Keys S Wireless Keyboard',
    description = 'Premium low-profile wireless keyboard with comfortable key travel and seamless multi-device switching.',
    price = 10999.00,
    category = 'Electronics',
    image_url = 'https://images.unsplash.com/photo-1511467687858-23d96c32e4ae?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Logitech MX Keys S', 'Logitech MX Keys S Wireless Keyboard');

UPDATE products
SET name = 'Oversized Graphic Cotton T-Shirt',
    description = 'Soft heavyweight cotton tee with an oversized fit and an easy streetwear-inspired silhouette.',
    price = 1299.00,
    category = 'Fashion',
    image_url = 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Oversized Graphic Tee', 'Oversized Graphic Cotton T-Shirt');

UPDATE products
SET name = 'Slim Fit Washed Black Jeans',
    description = 'Stretch denim jeans with a slim fit, washed black finish, and everyday comfort for smart casual styling.',
    price = 1999.00,
    category = 'Fashion',
    image_url = 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Slim Fit Black Jeans', 'Slim Fit Washed Black Jeans');

UPDATE products
SET name = 'Women''s Linen Blend Co-ord Set',
    description = 'Lightweight linen blend shirt and trouser set designed for relaxed comfort and polished summer dressing.',
    price = 2799.00,
    category = 'Fashion',
    image_url = 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Women''s Linen Co-ord Set', 'Women''s Linen Blend Co-ord Set');

UPDATE products
SET name = 'Classic Indigo Denim Jacket',
    description = 'Timeless indigo denim jacket with a structured fit, durable stitching, and year-round layering appeal.',
    price = 2499.00,
    category = 'Fashion',
    image_url = 'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Classic Denim Jacket', 'Classic Indigo Denim Jacket');

UPDATE products
SET name = 'Resort Stripe Summer Shirt',
    description = 'Breathable short-sleeve shirt with subtle stripes and a relaxed shape made for warm-weather dressing.',
    price = 1499.00,
    category = 'Fashion',
    image_url = 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Casual Summer Shirt', 'Resort Stripe Summer Shirt');

UPDATE products
SET name = 'Essential Fleece Pullover Hoodie',
    description = 'Soft fleece hoodie with a clean finish, warm brushed lining, and everyday easy-wear comfort.',
    price = 1899.00,
    category = 'Fashion',
    image_url = 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Everyday Hoodie', 'Essential Fleece Pullover Hoodie');

UPDATE products
SET name = 'Stainless Steel Chronograph Watch',
    description = 'Refined stainless steel chronograph watch with a bold dial, polished case, and versatile everyday style.',
    price = 3499.00,
    category = 'Accessories',
    image_url = 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Chronograph Wrist Watch', 'Stainless Steel Chronograph Watch');

UPDATE products
SET name = 'Premium Leather Card Holder',
    description = 'Slim leather card holder with precise stitching, easy-access slots, and a compact pocket-friendly profile.',
    price = 999.00,
    category = 'Accessories',
    image_url = 'https://images.unsplash.com/photo-1627123424574-724758594e93?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Leather Card Holder', 'Premium Leather Card Holder');

UPDATE products
SET name = 'Polarized Aviator Sunglasses',
    description = 'Lightweight aviator sunglasses with polarized lenses for clear outdoor vision and reliable UV protection.',
    price = 1599.00,
    category = 'Accessories',
    image_url = 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Polarized Sunglasses', 'Polarized Aviator Sunglasses');

UPDATE products
SET name = 'Urban Commuter Backpack',
    description = 'Smart commuter backpack with padded laptop storage, organized pockets, and a durable water-resistant shell.',
    price = 2299.00,
    category = 'Accessories',
    image_url = 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Travel Backpack', 'Urban Commuter Backpack');

UPDATE products
SET name = 'Minimal Gold Pendant Necklace',
    description = 'Delicate pendant necklace with a refined finish that elevates everyday outfits and evening looks alike.',
    price = 1399.00,
    category = 'Accessories',
    image_url = 'https://images.unsplash.com/photo-1617038220319-276d3cfab638?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Minimal Pendant Necklace', 'Minimal Gold Pendant Necklace');

UPDATE products
SET name = 'Textured Leather Casual Belt',
    description = 'Textured leather belt with a matte buckle and clean finish for denim, chinos, and daily wear.',
    price = 899.00,
    category = 'Accessories',
    image_url = 'https://images.unsplash.com/photo-1624222247344-550fb60583dc?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Textured Belt', 'Textured Leather Casual Belt');

UPDATE products
SET name = 'Nike Air Zoom Running Shoes',
    description = 'Responsive running shoes with lightweight cushioning, breathable mesh, and reliable all-day comfort.',
    price = 4999.00,
    category = 'Footwear',
    image_url = 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Nike Air Zoom Runner', 'Nike Air Zoom Running Shoes');

UPDATE products
SET name = 'Adidas Court Lifestyle Sneakers',
    description = 'Clean court-inspired sneakers with soft lining, supportive cushioning, and an easy everyday look.',
    price = 4299.00,
    category = 'Footwear',
    image_url = 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Adidas Court Sneakers', 'Adidas Court Lifestyle Sneakers');

UPDATE products
SET name = 'Puma Flex Training Shoes',
    description = 'Stable training shoes designed for gym sessions, quick movement drills, and flexible comfort.',
    price = 3899.00,
    category = 'Footwear',
    image_url = 'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Puma Training Shoes', 'Puma Flex Training Shoes');

UPDATE products
SET name = 'Classic Leather Penny Loafers',
    description = 'Smooth leather penny loafers with cushioned support and a polished silhouette suited to work or events.',
    price = 4599.00,
    category = 'Footwear',
    image_url = 'https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Classic Leather Loafers', 'Classic Leather Penny Loafers');

UPDATE products
SET name = 'Comfort Cloud Slides',
    description = 'Easy slip-on slides with a contoured footbed, soft feel, and dependable grip for daily wear.',
    price = 1499.00,
    category = 'Footwear',
    image_url = 'https://images.unsplash.com/photo-1608256246200-53e8b47b2e3c?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Comfort Slides', 'Comfort Cloud Slides');

UPDATE products
SET name = 'Canvas High-Top Street Sneakers',
    description = 'Retro-inspired high-top sneakers with a durable canvas upper and padded ankle support.',
    price = 2599.00,
    category = 'Footwear',
    image_url = 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Canvas High-Top Sneakers', 'Canvas High-Top Street Sneakers');

UPDATE products
SET name = 'Ultrasonic Aroma Diffuser',
    description = 'Quiet ultrasonic diffuser that fills your room with a gentle mist and a calming spa-like atmosphere.',
    price = 1799.00,
    category = 'Home & Lifestyle',
    image_url = 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Aroma Diffuser', 'Ultrasonic Aroma Diffuser');

UPDATE products
SET name = 'Stoneware Coffee Mug Set',
    description = 'Modern stoneware mug set with a matte finish, comfortable grip, and cozy everyday appeal.',
    price = 1199.00,
    category = 'Home & Lifestyle',
    image_url = 'https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Ceramic Coffee Mug Set', 'Stoneware Coffee Mug Set');

UPDATE products
SET name = 'Textured Throw Cushion Set',
    description = 'Soft textured cushion set that refreshes your sofa, reading corner, or bed with instant warmth.',
    price = 1499.00,
    category = 'Home & Lifestyle',
    image_url = 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Throw Cushion Pair', 'Textured Throw Cushion Set');

UPDATE products
SET name = 'Adjustable LED Desk Lamp',
    description = 'Minimal desk lamp with an adjustable arm, focused warm light, and a clean modern finish.',
    price = 2399.00,
    category = 'Home & Lifestyle',
    image_url = 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Desk Lamp Pro', 'Adjustable LED Desk Lamp');

UPDATE products
SET name = 'Bamboo Foldable Laundry Basket',
    description = 'Breathable bamboo-frame laundry basket with a foldable shape and soft inner lining.',
    price = 1899.00,
    category = 'Home & Lifestyle',
    image_url = 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Bamboo Laundry Basket', 'Bamboo Foldable Laundry Basket');

UPDATE products
SET name = 'Modern Indoor Plant Stand',
    description = 'Minimal plant stand that adds height, style, and warmth to your living room or balcony corner.',
    price = 1599.00,
    category = 'Home & Lifestyle',
    image_url = 'https://images.unsplash.com/photo-1484154218962-a197022b5858?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Indoor Plant Stand', 'Modern Indoor Plant Stand');

UPDATE products
SET name = 'Noise Cancelling Over-Ear Headphones',
    description = 'Comfortable over-ear headphones with immersive sound, active noise cancellation, and long battery life.',
    price = 9999.00,
    category = 'Electronics',
    image_url = 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Noise-Cancelling Headphones', 'Noise Cancelling Over-Ear Headphones');

UPDATE products
SET name = 'Premium Leather Bifold Wallet',
    description = 'Classic leather bifold wallet with a slim shape, clean stitching, and essential card storage.',
    price = 1299.00,
    category = 'Accessories',
    image_url = 'https://images.unsplash.com/photo-1627123424574-724758594e93?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Minimal Leather Wallet', 'Premium Leather Bifold Wallet');

UPDATE products
SET name = 'Smart Fitness Watch with AMOLED Display',
    description = 'Fitness watch with a bright AMOLED screen, heart-rate tracking, sleep insights, and daily activity modes.',
    price = 5499.00,
    category = 'Electronics',
    image_url = 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Smart Fitness Watch', 'Smart Fitness Watch with AMOLED Display');

UPDATE products
SET name = 'Portable Bluetooth Speaker with Deep Bass',
    description = 'Compact wireless speaker with rich bass, clear vocals, and dependable battery life for daily listening.',
    price = 2199.00,
    category = 'Electronics',
    image_url = 'https://images.unsplash.com/photo-1589003077984-894e133dabab?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Portable Bluetooth Speaker', 'Portable Bluetooth Speaker with Deep Bass');

UPDATE products
SET name = 'Apple iPhone 13 128GB',
    description = 'Popular Apple smartphone with a sharp display, dependable performance, and a premium compact design.',
    price = 62999.00,
    category = 'Electronics',
    image_url = 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('iPhone 13', 'Apple iPhone 13 128GB');

UPDATE products
SET name = 'Nike Everyday Running Shoes',
    description = 'Everyday running shoes with lightweight cushioning, breathable construction, and reliable walking comfort.',
    price = 3299.00,
    category = 'Footwear',
    image_url = 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Nike Shoes', 'Nike Everyday Running Shoes');

UPDATE products
SET name = 'Everyday Cotton Crew T-Shirt',
    description = 'Classic crew-neck t-shirt in soft cotton jersey designed for daily layering and all-day comfort.',
    price = 899.00,
    category = 'Fashion',
    image_url = 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('T-Shirt', 'Everyday Cotton Crew T-Shirt');

UPDATE products
SET name = 'Stainless Steel Everyday Watch',
    description = 'Elegant everyday watch with a polished steel finish and a versatile design that suits casual and formal looks.',
    price = 2299.00,
    category = 'Accessories',
    image_url = 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=900&q=80'
WHERE name IN ('Watch', 'Stainless Steel Everyday Watch');

-- Add new products
INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Bose QuietComfort Wireless Headphones',
       'Premium wireless headphones with soft ear cushions, rich balanced sound, and reliable active noise cancellation.',
       25999.00,
       10,
       'Electronics',
       'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=80'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Bose QuietComfort Wireless Headphones'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Apple Watch SE GPS',
       'Feature-packed smartwatch with fitness tracking, notification support, and a lightweight everyday design.',
       27999.00,
       11,
       'Electronics',
       'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?auto=format&fit=crop&w=900&q=80'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Apple Watch SE GPS'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'JBL Flip 6 Portable Bluetooth Speaker',
       'Portable speaker with strong bass response, clear outdoor sound, and a rugged design for travel or home use.',
       10999.00,
       16,
       'Electronics',
       'https://images.unsplash.com/photo-1589003077984-894e133dabab?auto=format&fit=crop&w=900&q=80'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'JBL Flip 6 Portable Bluetooth Speaker'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Straight Fit Blue Denim Jeans',
       'Straight-fit denim jeans with a classic mid-rise waist and an easy everyday silhouette.',
       2199.00,
       24,
       'Fashion',
       'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?auto=format&fit=crop&w=900&q=80'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Straight Fit Blue Denim Jeans'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Relaxed Fit Polo T-Shirt',
       'Soft knit polo t-shirt with a relaxed fit and clean collar details for elevated casual dressing.',
       1399.00,
       27,
       'Fashion',
       'https://images.unsplash.com/photo-1586790170083-2f9ceadc732d?auto=format&fit=crop&w=900&q=80'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Relaxed Fit Polo T-Shirt'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Tailored Cotton Overshirt',
       'Structured cotton overshirt that layers easily over tees and adds polished depth to everyday outfits.',
       2499.00,
       18,
       'Fashion',
       'https://images.unsplash.com/photo-1593030761757-71fae45fa0e7?auto=format&fit=crop&w=900&q=80'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Tailored Cotton Overshirt'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Reebok Club C Leather Sneakers',
       'Classic leather sneakers with a clean retro profile, soft cushioning, and easy day-long comfort.',
       4799.00,
       14,
       'Footwear',
       'https://images.unsplash.com/photo-1543508282-6319a3e2621f?auto=format&fit=crop&w=900&q=80'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Reebok Club C Leather Sneakers'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'New Balance Everyday Walkers',
       'Supportive walking sneakers with plush cushioning and a versatile look built for daily wear.',
       5599.00,
       13,
       'Footwear',
       'https://images.unsplash.com/photo-1605348532760-6753d2c43329?auto=format&fit=crop&w=900&q=80'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'New Balance Everyday Walkers'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Waffle Knit Throw Blanket',
       'Soft waffle knit throw blanket that adds texture, warmth, and cozy comfort to sofas and beds.',
       1999.00,
       22,
       'Home & Lifestyle',
       'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&q=80'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Waffle Knit Throw Blanket'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Ribbed Glass Vase Set',
       'Decorative ribbed glass vase set that brings a clean, modern accent to shelves, tables, and entryways.',
       1699.00,
       20,
       'Home & Lifestyle',
       'https://images.unsplash.com/photo-1618220179428-22790b461013?auto=format&fit=crop&w=900&q=80'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Ribbed Glass Vase Set'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Acacia Wood Serving Tray',
       'Natural acacia wood serving tray with sturdy handles for breakfast, coffee service, and countertop styling.',
       1499.00,
       21,
       'Home & Lifestyle',
       'https://images.unsplash.com/photo-1517705008128-361805f42e86?auto=format&fit=crop&w=900&q=80'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Acacia Wood Serving Tray'
);

-- Exact requested product inserts
INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'LG 28L Convection Microwave Oven',
       'Multi-purpose convection microwave oven with baking, grilling, and reheating modes for modern kitchens.',
       12999.00,
       9,
       'Electronics',
       'https://images.unsplash.com/photo-1586201375761-83865001e31c'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'LG 28L Convection Microwave Oven'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Philips Air Fryer XL',
       'Healthy air fryer with rapid air technology for oil-free cooking and crispy results.',
       9999.00,
       11,
       'Electronics',
       'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Philips Air Fryer XL'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Dell 24-inch IPS Monitor',
       'Full HD IPS monitor with slim bezels, vibrant colors, and eye comfort technology.',
       14999.00,
       10,
       'Electronics',
       'https://images.unsplash.com/photo-1587829741301-dc798b83add3'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Dell 24-inch IPS Monitor'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Men''s Slim Fit Formal Shirt',
       'Crisp cotton formal shirt with a slim fit design perfect for office and events.',
       1799.00,
       24,
       'Fashion',
       'https://images.unsplash.com/photo-1521335629791-ce4aec67dd53'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Men''s Slim Fit Formal Shirt'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Women''s Floral Summer Dress',
       'Lightweight floral dress designed for comfort and style during warm weather.',
       2499.00,
       18,
       'Fashion',
       'https://images.unsplash.com/photo-1496747611176-843222e1e57c'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Women''s Floral Summer Dress'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Casual Hoodie Sweatshirt',
       'Soft fleece hoodie with relaxed fit and everyday streetwear appeal.',
       1999.00,
       20,
       'Fashion',
       'https://images.unsplash.com/photo-1556821840-3a63f95609a7'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Casual Hoodie Sweatshirt'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Adidas Ultraboost Running Shoes',
       'High-performance running shoes with responsive cushioning and breathable knit upper.',
       8999.00,
       12,
       'Footwear',
       'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Adidas Ultraboost Running Shoes'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Puma RS-X Reinvention Sneakers',
       'Bold design sneakers with chunky sole and superior comfort for daily wear.',
       6999.00,
       14,
       'Footwear',
       'https://images.unsplash.com/photo-1608231387042-66d1773070a5'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Puma RS-X Reinvention Sneakers'
);

INSERT INTO categories (name, slug, description, banner_image)
VALUES
    ('Electronics', 'electronics', 'Smart gadgets and premium devices for work, entertainment, and everyday convenience.', 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=1400&q=80'),
    ('Fashion', 'fashion', 'Fresh wardrobe staples, elevated basics, and trend-right styles for daily wear.', 'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1400&q=80'),
    ('Accessories', 'accessories', 'Modern finishing touches that bring personality and function to every outfit.', 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=1400&q=80'),
    ('Footwear', 'footwear', 'Comfort-first sneakers, slides, and statement shoes built for movement.', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1400&q=80'),
    ('Home & Lifestyle', 'home-lifestyle', 'Design-led essentials that make your living space feel warm and polished.', 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1400&q=80'),
    ('Skincare', 'skincare', 'Thoughtfully selected skincare essentials for everyday glow, hydration, and self-care rituals.', 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=1400&q=80')
ON DUPLICATE KEY UPDATE
    description = VALUES(description),
    banner_image = VALUES(banner_image);

INSERT INTO users (name, email, password, role)
VALUES ('Admin', 'admin@ekart.com', '$2a$12$yTrTAhca3VnPBGJo.2kLyeKAGlxeQxXHxqmaqMKQxKIwoDSN5SgcG', 'ADMIN')
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    password = VALUES(password),
    role = VALUES(role);

UPDATE users
SET password = '$2a$12$yTrTAhca3VnPBGJo.2kLyeKAGlxeQxXHxqmaqMKQxKIwoDSN5SgcG',
    role = 'ADMIN'
WHERE email = 'admin@ekart.com';

-- Homepage and catalog alignment updates
UPDATE products
SET image_url = 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9'
WHERE name IN ('Apple iPhone 15 128GB', 'Apple iPhone 13 128GB');

UPDATE products
SET image_url = 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853'
WHERE name = 'Dell Inspiron 14 FHD Laptop';

UPDATE products
SET image_url = 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e'
WHERE name IN ('Bose QuietComfort Wireless Headphones', 'Noise Cancelling Over-Ear Headphones');

UPDATE products
SET image_url = 'https://images.unsplash.com/photo-1586201375761-83865001e31c'
WHERE name = 'LG 28L Convection Microwave Oven';

UPDATE products
SET image_url = 'https://images.unsplash.com/photo-1587829741301-dc798b83add3'
WHERE name = 'Dell 24-inch IPS Monitor';

UPDATE products
SET image_url = 'https://images.unsplash.com/photo-1589003077984-894e133dabab'
WHERE name IN ('JBL Flip 6 Portable Bluetooth Speaker', 'Portable Bluetooth Speaker with Deep Bass');

UPDATE products
SET image_url = 'https://images.unsplash.com/photo-1521335629791-ce4aec67dd53'
WHERE name = 'Men''s Slim Fit Formal Shirt';

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Face Cleanser Gel',
       'Gentle daily cleanser that removes dirt and excess oil without drying the skin.',
       499.00,
       20,
       'Skincare',
       'https://images.unsplash.com/photo-1556228578-8c89e6adf883'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Face Cleanser Gel'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Vitamin C Serum',
       'Brightening serum that helps reduce dark spots and improves skin texture.',
       899.00,
       20,
       'Skincare',
       'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Vitamin C Serum'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Moisturizing Cream',
       'Hydrating face cream designed for soft, smooth, and healthy skin.',
       699.00,
       20,
       'Skincare',
       'https://images.unsplash.com/photo-1585386959984-a4155224a1ad'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Moisturizing Cream'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Samsung 32-inch Smart LED TV',
       'Samsung 32-inch Smart LED TV',
       28999.00,
       20,
       'Electronics',
       'https://images.unsplash.com/photo-1593784991095-a205069470b6'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Samsung 32-inch Smart LED TV'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'HP Wireless Keyboard and Mouse Combo',
       'HP Wireless Keyboard and Mouse Combo',
       2499.00,
       20,
       'Electronics',
       'https://images.unsplash.com/photo-1511467687858-23d96c32e4ae'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'HP Wireless Keyboard and Mouse Combo'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Xiaomi Smart Air Purifier',
       'Xiaomi Smart Air Purifier',
       11999.00,
       20,
       'Electronics',
       'https://images.unsplash.com/photo-1581578731548-c64695cc6952'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Xiaomi Smart Air Purifier'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Regular Fit Cotton Polo T-Shirt',
       'Regular Fit Cotton Polo T-Shirt',
       1299.00,
       20,
       'Fashion',
       'https://images.unsplash.com/photo-1586790170083-2f9ceadc732d'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Regular Fit Cotton Polo T-Shirt'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Women''s High Waist Jeans',
       'Women''s High Waist Jeans',
       2199.00,
       20,
       'Fashion',
       'https://images.unsplash.com/photo-1541099649105-f69ad21f3246'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Women''s High Waist Jeans'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Lightweight Bomber Jacket',
       'Lightweight Bomber Jacket',
       3499.00,
       20,
       'Fashion',
       'https://images.unsplash.com/photo-1520975916090-3105956dac38'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Lightweight Bomber Jacket'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Nike Revolution Running Shoes',
       'Nike Revolution Running Shoes',
       3999.00,
       20,
       'Footwear',
       'https://images.unsplash.com/photo-1542291026-7eec264c27ff'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Nike Revolution Running Shoes'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Skechers Go Walk Shoes',
       'Skechers Go Walk Shoes',
       4999.00,
       20,
       'Footwear',
       'https://images.unsplash.com/photo-1608231387042-66d1773070a5'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Skechers Go Walk Shoes'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Converse Chuck Taylor High Tops',
       'Converse Chuck Taylor High Tops',
       4599.00,
       20,
       'Footwear',
       'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Converse Chuck Taylor High Tops'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Canvas Laptop Sleeve',
       'Canvas Laptop Sleeve',
       899.00,
       20,
       'Accessories',
       'https://images.unsplash.com/photo-1585386959984-a4155224a1ad'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Canvas Laptop Sleeve'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Minimalist Wrist Bracelet',
       'Minimalist Wrist Bracelet',
       599.00,
       20,
       'Accessories',
       'https://images.unsplash.com/photo-1617038220319-276d3cfab638'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Minimalist Wrist Bracelet'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Travel Organizer Pouch',
       'Travel Organizer Pouch',
       799.00,
       20,
       'Accessories',
       'https://images.unsplash.com/photo-1553062407-98eeb64c6a62'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Travel Organizer Pouch'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Wooden Wall Shelf',
       'Wooden Wall Shelf',
       1599.00,
       20,
       'Home & Lifestyle',
       'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Wooden Wall Shelf'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'LED String Lights',
       'LED String Lights',
       799.00,
       20,
       'Home & Lifestyle',
       'https://images.unsplash.com/photo-1512446733611-9099a758e369'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'LED String Lights'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Glass Storage Jar Set',
       'Glass Storage Jar Set',
       1299.00,
       20,
       'Home & Lifestyle',
       'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Glass Storage Jar Set'
);

INSERT INTO products (name, description, price, stock, category, image_url)
SELECT 'Ceramic Indoor Planter Set',
       'Minimal ceramic planter set perfect for indoor plants and modern decor.',
       1299.00,
       20,
       'Home & Lifestyle',
       'https://images.unsplash.com/photo-1484154218962-a197022b5858'
WHERE NOT EXISTS (
    SELECT 1 FROM products WHERE name = 'Ceramic Indoor Planter Set'
);
