# Product Context: Typst CV/Letter Generator

## Problem Solved

The project aims to simplify the creation of professional CVs and cover letters. Users can focus on content by writing in familiar Markdown, while leveraging the powerful typesetting capabilities of Typst for high-quality PDF output. It avoids the need for users to learn complex Typst syntax directly for basic document creation.

## Core User Need

Users need a straightforward way to convert their Markdown CV/letter documents into PDFs without dealing with complex build commands or rigid file naming conventions. The original `justfile`-based system, while functional, was identified as too complex and inflexible for general use.

## Desired User Experience

-   **Simplicity:** A single, intuitive command should handle the conversion process.
-   **Flexibility:** Users should be able to name their Markdown files freely.
-   **Customization:** Easy mechanism to provide private information (like phone/email) or override other metadata without editing core project files.
-   **Standard Tooling:** Ability to integrate the tool into scripts (stdin/stdout) and use it easily within a Docker container.
-   **Clear Documentation:** Instructions should be clear for both direct command-line usage and Docker usage.

## Target Audience

Individuals (developers, researchers, etc.) who are comfortable with Markdown and prefer text-based document creation workflows, but want polished PDF outputs without mastering a full typesetting system like LaTeX or Typst directly.
