import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/rating_service.dart';
import 'package:app/models/dish.dart';
import 'package:app/services/auth_service.dart';

class RatingDialog extends StatefulWidget {
  final Dish dish;

  const RatingDialog({super.key, required this.dish});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _rating = 3;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Valorar ${widget.dish.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Selecciona tu calificación:'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 32,
                ),
                onPressed: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 16),
          if (_isSubmitting) const CircularProgressIndicator(),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text('Enviar'),
          onPressed: _isSubmitting ? null : () => _submitRating(),
        ),
      ],
    );
  }

  Future<void> _submitRating() async {
    setState(() => _isSubmitting = true);

    try {
      final token = Provider.of<AuthService>(context, listen: false).token;
      if (token == null) return;

      await RatingService().rateDish(token, widget.dish.token, _rating);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Gracias por valorar ${widget.dish.name}!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar valoración: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}