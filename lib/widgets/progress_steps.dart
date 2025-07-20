import 'package:flutter/material.dart';

class ProgressSteps extends StatelessWidget {
  final int currentStep;
  final List<String> steps;
  const ProgressSteps(
      {super.key, required this.currentStep, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Theme.of(context).colorScheme.secondary
                          : isCompleted
                              ? Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.5)
                              : Colors.grey[800],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.grey[700]!,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check,
                              size: 18, color: Colors.black)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isActive ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  if (index != steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 4,
                        color: isCompleted
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.grey[800],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                steps[index],
                style: TextStyle(
                  fontSize: 12,
                  color: isActive
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.grey[400],
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }),
    );
  }
}
