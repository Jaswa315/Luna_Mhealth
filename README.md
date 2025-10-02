Luna mHealth

Luna mHealth is a mobile health education platform designed for resource-constrained communities with limited or no internet access. It transforms medical and educational content (often authored in PowerPoint) into offline-ready, interactive mobile modules.

This project focuses on re-architecting the Luna system for scalability, maintainability, and testability, while also enabling rich content rendering on mobile devices.

⸻

🚀 Features
	•	Offline Health Education – Delivers critical content without requiring internet access.
	•	Builder-Based Architecture – Replaced a legacy Module Object Generator with a modular Builder framework.
	•	Redesigned Domain Model – Simplified module, page, and component structures for better scalability.
	•	Rendering Engine – Converts PowerPoint XML objects into mobile-ready visuals (lines, shapes, flows).
	•	Test-Driven Development (TDD) – Applied Red-Green-Refactor cycle, improving clarity and code quality.
	•	Design Principles – Implemented Single Responsibility (SRP) and Open-Closed (OCP) principles.
	•	Improved Collaboration – Shifted to small, focused pull requests for easier review and maintainability.

⸻

🛠️ Tech & Tools
	•	Languages: Dart (Flutter), Java (core rendering), XML parsing
	•	Architecture: Builder Pattern, Domain Model Refactoring
	•	Testing: Test-Driven Development (TDD)
	•	Design Principles: SRP, OCP, KISS, YAGNI

⸻

📂 Project Structure
	•	luna_core/ → Core models (Module, Page, Component, BoundingBox, etc.)
	•	luna_authoring_system/ → Builder framework for generating structured modules from PowerPoint files
	•	luna_mobile/ → Mobile rendering pipeline (displays XML-derived visuals and content flows)

⸻

📖 Key Learnings
	•	Testing before coding made the design clearer and more maintainable.
	•	Applying clean software engineering principles reduced complexity and improved extensibility.
	•	Creating focused PRs improved teamwork and code reviews.

⸻

📌 Future Work
	•	Support for multimedia rendering (images, audio, video).
	•	Extending navigation for non-linear storytelling (choose-your-own-adventure style).
	•	Broader multilingual support for content modules.

