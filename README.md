# Create CVs and Cover Letters in Markdown and Render to PDF with Typst and Pandoc

## Overview

This project allows you
to write your CV and cover letter in Markdown
and generate PDFs using Typst and Pandoc.
It provides a flexible command-line interface and Docker support for easy integration.

---

## Usage

The primary way to use this tool is via the `build.sh` script or the provided Docker image.

### Command-Line Interface (CLI)

```bash
./build.sh <input_markdown_file | -> [--type <cv|letter>] [--output <output_pdf_file | ->] [--output-dir <directory>] [--set KEY=VALUE]...
```

**Arguments & Options:**

-   `<input_markdown_file | ->`: (Required) Path to the input Markdown file, or `-` to read from stdin.
-   `--type <cv|letter>`: (Optional) Explicitly set the document type. If omitted, it attempts to infer from the input filename (containing "cv" or "letter"). Defaults to `cv` if inference fails.
-   `--output <output_pdf_file | ->`: (Optional) Specify the output PDF file path, or `-` to write to stdout. If omitted, defaults to `<input_basename>.pdf` in the output directory. *Required if reading from stdin and not outputting to stdout.*
-   `--output-dir <directory>`: (Optional) Specify the directory for the output PDF file. Defaults to the current directory (`.`). The directory will be created if it doesn't exist.
-   `--set KEY=VALUE`: (Optional, repeatable) Override metadata values. The `KEY` is converted to lowercase and passed to Typst. See [Metadata Overrides](#metadata-overrides).

**Examples:**

```bash
# Build a CV from a file, output to the same directory
./build.sh my-cv.md

# Build a letter, specifying type and output directory
./build.sh my-letter.md --type letter --output-dir ./output

# Build a CV, overriding email and adding phone number, output to specific file
./build.sh my-cv.md --set EMAIL=private@email.com --set PHONE="123 456 7890" --output my-private-cv.pdf

# Build from stdin, output to stdout, overriding author
cat my-cv.md | ./build.sh - --set AUTHOR="Another Name" --output - > another-cv.pdf
```

### Docker Usage

A Docker image containing all dependencies is available.

1.  **Pull the image from Docker Hub:**
    ```bash
    docker pull kadykov/typst-cv
    ```
    *(Or build locally: `docker build -t kadykov/typst-cv .`)*

2.  **Run the container:** Mount your project directory (containing your `.md` files) to `/data` inside the container and pass arguments to `build.sh`.

    ```bash
    docker run --rm -v "$(pwd):/data" kadykov/typst-cv <input_file.md> [OPTIONS...]
    ```

**Docker Examples:**

```bash
# Build my-cv.md inside the container, output PDF appears in current host directory
docker run --rm -v "$(pwd):/data" kadykov/typst-cv my-cv.md

# Build my-letter.md, output to ./output directory on host
docker run --rm -v "$(pwd):/data" kadykov/typst-cv my-letter.md --output-dir output

# Build with overrides using environment variables (prefixed with TYPSTCV_)
docker run --rm -v "$(pwd):/data" \
  -e TYPSTCV_EMAIL="private@email.com" \
  -e TYPSTCV_PHONE="123 456 7890" \
  kadykov/typst-cv my-cv.md --output my-private-cv.pdf
```

---

## File Format

Both the CV and cover letter are written in Markdown.
Metadata and special features are defined in the YAML header.

### Metadata Fields

Include the following fields in the YAML header for your CV or cover letter:

**Common Metadata Fields:**

These fields are typically defined in the YAML frontmatter of your Markdown file. They can be overridden using the methods described in [Metadata Overrides](#metadata-overrides).

-   `author`: Your name.
-   `title`: Document title (e.g., "Research Engineer" for a CV, "Letter to..." for a cover letter).
-   `email`: Your primary email address.
-   `github`, `gitlab`, `linkedin`: Your usernames on these platforms.
-   `website`: Your website URL (e.g., `www.kadykov.com`).
-   `date`: Custom creation date (format: `year: YYYY, month: M, day: D`). Defaults to today if omitted.
-   `keywords`: List of keywords for PDF metadata.
-   `links`: Dictionary mapping keywords to URLs for automatic hyperlinking in the text (see [Features](#features)).

**Additional Fields for Cover Letters:**

- `to`: Recipient's address.
- `from`: Your address.

---

## Features and Usage

## Metadata Overrides

You can override values defined in the YAML frontmatter without editing the Markdown file using two methods. This is useful for including private information (like a phone number) or customizing documents for specific applications.

1.  **Environment Variables:** Set environment variables prefixed with `TYPSTCV_`. The suffix will be used as the lowercase key for the override.
    ```bash
    export TYPSTCV_EMAIL="private@email.com"
    export TYPSTCV_PHONE="+1 123 456 7890"
    ./build.sh my-cv.md
    # Or with Docker:
    docker run --rm -v "$(pwd):/data" -e TYPSTCV_EMAIL="private@email.com" typst-cv-generator my-cv.md
    ```

2.  **`--set` Argument:** Use the `--set KEY=VALUE` argument when running `build.sh`. The `KEY` is converted to lowercase.
    ```bash
    ./build.sh my-cv.md --set email=private@email.com --set phone="+1 123 456 7890" --set title="Senior Engineer Application"
    ```

**Priority:** Values from `--set` arguments and `TYPSTCV_` environment variables take precedence over values defined in the YAML frontmatter. The Typst template checks for these overrides first.

**Note:** The `phone` field is typically *only* provided via overrides, as it's usually considered private information not included directly in the source Markdown/YAML.

---

## Features and Usage

### Automatic Hyperlinks

A Pandoc filter (`linkify.lua`) automatically converts keywords found in your document text into hyperlinks if they are defined in the `links` dictionary in the YAML metadata.

**Example YAML:**
```yaml
links:
  TDS: https://en.wikipedia.org/wiki/Terahertz_time-domain_spectroscopy
  THz: https://en.wikipedia.org/wiki/Terahertz_radiation
```
Any occurrence of "TDS" or "THz" in the Markdown body will be linked accordingly.

### Right-Side Content (CVs)

You can display content
(e.g., profile picture, location, dates)
on the right side of your CV.
To enable add metadata (`key="value"`)
to the heading you want to associate with side content.

**Supported keys:**

- `photo`: Typst block with your profile image.
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
Rendered example PDFs are available [here](http://github.kadykov.com/typstCV/).

```markdown
---
author: Aleksandr KADYKOV
title: Research Engineer
email: cv@kadykov.com
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

# Research Engineer {photo='image("./photo.jpg", width: 120pt)'}

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
