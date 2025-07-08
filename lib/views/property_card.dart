import 'package:flutter/material.dart';
import 'package:interview_task/core/utils/app_colors.dart';
import 'package:interview_task/views/statuscolor.dart';
import '../models/property_model.dart';
import '../views/property_detail_screen.dart';
import '../core/widgets/app_text.dart';
import '../core/animations/animations.dart';

class PropertyCard extends StatefulWidget {
  final PropertyModel property;

  const PropertyCard({super.key, required this.property});

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final property = widget.property;

    return AppAnimations.slideInUp(
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PropertyDetailScreen(property: property),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image Slider + Status + Dots
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: PageView.builder(
                        itemCount: property.images.length,
                        onPageChanged: (i) =>
                            setState(() => _currentImageIndex = i),
                        itemBuilder: (_, i) {
                          return Hero(
                            tag: '${property.id}_image',
                            child: Image.network(
                              property.images[i],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // ── Status Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: PropertyUtils.getStatusColor(property.status),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: AppText(
                        property.status,
                        size: 11,
                        color: Colors.white,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // ── Image Dots
                  if (property.images.length > 1)
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                        List.generate(property.images.length, (index) {
                          final isActive = index == _currentImageIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin:
                            const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: isActive ? 18 : 8,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),

              // ── Content
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      property.title,
                      size: 18,
                      weight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 16, color: colorScheme.primary),
                        const SizedBox(width: 4),
                        AppText(
                          '${property.location.city}, ${property.location.country}',
                          size: 13,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    AppText(
                      '${property.bedrooms} Beds · ${property.bathrooms} Baths · ${property.areaSqFt} sqft',
                      size: 13,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(height: 12),

                    AppText(
                      '\$${property.price} ${property.currency}',
                      size: 16,
                      weight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 14),

                    // ── Tags
                    if (property.tags.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: property.tags
                            .map(
                              (tag) => Chip(
                            label: AppText(tag, size: 12),
                            labelPadding: const EdgeInsets.symmetric(
                                horizontal: 10),
                                backgroundColor: AppColors.cardBackground,
                                shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        )
                            .toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      durationMs: 500,
    );
  }
}
