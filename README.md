# Create CVs and Cover Letters in Markdown and Render to PDF with Typst and Pandoc

[![Build Status](https://github.com/kadykov/typstCV/actions/workflows/ci.yml/badge.svg)](https://github.com/kadykov/typstCV/actions/workflows/ci.yml)

## Overview

This project allows you
to write your CV and cover letter in Markdown
and generate PDFs using Typst and Pandoc.
It supports both **public** and **private** versions
(includes private details like phone numbers).

---

## Getting Started

1. Clone the repository and open it as a development container.
2. Use the following commands for rendering:
   - `just build`: Generates the **public version** (excludes private details like phone numbers).
   - `just build-private`: Generates the **private version** (includes private details).

---

## Generating Private Versions

By default, running `just build` creates a public version that omits sensitive details.
To create private versions:

1. Rename `.env.example` to `.env`.
2. Enter your private details (phone number and email) in the `.env` file.
3. Run `just build-private` to render the private version.

---

## File Format

Both the CV and cover letter are written in Markdown.
Metadata and special features are defined in the YAML header.

### Metadata Fields

Include the following fields in the YAML header for your CV or cover letter:

**For both CV and cover letter:**

- `author`: Your name.
- `title`: Job title or position.
- `public-email`: Publicly available email address.
- `github`, `gitlab`, `linkedin`: Your usernames on these platforms.
- `website`: Your website URL (without the protocol).
- `date`: Custom creation date (format: `datetime(year: YYYY, month: M, day: D)`).
- `keywords`: Keywords for PDF metadata.
- `links`: Dictionary of keywords and URLs to auto-convert keywords into hyperlinks.

**Additional fields for cover letters:**

- `to`: Recipient's address.
- `from`: Your address.

---

## Features and Usage

### Adding Hyperlinks to Keywords

A Pandoc filter (`linkify.lua`) converts keywords in your document into hyperlinks.
To enable:

1. Add a `links` dictionary in the YAML metadata.
2. Define keywords and their corresponding URLs. See [CV example](#cv-example)

The commands `just build` and `just build-private` apply this filter by default.

### Right-Side Content in CVs

You can display content
(e.g., profile picture, location, dates)
on the right side of your CV.
To enable add metadata (`key="value"`)
to the heading you want to associate with side content.

**Supported keys:**

- `photo`: Path to your profile picture.
- `location`: Typst block with location details.
- `date`: Typst block with dates.

**Example:**

```markdown
## Multitel ASBL {location="Mons \\ Belgium"}

_Non-profit innovation center_

### Research Engineer {date="Jul.~2021 \\ Aug.~2024"}

Developed a THz time-domain spectroscopy (THz-TDS) data pipeline with an improved signal-to-noise ratio using sensitivity profile-shaped filtering.
```

**Note:** Use `\\` for line breaks in Typst blocks (Pandoc strips single `\`).

#### Known Issue

Side content automatically starts a new paragraph after the heading. To avoid extra spacing, structure your content accordingly.

---

### Hiding Section Titles

Section titles can be hidden (invisible to humans but visible to bots)
to save space and maintain structure.
To hide a title add `.hidden` to the heading metadata.

**Example:**

```markdown
# Professional Experience {.hidden}
```

---

### Full-Width Bibliography with Ordered Lists

In CVs and cover letters,
most content is constrained
to a limited width for better readability.
However,
bibliographic references do not require
the same level of readability
and are optimized to occupy minimal space.
To achieve this use **ordered lists** for bibliographic references,
and they automatically span the full width of the document.

---

## Examples

### CV Example

Below is a minimal example of a CV in Markdown.
For a detailed example, see [`kadykov-cv-en.md`](kadykov-cv-en.md).
Rendered PDFs are [hosted](http://github.kadykov.com/typstCV/) on GitHub Pages.

```markdown
---
author: Aleksandr KADYKOV
title: Research Engineer
public-email: cv@kadykov.com
github: kadykov
gitlab: kadykov
linkedin: aleksandr-kadykov
website: www.kadykov.com
keywords:
  - résumé
  - resume
  - CV
links:
  TDS: https://en.wikipedia.org/wiki/Terahertz_time-domain_spectroscopy
  THz: https://en.wikipedia.org/wiki/Terahertz_radiation

---

# Research Engineer {photo="photo.jpg"}

Headline of your CV

# Core Competencies {.hidden}

- Data analysis & presentation
- Experimental design & execution
- Instrumentation integration & orchestration
- Scientific Python development

# Professional Experience {.hidden}

---

## Multitel ASBL {location="Mons \\ Belgium"}

_Company description._

### Research Engineer {date="Jul.~2021 \\ Aug.~2024"}

Your explanation of what you have done.
```
