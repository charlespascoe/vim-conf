def append_bullet(contents, bullet):
    if len(contents) == 0:
        return [bullet]

    last_item = contents[-1]

    if type(last_item) is str or last_item.indent >= bullet.indent:
        # Either previous item was text, or it's a bullet with greater indent
        # So just append the bullet
        return contents + [bullet]

    last_item.append_bullet(bullet)

    return contents


class Bullet:
    def __init__(self, bullet_type, indent, content, subbullets=[]):
        self.bullet_type = bullet_type
        self.indent = indent
        self.content = content
        self.subbullets = subbullets

    @staticmethod
    def from_dict(d):
        return Bullet(
            d['type'],
            d['indent'],
            d['content'],
            [Bullet.from_dict(item) for item in d['subbullets']],
        )

    def append_bullet(self, bullet):
        self.subbullets = append_bullet(self.subbullets, bullet)

    def to_dict(self):
        return {
            'type': self.bullet_type,
            'content': self.content,
            'indent': self.indent,
            'subbullets': [bullet.to_dict() for bullet in self.subbullets],
        }

    def walk(self):
        yield self

        for bullet in self.subbullets:
            yield from bullet.walk()

    def __str__(self):
        result = [f'{self.bullet_type} {self.content}']

        for bullet in self.subbullets:
            lines = str(bullet).split('\n')

            indented_lines = ['    ' + line for line in lines]

            result += indented_lines

        return '\n'.join(result)


class Section:
    def __init__(self, title = '', contents = []):
        self.title = title
        self.contents = contents

    @staticmethod
    def from_dict(d):
        return Section(
            d['title'],
            [
                item if type(item) is str else Bullet.from_dict(item)
                for item in d['contents']
            ]
        )

    def is_empty(self):
        return self.title == '' and len(self.contents) == 0

    def append_bullet(self, bullet):
        self.contents = append_bullet(self.contents, bullet)

    def to_dict(self):
        return {
            'title': self.title,
            'contents': [
                item if type(item) is str else item.to_dict()
                for item in self.contents
            ],
        }

    def walk(self):
        for item in self.contents:
            if isinstance(item, Bullet):
                yield from item.walk()


class Document:
    def __init__(self, title, sections):
        self.title = title
        self.sections = sections

    @staticmethod
    def from_dict(d):
        return Document(
            d['title'],
            [Section.from_dict(item) for item in d['sections']],
        )

    def to_dict(self):
        return {
            'title': self.title,
            'sections': [section.to_dict() for section in self.sections],
        }

    def walk(self):
        for section in self.sections:
            yield from section.walk()
