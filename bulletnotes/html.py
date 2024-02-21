import re


emphasis_regex = re.compile("`([^`]+)`")
tag_regex = re.compile(r"#([a-zA-Z0-9_\-]+)")
contact_regex = re.compile(r"(?<!\w)@([a-zA-Z0-9_\-.]+)")
link_regex = re.compile(r'(?<!\w)\[(http[^"\]]+)\](?:\(([^)]+)\))?(?!\w)')
ref_regex = re.compile(r"&([a-zA-Z0-9_\-.:]+(/[a-zA-Z0-9_\-.:]+)*)")
monospace_regex = re.compile(r"(?<!\\)\{((\\[\\{}]|[^}])*)\}")
highlighted_monospace_regex = re.compile(r"(?<!\\)\{\{((\\[\\{}]|[^}])*)\}\}")
anchor_regex = re.compile(r":([a-zA-Z0-9]+):")
anchor_pointer_regex = re.compile(r"\[:([a-zA-Z0-9]+):\]")
escape_regex = re.compile(r"\\([{}])")  # TODO add more escaped characters


def escape_html(text):
    return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def format_style(style):
    if style is None:
        return ""

    return " ".join(f"{key}: {style[key]};" for key in style).replace('"', '\\"')


class BulletFormatter:
    def __init__(self, style, bullets_formatter, text_formatter):
        self.style = {}

        for key, value in BulletFormatter.default_style.items():
            self.style[key] = value

        if style is not None:
            for key, value in style.items():
                self.style[key] = value

        self.bullets_formatter = bullets_formatter
        self.text_formatter = text_formatter

    def __call__(self, bullet):
        output = Element(
            "li",
            self.text_formatter(bullet.content),
            {"style": format_style(self.style or BulletFormatter.default_style)},
        )

        if len(bullet.subbullets) > 0:
            ul = self.bullets_formatter.build_ul()

            for b in bullet.subbullets:
                ul.append(self(b))

            output.append(ul)

        return output


BulletFormatter.default_style = {
    "color": "initial",
    "font-weight": "initial",
    "font-style": "initial",
    "background-color": "initial",
}


class BulletsFormatter:
    def __init__(self, text_formatter):
        self.formatters = {}
        self.text_formatter = text_formatter
        self.default_formatter = None

    def register(self, bullet_types, style, *text_transforms):
        formatter = BulletFormatter(
            style,
            self,
            self.text_formatter.extend(*text_transforms),
        )

        for bt in bullet_types:
            self.formatters[bt] = formatter

    @staticmethod
    def default(text_formatter):
        bf = BulletsFormatter(text_formatter)

        bf.register("-", {"color": "black"})
        bf.register("*+", {"color": "green"}, lambda s: [Element("b", "AP:"), " ", s])
        bf.register("?<", {"color": "#FF5722"})
        bf.register(">", {"color": "initial", "font-weight": "bold"})
        # bf.register('#', {'color': '#0070ff', 'font-style': 'italic'})

        return bf

    def __call__(self, bullet):
        if bullet.bullet_type not in self.formatters:
            if self.default_formatter is None:
                return ""

            return self.default_formatter(bullet)

        formatter = self.formatters[bullet.bullet_type]

        return formatter(bullet)

    def build_ul(self):
        return Element("ul", [], {"style": format_style(BulletsFormatter.list_style)})


BulletsFormatter.list_style = {
    "margin": "0",
    "margin-bottom": "5px",
}


contact_style = {
    "color": "blue",
    "font-weight": "bold",
}


class Element:
    def __init__(self, el, content=[], attrs={}):
        self.el = el
        # Use list(content) to create copy of content list
        self.content = list(content) if isinstance(content, list) else [content]
        self.attrs = attrs

    def to_html(self):
        if self.el == "br":
            return "<br/>"

        # TODO: Escape attrs
        attrs = " ".join(f'{key}="{self.attrs[key]}"' for key in self.attrs)

        if attrs != "":
            attrs = " " + attrs

        content = "".join(
            str(c) if not isinstance(c, str) else escape_html(c) for c in self.content
        )
        return f"<{self.el}{attrs}>{content}</{self.el}>"

    def append(self, *content):
        self.content.extend(content)

    def __str__(self):
        return self.to_html()


def apply_parsers(s, parsers):
    result = [s]

    for parser in parsers:
        result = sum((parser(s) for s in result), [])

    return result


def parse_pattern(pattern, fn):
    def parse(s):
        if not isinstance(s, str):
            return [s]

        result = []

        while True:
            match = pattern.search(s)
            if match is None:
                break

            start, end = match.span()
            result.append(s[:start])
            result.append(fn(match))
            s = s[end:]

        result.append(s)

        return result

    return parse


