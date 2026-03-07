#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["markdown-it-py"]
# ///
"""Generate a table of contents for README.md from its headings."""

import re
import sys
from pathlib import Path

from markdown_it import MarkdownIt


def github_anchor(text: str) -> str:
    """Convert heading text to a GitHub-compatible anchor slug."""
    # Strip markdown links, keeping only the link text
    text = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", text)
    # Strip inline code backticks
    text = re.sub(r"`([^`]+)`", r"\1", text)
    # Strip HTML tags
    text = re.sub(r"<[^>]+>", "", text)
    # GitHub anchor rules: lowercase, replace spaces with hyphens, strip non-alphanumeric (except hyphens)
    slug = text.strip().lower()
    slug = re.sub(r"\s+", "-", slug)
    slug = re.sub(r"[^\w-]", "", slug)
    return slug


def extract_headings(md_text: str) -> list[tuple[int, str]]:
    """Extract headings using markdown-it-py parser."""
    md = MarkdownIt()
    tokens = md.parse(md_text)
    headings = []
    for i, token in enumerate(tokens):
        if token.type == "heading_open":
            level = int(token.tag[1])  # h1 -> 1, h2 -> 2, etc.
            # The next token contains the heading text
            inline_token = tokens[i + 1]
            text = inline_token.content
            headings.append((level, text))
    return headings


TOC_START = "<!-- TOC -->"
TOC_END = "<!-- /TOC -->"


def generate_toc(headings: list[tuple[int, str]], min_level: int = 2) -> str:
    """Generate markdown TOC from headings, skipping h1."""
    lines = [TOC_START, "## Table of Contents", ""]
    for level, text in headings:
        if level < min_level:
            continue
        indent = "  " * (level - min_level)
        anchor = github_anchor(text)
        # Strip any markdown formatting for the display text
        display = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", text)
        lines.append(f"{indent}- [{display}](#{anchor})")
    lines.append("")
    lines.append(TOC_END)
    return "\n".join(lines)


def main() -> None:
    readme_path = Path(__file__).resolve().parent.parent / "README.md"
    if not readme_path.exists():
        print(f"Error: {readme_path} not found", file=sys.stderr)
        sys.exit(1)

    content = readme_path.read_text()

    # Extract headings from the full file (before any TOC insertion)
    # so we don't include the TOC's own "Table of Contents" heading
    clean_content = content
    if TOC_START in content and TOC_END in content:
        before = content[: content.index(TOC_START)]
        after = content[content.index(TOC_END) + len(TOC_END) :]
        clean_content = before + after

    headings = extract_headings(clean_content)
    toc = generate_toc(headings)

    if TOC_START in content and TOC_END in content:
        # Replace existing TOC
        new_content = re.sub(
            rf"{re.escape(TOC_START)}.*?{re.escape(TOC_END)}",
            toc,
            content,
            flags=re.DOTALL,
        )
    else:
        # Insert TOC after the first blank line following the h1 + badges + intro paragraph
        # Find the end of the introductory section (after first paragraph break following badges)
        lines = content.split("\n")
        insert_idx = None
        found_h1 = False
        blank_count = 0
        for i, line in enumerate(lines):
            if line.startswith("# ") and not found_h1:
                found_h1 = True
                continue
            if found_h1 and line.strip() == "":
                blank_count += 1
                # Insert after the intro paragraph (second blank line group after h1)
                if blank_count >= 4:  # after h1, badge, intro paragraph, announcement link
                    insert_idx = i + 1
                    break
        if insert_idx is None:
            # Fallback: insert after first heading
            for i, line in enumerate(lines):
                if line.startswith("## "):
                    insert_idx = i
                    break
        if insert_idx is None:
            insert_idx = 2  # after title

        lines.insert(insert_idx, toc + "\n")
        new_content = "\n".join(lines)

    readme_path.write_text(new_content)
    print(f"TOC generated in {readme_path}")


if __name__ == "__main__":
    main()
