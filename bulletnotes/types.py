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
            d["type"],
            d["indent"],
            d["content"],
            [Bullet.from_dict(item) for item in d["subbullets"]],
        )

    def append_bullet(self, bullet):
        self.subbullets = append_bullet(self.subbullets, bullet)

    def to_dict(self):
        return {
            "type": self.bullet_type,
            "content": self.content,
            "indent": self.indent,
            "subbullets": [bullet.to_dict() for bullet in self.subbullets],
        }

    def walk(self):
        yield self

        for bullet in self.subbullets:
            yield from bullet.walk()

    def __str__(self):
        result = [f"{self.bullet_type} {self.content}"]

        for bullet in self.subbullets:
            lines = str(bullet).split("\n")

            indented_lines = ["    " + line for line in lines]

            result += indented_lines

        return "\n".join(result)


class CodeBlock:
    def __init__(self, code, lang=""):
        self.code = code.rstrip()
        self.lang = lang

    @staticmethod
    def from_dict(d):
        return CodeBlock(d["code"], d.get("lang", ""))

    def to_dict(self):
        d = {"code": self.code}

        if len(self.lang) > 0:
            d["lang"] = self.lang

        return d

    def walk(self):
        yield self

    def __str__(self):
        return "{{{" + self.lang + "\n" + self.code + "\n}}}"


class Section:
    def __init__(self, title="", contents=None):
        self.title = title
        self.contents = contents or []

    @staticmethod
    def from_dict(d):
        contents = []

        for item in d["contents"]:
            if type(item) is str:
                contents.append(item)
            elif "code" in item:
                contents.append(CodeBlock.from_dict(item))
            else:
                contents.append(Bullet.from_dict(item))

        return Section(d["title"], contents)

    def is_empty(self):
        return self.title == "" and len(self.contents) == 0

    def append_bullet(self, bullet):
        self.contents = append_bullet(self.contents, bullet)

    def append(self, item):
        self.contents.append(item)

    def to_dict(self):
        return {
            "title": self.title,
            "contents": [
                item if type(item) is str else item.to_dict() for item in self.contents
            ],
        }

    def walk(self):
        for item in self.contents:
            if isinstance(item, Bullet):
                yield from item.walk()
            else:
                yield item

    def __str__(self):
        result = ""

        if len(self.title) > 0:
            result += f":: {self.title} ::\n\n"

        prev_was_bullet = False

        for item in self.contents:
            if isinstance(item, Bullet):
                result += str(item) + "\n"
                prev_was_bullet = True
            else:
                if prev_was_bullet:
                    result += "\n"

                result += str(item) + "\n\n"
                prev_was_bullet = False

        if prev_was_bullet:
            result += "\n"

        return result


class Document:
    def __init__(self, title, sections):
        self.title = title
        self.sections = sections

    @staticmethod
    def from_dict(d):
        return Document(
            d["title"],
            [Section.from_dict(item) for item in d["sections"]],
        )

    def to_dict(self):
        return {
            "title": self.title,
            "sections": [section.to_dict() for section in self.sections],
        }

    def walk(self):
        for section in self.sections:
            yield from section.walk()

    def __str__(self):
        result = ""

        if len(self.title) > 0:
            result += f"## {self.title} ##\n\n"

        for section in self.sections:
            result += str(section) + "\n"

        return result.strip()
