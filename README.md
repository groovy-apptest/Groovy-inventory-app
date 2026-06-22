# Groovy Inventory

Groovy Inventory is a Flutter inventory management app for factory stock, raw transactions, adjustments, reports, and alerts. It uses a FastAPI + MongoDB backend from the sibling `Groovy-Inventory-Backend` project.

## Project Docs

- `PROJECT_STRUCTURE.md` documents the current Flutter app architecture, routing, shared widgets, backend connection, and conventions.
- Cross-feature shared widgets live in `lib/core/widgets/`.
- Feature-specific code stays under `lib/features/<feature>/`.

## Run

```bash
flutter pub get
flutter run
```

The backend must be running for API-backed screens to load data.
