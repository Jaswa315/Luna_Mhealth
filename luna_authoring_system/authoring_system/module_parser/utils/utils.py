import re

def extract_clickable_text(notes):
    """
    Extracts clickable text from notes (URL in square brackets followed by URL).

    Args:
        notes (str): The notes text from a slide.

    Returns:
        list: A list of dictionaries containing 'text' and 'url' keys for each clickable text item.
    """
    clickable_text_pattern = r'\[([^\]]+)\]\(([^)]+)\)'
    clickable_text_matches = re.findall(clickable_text_pattern, notes)
    return [{'text': match[0], 'url': match[1]} for match in clickable_text_matches]
