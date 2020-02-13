def append_bullet(contents, bullet):
    if len(contents) == 0:
        return [bullet]

    last_item = contents[-1]

    if not isinstance(last_item, SubbulletContainer):
        return contents + [bullet]

    if isinstance(last_item, Bullet) and last_item.indent >= bullet.indent:
        return contents + [bullet]

    last_item.append_bullet(bullet)

    return contents


class SubbulletContainer:
    def append_bullet(self, bullet):
        raise Exception('Not Implemented')

    def find_all(self, predicate):
        raise Exception('Not Implemented')


class DictSerialisable:
    def to_dict(self):
        raise Exception('Not Implemented')


class Bullet(SubbulletContainer):
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

    def find_all(self, predicate):
        if predicate(self):
            yield self

        for bullet in self.subbullets:
            yield from bullet.find_all(predicate)

    def __str__(self):
        result = [f'{self.bullet_type} {self.content}']

        for bullet in self.subbullets:
            lines = str(bullet).split('\n')

            indented_lines = ['    ' + line for line in lines]

            result += indented_lines

        return '\n'.join(result)


class Section(SubbulletContainer):
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
                if isinstance(item, DictSerialisable) or isinstance(item, str)
            ],
        }

    def find_all(self, predicate):
        for item in self.contents:
            if isinstance(item, Bullet):
                yield from item.find_all(predicate)


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
            'sections': [section.to_dict() for section in self.sections if isinstance(section, DictSerialisable)],
        }

    def find_all(self, predicate):
        for section in self.sections:
            if isinstance(section, SubbulletContainer):
                yield from section.find_all(predicate)