parse_link = parse_pattern(
    link_regex,
    lambda m: Element(
        "a",
        m.group(2) or m.group(1),
        {"href": m.group(1), "target": "_blank"},
    ),
)
parse_highlighted_monospace = parse_pattern(
    highlighted_monospace_regex,
    lambda m: Element(
        "span",
        m.group(1).replace("\\{", "{").replace("\\}", "}"),
        {"style": "font-family: monospace; color: crimson;"},
    ),
)
parse_monospace = parse_pattern(
    monospace_regex,
    lambda m: Element(
        "span",
        m.group(1).replace("\\{", "{").replace("\\}", "}"),
        {"style": "font-family: monospace;"},
    ),
)
parse_emphasis = parse_pattern(
    emphasis_regex,
    lambda m: Element(
        "b",
        apply_parsers(m.group(1), [p for p in parsers if p != parse_emphasis]),
    ),
)
parse_tag = parse_pattern(
    tag_regex,
    lambda m: Element("b", m.group(1).replace("_", " ")),
)
parse_contact = parse_pattern(
    contact_regex,
    lambda m: Element(
        "span",
        m.group(1).replace("_", " "),
        {"style": format_style(contact_style)},
    ),
)
parse_anchor_pointer = parse_pattern(
    anchor_pointer_regex,
    lambda m: Element("a", m.group(1), {"href": f"#{m.group(1)}"}),
)
parse_anchor = parse_pattern(
    anchor_regex,
    lambda m: Element(
        "span",
        f":{m.group(1)}:",
        {"id": m.group(1), "style": "color: teal;"},
    ),
)
parse_ref = parse_pattern(
    ref_regex,
    lambda m: Element(
        "span",
        m.group(1),
        {"style": "color: red;"},
    ),
)

parsers = [
    parse_link,
    parse_highlighted_monospace,
    parse_monospace,
    parse_emphasis,
    parse_tag,
    parse_contact,
    parse_anchor_pointer,
    parse_anchor,
    parse_ref,
]


class TextFormatter:
    def __init__(self, transforms):
        self.transforms = transforms

    @staticmethod
    def default():
        return TextFormatter(parsers)

    def extend(self, *transforms):
        if len(transforms) == 0:
            return self

        return TextFormatter(self.transforms + list(transforms))

    def __call__(self, text):
        return apply_parsers(text, self.transforms)


class SectionFormatter:
    def __init__(self, heading_style, bullets_formatter, text_formatter):
        self.heading_style = heading_style
        self.bullets_formatter = bullets_formatter
        self.text_formatter = text_formatter
        self.append_br_to_paragraphs = False
        self.append_br_to_bullet_lists = False
        self.heading_style = {"font-size": "1.2em", "text-decoration": "underline"}

    @staticmethod
    def default():
        tf = TextFormatter.default()
        return SectionFormatter(
            None,
            BulletsFormatter.default(tf),
            tf,
        )

    def __call__(self, section):
        output = Element("section")

        if section.title != "":
            output.append(
                Element(
                    "h2",
                    self.text_formatter(section.title),
                    {"style": format_style(self.heading_style)},
                )
            )

        ul = None

        for item in section.contents:
            if type(item) is str:
                output.append(Element("p", self.text_formatter(item)))

                if self.append_br_to_paragraphs:
                    output.append(Element("br"))

                ul = None
            else:  # Item is bullet
                if ul is None:
                    ul = self.bullets_formatter.build_ul()
                    output.append(ul)

                    if self.append_br_to_bullet_lists:
                        output.append(Element("br"))

                ul.append(self.bullets_formatter(item))

        return output


class DocumentFormatter:
    def __init__(self, header_style, section_formatter, text_formatter=None):
        self.header_style = header_style
        self.section_formatter = section_formatter
        self.text_formatter = text_formatter or section_formatter.text_formatter
        self.global_styles = {}

    @staticmethod
    def default():
        df = DocumentFormatter(
            None,
            SectionFormatter.default(),
        )

        df.global_styles = {
            "body": {
                "font-family": "Arial",
                # NOTE: May need to have different values for each platform
                "font-size": "11pt",
            }
        }

        return df

    def to_html(self, document):
        output = []

        if document.title != "":
            output.append(
                Element(
                    "h1",
                    self.text_formatter(document.title),
                    {"style": format_style(self.header_style)},
                )
            )

        output += [self.section_formatter(section) for section in document.sections]

        return "".join(
            str(e) if not isinstance(e, str) else escape_html(e) for e in output
        )

    def format_global_styles(self):
        return " ".join(
            f"{selector} {{ {format_style(style)} }}"
            for selector, style in self.global_styles.items()
        )

    def to_full_html(self, document):
        inner_html = self.to_html(document)
        global_styles = self.format_global_styles()

        return f"<html><head><style>{global_styles}</style></head><body>{inner_html}</body></html>"
