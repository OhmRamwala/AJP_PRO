package com.ekart.util;

import com.ekart.model.Category;

import java.util.List;
import java.util.Locale;
import java.util.Optional;

public final class CatalogUtil {
    private static final List<Category> CATEGORIES = List.of(
            new Category(
                    "Electronics",
                    "electronics",
                    "Smart gadgets and premium devices that keep life connected.",
                    "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=1400&q=80"
            ),
            new Category(
                    "Fashion",
                    "fashion",
                    "Trend-right fits and elevated everyday wardrobe essentials.",
                    "https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1400&q=80"
            ),
            new Category(
                    "Accessories",
                    "accessories",
                    "Small details that instantly sharpen your personal style.",
                    "https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=1400&q=80"
            ),
            new Category(
                    "Footwear",
                    "footwear",
                    "Sneakers, slides, and sharp silhouettes built for comfort.",
                    "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1400&q=80"
            ),
            new Category(
                    "Home & Lifestyle",
                    "home-lifestyle",
                    "Warm, modern pieces that make everyday spaces feel premium.",
                    "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1400&q=80"
            ),
            new Category(
                    "Skincare",
                    "skincare",
                    "Thoughtfully selected skincare essentials for everyday glow, hydration, and self-care rituals.",
                    "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=1400&q=80"
            )
    );

    private CatalogUtil() {
    }

    public static List<Category> getCategories() {
        return CATEGORIES;
    }

    public static Optional<Category> findBySlug(String slug) {
        if (slug == null || slug.isBlank()) {
            return Optional.empty();
        }

        String normalizedSlug = slug.trim().toLowerCase(Locale.ENGLISH);
        return CATEGORIES.stream()
                .filter(category -> category.getSlug().equalsIgnoreCase(normalizedSlug))
                .findFirst();
    }

    public static Optional<Category> findByName(String name) {
        if (name == null || name.isBlank()) {
            return Optional.empty();
        }

        String normalizedName = name.trim().toLowerCase(Locale.ENGLISH);
        return CATEGORIES.stream()
                .filter(category -> category.getName().toLowerCase(Locale.ENGLISH).equals(normalizedName))
                .findFirst();
    }

    public static String normalizeCategoryName(String category) {
        return findByName(category)
                .map(Category::getName)
                .orElseGet(() -> category == null ? "" : category.trim());
    }

    public static String resolveCategory(String currentCategory, String productName, String description) {
        Optional<Category> existingCategory = findByName(currentCategory);
        if (existingCategory.isPresent()) {
            return existingCategory.get().getName();
        }

        String searchableText = ((productName == null ? "" : productName) + " " + (description == null ? "" : description))
                .toLowerCase(Locale.ENGLISH);

        if (containsAny(searchableText, "shoe", "shoes", "sneaker", "sneakers", "slide", "slides", "loafer", "loafers", "runner", "running")) {
            return "Footwear";
        }
        if (containsAny(searchableText, "shirt", "t-shirt", "tshirt", "tee", "jeans", "jacket", "hoodie", "linen", "denim", "coord", "fashion")) {
            return "Fashion";
        }
        if (containsAny(searchableText, "wallet", "watch", "sunglasses", "backpack", "necklace", "belt", "card holder", "accessories", "holder")) {
            return "Accessories";
        }
        if (containsAny(searchableText, "diffuser", "mug", "cushion", "lamp", "basket", "stand", "plant", "home", "lifestyle", "laundry", "coffee")) {
            return "Home & Lifestyle";
        }
        if (containsAny(searchableText, "phone", "iphone", "smartphone", "headphone", "headphones", "earbuds", "laptop", "tv", "camera", "speaker", "keyboard", "smart", "fitness")) {
            return "Electronics";
        }
        return "Accessories";
    }

    public static String resolveImageUrl(String rawImageUrl, String category, String productName, String description) {
        String trimmedImageUrl = rawImageUrl == null ? "" : rawImageUrl.trim();
        if (!trimmedImageUrl.isBlank()
                && !trimmedImageUrl.toLowerCase(Locale.ENGLISH).contains("placehold.co")
                && !trimmedImageUrl.toLowerCase(Locale.ENGLISH).contains("text=ekart")) {
            return trimmedImageUrl;
        }
        return fallbackImageUrl(category, productName, description);
    }

    public static String fallbackImageUrl(String category, String productName, String description) {
        String resolvedCategory = resolveCategory(category, productName, description);
        return switch (resolvedCategory) {
            case "Electronics" -> "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=900&q=80";
            case "Fashion" -> "https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=900&q=80";
            case "Footwear" -> "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=80";
            case "Home & Lifestyle" -> "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&q=80";
            default -> "https://images.unsplash.com/photo-1523170335258-f5ed11844a49?auto=format&fit=crop&w=900&q=80";
        };
    }

    private static boolean containsAny(String text, String... keywords) {
        for (String keyword : keywords) {
            if (text.contains(keyword)) {
                return true;
            }
        }
        return false;
    }
}
