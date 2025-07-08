// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:interview_task/views/statuscolor.dart';
// import '../models/property_model.dart';
// import 'services/image_service.dart';
//
// class PropertyDetailScreen extends StatefulWidget {
//   final PropertyModel property;
//   const PropertyDetailScreen({super.key, required this.property});
//
//   @override
//   State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
// }
//
// class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
//   final _imageService = ImageService();
//   final List<XFile> _localImages = [];
//   final PageController _pageController = PageController();
//
//   int _currentImageIndex = 0;
//   XFile? _tempImage;
//
//   Future<void> _pick(ImageSource source) async {
//     try {
//       final picked = await _imageService.pickImage(
//         context: context, // Needed for web
//         source: source,
//       );
//       if (picked == null) return;
//       setState(() => _tempImage = picked);
//       _showPickSheet();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Image error: $e')),
//       );
//     }
//   }
//
//
//   void _addTempImage() {
//     if (_tempImage == null) return;
//     setState(() {
//       _localImages.add(_tempImage!);
//       _currentImageIndex = widget.property.images.length + _localImages.length - 1;
//       _tempImage = null;
//     });
//     Navigator.pop(context);
//   }
//
//   void _showPickSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => Padding(
//         padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(24)),
//         child: _tempImage == null
//             ? SizedBox(
//           height: 140,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _PickOption(
//                 icon: Icons.camera_alt,
//                 label: _imageService.isWeb ? 'Webcam' : 'Camera',
//                 onTap: () {
//                   Navigator.pop(context);
//                   // Ensure this calls the correct method for web
//                   _pick(ImageSource.camera);
//                 },
//               ),
//               _PickOption(
//                 icon: Icons.photo_library,
//                 label: 'Gallery',
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pick(ImageSource.gallery);
//                 },
//               ),
//             ],
//           ),
//         )
//             : ConstrainedBox(
//           constraints: const BoxConstraints(maxHeight: 350),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image(
//                 image: _imageService.getPreviewProvider(_tempImage!),
//                 height: 200,
//                 fit: BoxFit.cover,
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: _addTempImage,
//                     icon: const Icon(Icons.check),
//                     label: const Text('Add'),
//                   ),
//                   OutlinedButton.icon(
//                     onPressed: () {
//                       setState(() => _tempImage = null);
//                       Navigator.pop(context);
//                       _showPickSheet();
//                     },
//                     icon: const Icon(Icons.refresh),
//                     label: const Text('Retake'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final p = widget.property;
//     final total = p.images.length + _localImages.length;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(p.title),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           AspectRatio(
//             aspectRatio: 16 / 9,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Stack(
//                 children: [
//                   PageView.builder(
//                     controller: _pageController,
//                     itemCount: total,
//                     onPageChanged: (i) => setState(() => _currentImageIndex = i),
//                     itemBuilder: (_, i) {
//                       if (i < p.images.length) {
//                         return Image.network(p.images[i], fit: BoxFit.cover);
//                       } else {
//                         final localIdx = i - p.images.length;
//                         return Image(
//                           image: _imageService.getPreviewProvider(_localImages[localIdx]),
//                           fit: BoxFit.cover,
//                         );
//                       }
//                     },
//                   ),
//                   if (total > 1)
//                     Positioned(
//                       bottom: 8,
//                       left: 0,
//                       right: 0,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: List.generate(
//                           total,
//                               (i) => AnimatedContainer(
//                             duration: const Duration(milliseconds: 250),
//                             margin: const EdgeInsets.symmetric(horizontal: 3),
//                             width: _currentImageIndex == i ? 12 : 8,
//                             height: 8,
//                             decoration: BoxDecoration(
//                               color: _currentImageIndex == i ? Colors.white : Colors.white70,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton.icon(
//             onPressed: _showPickSheet,
//             icon: const Icon(Icons.add_a_photo),
//             label: const Text('Add Photo'),
//           ),
//           const SizedBox(height: 24),
//           Text(
//             '\$${p.price} ${p.currency}',
//             style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Chip(
//                 label: Text(p.status),
//                 backgroundColor: PropertyUtils.getStatusColor(p.status),
//                 labelStyle: const TextStyle(color: Colors.white),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             '${p.bedrooms} Beds · ${p.bathrooms} Baths · ${p.areaSqFt} sqft',
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//           const SizedBox(height: 16),
//           Text(p.description, style: Theme.of(context).textTheme.bodyLarge),
//           const SizedBox(height: 24),
//           if (p.tags.isNotEmpty) ...[
//             Text('Highlights', style: Theme.of(context).textTheme.titleMedium),
//             const SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               children: p.tags.map((e) => Chip(label: Text(e))).toList(),
//             ),
//             const SizedBox(height: 24),
//           ],
//           Text('Agent', style: Theme.of(context).textTheme.titleMedium),
//           ListTile(
//             contentPadding: EdgeInsets.zero,
//             leading: const CircleAvatar(child: Icon(Icons.person)),
//             title: Text(p.agent.name),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(p.agent.contact),
//                 Text(p.agent.email),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _PickOption extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;
//
//   const _PickOption({required this.icon, required this.label, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) => Column(
//     children: [
//       InkWell(
//         onTap: onTap,
//         child: CircleAvatar(radius: 30, child: Icon(icon, size: 28)),
//       ),
//       const SizedBox(height: 8),
//       Text(label),
//     ],
//   );
// }
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interview_task/views/statuscolor.dart';
import '../models/property_model.dart';
import 'services/image_service.dart';

