import re
from .types import Document, Section, Bullet


title_regexp = re.compile('^##([^#]+)##')
subtitle_regexp = re.compile('^::([^:]+)::')


def isempty(s):
    return s == '' or s.isspace()


def bullets_to_char_set(bullets):
    return ''.join('\\' + bullet for bullet in bullets)


def parse_doc(lines, bullet_types):
    bullet_regexp = re.compile('^((\\s{4})*)([' + bullets_to_char_set(bullet_types) + ']) ')

    pos = 0
    title = ''
    sections = []
    cur_text = ''
    cur_section = Section()

    while pos < len(lines):
        line = lines[pos]

        title_match = title_regexp.match(line)

        if title == '' and title_match is not None:
            title = title_match.group(1).strip()
            pos += 1
            continue

        subtitle_match = subtitle_regexp.match(line)

        if subtitle_match is not None:
            subtitle = subtitle_match.group(1).strip()

            if not isempty(cur_text):
                cur_section.contents.append(cur_text.strip())
                cur_text = ''

            if not cur_section.is_empty():
                sections.append(cur_section)

            cur_section = Section(subtitle)

            pos += 1
            continue

        if bullet_regexp.match(line):
            if not isempty(cur_text):
                cur_section.contents.append(cur_text.strip())
                cur_text = ''

            bullet, new_pos = parse_bullet(lines, pos, bullet_regexp)

            cur_section.append_bullet(bullet)

            pos = new_pos

            continue

        if not isempty(line):
            cur_text += ' ' + line.strip()
        elif not isempty(cur_text):
            cur_section.contents.append(cur_text.strip())
            cur_text = ''

        pos += 1

    if not isempty(cur_text):
        cur_section.contents.append(cur_text.strip())
        cur_text = ''

    if not cur_section.is_empty():
        sections.append(cur_section)

    return Document(title, sections)


def parse_bullet(lines, start_line, bullet_regexp):
    indent_match = bullet_regexp.match(lines[start_line])

    if not indent_match:
        raise Exception('Unexpected error: No match when finding indent')

    indent = indent_match.group(1)
    bullet_type = indent_match.group(3)
    indent_level = len(indent) // 4

    contents = [bullet_regexp.sub('', lines[start_line])]

    pos = start_line + 1

    while pos < len(lines):
        line = lines[pos]

        is_continuation = (
            # Line must not be empty (only contiguous text)
            not isempty(line) and
            # Indent must be at least the indent of the bullet
            line.startswith(indent) and
            # Line must not be a new subbullet
            not bullet_regexp.match(line)
        )

        if is_continuation:
            contents.append(line.strip())
            pos += 1
        else:
            break

    return Bullet(
        bullet_type,
        indent_level,
        ' '.join(contents),
    ), pos