class PropertyDetailScreen extends StatefulWidget {
  final PropertyModel property;
  const PropertyDetailScreen({super.key, required this.property});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  final _imageService = ImageService();
  final List<XFile> _localImages = [];
  final PageController _pageController = PageController();

  int _currentImageIndex = 0;
  XFile? _tempImage;

  Future<void> _pick(ImageSource source) async {
    try {
      final picked = await _imageService.pickImage(
        context: context, // Needed for web
        source: source,
      );
      if (picked == null) return;
      setState(() => _tempImage = picked);
      _showPickSheet();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image error: $e')),
      );
    }
  }

  void _addTempImage() {
    if (_tempImage == null) return;
    setState(() {
      _localImages.add(_tempImage!);
      _currentImageIndex = widget.property.images.length + _localImages.length - 1;
      _tempImage = null;
    });
    Navigator.pop(context);
  }

  void _removeImage(int index) {
    setState(() {
      _localImages.removeAt(index);
      // Adjust the current index if necessary
      if (_currentImageIndex >= _localImages.length + widget.property.images.length) {
        _currentImageIndex = _localImages.length + widget.property.images.length - 1;
      }
    });
  }

  void _showPickSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(24)),
        child: _tempImage == null
            ? SizedBox(
          height: 140,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _PickOption(
                icon: Icons.camera_alt,
                label: _imageService.isWeb ? 'Webcam' : 'Camera',
                onTap: () {
                  Navigator.pop(context);
                  _pick(ImageSource.camera);
                },
              ),
              _PickOption(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () {
                  Navigator.pop(context);
                  _pick(ImageSource.gallery);
                },
              ),
            ],
          ),
        )
            : ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 350),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: _imageService.getPreviewProvider(_tempImage!),
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _addTempImage,
                    icon: const Icon(Icons.check),
                    label: const Text('Add'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _tempImage = null);
                      Navigator.pop(context);
                      _showPickSheet();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retake'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.property;
    final total = p.images.length + _localImages.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: total,
                    onPageChanged: (i) => setState(() => _currentImageIndex = i),
                    itemBuilder: (_, i) {
                      if (i < p.images.length) {
                        return Image.network(p.images[i], fit: BoxFit.cover);
                      } else {
                        final localIdx = i - p.images.length;
                        return Stack(
                          children: [
                            Image(
                              image: _imageService.getPreviewProvider(_localImages[localIdx]),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeImage(localIdx),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  if (total > 1)
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          total,
                              (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentImageIndex == i ? 12 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == i ? Colors.white : Colors.white70,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _showPickSheet,
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Add Photo'),
          ),
          const SizedBox(height: 24),
          Text(
            '\$${p.price} ${p.currency}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Chip(
                label: Text(p.status),
                backgroundColor: PropertyUtils.getStatusColor(p.status),
                labelStyle: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${p.bedrooms} Beds · ${p.bathrooms} Baths · ${p.areaSqFt} sqft',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(p.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          if (p.tags.isNotEmpty) ...[
            Text('Highlights', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: p.tags.map((e) => Chip(label: Text(e))).toList(),
            ),
            const SizedBox(height: 24),
          ],
          Text('Agent', style: Theme.of(context).textTheme.titleMedium),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(p.agent.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.agent.contact),
                Text(p.agent.email),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PickOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      InkWell(
        onTap: onTap,
        child: CircleAvatar(radius: 30, child: Icon(icon, size: 28)),
      ),
      const SizedBox(height: 8),
      Text(label),
    ],
  );
}